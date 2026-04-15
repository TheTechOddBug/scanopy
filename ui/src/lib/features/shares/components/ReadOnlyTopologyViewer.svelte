<script lang="ts">
	import { SvelteFlowProvider, type Node, type Edge } from '@xyflow/svelte';
	import BaseTopologyViewer from '$lib/features/topology/components/visualization/BaseTopologyViewer.svelte';
	import SearchOverlay from '$lib/features/topology/components/visualization/SearchOverlay.svelte';
	import ShortcutsHelpOverlay from '$lib/features/topology/components/visualization/ShortcutsHelpOverlay.svelte';
	import type { Topology } from '$lib/features/topology/types/base';
	import { setContext } from 'svelte';
	import { get, writable } from 'svelte/store';
	import ReadOnlyInspectorPanel from './ReadOnlyInspectorPanel.svelte';
	import ExportButton from '$lib/features/topology/components/ExportButton.svelte';
	import ExportModal from '$lib/features/topology/components/ExportModal.svelte';
	import SegmentedControl from '$lib/shared/components/forms/SegmentedControl.svelte';
	import { Share2, LoaderCircle } from 'lucide-svelte';
	import type { ExportFeatures } from '../types/base';
	import { hydrateStoresFromTopology } from '$lib/features/topology/queries';
	import { searchOpen, clearSearch } from '$lib/features/topology/interactions';
	import { clearSelection } from '$lib/features/topology/selection';
	import { views } from '$lib/shared/stores/metadata';

	export let topology: Topology;
	export let showControls: boolean = true;
	export let showInspectPanel: boolean = true;
	export let showExport: boolean = false;
	export let isEmbed: boolean = false;
	export let shareName: string = '';
	export let showMinimap: boolean = false;
	export let exportFeatures: ExportFeatures | undefined = undefined;
	export let enabledViews: string[] = [];
	export let currentView: string = 'L3Logical';
	export let onViewChange: (view: string) => void = () => {};
	export let viewLoading: boolean = false;

	let isExportModalOpen = false;
	let shortcutsHelpOpen = false;
	let baseViewer: BaseTopologyViewer | null = null;

	// Build SegmentedControl options from enabled views
	$: viewOptions = enabledViews.map((viewId) => ({
		value: viewId,
		label: views.getName(viewId),
		icon: views.getIconComponent(viewId),
		tooltip: views.getDescription(viewId)
	}));

	// Hydrate the global activeView + topologyOptions stores so the rendering
	// pipeline sees the correct view for this shared topology.
	hydrateStoresFromTopology(topology, true);

	// Create a context store for the topology so child components (inspectors) can access it
	const topologyContext = writable<Topology>(topology);
	setContext('topology', topologyContext);

	// Create local stores for selected node/edge (instead of using global store).
	// BaseTopologyViewer resolves these via getContext and uses them as its selection source.
	const selectedNodeStore = writable<Node | null>(null);
	const selectedEdgeStore = writable<Edge | null>(null);
	const selectedNodesStore = writable<Node[]>([]);
	setContext('selectedNode', selectedNodeStore);
	setContext('selectedEdge', selectedEdgeStore);
	setContext('selectedNodes', selectedNodesStore);

	// Keep context in sync with prop and re-hydrate on topology change (view switch)
	$: {
		topologyContext.set(topology);
		hydrateStoresFromTopology(topology, true);
	}

	// --- Keyboard shortcuts (same handler as TopologyViewer, minus edit-only shortcuts) ---

	function isInputElement(target: EventTarget | null): boolean {
		if (!target || !(target instanceof HTMLElement)) return false;
		const tag = target.tagName.toLowerCase();
		if (tag === 'input' || tag === 'textarea' || tag === 'select') return true;
		if (target.isContentEditable) return true;
		return false;
	}

	function handleKeydown(event: KeyboardEvent) {
		if (shortcutsHelpOpen) return;

		const isSearchOpen = get(searchOpen);

		if (event.key === 'Escape') {
			if (isSearchOpen) {
				clearSearch();
			} else {
				clearSelection({
					selectedNode: selectedNodeStore,
					selectedEdge: selectedEdgeStore,
					selectedNodes: selectedNodesStore
				});
			}
			return;
		}

		if (isInputElement(event.target)) return;

		if ((event.metaKey || event.ctrlKey) && event.key === 'f') {
			event.preventDefault();
			searchOpen.set(true);
			return;
		}

		if (event.metaKey || event.ctrlKey || event.altKey) return;

		switch (event.key) {
			case '/':
				event.preventDefault();
				searchOpen.set(true);
				break;
			case 'f':
			case 'F':
				baseViewer?.triggerFitView();
				break;
			case 'z':
			case 'Z': {
				const multiSelected = get(selectedNodesStore);
				const singleSelected = get(selectedNodeStore);
				if (multiSelected.length >= 2) {
					baseViewer?.fitViewToNodes(multiSelected.map((n) => n.id));
				} else if (singleSelected) {
					baseViewer?.fitViewToNodes([singleSelected.id]);
				}
				break;
			}
			case '?':
				shortcutsHelpOpen = !shortcutsHelpOpen;
				break;
			case ']':
				baseViewer?.triggerStepExpand();
				break;
			case '[':
				baseViewer?.triggerStepCollapse();
				break;
		}
	}
</script>

<svelte:window on:keydown={handleKeydown} />

<SvelteFlowProvider>
	<div class="flex h-full w-full flex-col">
		{#if shareName || enabledViews.length > 1}
			<header
				class="flex flex-shrink-0 items-center justify-between border-b px-4 py-3"
				style="border-color: var(--color-border); background: var(--color-bg-elevated)"
			>
				<div class="flex items-center gap-3">
					{#if shareName}
						<Share2 class="text-info h-8 w-8" />
						<h1 class="text-primary font-semibold">{shareName}</h1>
					{/if}
				</div>
				<div class="flex items-center gap-4">
					{#if enabledViews.length > 1}
						<div class="flex items-center gap-2">
							{#if viewLoading}
								<LoaderCircle class="text-muted h-4 w-4 animate-spin" />
							{/if}
							<SegmentedControl
								options={viewOptions}
								selected={currentView}
								onchange={onViewChange}
								size="sm"
								disabled={viewLoading}
							/>
						</div>
					{/if}
					{#if showExport}
						<ExportButton onclick={() => (isExportModalOpen = true)} />
					{/if}
				</div>
			</header>
		{/if}
		<div class="relative min-h-0 flex-1">
			{#if showInspectPanel}
				<ReadOnlyInspectorPanel />
			{/if}
			<BaseTopologyViewer
				bind:this={baseViewer}
				{topology}
				readonly={true}
				{showControls}
				{isEmbed}
				showBranding={true}
				{showMinimap}
				onOpenShortcuts={() => (shortcutsHelpOpen = true)}
				onOpenSearch={() => searchOpen.set(true)}
			/>
			<SearchOverlay />
			<ShortcutsHelpOverlay bind:isOpen={shortcutsHelpOpen} readonly={true} />
		</div>
	</div>

	{#if showExport}
		<ExportModal
			topologyId={topology.id}
			topologyName={topology.name}
			bind:isOpen={isExportModalOpen}
			isShareView={true}
			{exportFeatures}
		/>
	{/if}
</SvelteFlowProvider>
