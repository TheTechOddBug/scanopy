<script lang="ts" context="module">
	import { entities } from '$lib/shared/stores/metadata';

	export const NetworkDisplay: EntityDisplayComponent<Network, object> = {
		getId: (network: Network) => network.id,
		getLabel: (network: Network) => network.name,
		getDescription: (network: Network) => (network.snmp_credential_id ? 'SNMP Enabled' : ''),
		getIcon: () => entities.getIconComponent('Network'),
		getIconColor: () => entities.getColorHelper('Network').icon,
		getTags: (network: Network) => {
			if (network.snmp_credential_id) {
				return [{ label: 'SNMP', color: entities.getColorHelper('SnmpCredential').color }];
			}
			return [];
		},
		getCategory: () => null
	};
</script>

<script lang="ts">
	import ListSelectItem from '$lib/shared/components/forms/selection/ListSelectItem.svelte';
	import type { EntityDisplayComponent } from '../types';
	import type { Network } from '$lib/features/networks/types';

	export let item: Network;
	export let context = {};
</script>

<ListSelectItem {item} {context} displayComponent={NetworkDisplay} />
