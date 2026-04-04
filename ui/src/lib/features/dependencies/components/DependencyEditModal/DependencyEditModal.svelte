<script lang="ts">
	import { createForm } from '@tanstack/svelte-form';
	import { submitForm, validateForm } from '$lib/shared/components/forms/form-context';
	import { required, max } from '$lib/shared/components/forms/validators';
	import { Info, Palette, ArrowRight } from 'lucide-svelte';
	import InlineInfo from '$lib/shared/components/feedback/InlineInfo.svelte';
	import { createEmptyDependencyFormData } from '../../queries';
	import GenericModal from '$lib/shared/components/layout/GenericModal.svelte';
	import type { Dependency, EdgeStyle } from '../../types/base';
	import type { Color } from '$lib/shared/utils/styling';
	import ModalHeaderIcon from '$lib/shared/components/layout/ModalHeaderIcon.svelte';
	import { entities, dependencyTypes } from '$lib/shared/stores/metadata';
	import { useServicesCacheQuery } from '$lib/features/services/queries';
	import { useNetworksQuery } from '$lib/features/networks/queries';
	import { useHostsQuery } from '$lib/features/hosts/queries';
	import { useInterfacesQuery } from '$lib/features/interfaces/queries';
	import { usePortsQuery } from '$lib/features/ports/queries';
	import { useSubnetsQuery, isContainerSubnet } from '$lib/features/subnets/queries';
	import { BindingWithServiceDisplay } from '$lib/shared/components/forms/selection/display/BindingWithServiceDisplay.svelte';
	import ListManager from '$lib/shared/components/forms/selection/ListManager.svelte';
	import EntityMetadataSection from '$lib/shared/components/forms/EntityMetadataSection.svelte';
	import EdgeStyleForm from './EdgeStyleForm.svelte';
	import TextInput from '$lib/shared/components/forms/input/TextInput.svelte';
	import TextArea from '$lib/shared/components/forms/input/TextArea.svelte';
	import SelectInput from '$lib/shared/components/forms/input/SelectInput.svelte';
	import SelectNetwork from '$lib/features/networks/components/SelectNetwork.svelte';
	import TagPicker from '$lib/features/tags/components/TagPicker.svelte';
	import {
		common_back,
		common_cancel,
		common_create,
		common_delete,
		common_deleting,
		common_description,
		common_details,
		common_editName,
		common_next,
		common_saving,
		common_update,
		dependencies_createDependency,
		dependencies_descriptionPlaceholder,
		dependencies_edgeAppearance,
		dependencies_dependencyName,
		dependencies_dependencyNamePlaceholder,
		dependencies_dependencyType,
		dependencies_loadingServices,
		dependencies_noBindingsYet,
		dependencies_selectBinding,
		dependencies_serviceBindings,
		dependencies_serviceBindingsHelp,
		dependencies_serviceBindingsInfoTitle,
		dependencies_serviceBindingsInfoBody
	} from '$lib/paraglide/messages';

	interface Props {
		dependency?: Dependency | null;
		isOpen?: boolean;
		onCreate: (data: Dependency) => Promise<void> | void;
		onUpdate: (id: string, data: Dependency) => Promise<void> | void;
		onClose: () => void;
		onDelete?: ((id: string) => Promise<void> | void) | null;
		name?: string;
	}

	let {
		dependency = null,
		isOpen = false,
		onCreate,
		onUpdate,
		onClose,
		onDelete = null,
		name = undefined
	}: Props = $props();

	// TanStack Query hooks
	const servicesQuery = useServicesCacheQuery();
	const networksQuery = useNetworksQuery();
	// Use limit: 0 to get all hosts for dependency edit modal
	const hostsQuery = useHostsQuery({ limit: 0 });
	const interfacesQuery = useInterfacesQuery();
	const portsQuery = usePortsQuery();
	const subnetsQuery = useSubnetsQuery();

	let servicesData = $derived(servicesQuery.data ?? []);
	let isServicesLoading = $derived(hostsQuery.isPending);
	let networksData = $derived(networksQuery.data ?? []);
	let hostsData = $derived(hostsQuery.data?.items ?? []);
	let interfacesData = $derived(interfacesQuery.data ?? []);
	let portsData = $derived(portsQuery.data ?? []);
	let subnetsData = $derived(subnetsQuery.data ?? []);
	let defaultNetworkId = $derived(networksData[0]?.id ?? '');

	// Helper to check if subnet is a container subnet
	let isContainerSubnetFn = $derived((subnetId: string) => {
		const subnet = subnetsData.find((s) => s.id === subnetId);
		return subnet ? isContainerSubnet(subnet) : false;
	});

	// Context for BindingWithServiceDisplay
	let bindingContext = $derived({
		services: servicesData,
		hosts: hostsData,
		interfaces: interfacesData,
		ports: portsData,
		isContainerSubnet: isContainerSubnetFn
	});

	let loading = $state(false);
	let deleting = $state(false);

	let isEditing = $derived(dependency !== null);
	let title = $derived(
		isEditing ? common_editName({ name: dependency?.name ?? '' }) : dependencies_createDependency()
	);

	// Tab management
	let activeTab = $state('details');
	let furthestReached = $state(0);

	let tabs = $derived([
		{ id: 'details', label: common_details(), icon: Info },
		{
			id: 'bindings',
			label: dependencies_serviceBindings(),
			icon: entities.getIconComponent('Binding'),
			disabled: !isEditing && furthestReached < 1
		},
		{
			id: 'edge-style',
			label: dependencies_edgeAppearance(),
			icon: Palette,
			disabled: !isEditing && furthestReached < 2
		}
	]);

	let enabledTabs = $derived(tabs.filter((t) => !t.disabled));
	let currentEnabledIndex = $derived(enabledTabs.findIndex((t) => t.id === activeTab));

	function nextTab() {
		if (currentEnabledIndex < enabledTabs.length - 1) {
			activeTab = enabledTabs[currentEnabledIndex + 1].id;
		}
	}

	function previousTab() {
		if (currentEnabledIndex > 0) {
			activeTab = enabledTabs[currentEnabledIndex - 1].id;
		}
	}

	// Wizard steps for progressive unlock in create mode
	const wizardSteps = ['details', 'bindings', 'edge-style'];
	let isLastWizardStep = $derived(activeTab === wizardSteps[wizardSteps.length - 1]);

	// Dynamic labels based on create/edit mode and tab position
	let saveLabel = $derived(
		isEditing ? common_update() : isLastWizardStep ? common_create() : common_next()
	);
	let cancelLabel = $derived(isEditing ? common_cancel() : common_back());
	let showCancel = $derived(isEditing ? true : currentEnabledIndex !== 0);

	function getDefaultValues(): Dependency {
		return dependency ? { ...dependency } : createEmptyDependencyFormData(defaultNetworkId);
	}

	// Create form
	const form = createForm(() => ({
		defaultValues: createEmptyDependencyFormData(''),
		onSubmit: async ({ value }) => {
			const dependencyData: Dependency = {
				...(value as Dependency),
				name: value.name.trim(),
				description: value.description?.trim() || '',
				// Use local state for values that need Svelte reactivity
				members: memberBindingIds.length > 0
					? { type: 'Bindings' as const, binding_ids: memberBindingIds }
					: { type: 'Services' as const, service_ids: [] },
				color: edgeColor,
				edge_style: edgeEdgeStyle
			};

			loading = true;
			try {
				if (isEditing && dependency) {
					await onUpdate(dependency.id, dependencyData);
				} else {
					await onCreate(dependencyData);
				}
			} finally {
				loading = false;
			}
		}
	}));

	// Local state to enable Svelte 5 reactivity
	// (form.state.values is not tracked by $derived)
	let memberBindingIds = $state<string[]>([]);
	let selectedNetworkId = $state<string>('');
	let edgeColor = $state<Color>('Blue');
	let edgeEdgeStyle = $state<EdgeStyle>('SmoothStep');

	// Reset form when modal opens
	function handleOpen() {
		const defaults = getDefaultValues();
		form.reset(defaults);
		// Extract binding IDs from members for backward compatibility
		const members = defaults.members;
		if (members && 'binding_ids' in members) {
			memberBindingIds = members.binding_ids ?? [];
		} else if (members && 'service_ids' in members) {
			memberBindingIds = [];
		} else {
			memberBindingIds = [];
		}
		selectedNetworkId = defaults.network_id ?? '';
		edgeColor = defaults.color || 'Blue';
		edgeEdgeStyle = defaults.edge_style || 'SmoothStep';
		activeTab = 'details';
		furthestReached = 0;
	}

	// Available service bindings (exclude already selected ones and Unclaimed Open Ports)
	let availableServiceBindings = $derived.by(() => {
		return servicesData
			.filter((s) => s.network_id == selectedNetworkId)
			.filter((s) => s.service_definition !== 'Unclaimed Open Ports')
			.flatMap((s) => s.bindings)
			.filter((sb) => !memberBindingIds.some((binding) => binding === sb.id));
	});

	let selectedServiceBindings = $derived.by(() => {
		return memberBindingIds
			.map((bindingId) => servicesData.flatMap((s) => s.bindings).find((sb) => sb.id === bindingId))
			.filter(Boolean);
	});

	// Handlers for service bindings
	function handleAdd(bindingId: string) {
		memberBindingIds = [...memberBindingIds, bindingId];
	}

	function handleRemove(index: number) {
		memberBindingIds = memberBindingIds.filter((_, i) => i !== index);
	}

	function handleServiceBindingsReorder(fromIndex: number, toIndex: number) {
		if (fromIndex === toIndex) return;
		const current = [...memberBindingIds];
		const [movedBinding] = current.splice(fromIndex, 1);
		current.splice(toIndex, 0, movedBinding);
		memberBindingIds = current;
	}

	async function handleSubmit() {
		await submitForm(form);
	}

	// Handle form-based submission for create flow with steps
	async function handleFormSubmit() {
		if (isEditing || isLastWizardStep) {
			handleSubmit();
		} else {
			const isValid = await validateForm(form);
			if (isValid) {
				const wizardIndex = wizardSteps.indexOf(activeTab);
				if (wizardIndex >= 0 && wizardIndex + 1 > furthestReached) {
					furthestReached = wizardIndex + 1;
				}
				nextTab();
			}
		}
	}

	function handleFormCancel() {
		if (isEditing || currentEnabledIndex === 0) {
			onClose();
		} else {
			previousTab();
		}
	}

	async function handleDelete() {
		if (onDelete && dependency) {
			deleting = true;
			try {
				await onDelete(dependency.id);
			} finally {
				deleting = false;
			}
		}
	}

	// Dependency type options
	let dependencyTypeOptions = $derived(
		dependencyTypes.getItems().map((dt) => ({
			value: dt.id,
			label: dt.name ?? dt.id
		}))
	);

	let colorHelper = entities.getColorHelper('Dependency');

	// Read-only formData for EdgeStyleForm display (uses callbacks for changes)
	let edgeStyleFormData = $derived({
		color: edgeColor,
		edge_style: edgeEdgeStyle
	} as Dependency);
