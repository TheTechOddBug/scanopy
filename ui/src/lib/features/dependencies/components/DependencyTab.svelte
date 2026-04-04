<script lang="ts">
	import TabHeader from '$lib/shared/components/layout/TabHeader.svelte';
	import type { Dependency } from '../types/base';
	import DependencyCard from './DependencyCard.svelte';
	import DependencyEditModal from './DependencyEditModal/DependencyEditModal.svelte';
	import EmptyState from '$lib/shared/components/layout/EmptyState.svelte';
	import PreDaemonEmptyState from '$lib/shared/components/layout/PreDaemonEmptyState.svelte';
	import Loading from '$lib/shared/components/feedback/Loading.svelte';
	import DataControls from '$lib/shared/components/data/DataControls.svelte';
	import { defineFields } from '$lib/shared/components/data/types';
	import { Plus } from 'lucide-svelte';
	import { useTagsQuery } from '$lib/features/tags/queries';
	import {
		useDependenciesQuery,
		useCreateDependencyMutation,
		useUpdateDependencyMutation,
		useDeleteDependencyMutation,
		useBulkDeleteDependenciesMutation
	} from '../queries';
	import { useServicesCacheQuery } from '$lib/features/services/queries';
	import { useNetworksQuery } from '$lib/features/networks/queries';
	import { useHostsQuery } from '$lib/features/hosts/queries';
	import type { TabProps } from '$lib/shared/types';
	import type { components } from '$lib/api/schema';
	import { useOrganizationQuery } from '$lib/features/organizations/queries';
	import { hasDaemon } from '$lib/shared/onboarding/checklist';
	import { downloadCsv } from '$lib/shared/utils/csvExport';
	import { modalState, resolveModalDeepLink } from '$lib/shared/stores/modal-registry';
	import {
		common_confirmDeleteName,
		common_create,
		common_created,
		common_description,
		common_dependenciesLabel,
		common_name,
		common_network,
		common_tags,
		common_unknownNetwork,
		common_updated,
		dependencies_confirmBulkDelete,
		dependencies_dependencyType,
		dependencies_noDependenciesHelp,
		dependencies_noDependenciesYet,
		dependencies_subtitle
	} from '$lib/paraglide/messages';

	type DependencyOrderField = components['schemas']['DependencyOrderField'];
	type OnboardingOperation = components['schemas']['OnboardingOperation'];

	let { isReadOnly = false }: TabProps = $props();

	// Organization query for onboarding state
	const organizationQuery = useOrganizationQuery();
	let onboarding = $derived((organizationQuery.data?.onboarding ?? []) as OnboardingOperation[]);

	// Queries
	const tagsQuery = useTagsQuery();
	const dependenciesQuery = useDependenciesQuery();
	const networksQuery = useNetworksQuery();
	// Load all hosts to populate services cache for DependencyCard display
	const hostsQuery = useHostsQuery({ limit: 0 });
	useServicesCacheQuery();

	// Mutations
	const createDependencyMutation = useCreateDependencyMutation();
	const updateDependencyMutation = useUpdateDependencyMutation();
	const deleteDependencyMutation = useDeleteDependencyMutation();
	const bulkDeleteDependenciesMutation = useBulkDeleteDependenciesMutation();

	// Derived data
	let tagsData = $derived(tagsQuery.data ?? []);
	let dependenciesData = $derived(dependenciesQuery.data ?? []);
	let networksData = $derived(networksQuery.data ?? []);
	let isLoading = $derived(dependenciesQuery.isPending || hostsQuery.isPending);

	let showDependencyEditor = $state(false);
	let editingDependency = $state<Dependency | null>(null);

	// Deep-link: open dependency editor from URL (handles both fresh open and entity switch)
	$effect(() => {
		const result = resolveModalDeepLink(
			$modalState,
			'dependency-editor',
			dependenciesData,
			showDependencyEditor,
			editingDependency?.id
		);
		if (result !== undefined) {
			editingDependency = result;
			showDependencyEditor = true;
		}
	});

	function handleCreateDependency() {
		editingDependency = null;
		showDependencyEditor = true;
	}

	function handleEditDependency(dependency: Dependency) {
		editingDependency = dependency;
		showDependencyEditor = true;
	}

	function handleDeleteDependency(dependency: Dependency) {
		if (confirm(common_confirmDeleteName({ name: dependency.name }))) {
			deleteDependencyMutation.mutate(dependency.id);
		}
	}

	async function handleDependencyCreate(data: Dependency) {
		try {
			await createDependencyMutation.mutateAsync(data);
			showDependencyEditor = false;
			editingDependency = null;
		} catch {
			// Error handled by mutation
		}
	}

	async function handleDependencyUpdate(id: string, data: Dependency) {
		try {
			await updateDependencyMutation.mutateAsync(data);
			showDependencyEditor = false;
			editingDependency = null;
		} catch {
			// Error handled by mutation
		}
	}

	function handleCloseDependencyEditor() {
		showDependencyEditor = false;
		editingDependency = null;
	}

	async function handleBulkDelete(ids: string[]) {
		if (confirm(dependencies_confirmBulkDelete({ count: ids.length }))) {
			await bulkDeleteDependenciesMutation.mutateAsync(ids);
		}
	}

	function getDependencyTags(dependency: Dependency): string[] {
		return dependency.tags;
	}

	// CSV export handler
	async function handleCsvExport() {
		await downloadCsv('Dependency', {});
	}

	// Define field configuration for the DataTableControls
	// Uses defineFields to ensure all DependencyOrderField values are covered
	let dependencyFields = $derived(
		defineFields<Dependency, DependencyOrderField>(
			{
				name: { label: common_name(), type: 'string', searchable: true },
				dependency_type: {
					label: dependencies_dependencyType(),
					type: 'string',
					searchable: true,
					filterable: true
				},
				network_id: {
					label: common_network(),
					type: 'string',
					filterable: true,
					groupable: true,
					getValue: (item) =>
						networksData.find((n) => n.id == item.network_id)?.name || common_unknownNetwork()
				},
				created_at: { label: common_created(), type: 'date' },
				updated_at: { label: common_updated(), type: 'date' }
			},
			[
				{ key: 'description', label: common_description(), type: 'string', searchable: true },
				{
					key: 'tags',
					label: common_tags(),
					type: 'array',
					searchable: true,
					filterable: true,
					getValue: (entity) =>
						entity.tags
							.map((id) => tagsData.find((t) => t.id === id)?.name)
							.filter((name): name is string => !!name)
				}
			]
		)
	);
