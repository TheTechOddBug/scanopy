import type { TopologyEdge } from '../types/base';
import type { components } from '$lib/api/schema';

type EdgeTypeDiscriminants = components['schemas']['EdgeTypeDiscriminants'];
type TopologyPerspective = components['schemas']['TopologyPerspective'];

export type EdgeClassification = 'primary' | 'overlay';

/**
 * Classify an edge as primary (affects layout) or overlay (drawn after layout).
 * Uses the backend-provided `classification` field; defaults to overlay if absent.
 */
export function classifyEdge(edge: TopologyEdge): EdgeClassification {
	if ('classification' in edge && (edge as Record<string, unknown>).classification) {
		return (edge as Record<string, unknown>).classification as EdgeClassification;
	}
	return 'overlay';
}

export function isOverlayEdge(edge: TopologyEdge): boolean {
	return classifyEdge(edge) === 'overlay';
}

/** Returns the edge types that should be hidden by default for a given perspective. */
export function getDefaultHiddenEdgeTypes(
	perspective: TopologyPerspective
): EdgeTypeDiscriminants[] {
	switch (perspective) {
		case 'l3_logical':
			return [
				'HostVirtualization',
				'ServiceVirtualization',
				'RequestPath',
				'HubAndSpoke',
				'PhysicalLink'
			];
		case 'l2_physical':
			return ['HostVirtualization', 'ServiceVirtualization', 'RequestPath', 'HubAndSpoke'];
		case 'infrastructure':
			return ['RequestPath', 'HubAndSpoke', 'PhysicalLink'];
		case 'application':
			return ['HostVirtualization', 'ServiceVirtualization', 'HubAndSpoke', 'PhysicalLink'];
	}
}
