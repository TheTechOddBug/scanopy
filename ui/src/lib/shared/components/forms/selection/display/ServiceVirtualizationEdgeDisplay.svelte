<script lang="ts" context="module">
	import { edgeTypes, serviceDefinitions } from '$lib/shared/stores/metadata';
	import type { Topology, TopologyEdge } from '$lib/features/topology/types/base';

	export const ServiceVirtualizationEdgeDisplay: EntityDisplayComponent<
		TopologyEdge,
		EdgeDisplayContext
	> = {
		getId: (edge) => edge.id,
		getLabel: (edge, context) => {
			if (!context?.topology || !('containerizing_service_id' in edge))
				return 'Service Virtualization';
			const service = context.topology.services.find(
				(s) => s.id === edge.containerizing_service_id
			);
			return service?.name ?? 'Unknown Service';
		},
		getDescription: (edge, context) => {
			if (!context?.topology || !('containerizing_service_id' in edge)) return '';
			const service = context.topology.services.find(
				(s) => s.id === edge.containerizing_service_id
			);
			if (!service) return '';
			return serviceDefinitions.getName(service.service_definition) ?? '';
		},
		getIcon: () => edgeTypes.getIconComponent('ServiceVirtualization'),
		getIconColor: () => edgeTypes.getColorHelper('ServiceVirtualization').icon
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

<ListSelectItem {item} {context} displayComponent={ServiceVirtualizationEdgeDisplay} />
