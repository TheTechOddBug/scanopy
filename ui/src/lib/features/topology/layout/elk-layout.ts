import type { ElkNode, ElkExtendedEdge } from 'elkjs';
import type { TopologyNode, TopologyEdge, Topology } from '../types/base';
import type { components } from '$lib/api/schema';
import { classifyEdge } from './edge-classification';

type SubnetType = components['schemas']['SubnetType'];

export interface ElkLayoutInput {
	nodes: TopologyNode[];
	edges: TopologyEdge[];
	topology: Topology;
}

export interface ElkLayoutResult {
	nodePositions: Map<string, { x: number; y: number }>;
	containerSizes: Map<string, { width: number; height: number }>;
}

let elkPromise: Promise<import('elkjs')['default']> | null = null;

async function getElk(): Promise<import('elkjs/lib/elk-api')['default']> {
	if (!elkPromise) {
		elkPromise = import('elkjs/lib/elk.bundled.js').then((mod) => {
			const ELK = mod.default;
			return new ELK();
		});
	}
	return elkPromise;
}

/** Map SubnetType to vertical layer order (lower = higher on screen). */
const SUBNET_TYPE_LAYER: Record<SubnetType, number> = {
	Internet: 0,
	Remote: 0,
	Gateway: 1,
	VpnTunnel: 1,
	Dmz: 1,
	Lan: 2,
	WiFi: 2,
	IoT: 2,
	Guest: 2,
	Management: 3,
	Storage: 3,
	DockerBridge: 4,
	MacVlan: 4,
	IpVlan: 4,
	Loopback: 999,
	Unknown: 999
};

/** Root-level ELK layout options for layered compound layout. */
const ROOT_LAYOUT_OPTIONS: Record<string, string> = {
	'elk.algorithm': 'layered',
	'elk.direction': 'DOWN',
	'elk.layered.spacing.nodeNodeBetweenLayers': '100',
	'elk.layered.spacing.edgeNodeBetweenLayers': '50',
	'elk.spacing.componentComponent': '80',
	'elk.spacing.nodeNode': '60',
	'elk.layered.nodePlacement.strategy': 'NETWORK_SIMPLEX',
	'elk.layered.crossingMinimization.strategy': 'LAYER_SWEEP',
	'elk.hierarchyHandling': 'SEPARATE_CHILDREN',
	'elk.layered.layering.strategy': 'INTERACTIVE',
	'elk.layered.compaction.postCompaction.strategy': 'LEFT_RIGHT_CONSTRAINT_LOCKING',
	'elk.aspectRatio': '1.6',
	'elk.padding': '[top=20,left=20,bottom=20,right=20]'
};

/** Container node padding (extra top for header). */
const CONTAINER_PADDING = '[top=50,left=25,bottom=25,right=25]';

function getLayerHint(node: TopologyNode, topology: Topology): number {
	// Future: use layer_hint if present
	if ('layer_hint' in node && typeof (node as Record<string, unknown>).layer_hint === 'number') {
		return (node as Record<string, unknown>).layer_hint as number;
	}

	// Derive from subnet's subnet_type
	const subnet = topology.subnets.find((s) => s.id === node.id);
	if (subnet) {
		return SUBNET_TYPE_LAYER[subnet.subnet_type as SubnetType] ?? 999;
	}
	return 999;
}

/**
 * Build an ELK graph from topology data.
 * Containers become parent nodes; leaves become children inside their container.
 * Only primary edges are included (overlay edges don't affect layout).
 */
