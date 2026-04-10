/**
 * Layout diagnostic tool for detecting topology layout corruption.
 *
 * Inspects the current rendered SvelteFlow topology and reports layout violations:
 * - Element overlap within the same container
 * - Container undersize (children exceed container bounds)
 * - Elements out of bounds (positioned outside parent container)
 * - Missing positions (zero position or zero size)
 *
 * Usage: call window.__scanopyLayoutDiag() from browser console.
 * Output: JSON array of violations.
 */

export interface LayoutViolation {
	type: 'overlap' | 'container_undersize' | 'out_of_bounds' | 'missing_position';
	severity: 'error' | 'warning';
	nodeA: string;
	nodeB?: string;
	container?: string;
	details: Record<string, unknown>;
}

interface NodeRect {
	id: string;
	x: number;
	y: number;
	width: number;
	height: number;
	parentId: string | undefined;
	type: string;
}

const OVERLAP_TOLERANCE = 2; // px tolerance for overlap detection
const BOUNDS_TOLERANCE = 5; // px tolerance for out-of-bounds

/**
 * Read node positions and sizes from SvelteFlow's internal state (preferred)
 * or fall back to DOM parsing.
 */
function readNodes(): NodeRect[] {
	// Try SvelteFlow state first (exposed by BaseTopologyViewer)
	const layoutState = (window as Record<string, unknown>).__scanopyLayoutState as
		| {
				getNodes: () => {
					id: string;
					position: { x: number; y: number };
					type?: string;
					parentId?: string;
					width?: number;
					height?: number;
					computed?: { width?: number; height?: number };
				}[];
		  }
		| undefined;

	if (layoutState?.getNodes) {
		const flowNodes = layoutState.getNodes();
		return flowNodes.map((n) => ({
			id: n.id,
			x: n.position.x,
			y: n.position.y,
			// Use layout pipeline defaults (250x100) for uncomputed nodes to avoid
			// false positives — SvelteFlow elements have undefined height until rendered
			width: n.computed?.width ?? n.width ?? 250,
			height: n.computed?.height ?? n.height ?? 100,
			parentId: n.parentId,
			type: n.type ?? 'Element'
		}));
	}

	// Fallback: parse DOM
	console.warn('[LAYOUT-DEBUG] SvelteFlow state not available, falling back to DOM parsing');
	return readNodesFromDOM();
}

/**
 * Fallback: read positions from DOM transforms.
 */
function readNodesFromDOM(): NodeRect[] {
	const flowContainer = document.querySelector('.svelte-flow');
	if (!flowContainer) return [];

	const nodes: NodeRect[] = [];
	const nodeEls = flowContainer.querySelectorAll('.svelte-flow__node');

	for (const el of nodeEls) {
		const htmlEl = el as HTMLElement;
		const id = htmlEl.dataset.id;
		if (!id) continue;

		const transform = htmlEl.style.transform;
		let x = 0;
		let y = 0;
		if (transform) {
			const match = transform.match(/translate\((-?[\d.]+)px,\s*(-?[\d.]+)px\)/);
			if (match) {
				x = parseFloat(match[1]);
				y = parseFloat(match[2]);
			}
		}

		const width = htmlEl.offsetWidth;
		const height = htmlEl.offsetHeight;
		const isContainer = htmlEl.classList.contains('type-Container');
		const type = isContainer ? 'Container' : 'Element';

		// Walk up to find parent node
		const parentEl = htmlEl.parentElement?.closest('.svelte-flow__node');
		const parentId = parentEl ? (parentEl as HTMLElement).dataset.id : undefined;

		nodes.push({ id, x, y, width, height, parentId, type });
	}

	return nodes;
}

/**
 * Check for element overlap within the same container.
 */
function checkOverlap(nodes: NodeRect[]): LayoutViolation[] {
	const violations: LayoutViolation[] = [];

	// Group nodes by parent container
	const byParent = new Map<string, NodeRect[]>();
	for (const node of nodes) {
		const key = node.parentId ?? '__root__';
		if (!byParent.has(key)) byParent.set(key, []);
		byParent.get(key)!.push(node);
	}

	for (const [parentId, siblings] of byParent) {
		for (let i = 0; i < siblings.length; i++) {
			for (let j = i + 1; j < siblings.length; j++) {
				const a = siblings[i];
				const b = siblings[j];

				const overlapX = Math.min(a.x + a.width, b.x + b.width) - Math.max(a.x, b.x);
				const overlapY = Math.min(a.y + a.height, b.y + b.height) - Math.max(a.y, b.y);

				if (overlapX > OVERLAP_TOLERANCE && overlapY > OVERLAP_TOLERANCE) {
					violations.push({
						type: 'overlap',
						severity: 'error',
						nodeA: a.id,
						nodeB: b.id,
						container: parentId === '__root__' ? undefined : parentId,
						details: {
							nodeA_pos: { x: a.x, y: a.y, w: a.width, h: a.height },
							nodeB_pos: { x: b.x, y: b.y, w: b.width, h: b.height },
							overlap_x: Math.round(overlapX),
							overlap_y: Math.round(overlapY)
						}
					});
				}
			}
		}
	}

	return violations;
}

/**
 * Check for containers that are too small to contain their children.
 */
