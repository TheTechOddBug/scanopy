<script lang="ts">
	import type { Node } from '@xyflow/svelte';
	import { useSvelteFlow } from '@xyflow/svelte';
	import { Crosshair } from 'lucide-svelte';
	import InspectorInterfaceNode from './nodes/InspectorInterfaceNode.svelte';
	import InspectorSubnetNode from './nodes/InspectorSubnetNode.svelte';
	import { topology_focusNode } from '$lib/paraglide/messages';

	let { node }: { node: Node } = $props();

	const { fitView } = useSvelteFlow();

	let isInterfaceNode = $derived(node.type === 'InterfaceNode');
	let isSubnetNode = $derived(node.type === 'SubnetNode');

	function handleFocus() {
		fitView({ nodes: [{ id: node.id }], padding: 0.5, duration: 300 });
	}
</script>

<div class="w-full space-y-4">
	<div class="flex items-center justify-end">
		<button class="btn-icon p-1" onclick={handleFocus} title={topology_focusNode()}>
			<Crosshair class="h-4 w-4" />
		</button>
	</div>

	{#if isInterfaceNode}
		<InspectorInterfaceNode {node} />
	{:else if isSubnetNode}
		<InspectorSubnetNode {node} />
	{:else}
		<div class="space-y-3">
			<p class="text-tertiary text-sm">Unable to display node details</p>
		</div>
	{/if}
</div>
