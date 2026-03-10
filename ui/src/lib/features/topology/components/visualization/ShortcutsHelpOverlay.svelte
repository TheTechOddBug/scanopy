<script lang="ts">
	import { X } from 'lucide-svelte';
	import {
		topology_shortcutsTitle,
		topology_shortcutSearch,
		topology_shortcutFitView,
		topology_shortcutZoomSelection,
		topology_shortcutToggleLock,
		topology_shortcutRebuild,
		topology_shortcutDeselect,
		topology_shortcutHelp,
		topology_shortcutSelectAll,
		topology_shortcutBoxSelect,
		topology_shortcutToggleSelect
	} from '$lib/paraglide/messages';

	let { isOpen = $bindable(false) }: { isOpen: boolean } = $props();

	const shortcuts = [
		{ keys: ['Ctrl/Cmd', 'F'], description: () => topology_shortcutSearch() },
		{ keys: ['/'], description: () => topology_shortcutSearch() },
		{ keys: ['F'], description: () => topology_shortcutFitView() },
		{ keys: ['Z'], description: () => topology_shortcutZoomSelection() },
		{ keys: ['L'], description: () => topology_shortcutToggleLock() },
		{ keys: ['R'], description: () => topology_shortcutRebuild() },
		{ keys: ['Escape'], description: () => topology_shortcutDeselect() },
		{ keys: ['?'], description: () => topology_shortcutHelp() },
		{ keys: ['Ctrl/Cmd', 'A'], description: () => topology_shortcutSelectAll() },
		{ keys: ['Shift', 'Drag'], description: () => topology_shortcutBoxSelect() },
		{ keys: ['Shift', 'Click'], description: () => topology_shortcutToggleSelect() }
	];

	function handleKeydown(event: KeyboardEvent) {
		if (event.key === 'Escape') {
			event.preventDefault();
			event.stopPropagation();
			isOpen = false;
		}
	}

	function handleBackdropClick() {
		isOpen = false;
	}
</script>

{#if isOpen}
	<!-- svelte-ignore a11y_no_static_element_interactions -->
	<div class="fixed inset-0 z-50 flex items-center justify-center" onkeydown={handleKeydown}>
		<!-- Backdrop -->
		<!-- svelte-ignore a11y_click_events_have_key_events -->
		<!-- svelte-ignore a11y_no_static_element_interactions -->
		<div class="absolute inset-0 bg-black/50" onclick={handleBackdropClick}></div>

		<!-- Modal -->
		<div class="card card-static relative z-10 w-96 p-4 shadow-xl">
			<div class="mb-4 flex items-center justify-between">
				<h3 class="text-primary text-sm font-semibold">{topology_shortcutsTitle()}</h3>
				<button class="btn-icon p-1" onclick={() => (isOpen = false)}>
					<X class="h-4 w-4" />
				</button>
			</div>

			<div class="space-y-1">
				{#each shortcuts as shortcut (shortcut.keys.join('+'))}
					<div class="flex items-center justify-between py-1.5">
						<span class="text-secondary text-sm">{shortcut.description()}</span>
						<div class="flex items-center gap-1">
							{#each shortcut.keys as key (key)}
								<kbd
									class="rounded border px-1.5 py-0.5 text-xs"
									style="border-color: var(--color-border); background: var(--color-bg-secondary); color: var(--color-text-secondary)"
								>
									{key}
								</kbd>
							{/each}
						</div>
					</div>
				{/each}
			</div>
		</div>
	</div>
{/if}