</script>

<GenericModal
	{isOpen}
	{title}
	{name}
	entityId={dependency?.id}
	size="full"
	{onClose}
	onOpen={handleOpen}
	showCloseButton={true}
	{tabs}
	{activeTab}
	tabStyle={isEditing ? 'tabs' : 'stepper'}
	onTabChange={(tabId) => (activeTab = tabId)}
>
	{#snippet headerIcon()}
		<ModalHeaderIcon Icon={entities.getIconComponent('Dependency')} color={colorHelper.color} />
	{/snippet}

	<form
		onsubmit={(e) => {
			e.preventDefault();
			e.stopPropagation();
			handleFormSubmit();
		}}
		class="flex min-h-0 flex-1 flex-col"
	>
		<div class="min-h-0 flex-1 overflow-auto">
			<!-- Details Tab -->
			{#if activeTab === 'details'}
				<div class="space-y-4 p-6">
					<form.Field
						name="name"
						validators={{
							onBlur: ({ value }) => required(value) || max(100)(value)
						}}
					>
						{#snippet children(field)}
							<TextInput
								label={dependencies_dependencyName()}
								id="name"
								{field}
								placeholder={dependencies_dependencyNamePlaceholder()}
								required
							/>
						{/snippet}
					</form.Field>

					<form.Field name="network_id">
						{#snippet children(field)}
							<SelectNetwork
								selectedNetworkId={field.state.value}
								onNetworkChange={(id) => {
									field.handleChange(id);
									selectedNetworkId = id;
								}}
							/>
						{/snippet}
					</form.Field>

					<form.Field name="dependency_type">
						{#snippet children(field)}
							<SelectInput
								label={dependencies_dependencyType()}
								id="dependency_type"
								{field}
								options={dependencyTypeOptions}
							/>
							<p class="text-tertiary text-xs">
								{dependencyTypes.getDescription(field.state.value)}
							</p>
						{/snippet}
					</form.Field>

					<form.Field
						name="description"
						validators={{
							onBlur: ({ value }) => max(500)(value || '')
						}}
					>
						{#snippet children(field)}
							<TextArea
								label={common_description()}
								id="description"
								{field}
								placeholder={dependencies_descriptionPlaceholder()}
							/>
						{/snippet}
					</form.Field>

					<form.Field name="tags">
						{#snippet children(field)}
							<TagPicker
								selectedTagIds={field.state.value || []}
								onChange={(tags) => field.handleChange(tags)}
							/>
						{/snippet}
					</form.Field>
				</div>
			{/if}

			<!-- Bindings Tab -->
			{#if activeTab === 'bindings'}
				<div class="space-y-4 p-6">
					<InlineInfo
						title={dependencies_serviceBindingsInfoTitle()}
						body={dependencies_serviceBindingsInfoBody()}
						dismissableKey="dependency-bindings-info"
					/>
					<div class="card">
						<ListManager
							label={dependencies_serviceBindings()}
							helpText={dependencies_serviceBindingsHelp()}
							placeholder={isServicesLoading
								? dependencies_loadingServices()
								: dependencies_selectBinding()}
							emptyMessage={dependencies_noBindingsYet()}
							allowReorder={true}
							allowItemEdit={() => false}
							showSearch={true}
							options={availableServiceBindings}
							items={selectedServiceBindings}
							optionDisplayComponent={BindingWithServiceDisplay}
							itemDisplayComponent={BindingWithServiceDisplay}
							getItemContext={() => bindingContext}
							getOptionContext={() => bindingContext}
							onAdd={handleAdd}
							onRemove={handleRemove}
							onMoveUp={(index) => handleServiceBindingsReorder(index, index - 1)}
							onMoveDown={(index) => handleServiceBindingsReorder(index, index + 1)}
						/>
					</div>
				</div>
			{/if}

			<!-- Edge Style Tab -->
			{#if activeTab === 'edge-style'}
				<div class="p-6">
					<EdgeStyleForm
						formData={edgeStyleFormData}
						showCollapseToggle={false}
						layout="horizontal"
						onColorChange={(color) => {
							edgeColor = color;
							form.setFieldValue('color', color);
						}}
						onEdgeStyleChange={(style) => {
							edgeEdgeStyle = style;
							form.setFieldValue('edge_style', style);
						}}
					/>
				</div>
			{/if}
		</div>

		{#if isEditing && dependency}
			<EntityMetadataSection entities={[dependency]} />
		{/if}

		<!-- Footer -->
		<div class="modal-footer">
			<div class="flex items-center justify-between">
				<div>
					{#if isEditing && onDelete}
						<button
							type="button"
							disabled={deleting || loading}
							onclick={handleDelete}
							class="btn-danger"
						>
							{deleting ? common_deleting() : common_delete()}
						</button>
					{/if}
				</div>
				<div class="flex items-center gap-3">
					{#if showCancel}
						<button
							type="button"
							disabled={loading || deleting}
							onclick={handleFormCancel}
							class="btn-secondary"
						>
							{cancelLabel}
						</button>
					{/if}
					<button
						type="submit"
						disabled={loading || deleting}
						class="btn-primary {!isEditing && !isLastWizardStep ? 'btn-primary-lg' : ''}"
					>
						{loading ? common_saving() : saveLabel}
						{#if !isEditing && !isLastWizardStep}
							<ArrowRight class="h-4 w-4" />
						{/if}
					</button>
				</div>
			</div>
		</div>
	</form>
</GenericModal>
