<script lang="ts">
	import type { components } from '$lib/api/schema';
	import {
		UNTAGGED_SENTINEL,
		GENERIC_SENTINEL,
		hoveredTag,
		type HoveredTag
	} from '../../../interactions';
	import FilterGroup, { type FilterItem } from './FilterGroup.svelte';
	import { concepts } from '$lib/shared/stores/metadata';
	import { topology_genericServices } from '$lib/paraglide/messages';

	type TagType = components['schemas']['Tag'];

	let {
		label,
		tags,
		hiddenTagIds,
		onToggle,
		entityType,
		hasUntagged = false,
		hasGeneric = false
	}: {
		label: string;
		tags: TagType[];
		hiddenTagIds: string[];
		onToggle: (tagId: string) => void;
		entityType: HoveredTag['entityType'];
		hasUntagged?: boolean;
		hasGeneric?: boolean;
	} = $props();

	// Build items list with sentinel pseudo-tags first, then real tags
	let items = $derived.by(() => {
		const result: FilterItem[] = [];
		if (hasUntagged) {
			result.push({ value: UNTAGGED_SENTINEL, label: 'Untagged', color: 'Gray' });
		}
		if (hasGeneric) {
			result.push({
				value: GENERIC_SENTINEL,
				label: topology_genericServices(),
				color: 'Gray'
			});
		}
		for (const tag of tags) {
			const isAppGroup = tag.is_application_group ?? false;
			result.push({
				value: tag.id,
				label: tag.name,
				color: tag.color as FilterItem['color'],
				icon: isAppGroup ? concepts.getIconComponent('Application') : undefined,
				isShiny: isAppGroup
			});
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
