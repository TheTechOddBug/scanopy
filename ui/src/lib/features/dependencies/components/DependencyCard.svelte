<script lang="ts">
	import { Edit, Trash2 } from 'lucide-svelte';
	import GenericCard from '$lib/shared/components/data/GenericCard.svelte';
	import type { Dependency } from '../types/base';
	import { entities, dependencyTypes } from '$lib/shared/stores/metadata';
	import { useServicesCacheQuery } from '$lib/features/services/queries';
	import { toColor } from '$lib/shared/utils/styling';
	import { serviceDefinitions } from '$lib/shared/stores/metadata';
	import TagPickerInline from '$lib/features/tags/components/TagPickerInline.svelte';
	import { entityRef } from '$lib/shared/components/data/types';
	import {
		common_color,
		common_delete,
		common_description,
		common_edit,
		common_noTypeSpecified,
		common_services,
		common_tags,
		dependencies_edgeStyleLabel,
		dependencies_dependencyType,
		dependencies_noServicesInDependency
	} from '$lib/paraglide/messages';

	// Queries
	const servicesQuery = useServicesCacheQuery();

	// Derived data
	let servicesData = $derived(servicesQuery.data ?? []);

	let {
		dependency,
		onEdit,
		onDelete,
		viewMode,
		selected,
		onSelectionChange = () => {}
	}: {
		dependency: Dependency;
		onEdit?: (dependency: Dependency) => void;
		onDelete?: (dependency: Dependency) => void;
		viewMode: 'card' | 'list';
		selected: boolean;
		onSelectionChange?: (selected: boolean) => void;
	} = $props();

	// Get services for this dependency via members
	// Using $derived.by() for proper reactivity with complex computation
	let dependencyServices = $derived.by(() => {
		if (
			dependency.dependency_type !== 'RequestPath' &&
			dependency.dependency_type !== 'HubAndSpoke'
		) {
			return [];
		}
		if (servicesData.length === 0 || (dependency.members ?? []).length === 0) {
			return [];
		}
		// Build a map of service.id -> service for lookup
		const serviceMap = new Map(servicesData.map((s) => [s.id, s]));

		return (dependency.members ?? [])
			.map((member) => serviceMap.get(member.service_id))
			.filter((s): s is NonNullable<typeof s> => s !== null && s !== undefined);
	});

	let dependencyServiceLabels = $derived(
		dependencyServices.map((s) => {
			const def = serviceDefinitions.getItem(s.service_definition);
			return {
				id: s.id,
				label: def ? `${s.name} (${def.name})` : s.name,
				service: s
			};
		})
	);

	// Build card data
	let cardData = $derived({
		title: dependency.name,
		iconColor: dependencyTypes.getColorHelper(dependency.dependency_type).icon,
		Icon: dependencyTypes.getIconComponent(dependency.dependency_type),
		fields: [
			{
				label: common_description(),
				value: dependency.description
			},
			{
				label: dependencies_dependencyType(),
				value: [
					{
						id: 'type',
						label: dependencyTypes.getName(dependency.dependency_type),
						color: dependencyTypes.getColorString(dependency.dependency_type)
					}
				],
				emptyText: common_noTypeSpecified()
			},
			{
				label: common_color(),
				value: [
					{
						id: 'color',
						label: dependency.color.charAt(0).toUpperCase() + dependency.color.slice(1),
						color: dependency.color
					}
				],
				emptyText: common_noTypeSpecified()
			},
			{
				label: dependencies_edgeStyleLabel(),
				value: [
					{
						id: 'type',
						label: dependency.edge_style,
						color: toColor('gray')
					}
				],
				emptyText: common_noTypeSpecified()
			},
			{
				label: common_services(),
				value: dependencyServiceLabels.map(({ id, label, service }, i) => ({
					id: id + i,
					label,
					color: entities.getColorString('Service'),
					entityRef: entityRef('Service', service.id, service, { interfaceId: null })
				})),
				emptyText: dependencies_noServicesInDependency()
			},
			{ label: common_tags(), snippet: tagsSnippet }
		],

		actions: [
			...(onDelete
				? [
						{
							label: common_delete(),
							icon: Trash2,
							class: 'btn-icon-danger',
							onClick: () => onDelete(dependency)
						}
					]
				: []),
			...(onEdit ? [{ label: common_edit(), icon: Edit, onClick: () => onEdit(dependency) }] : [])
		]
	});
</script>

{#snippet tagsSnippet()}
	<div class="flex items-center gap-2">
		<span class="text-secondary text-sm">{common_tags()}:</span>
		<TagPickerInline
			selectedTagIds={dependency.tags}
			entityId={dependency.id}
			entityType="Dependency"
		/>
	</div>
{/snippet}

<GenericCard {...cardData} {viewMode} {selected} {onSelectionChange} />
