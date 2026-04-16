<script lang="ts" module>
	import type { Topology } from '../../../../types/base';

	export interface BindingPickerService {
		serviceId: string;
		serviceName: string;
		hostName: string;
		/**
		 * Optional IP-address scope. If set, candidate bindings are filtered to those whose
		 * `ip_address_id` matches this value or is null (i.e. all-IPs binding).
		 */
		ipAddressIdFilter?: string | null;
		/** Optional display label for the IP scope, shown as a subtitle. */
		ipScopeLabel?: string;
	}

	export interface BindingOption {
		id: string;
		label: string;
	}

	export function buildBindingOptions(
		topology: Topology,
		serviceId: string,
		ipAddressIdFilter: string | null | undefined
	): BindingOption[] {
		const service = topology.services.find((s) => s.id === serviceId);
		if (!service) return [];
		const options: BindingOption[] = [];
		for (const binding of service.bindings) {
			if (ipAddressIdFilter != null) {
				if (binding.ip_address_id !== ipAddressIdFilter && binding.ip_address_id !== null) {
					continue;
				}
			}
			const portInfo =
				binding.type === 'Port' && binding.port_id
					? (() => {
							const port = topology.ports.find((p) => p.id === binding.port_id);
							return port ? `:${port.number}/${port.protocol}` : '';
						})()
					: '';
			const ipInfo = binding.ip_address_id
				? (() => {
						const ip = topology.ip_addresses.find((i) => i.id === binding.ip_address_id);
						return ip ? ` @ ${ip.ip_address}` : '';
					})()
				: '';
			options.push({
				id: binding.id,
				label: `${service.name}${portInfo}${ipInfo}`
			});
		}
		return options;
	}
</script>

<script lang="ts">
	import SelectInput from '$lib/shared/components/forms/input/SelectInput.svelte';
	import type { AnyFieldApi } from '@tanstack/svelte-form';
	import { topology_multiSelectNoBindings, common_bindings } from '$lib/paraglide/messages';

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
</script>

<div class="space-y-2">
	{#each services as service (service.serviceId)}
		{@const options = buildBindingOptions(topology, service.serviceId, service.ipAddressIdFilter)}
		<div class="card card-static space-y-1 p-2">
			<div class="text-primary truncate text-xs font-medium">
				{service.serviceName}
			</div>
			<div class="text-tertiary truncate text-[10px]">
				{service.hostName}{service.ipScopeLabel ? ` — ${service.ipScopeLabel}` : ''}
			</div>
			{#if options.length === 0}
				<div class="text-tertiary text-xs italic">
					{topology_multiSelectNoBindings()}
				</div>
			{:else if options.length === 1}
				<div class="text-secondary text-xs">
					{options[0].label}
				</div>
			{:else}
				<form.Field name="{fieldPrefix}.{service.serviceId}">
					{#snippet children(field: AnyFieldApi)}
						<SelectInput
							label=""
							id="binding-{fieldPrefix}-{service.serviceId}"
							{field}
							{disabled}
							required
							options={[
								{ value: '', label: common_bindings(), disabled: true },
								...options.map((o) => ({ value: o.id, label: o.label }))
							]}
						/>
					{/snippet}
				</form.Field>
			{/if}
		</div>
	{/each}
</div>
