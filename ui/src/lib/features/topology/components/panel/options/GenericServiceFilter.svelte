<script lang="ts">
	import { common_generic } from '$lib/paraglide/messages';
	import { topology_showGenericServices } from '$lib/paraglide/messages';

	let {
		hidden,
		onToggle
	}: {
		hidden: boolean;
		onToggle: () => void;
	} = $props();
</script>

<div class="space-y-1">
	<div class="text-tertiary text-xs">{common_generic()}</div>
	<label class="flex items-center gap-2">
		<input type="checkbox" checked={!hidden} onchange={onToggle} class="h-3.5 w-3.5 rounded" />
		<span class="text-secondary text-xs">{topology_showGenericServices()}</span>
	</label>
</div>