</script>

<div class="space-y-6">
	<TabHeader title={common_dependenciesLabel()} subtitle={dependencies_subtitle()}>
		<svelte:fragment slot="actions">
			{#if hasDaemon(onboarding) && !isReadOnly}
				<button class="btn-primary flex items-center" onclick={handleCreateDependency}
					><Plus class="h-5 w-5" />{common_create()}</button
				>
			{/if}
		</svelte:fragment>
	</TabHeader>

	{#if !hasDaemon(onboarding)}
		<PreDaemonEmptyState
			title="Install a daemon to start organizing dependencies on your network."
		/>
	{:else if isLoading}
		<Loading />
	{:else if dependenciesData.length === 0}
		<!-- Empty state -->
		<EmptyState
			title={dependencies_noDependenciesYet()}
			subtitle={dependencies_noDependenciesHelp()}
			onClick={handleCreateDependency}
			cta={common_create()}
		/>
	{:else}
		<DataControls
			items={dependenciesData}
			fields={dependencyFields}
			storageKey="scanopy-dependencies-table-state"
			onBulkDelete={isReadOnly ? undefined : handleBulkDelete}
			entityType={isReadOnly ? undefined : 'Dependency'}
			getItemTags={getDependencyTags}
			getItemId={(item) => item.id}
			onCsvExport={handleCsvExport}
		>
			{#snippet children(
				item: Dependency,
				viewMode: 'card' | 'list',
				isSelected: boolean,
				onSelectionChange: (selected: boolean) => void
			)}
				<DependencyCard
					dependency={item}
					selected={isSelected}
					{onSelectionChange}
					{viewMode}
					onEdit={isReadOnly ? undefined : () => handleEditDependency(item)}
					onDelete={isReadOnly ? undefined : () => handleDeleteDependency(item)}
				/>
			{/snippet}
		</DataControls>
	{/if}
</div>

<!-- Modal -->
<DependencyEditModal
	name="dependency-editor"
	isOpen={showDependencyEditor}
	dependency={editingDependency}
	onCreate={handleDependencyCreate}
	onUpdate={handleDependencyUpdate}
	onClose={handleCloseDependencyEditor}
	onDelete={editingDependency
		? () => {
				handleDeleteDependency(editingDependency!);
				handleCloseDependencyEditor();
			}
		: null}
/>
