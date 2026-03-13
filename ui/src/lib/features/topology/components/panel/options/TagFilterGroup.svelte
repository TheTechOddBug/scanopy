<script lang="ts">
	import type { Color } from '$lib/shared/utils/styling';
	import type { components } from '$lib/api/schema';
	import { UNTAGGED_SENTINEL, hoveredTag, type HoveredTag } from '../../../interactions';
	import FilterGroup from './FilterGroup.svelte';

	type TagType = components['schemas']['Tag'];

	let {
		label,
		tags,
		hiddenTagIds,
		onToggle,
		entityType,
		hasUntagged = false
	}: {
		label: string;
		tags: TagType[];
		hiddenTagIds: string[];
		onToggle: (tagId: string) => void;
		entityType: HoveredTag['entityType'];
		hasUntagged?: boolean;
	} = $props();

	// Build items list with untagged sentinel first if applicable
	let items = $derived.by(() => {
		const result: { value: string; label: string; color: Color }[] = [];
		if (hasUntagged) {
			result.push({ value: UNTAGGED_SENTINEL, label: 'Untagged', color: 'Gray' });
		}
		for (const tag of tags) {
			result.push({ value: tag.id, label: tag.name, color: tag.color as Color });
		}
		return result;
	});

	function handleHoverStart(value: string, color: Color) {
		hoveredTag.set({ tagId: value, color: color as string, entityType });
	}

	function handleHoverEnd() {
		hoveredTag.set(null);
	}
</script>

<FilterGroup
	{items}
	selectedValues={hiddenTagIds}
	mode="exclude"
	{onToggle}
	onHoverStart={handleHoverStart}
	onHoverEnd={handleHoverEnd}
	{label}
/>
