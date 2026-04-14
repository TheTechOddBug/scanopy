<script lang="ts">
	import type { IconComponent } from '$lib/shared/utils/types';

	interface ServiceDisplay {
		name: string;
		icon: IconComponent;
		iconClass?: string;
	}

	let {
		headerText = null,
		services = [],
		bodyText = null,
		width = 150,
		selected = false,
		class: className = ''
	}: {
		headerText?: string | null;
		services?: ServiceDisplay[];
		bodyText?: string | null;
		width?: number;
		selected?: boolean;
		class?: string;
	} = $props();
</script>

<div
	class="card {selected ? 'card-selected' : ''} {className}"
	style="width: {width}px; display: flex; flex-direction: column; padding: 0;"
>
	{#if headerText}
		<div class="relative flex-shrink-0 px-2 pt-2 text-center">
			<div class="text-tertiary truncate text-xs font-medium leading-none">
				{headerText}
			</div>
		</div>
	{/if}

	<div class="flex flex-1 flex-col items-center justify-center px-3 py-2">
		{#if services.length > 0}
			<div class="flex w-full flex-col items-center" style="min-width: 0; max-width: 100%;">
				{#each services as service}
					<div
						class="flex flex-col items-center justify-center py-2"
						style="min-width: 0; max-width: 100%; width: 100%;"
					>
						<div
							class="flex items-center justify-center gap-1"
							style="line-height: 1.3; width: 100%; min-width: 0; max-width: 100%;"
							title={service.name}
						>
							<svelte:component
								this={service.icon}
								class="h-5 w-5 flex-shrink-0 {service.iconClass ?? ''}"
							/>
							<span class="text-m text-secondary truncate">
								{service.name}
							</span>
						</div>
					</div>
				{/each}
			</div>
		{:else if bodyText}
			<div class="text-secondary truncate text-center text-xs leading-none" title={bodyText}>
				{bodyText}
			</div>
		{/if}
	</div>
</div>