function buildElkGraph(input: ElkLayoutInput): { graph: ElkNode; containerIds: Set<string> } {
	const containers: Map<string, ElkNode> = new Map();
	const containerIds = new Set<string>();

	// Create container (parent) nodes
	for (const node of input.nodes) {
		if (node.node_type === 'ContainerNode') {
			containerIds.add(node.id);
			const layerId = getLayerHint(node, input.topology);
			containers.set(node.id, {
				id: node.id,
				children: [],
				layoutOptions: {
					'elk.algorithm': 'rectpacking',
					'elk.padding': CONTAINER_PADDING,
					'elk.nodeSize.constraints': 'MINIMUM_SIZE',
					'elk.rectpacking.desiredAspectRatio': '2.5',
					'elk.spacing.nodeNode': '20',
					'elk.layered.layering.layerId': String(layerId)
				}
			});
		}
	}

	// Add leaf nodes as children of their containers
	for (const node of input.nodes) {
		if (node.node_type === 'LeafNode') {
			const parentId = node.container_id ?? node.subnet_id;
			const parent = containers.get(parentId);
			if (parent && parent.children) {
				parent.children.push({
					id: node.id,
					width: node.size.x,
					height: node.size.y,
					layoutOptions: {
						'elk.nodeSize.constraints': 'MINIMUM_SIZE',
						'elk.nodeSize.minimum': `(${node.size.x},${node.size.y})`
					}
				});
			}
		}
	}

	// Build leaf→container mapping
	const leafToContainer = new Map<string, string>();
	for (const node of input.nodes) {
		if (node.node_type === 'LeafNode') {
			const parentId = node.container_id ?? node.subnet_id;
			if (containers.has(parentId)) {
				leafToContainer.set(node.id, parentId);
			}
		}
	}

	// With SEPARATE_CHILDREN, create container-level edges from cross-container
	// leaf edges so the root layered algorithm can order containers properly.
	const edges: ElkExtendedEdge[] = [];
	const seenContainerEdges = new Set<string>();
	let edgeIndex = 0;
	for (const edge of input.edges) {
		if (classifyEdge(edge) !== 'primary') continue;

		const srcContainer = leafToContainer.get(edge.source);
		const tgtContainer = leafToContainer.get(edge.target);
		if (srcContainer && tgtContainer && srcContainer !== tgtContainer) {
			const key = `${srcContainer}->${tgtContainer}`;
			if (!seenContainerEdges.has(key)) {
				seenContainerEdges.add(key);
				edges.push({
					id: `elk-edge-${edgeIndex++}`,
					sources: [srcContainer],
					targets: [tgtContainer]
				});
			}
		}
	}

	const graph: ElkNode = {
		id: 'root',
		layoutOptions: ROOT_LAYOUT_OPTIONS,
		children: Array.from(containers.values()),
		edges
	};

	return { graph, containerIds };
}

/**
 * Extract positions from ELK result. Leaf positions are made relative to their
 * parent container (as @xyflow expects when parentId is set).
 */
function mapElkResults(layoutResult: ElkNode, containerIds: Set<string>): ElkLayoutResult {
	const nodePositions = new Map<string, { x: number; y: number }>();
	const containerSizes = new Map<string, { width: number; height: number }>();

	// Map container positions and sizes
	const containerPositions = new Map<string, { x: number; y: number }>();
	if (layoutResult.children) {
		for (const container of layoutResult.children) {
			if (!containerIds.has(container.id)) continue;
			const cx = container.x ?? 0;
			const cy = container.y ?? 0;
			containerPositions.set(container.id, { x: cx, y: cy });
			nodePositions.set(container.id, { x: cx, y: cy });
			containerSizes.set(container.id, {
				width: container.width ?? 0,
				height: container.height ?? 0
			});

			// Map leaf node positions (relative to parent)
			if (container.children) {
				for (const leaf of container.children) {
					nodePositions.set(leaf.id, {
						x: leaf.x ?? 0,
						y: leaf.y ?? 0
					});
				}
			}
		}
	}

	return { nodePositions, containerSizes };
}

/**
 * Compute layout positions using elkjs compound layered algorithm.
 * Returns positions for all nodes and computed sizes for containers.
 */
export async function computeElkLayout(input: ElkLayoutInput): Promise<ElkLayoutResult> {
	if (input.nodes.length === 0) {
		return { nodePositions: new Map(), containerSizes: new Map() };
	}

	const { graph, containerIds } = buildElkGraph(input);
	const elk = await getElk();
	const result = await elk.layout(graph);
	return mapElkResults(result, containerIds);
}
