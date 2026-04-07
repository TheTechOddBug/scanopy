<script lang="ts" context="module">
	import { edgeTypes, serviceDefinitions } from '$lib/shared/stores/metadata';
	import type { Topology, TopologyEdge } from '$lib/features/topology/types/base';

	export const HostVirtualizationEdgeDisplay: EntityDisplayComponent<
		TopologyEdge,
		EdgeDisplayContext
	> = {
		getId: (edge) => edge.id,
		getLabel: (edge, context) => {
			if (!context?.topology || !('vm_service_id' in edge)) return 'Host Virtualization';
			const vmService = context.topology.services.find((s) => s.id === edge.vm_service_id);
			return vmService?.name ?? 'Unknown VM';
		},
		getDescription: (edge, context) => {
			if (!context?.topology || !('vm_service_id' in edge)) return '';
			const vmService = context.topology.services.find((s) => s.id === edge.vm_service_id);
			if (!vmService) return '';
			return serviceDefinitions.getName(vmService.service_definition) ?? '';
		},
		getIcon: () => edgeTypes.getIconComponent('HostVirtualization'),
		getIconColor: () => edgeTypes.getColorHelper('HostVirtualization').icon
	};

	export interface EdgeDisplayContext {
		topology?: Topology;
	}
</script>

<script lang="ts">
	import type { EntityDisplayComponent } from '../types';
	import ListSelectItem from '../ListSelectItem.svelte';

	interface Props {
		item: TopologyEdge;
		context: EdgeDisplayContext;
	}

	let { item, context }: Props = $props();
</script>

<ListSelectItem {item} {context} displayComponent={HostVirtualizationEdgeDisplay} />
