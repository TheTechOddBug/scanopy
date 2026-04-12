<script lang="ts">
	import { Panel } from '@xyflow/svelte';
	import { Keyboard, Expand, Shrink, Pencil, ZoomIn, ZoomOut, Maximize } from 'lucide-svelte';
	import {
		topology_shortcutsTitle,
		topology_editModeTooltip,
		topology_viewModeTooltip,
		topology_zoomIn,
		topology_zoomOut,
		topology_shortcutFitView,
		common_edit,
		common_shortcuts
	} from '$lib/paraglide/messages';
	import TopologySidebarButton from './TopologySidebarButton.svelte';

	let {
		editMode = false,
		onToggleEditMode = null,
		onOpenShortcuts = null,
		sidebarCollapsed = false,
		onStepExpand,
		onStepCollapse,
		onZoomIn,
		onZoomOut,
		onFitView,
		expandDisabled,
		collapseDisabled,
		collapseLevel,
		collapseLevelTooltipExpand,
		collapseLevelTooltipCollapse
	}: {
		editMode?: boolean;
		onToggleEditMode?: (() => void) | null;
		onOpenShortcuts?: (() => void) | null;
		sidebarCollapsed?: boolean;
		onStepExpand: () => void;
		onStepCollapse: () => void;
		onZoomIn: () => void;
		onZoomOut: () => void;
		onFitView: () => void;
		expandDisabled: boolean;
		collapseDisabled: boolean;
		collapseLevel: number;
		collapseLevelTooltipExpand: string;
		collapseLevelTooltipCollapse: string;
	} = $props();
</script>

<Panel position="top-right" class="!m-[10px] !flex !flex-col !items-end !gap-2 !p-0">
	{#if onToggleEditMode}
		<TopologySidebarButton
			onclick={onToggleEditMode}
			title={editMode ? topology_editModeTooltip() : topology_viewModeTooltip()}
			label={common_edit()}
			shortcut="E"
			active={editMode}
			collapsed={sidebarCollapsed}
		>
			{#snippet icon()}
				<Pencil class="h-4 w-4" />
			{/snippet}
		</TopologySidebarButton>
	{/if}
	<TopologySidebarButton
		onclick={onStepExpand}
		title={collapseLevelTooltipExpand}
		shortcut="]"
		label=""
		disabled={expandDisabled}
		collapsed={sidebarCollapsed}
	>
		{#snippet icon()}
			<Expand class="h-4 w-4" />
		{/snippet}
	</TopologySidebarButton>
	<span
		class="flex h-5 w-5 items-center justify-center rounded text-xs font-semibold text-gray-500 dark:text-gray-400"
	>
		{collapseLevel}
	</span>
	<TopologySidebarButton
		onclick={onStepCollapse}
		title={collapseLevelTooltipCollapse}
		shortcut="["
		label=""
		disabled={collapseDisabled}
		collapsed={sidebarCollapsed}
	>
		{#snippet icon()}
			<Shrink class="h-4 w-4" />
		{/snippet}
	</TopologySidebarButton>
	{#if onOpenShortcuts}
		<TopologySidebarButton
			onclick={onOpenShortcuts}
			title={topology_shortcutsTitle()}
			label={common_shortcuts()}
			shortcut="?"
			collapsed={sidebarCollapsed}
		>
			{#snippet icon()}
				<Keyboard class="h-4 w-4" />
			{/snippet}
		</TopologySidebarButton>
	{/if}
	<TopologySidebarButton
		onclick={onZoomIn}
		title={topology_zoomIn()}
		label=""
		collapsed={sidebarCollapsed}
	>
		{#snippet icon()}
			<ZoomIn class="h-4 w-4" />
		{/snippet}
	</TopologySidebarButton>
	<TopologySidebarButton
		onclick={onZoomOut}
		title={topology_zoomOut()}
		label=""
		collapsed={sidebarCollapsed}
	>
		{#snippet icon()}
			<ZoomOut class="h-4 w-4" />
		{/snippet}
	</TopologySidebarButton>
	<TopologySidebarButton
		onclick={onFitView}
		title={topology_shortcutFitView()}
		shortcut="F"
		label=""
		collapsed={sidebarCollapsed}
	>
		{#snippet icon()}
			<Maximize class="h-4 w-4" />
		{/snippet}
	</TopologySidebarButton>
</Panel>
