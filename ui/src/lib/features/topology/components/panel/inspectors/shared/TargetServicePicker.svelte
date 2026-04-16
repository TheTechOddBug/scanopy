<script lang="ts">
	import { SvelteSet } from 'svelte/reactivity';
	import type { DependencyTarget } from '../../../../resolvers';
	import type { Topology } from '../../../../types/base';
	import {
		dependencies_pickServicesOnHost,
		dependencies_pickServicesAtIp
	} from '$lib/paraglide/messages';

	let {
		topology,
		target,
		selectedServiceIds
	}: {
		topology: Topology;
		target: Extract<DependencyTarget, { kind: 'host' | 'ipAddress' }>;
		selectedServiceIds: SvelteSet<string>;
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

	function toggle(serviceId: string) {
		if (selectedServiceIds.has(serviceId)) selectedServiceIds.delete(serviceId);
		else selectedServiceIds.add(serviceId);
	}
</script>

<div class="card card-static space-y-1.5 p-2">
	<div class="text-primary text-xs font-medium">{heading}</div>
	{#if target.kind === 'ipAddress' && target.hostName}
		<div class="text-tertiary truncate text-[10px]">{target.hostName}</div>
	{/if}
	{#if candidates.length === 0}
		<div class="text-tertiary text-xs italic">—</div>
	{:else}
		<ul class="space-y-1">
			{#each candidates as service (service.id)}
				<li>
					<label class="flex cursor-pointer items-center gap-2 text-xs">
						<input
							type="checkbox"
							checked={selectedServiceIds.has(service.id)}
							onchange={() => toggle(service.id)}
						/>
						<span class="text-secondary truncate">{service.name}</span>
					</label>
				</li>
			{/each}
		</ul>
	{/if}
</div>
