<script lang="ts" context="module">
	import { entities, dependencyTypes } from '$lib/shared/stores/metadata';

	export const DependencyDisplay: EntityDisplayComponent<Dependency, object> = {
		getId: (dependency: Dependency) => dependency.id,
		getLabel: (dependency: Dependency) => dependency.name,
		getDescription: (dependency: Dependency) =>
			`${(dependency.members ?? []).length} member${(dependency.members ?? []).length !== 1 ? 's' : ''} in dependency`,
		getIcon: (dependency: Dependency) =>
			dependencyTypes.getIconComponent(dependency.dependency_type),
		getIconColor: () => entities.getColorHelper('Dependency').icon,
		getTags: (dependency: Dependency) => [
			{
				label: dependencyTypes.getName(dependency.dependency_type),
				color: dependencyTypes.getColorHelper(dependency.dependency_type).color
			}
		]
	};
</script>

<script lang="ts">
	import type { EntityDisplayComponent } from '../types';
	import ListSelectItem from '../ListSelectItem.svelte';
	import type { Dependency } from '$lib/features/dependencies/types/base';

	export let item: Dependency;
	export let context = {};
</script>

<ListSelectItem {item} {context} displayComponent={DependencyDisplay} />
