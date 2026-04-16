<script lang="ts" module>
	export interface BindingPickerService {
		serviceId: string;
		/**
		 * Optional IP-address scope. If set, candidate bindings are filtered to those whose
		 * `ip_address_id` matches this value or is null (i.e. all-IPs binding).
		 */
		ipAddressIdFilter?: string | null;
	}
</script>

<script lang="ts">
	import RichSelect from '$lib/shared/components/forms/selection/RichSelect.svelte';
	import EntityDisplayWrapper from '$lib/shared/components/forms/selection/display/EntityDisplayWrapper.svelte';
	import type { AnyFieldApi } from '@tanstack/svelte-form';
	import {
		BindingWithServiceDisplay,
		type BindingWithServiceContext
	} from '$lib/shared/components/forms/selection/display/BindingWithServiceDisplay.svelte';
	import { useSubnetsQuery, isContainerSubnet } from '$lib/features/subnets/queries';
	import {
		dependencies_selectPort,
		dependencies_noOpenPortsError,
		topology_multiSelectNoBindings
	} from '$lib/paraglide/messages';
	import type { Topology } from '../../../../types/base';
	import type { Binding } from '$lib/features/services/types/base';

	let {
		form,
		fieldPrefix = 'bindings',
		topology,
		services,
		disabled = false
	}: {
		// eslint-disable-next-line @typescript-eslint/no-explicit-any
		form: any;
		/** Prefix for the form field path — fields live at `${fieldPrefix}.${serviceId}`. */
		fieldPrefix?: string;
		topology: Topology;
		services: BindingPickerService[];
		disabled?: boolean;
	} = $props();

	const subnetsQuery = useSubnetsQuery();
	let subnetsData = $derived(subnetsQuery.data ?? []);
	let isContainerSubnetFn = $derived((subnetId: string) => {
		const subnet = subnetsData.find((s) => s.id === subnetId);
		return subnet ? isContainerSubnet(subnet) : false;
	});

	let bindingContext: BindingWithServiceContext = $derived({
		services: topology.services,
		hosts: topology.hosts,
		ip_addresses: topology.ip_addresses,
		ports: topology.ports,
		isContainerSubnet: isContainerSubnetFn,
		compact: true
	});

	// A binding chosen by any other service is unavailable to this one.
	// Read once per render from the form so the filter stays reactive.
	let chosenByOtherService = $derived.by(() => {
		const bindings = (form.state.values[fieldPrefix] ?? {}) as Record<string, string>;
		return (serviceId: string, bindingId: string) =>
			Object.entries(bindings).some(([svcId, bid]) => svcId !== serviceId && bid === bindingId);
	});

	function filterCandidates(
		service: BindingPickerService,
		flatIndex: number,
		allBindings: Binding[]
	): Binding[] {
		return allBindings.filter((b) => {
			// Non-first services need a port — IP-only bindings are invalid.
			if (flatIndex > 0 && b.type === 'IPAddress') return false;
			// IP-scope filter: when the service came from an IP-address target,
			// restrict to bindings on that IP (or null = all-IPs).
			if (service.ipAddressIdFilter != null) {
				if (b.ip_address_id !== service.ipAddressIdFilter && b.ip_address_id !== null) {
					return false;
				}
			}
			// Dedupe against other services' selections.
			if (chosenByOtherService(service.serviceId, b.id)) return false;
			return true;
		});
	}

	function getService(serviceId: string) {
		return topology.services.find((s) => s.id === serviceId);
	}

	function hostNameFor(serviceId: string): string {
		const svc = getService(serviceId);
		if (!svc) return '';
		return topology.hosts.find((h) => h.id === svc.host_id)?.name ?? '';
	}

	// Auto-resolve singletons: when a service has exactly one candidate binding, write it
	// to the form. Idempotent — setFieldValue skips if the value matches.
	$effect(() => {
		for (let i = 0; i < services.length; i++) {
			const svc = services[i];
			const backing = getService(svc.serviceId);
			if (!backing) continue;
			const candidates = filterCandidates(svc, i, backing.bindings);
			if (candidates.length !== 1) continue;
			const existing = form.state.values[fieldPrefix]?.[svc.serviceId];
			if (existing === candidates[0].id) continue;
			form.setFieldValue(`${fieldPrefix}.${svc.serviceId}`, candidates[0].id);
		}
	});
</script>

<div class="space-y-2">
	{#each services as service, flatIndex (service.serviceId)}
		{@const backing = getService(service.serviceId)}
		{#if backing}
			{@const candidates = filterCandidates(service, flatIndex, backing.bindings)}
			{#if candidates.length === 0}
				<div class="card card-static space-y-1 p-2">
					{#if flatIndex > 0 && backing.bindings.every((b) => b.type === 'IPAddress')}
						<p class="text-danger text-xs">
							{dependencies_noOpenPortsError({
								serviceName: backing.name,
								hostName: hostNameFor(service.serviceId)
							})}
						</p>
					{:else}
						<div class="text-tertiary text-xs italic">
							{topology_multiSelectNoBindings()}
						</div>
					{/if}
				</div>
			{:else if candidates.length === 1}
				<div class="card card-static p-2">
					<EntityDisplayWrapper
						context={bindingContext}
						item={candidates[0]}
						displayComponent={BindingWithServiceDisplay}
					/>
				</div>
			{:else}
				<form.Field name="{fieldPrefix}.{service.serviceId}">
					{#snippet children(field: AnyFieldApi)}
						<RichSelect
							options={candidates}
							selectedValue={field.state.value ?? null}
							placeholder={dependencies_selectPort()}
							displayComponent={BindingWithServiceDisplay}
							getOptionContext={() => bindingContext}
							onSelect={(bindingId) => field.handleChange(bindingId)}
							required
							{disabled}
						/>
					{/snippet}
				</form.Field>
			{/if}
		{/if}
	{/each}
</div>
