<script lang="ts">
	import Checkbox from '$lib/shared/components/forms/input/Checkbox.svelte';
	import type { AnyFieldApi } from '@tanstack/svelte-form';
	import type { DependencyTarget } from '../../../../resolvers';
	import type { Topology } from '../../../../types/base';
	import {
		dependencies_pickServicesOnHost,
		dependencies_pickServicesAtIp
	} from '$lib/paraglide/messages';

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

	let candidates = $derived(
		target.candidateServiceIds
			.map((id) => topology.services.find((s) => s.id === id))
			.filter((s): s is NonNullable<typeof s> => !!s)
	);

	let heading = $derived(
		target.kind === 'host'
			? dependencies_pickServicesOnHost({ hostName: target.label })
			: dependencies_pickServicesAtIp({ ipAddress: target.label })
	);
</script>

<div class="card card-static space-y-1.5 p-2">
	<div class="text-primary text-xs font-medium">{heading}</div>
	{#if target.kind === 'ipAddress' && target.hostName}
		<div class="text-tertiary truncate text-[10px]">{target.hostName}</div>
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
