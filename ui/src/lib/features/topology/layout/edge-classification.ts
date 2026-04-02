import type { TopologyEdge } from '../types/base';
import type { components } from '$lib/api/schema';

type EdgeTypeDiscriminants = components['schemas']['EdgeTypeDiscriminants'];

export type EdgeClassification = 'primary' | 'overlay';

/**
 * Classify an edge as primary (affects layout) or overlay (drawn after layout).
 * Supports future `classification` field from backend; infers for L3 when absent.
 */
export function classifyEdge(edge: TopologyEdge): EdgeClassification {
	if ('classification' in edge && (edge as Record<string, unknown>).classification) {
		return (edge as Record<string, unknown>).classification as EdgeClassification;
	}
	return edge.edge_type === 'Interface' ? 'primary' : 'overlay';
}

export function isOverlayEdge(edge: TopologyEdge): boolean {
	return classifyEdge(edge) === 'overlay';
}

/** Edge types that are overlay in L3 perspective (hidden by default). */
export const L3_OVERLAY_EDGE_TYPES: EdgeTypeDiscriminants[] = [
	'HostVirtualization',
	'ServiceVirtualization',
	'RequestPath',
	'HubAndSpoke',
	'PhysicalLink'
];
