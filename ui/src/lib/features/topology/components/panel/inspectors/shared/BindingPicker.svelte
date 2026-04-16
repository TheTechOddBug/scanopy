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
	import {
		topology_multiSelectNoBindings,
		topology_multiSelectPickBinding
	} from '$lib/paraglide/messages';

	let {
		topology,
		services,
		selections,
		disabled = false
	}: {
		topology: Topology;
		services: BindingPickerService[];
		selections: Map<string, string | null>;
		disabled?: boolean;
	} = $props();

	function optionsFor(service: BindingPickerService): BindingOption[] {
		return buildBindingOptions(topology, service.serviceId, service.ipAddressIdFilter);
	}

	// Reactively initialise / prune the selections map to match current services.
	$effect(() => {
		const wanted = new Set(services.map((s) => s.serviceId));
		for (const key of selections.keys()) {
			if (!wanted.has(key)) selections.delete(key);
		}
		for (const service of services) {
			if (!selections.has(service.serviceId)) {
				const opts = optionsFor(service);
				selections.set(service.serviceId, opts.length === 1 ? opts[0].id : null);
			}
		}
	});
</script>

<div class="space-y-2">
	{#each services as service (service.serviceId)}
		{@const options = optionsFor(service)}
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
				<select
					class="h-auto min-h-6 w-full rounded px-1 text-xs"
					style="border: 1px solid var(--color-border-input); background: var(--color-bg-input); color: var(--color-text-primary)"
					value={selections.get(service.serviceId) ?? ''}
					{disabled}
					onchange={(e) => {
						const target = e.target as HTMLSelectElement;
						selections.set(service.serviceId, target.value || null);
					}}
				>
					<option value="">{topology_multiSelectPickBinding()}</option>
					{#each options as option (option.id)}
						<option value={option.id}>{option.label}</option>
					{/each}
				</select>
			{/if}
		</div>
	{/each}
</div>
