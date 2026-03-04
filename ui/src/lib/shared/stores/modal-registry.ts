import { writable } from 'svelte/store';
import type { EntityDiscriminants } from '$lib/api/entities';
import { entityUIConfig } from '$lib/shared/entity-ui-config';

export interface ModalState {
	name: string | null;
	id: string | null;
	tab: string | null;
}

const EMPTY_STATE: ModalState = { name: null, id: null, tab: null };

export const modalState = writable<ModalState>({ ...EMPTY_STATE });

/**
 * Open a modal by name. Updates the store and URL search params.
 */
export function openModal(name: string, opts?: { id?: string; tab?: string }): void {
	const state: ModalState = {
		name,
		id: opts?.id ?? null,
		tab: opts?.tab ?? null
	};
	modalState.set(state);
	syncToUrl(state);
}

/**
 * Close the current modal. Clears the store and URL search params.
 */
export function closeModal(): void {
	modalState.set({ ...EMPTY_STATE });
	syncToUrl(EMPTY_STATE);
}

/**
 * Update the active tab in the current modal. Updates store and URL.
 */
export function setModalTab(tab: string): void {
	modalState.update((s) => {
		const next = { ...s, tab };
		syncToUrl(next);
		return next;
	});
}

/**
 * Read URL params into the modal store. Call once after app initialization.
 */
export function initModalFromUrl(): void {
	if (typeof window === 'undefined') return;
	const params = new URLSearchParams(window.location.search);
	const name = params.get('modal');
	if (!name) return;
	const state: ModalState = {
		name,
		id: params.get('id'),
		tab: params.get('tab')
	};
	modalState.set(state);
}

/**
 * Navigate to an entity's tab and open its edit modal.
 * For sub-entities (Interface, IfEntry, etc.), opens the parent Host's modal on the relevant tab.
 */
export function navigateToEntity(
	entityType: EntityDiscriminants,
	entityId: string,
	data?: Record<string, unknown>
): void {
	const config = entityUIConfig[entityType];
	if (!config) return;

	if (config.modalName) {
		window.location.hash = config.tabId;
		openModal(config.modalName, { id: entityId });
	} else if (config.parentType && config.parentIdField && data) {
		const parentConfig = entityUIConfig[config.parentType];
		const parentId = data[config.parentIdField] as string | undefined;
		if (parentConfig?.modalName && parentId) {
			window.location.hash = parentConfig.tabId;
			openModal(parentConfig.modalName, { id: parentId, tab: config.modalTab });
		}
	}
}

function syncToUrl(state: ModalState): void {
	if (typeof window === 'undefined') return;
	const url = new URL(window.location.href);
	if (state.name) {
		url.searchParams.set('modal', state.name);
		if (state.id) {
			url.searchParams.set('id', state.id);
		} else {
			url.searchParams.delete('id');
		}
		if (state.tab) {
			url.searchParams.set('tab', state.tab);
		} else {
			url.searchParams.delete('tab');
		}
	} else {
		url.searchParams.delete('modal');
		url.searchParams.delete('id');
		url.searchParams.delete('tab');
	}
	window.history.replaceState({}, '', url.toString());
}