function checkContainerUndersize(nodes: NodeRect[]): LayoutViolation[] {
	const violations: LayoutViolation[] = [];

	const containers = nodes.filter((n) => n.type === 'Container');

	for (const container of containers) {
		const children = nodes.filter((n) => n.parentId === container.id);
		if (children.length === 0) continue;

		let maxRight = 0;
		let maxBottom = 0;

		for (const child of children) {
			const right = child.x + child.width;
			const bottom = child.y + child.height;
			if (right > maxRight) maxRight = right;
			if (bottom > maxBottom) maxBottom = bottom;
		}

		const widthShortfall = maxRight - container.width;
		const heightShortfall = maxBottom - container.height;

		if (widthShortfall > BOUNDS_TOLERANCE || heightShortfall > BOUNDS_TOLERANCE) {
			violations.push({
				type: 'container_undersize',
				severity: 'error',
				nodeA: container.id,
				container: container.id,
				details: {
					container_size: { w: container.width, h: container.height },
					children_bbox: { maxRight: Math.round(maxRight), maxBottom: Math.round(maxBottom) },
					width_shortfall: Math.round(Math.max(0, widthShortfall)),
					height_shortfall: Math.round(Math.max(0, heightShortfall)),
					child_count: children.length
				}
			});
		}
	}

	return violations;
}

/**
 * Check for elements positioned outside their parent container's bounds.
 */
function checkOutOfBounds(nodes: NodeRect[]): LayoutViolation[] {
	const violations: LayoutViolation[] = [];
	const nodeMap = new Map(nodes.map((n) => [n.id, n]));

	for (const node of nodes) {
		if (!node.parentId) continue;
		const parent = nodeMap.get(node.parentId);
		if (!parent) continue;

		const outLeft = node.x < -BOUNDS_TOLERANCE;
		const outTop = node.y < -BOUNDS_TOLERANCE;
		const outRight = node.x + node.width > parent.width + BOUNDS_TOLERANCE;
		const outBottom = node.y + node.height > parent.height + BOUNDS_TOLERANCE;

		if (outLeft || outTop || outRight || outBottom) {
			violations.push({
				type: 'out_of_bounds',
				severity: 'error',
				nodeA: node.id,
				container: node.parentId,
				details: {
					node_pos: { x: node.x, y: node.y, w: node.width, h: node.height },
					parent_size: { w: parent.width, h: parent.height },
					out: {
						left: outLeft ? Math.round(Math.abs(node.x)) : 0,
						top: outTop ? Math.round(Math.abs(node.y)) : 0,
						right: outRight ? Math.round(node.x + node.width - parent.width) : 0,
						bottom: outBottom ? Math.round(node.y + node.height - parent.height) : 0
					}
				}
			});
		}
	}

	return violations;
}

/**
 * Check for elements/containers with zero or missing positions/sizes.
 */
function checkMissingPositions(nodes: NodeRect[]): LayoutViolation[] {
	const violations: LayoutViolation[] = [];

	for (const node of nodes) {
		const hasZeroPos = node.x === 0 && node.y === 0 && node.parentId !== undefined;
		const hasZeroSize = node.width === 0 || node.height === 0;

		if (hasZeroSize) {
			violations.push({
				type: 'missing_position',
				severity: 'error',
				nodeA: node.id,
				container: node.parentId,
				details: {
					position: { x: node.x, y: node.y },
					size: { w: node.width, h: node.height },
					issue: 'zero_size'
				}
			});
		} else if (hasZeroPos) {
			violations.push({
				type: 'missing_position',
				severity: 'warning',
				nodeA: node.id,
				container: node.parentId,
				details: {
					position: { x: node.x, y: node.y },
					size: { w: node.width, h: node.height },
					issue: 'zero_position_with_parent'
				}
			});
		}
	}

	return violations;
}

/**
 * Run all layout diagnostic checks on the current rendered topology.
 * Returns a JSON array of violations.
 */
export function runLayoutDiagnostic(): LayoutViolation[] {
	const nodes = readNodes();
	if (nodes.length === 0) {
		console.warn('[LAYOUT-DEBUG] No nodes found — is a topology rendered?');
		return [];
	}

	const containers = nodes.filter((n) => n.type === 'Container');
	const elements = nodes.filter((n) => n.type !== 'Container');
	console.log(
		`[LAYOUT-DEBUG] Diagnostic: inspecting ${nodes.length} nodes (${containers.length} containers, ${elements.length} elements)`
	);

	const violations: LayoutViolation[] = [
		...checkOverlap(nodes),
		...checkContainerUndersize(nodes),
		...checkOutOfBounds(nodes),
		...checkMissingPositions(nodes)
	];

	// Sort by severity (errors first) then by type
	violations.sort((a, b) => {
		if (a.severity !== b.severity) return a.severity === 'error' ? -1 : 1;
		return a.type.localeCompare(b.type);
	});

	const errorCount = violations.filter((v) => v.severity === 'error').length;
	const warningCount = violations.filter((v) => v.severity === 'warning').length;
	console.log(
		`[LAYOUT-DEBUG] Diagnostic complete: ${violations.length} violations (${errorCount} errors, ${warningCount} warnings)`
	);

	if (violations.length > 0) {
		// Group by type for summary
		const byType = new Map<string, number>();
		for (const v of violations) {
			byType.set(v.type, (byType.get(v.type) ?? 0) + 1);
		}
		console.log(`[LAYOUT-DEBUG] Violation summary:`, Object.fromEntries(byType));
	}

	return violations;
}

/**
 * Install the diagnostic on window for console access.
 */
export function installLayoutDiagnostic(): void {
	(window as Record<string, unknown>).__scanopyLayoutDiag = runLayoutDiagnostic;
	console.log(
		'[LAYOUT-DEBUG] Layout diagnostic installed. Run window.__scanopyLayoutDiag() to check for violations.'
	);
}
