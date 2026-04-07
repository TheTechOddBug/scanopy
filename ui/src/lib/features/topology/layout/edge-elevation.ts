import type { TopologyEdge, TopologyNode } from '../types/base';
import { willTargetContainer } from './edge-classification';

/**
 * Elevate edge endpoints from elements to the outermost accepting container.
 *
 * Two conditions must both be true for elevation to happen:
 * 1. The edge has `will_target_container: true` in its view config
 * 2. A container in the element's ancestry has `will_accept_edges: true`
 *
 * When multiple nested containers accept, the outermost acceptor wins.
 *
 * All edges are preserved (no deduplication) so that downstream bundling
 * can show correct edge counts.
 */
export function elevateEdgesToContainers(
	edges: TopologyEdge[],
	nodes: TopologyNode[]
): TopologyEdge[] {
	// Build container lookup: id → { parentId, willAcceptEdges }
	const containerInfo = new Map<
		string,
		{ parentId: string | undefined; willAcceptEdges: boolean }
	>();
	for (const node of nodes) {
		if (node.node_type === 'Container') {
			const n = node as Record<string, unknown>;
			containerInfo.set(node.id, {
				parentId: n.parent_container_id as string | undefined,
				willAcceptEdges: (n.will_accept_edges as boolean) ?? false
			});
		}
	}

	// Build element → outermost accepting container map
	const elevationMap = new Map<string, string>();
	for (const node of nodes) {
		if (node.node_type !== 'Element') continue;
		const containerId =
			(node as Record<string, unknown>).container_id ?? (node as Record<string, unknown>).subnet_id;
		if (typeof containerId !== 'string') continue;

		// Walk up from the element's direct container through parents,
		// tracking the outermost container that accepts edges
		let outermostAcceptor: string | undefined;
		let current: string | undefined = containerId;
		while (current) {
			const info = containerInfo.get(current);
			if (!info) break;
			if (info.willAcceptEdges) {
				outermostAcceptor = current;
			}
			current = info.parentId;
		}

		if (outermostAcceptor) {
			elevationMap.set(node.id, outermostAcceptor);
		}
	}

	if (elevationMap.size === 0) return edges;

	// Elevate edge endpoints — only for edges with will_target_container
	const result: TopologyEdge[] = [];

	for (const edge of edges) {
		if (!willTargetContainer(edge)) {
			result.push(edge);
			continue;
		}

		const source = elevationMap.get(edge.source) ?? edge.source;
		const target = elevationMap.get(edge.target) ?? edge.target;

		// Skip self-loops created by elevation
		if (source === target) continue;

		if (source !== edge.source || target !== edge.target) {
			result.push({ ...edge, source, target });
		} else {
			result.push(edge);
		}
	}

	return result;
}
