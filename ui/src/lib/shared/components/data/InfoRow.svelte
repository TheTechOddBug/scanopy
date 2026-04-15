<script lang="ts">
	export let label: string;
	export let mono: boolean = false;
</script>

<div class="info-row">
	<span class="info-label">{label}:</span>
	<span class="info-value" class:font-mono={mono} class:text-xs={mono}>
		<slot />
	</span>
</div>

<style>
	.info-row {
		container-type: inline-size;
		display: flex;
		flex-wrap: wrap;
		align-items: baseline;
		gap: 2px 8px;
	}

	.info-label {
		flex-shrink: 0;
		font-size: 0.875rem;
		color: var(--color-text-secondary);
	}

	.info-value {
		flex: 1 1 auto;
		min-width: 0;
		text-align: right;
		font-size: 0.875rem;
		color: var(--color-text-primary);
	}

	/* Narrow container: value wraps below label with indent marker */
	@container (max-width: 260px) {
		.info-value {
			flex-basis: 100%;
			text-align: left;
			border-left: 2px solid var(--color-border);
			padding-left: 8px;
		}
	}
</style>
