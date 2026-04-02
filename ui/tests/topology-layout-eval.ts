import { test, expect } from '@playwright/test';

interface NodeInfo {
	id: string;
	type: string; // 'ContainerNode' | 'LeafNode'
	x: number;
	y: number;
	width: number;
	height: number;
}

interface LayoutMetrics {
	overlapCount: number;
	hierarchyFlowPercent: number;
	spreadRatio: number;
	nodeCount: number;
}

/** Extract node positions and sizes from the rendered SvelteFlow DOM. */
async function extractNodes(page: import('@playwright/test').Page): Promise<NodeInfo[]> {
	return page.evaluate(() => {
		const nodes: NodeInfo[] = [];
		const nodeElements = document.querySelectorAll('.svelte-flow__node');

		for (const el of nodeElements) {
			const id = el.getAttribute('data-id') ?? '';
			const style = (el as HTMLElement).style;
			const transform = style.transform || '';

			// Parse transform: translate(Xpx, Ypx)
			const match = transform.match(/translate\(([^,]+)px,\s*([^)]+)px\)/);
			if (!match) continue;

			const x = parseFloat(match[1]);
			const y = parseFloat(match[2]);
			const width = (el as HTMLElement).offsetWidth;
			const height = (el as HTMLElement).offsetHeight;

			// Determine type from class or data attribute
			const isContainer = el.classList.contains('type-ContainerNode');
			const type = isContainer ? 'ContainerNode' : 'LeafNode';

			nodes.push({ id, type, x, y, width, height });
		}

		return nodes;
	});
}

/** Wait for layout to settle by polling positions until stable. */
async function waitForStableLayout(page: import('@playwright/test').Page): Promise<NodeInfo[]> {
	let previousPositions = '';
	let stableCount = 0;
	let nodes: NodeInfo[] = [];

	for (let i = 0; i < 20; i++) {
		nodes = await extractNodes(page);
		const currentPositions = JSON.stringify(nodes.map((n) => ({ id: n.id, x: n.x, y: n.y })));

		if (currentPositions === previousPositions && nodes.length > 0) {
			stableCount++;
			if (stableCount >= 2) break;
		} else {
			stableCount = 0;
		}

		previousPositions = currentPositions;
		await page.waitForTimeout(500);
	}

	return nodes;
}

/** Check if two bounding boxes overlap. */
function boxesOverlap(a: NodeInfo, b: NodeInfo): boolean {
	return !(
		a.x + a.width <= b.x ||
		b.x + b.width <= a.x ||
		a.y + a.height <= b.y ||
		b.y + b.height <= a.y
	);
}

/** Compute layout quality metrics. */
function computeMetrics(nodes: NodeInfo[]): LayoutMetrics {
	const containers = nodes.filter((n) => n.type === 'ContainerNode');

	// Overlap count (between containers only — leaves are inside containers)
	let overlapCount = 0;
	for (let i = 0; i < containers.length; i++) {
		for (let j = i + 1; j < containers.length; j++) {
			if (boxesOverlap(containers[i], containers[j])) {
				overlapCount++;
			}
		}
	}

	// Hierarchy flow: % of containers where higher-layer containers have smaller Y
	// (Since we can't easily determine layer from DOM, we just check that containers
	// are distributed vertically, not stacked at Y=0)
	const containerYs = containers.map((c) => c.y);
	const uniqueYLevels = new Set(containerYs.map((y) => Math.round(y / 10))).size;
	const hierarchyFlowPercent =
		containers.length > 1 ? (uniqueYLevels / containers.length) * 100 : 100;

	// Spread ratio: total bounding box area / sum of node areas
	const allNodes = nodes.filter((n) => n.width > 0 && n.height > 0);
	if (allNodes.length === 0) {
		return { overlapCount: 0, hierarchyFlowPercent: 100, spreadRatio: 1, nodeCount: 0 };
	}

	const minX = Math.min(...allNodes.map((n) => n.x));
	const minY = Math.min(...allNodes.map((n) => n.y));
	const maxX = Math.max(...allNodes.map((n) => n.x + n.width));
	const maxY = Math.max(...allNodes.map((n) => n.y + n.height));
	const boundingArea = (maxX - minX) * (maxY - minY);
	const sumNodeArea = allNodes.reduce((sum, n) => sum + n.width * n.height, 0);
	const spreadRatio = boundingArea > 0 ? boundingArea / sumNodeArea : 1;

	return {
		overlapCount,
		hierarchyFlowPercent,
		spreadRatio,
		nodeCount: nodes.length
	};
}

test('topology layout quality evaluation', async ({ page }) => {
	// Navigate to topology page
	await page.goto('/#topology');

	// Wait for SvelteFlow nodes to appear
	await page.waitForSelector('.svelte-flow__node', { timeout: 30000 });

	// Wait for layout to settle
	const nodes = await waitForStableLayout(page);

	console.log(`\n=== Topology Layout Evaluation ===`);
	console.log(`Nodes found: ${nodes.length}`);

	if (nodes.length === 0) {
		console.log('No nodes found — skipping evaluation');
		return;
	}

	// Compute metrics
	const metrics = computeMetrics(nodes);

	console.log(`\nMetrics:`);
	console.log(`  Overlap count:        ${metrics.overlapCount} (target: 0)`);
	console.log(`  Hierarchy flow:       ${metrics.hierarchyFlowPercent.toFixed(1)}% (target: >80%)`);
	console.log(`  Spread ratio:         ${metrics.spreadRatio.toFixed(2)} (target: 1.5-10.0)`);

	// Take screenshot
	await page.screenshot({
		path: 'tests/screenshots/topology-layout.png',
		fullPage: true
	});
	console.log(`\nScreenshot saved to tests/screenshots/topology-layout.png`);

	// Pass/fail thresholds
	const results = [
		{
			name: 'No overlaps',
			pass: metrics.overlapCount === 0,
			detail: `${metrics.overlapCount} overlaps`
		},
		{
			name: 'Hierarchy flow',
			pass: metrics.hierarchyFlowPercent > 80,
			detail: `${metrics.hierarchyFlowPercent.toFixed(1)}%`
		},
		{
			name: 'Spread ratio',
			pass: metrics.spreadRatio >= 1.5 && metrics.spreadRatio <= 10.0,
			detail: `${metrics.spreadRatio.toFixed(2)}`
		}
	];

	console.log(`\nResults:`);
	for (const r of results) {
		console.log(`  ${r.pass ? 'PASS' : 'FAIL'}: ${r.name} (${r.detail})`);
	}

	const allPassed = results.every((r) => r.pass);
	console.log(`\nOverall: ${allPassed ? 'PASS' : 'FAIL'}\n`);

	// Assert
	expect(metrics.overlapCount, 'Container nodes should not overlap').toBe(0);
	expect(
		metrics.hierarchyFlowPercent,
		'Containers should be distributed across vertical layers'
	).toBeGreaterThan(80);
});
