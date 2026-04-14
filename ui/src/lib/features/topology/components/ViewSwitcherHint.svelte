<script lang="ts">
	import { X } from 'lucide-svelte';
	import { showViewSwitcherHint } from '../queries';
	import { topology_viewSwitcherHint } from '$lib/paraglide/messages';
	import { onMount } from 'svelte';

	let { anchor }: { anchor: HTMLElement } = $props();

	let portalContainer: HTMLDivElement | null = $state(null);
	let top = $state(0);
	let left = $state(0);
	let ready = $state(false);

	onMount(() => {
		portalContainer = document.createElement('div');
		portalContainer.style.position = 'absolute';
		portalContainer.style.top = '0';
		portalContainer.style.left = '0';
		portalContainer.style.width = '0';
		portalContainer.style.height = '0';
		document.body.appendChild(portalContainer);

		setTimeout(() => {
			if (!anchor) return;
			const rect = anchor.getBoundingClientRect();
			const hintWidth = 256; // w-64
			top = rect.bottom + 8;
			left = rect.left + rect.width / 2 - hintWidth / 2;
			ready = true;
		}, 100);

		// Dismiss on any click
		function handleClick() {
			dismiss();
		}
		document.addEventListener('click', handleClick, { once: true, capture: true });

		return () => {
			portalContainer?.remove();
			document.removeEventListener('click', handleClick, { capture: true });
		};
	});

	function portal(node: HTMLElement) {
		portalContainer?.appendChild(node);
		return {
			destroy() {
				node.remove();
			}
		};
	}

	function dismiss() {
		showViewSwitcherHint.set(false);
	}
</script>

{#if ready && portalContainer}
	<div
		use:portal
		class="fixed z-[9999] w-64"
		style="top: {top}px; left: {left}px;"
	>
		<div class="hint-callout relative rounded-lg p-3 shadow-lg">
			<!-- Arrow pointing up, centered -->
			<div class="hint-arrow absolute -top-2 left-1/2 -translate-x-1/2"></div>
			<div class="flex items-start gap-2">
				<p class="text-primary flex-1 text-xs">
					{topology_viewSwitcherHint()}
				</p>
				<button class="btn-icon flex-shrink-0 p-0.5" onclick={dismiss}>
					<X class="h-3.5 w-3.5" />
				</button>
			</div>
		</div>
	</div>
{/if}

<style>
	.hint-callout {
		background: var(--color-bg-surface);
		border: 1px solid rgba(59, 130, 246, 0.4);
		box-shadow:
			0 0 12px rgba(59, 130, 246, 0.15),
			0 4px 12px rgba(0, 0, 0, 0.3);
	}

	.hint-arrow {
		width: 0;
		height: 0;
		border-left: 8px solid transparent;
		border-right: 8px solid transparent;
		border-bottom: 8px solid rgba(59, 130, 246, 0.4);
	}
</style>
