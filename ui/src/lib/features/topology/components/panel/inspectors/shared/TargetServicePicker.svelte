<script lang="ts">
	import Checkbox from '$lib/shared/components/forms/input/Checkbox.svelte';
	import type { AnyFieldApi } from '@tanstack/svelte-form';
	import EntityDisplayWrapper from '$lib/shared/components/forms/selection/display/EntityDisplayWrapper.svelte';
	import {
		HostDisplay,
		type HostDisplayContext
	} from '$lib/shared/components/forms/selection/display/HostDisplay.svelte';
	import {
		IPAddressDisplay,
		type IPAddressDisplayContext
	} from '$lib/shared/components/forms/selection/display/IPAddressDisplay.svelte';
	import { useSubnetsQuery } from '$lib/features/subnets/queries';
	import type { DependencyTarget } from '../../../../resolvers';
	import type { Topology } from '../../../../types/base';

	let {
		form,
		topology,
		target
	}: {
		// eslint-disable-next-line @typescript-eslint/no-explicit-any
		form: any;
		topology: Topology;
		target: Extract<DependencyTarget, { kind: 'host' | 'ipAddress' }>;
	} = $props();

	let host = $derived(topology.hosts.find((h) => h.id === target.hostId));
	let ipAddress = $derived(
		target.kind === 'ipAddress'
			? topology.ip_addresses.find((i) => i.id === target.ipAddressId)
			: undefined
	);

	let candidates = $derived(
		target.candidateServiceIds
			.map((id) => topology.services.find((s) => s.id === id))
			.filter((s): s is NonNullable<typeof s> => !!s)
	);

	let hostContext: HostDisplayContext = $derived({ compact: true });
	const subnetsQuery = useSubnetsQuery();
	let ipContext: IPAddressDisplayContext = $derived({
		subnets: subnetsQuery.data ?? [],
		compact: true
	});
</script>

<div class="card card-static space-y-2 p-2">
	<!-- Card header: host (and IP if applicable) rendered via shared entity displays -->
	{#if host}
		<EntityDisplayWrapper context={hostContext} item={host} displayComponent={HostDisplay} />
	{/if}
	{#if ipAddress}
		<EntityDisplayWrapper
			context={ipContext}
			item={ipAddress}
			displayComponent={IPAddressDisplay}
		/>
	{/if}

	{#if candidates.length === 0}
		<div class="text-tertiary text-xs italic">—</div>
	{:else}
		{#each candidates as service (service.id)}
			<form.Field name="picks.{target.elementId}.{service.id}">
				{#snippet children(field: AnyFieldApi)}
					<Checkbox label={service.name} id="target-{target.elementId}-{service.id}" {field} />
				{/snippet}
			</form.Field>
		{/each}
	{/if}
</div>
