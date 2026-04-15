<script lang="ts">
	export let label: string;
	export let mono: boolean = false;
</script>

<div class="flex flex-wrap items-baseline justify-between gap-x-2 gap-y-0.5">
	<span class="text-secondary flex-shrink-0 text-sm">{label}:</span>
	<span class="text-primary min-w-0 text-sm" class:font-mono={mono} class:text-xs={mono}>
		<slot />
	</span>
</div>
