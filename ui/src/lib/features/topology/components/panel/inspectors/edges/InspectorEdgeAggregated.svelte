<script lang="ts">
	import type { TopologyEdge, Topology } from '$lib/features/topology/types/base';
	import { useTopologiesQuery, selectedTopologyId } from '$lib/features/topology/queries';
	import { edgeTypes } from '$lib/shared/stores/metadata';
	import { topology_connectionsCount } from '$lib/paraglide/messages';
	import EntityDisplayWrapper from '$lib/shared/components/forms/selection/display/EntityDisplayWrapper.svelte';
	import { InterfaceEdgeDisplay } from '$lib/shared/components/forms/selection/display/InterfaceEdgeDisplay.svelte';
	import { PhysicalLinkEdgeDisplay } from '$lib/shared/components/forms/selection/display/PhysicalLinkEdgeDisplay.svelte';
	import { HostVirtualizationEdgeDisplay } from '$lib/shared/components/forms/selection/display/HostVirtualizationEdgeDisplay.svelte';
	import { ServiceVirtualizationEdgeDisplay } from '$lib/shared/components/forms/selection/display/ServiceVirtualizationEdgeDisplay.svelte';
	import { DependencyDisplay } from '$lib/shared/components/forms/selection/display/DependencyDisplay.svelte';
	import { getContext } from 'svelte';
	import type { Writable } from 'svelte/store';

	let { edges }: { edges: TopologyEdge[] } = $props();

	const topologyContext = getContext<Writable<Topology> | undefined>('topology');
	const topologiesQuery = useTopologiesQuery();
	let topologiesData = $derived(topologiesQuery.data ?? []);
	let topology = $derived(
		topologyContext ? $topologyContext : topologiesData.find((t) => t.id === $selectedTopologyId)
	);

	// Group edges by type
	let edgesByType = $derived.by(() => {
		const groups = new Map<string, TopologyEdge[]>();
		for (const edge of edges) {
			const type = edge.edge_type;
			const existing = groups.get(type);
			if (existing) {
				existing.push(edge);
			} else {
				groups.set(type, [edge]);
			}
		}
		return groups;
	});

	function getDisplayComponent(edgeType: string) {
		switch (edgeType) {
			case 'Interface':
				return InterfaceEdgeDisplay;
			case 'PhysicalLink':
				return PhysicalLinkEdgeDisplay;
			case 'HostVirtualization':
				return HostVirtualizationEdgeDisplay;
			case 'ServiceVirtualization':
				return ServiceVirtualizationEdgeDisplay;
			default:
				return null;
		}
	}

	function isDependencyEdge(edgeType: string) {
		return edgeType === 'HubAndSpoke' || edgeType === 'RequestPath';
	}
</script>

<div class="space-y-4">
	<span class="text-secondary block text-sm font-medium">
		{topology_connectionsCount({ count: edges.length })}
	</span>

	<div class="max-h-96 space-y-3 overflow-y-auto">
		{#each [...edgesByType.entries()] as [edgeType, typeEdges]}
			{@const typeName = edgeTypes.getName(edgeType)}
			{@const displayComponent = getDisplayComponent(edgeType)}

			{#if typeEdges.length > 1}
				<span class="text-tertiary block text-xs font-medium uppercase tracking-wide">
					{typeName} ({typeEdges.length})
				</span>
			{:else}
				<span class="text-tertiary block text-xs font-medium uppercase tracking-wide">
					{typeName}
				</span>
			{/if}

			{#each typeEdges as edge (edge.id)}
				<div class="card card-static">
					{#if isDependencyEdge(edgeType) && topology}
						{@const dependency =
							'group_id' in edge ? topology.dependencies.find((d) => d.id === edge.group_id) : null}
						{#if dependency}
							<EntityDisplayWrapper
								item={dependency}
								context={{}}
								displayComponent={DependencyDisplay}
							/>
						{/if}
					{:else if displayComponent}
						<EntityDisplayWrapper item={edge} context={{ topology }} {displayComponent} />
					{:else}
						<div class="px-2 py-1">
							<span class="text-secondary text-sm">{typeName}</span>
						</div>
					{/if}
				</div>
			{/each}
		{/each}
	</div>
</div>
