import * as LucideIcons from 'lucide-svelte';
import type { IconComponent } from './types';
import colors from 'tailwindcss/colors';
import LogoIcon from '$lib/shared/components/data/LogoIcon.svelte';
import type { components } from '$lib/api/schema';

// Use the generated Color type from OpenAPI schema
export type Color = components['schemas']['Color'];

export interface ColorStyle {
	text: string;
	bg: string;
	border: string;
	icon: string;
	ring: string;
	stroke: string;
	color: Color;
	rgb: string; // Added RGB value
}

// Dark mode color map (original)
const DARK_COLOR_MAP: Record<Color, ColorStyle> = {
	Pink: {
		color: 'Pink',
		text: 'text-pink-400',
		bg: 'bg-pink-900/50 border-pink-600',
		border: 'border-pink-600',
		icon: 'text-pink-400',
		ring: 'ring-pink-400',
		stroke: 'stroke-pink-400',
		rgb: 'rgb(244, 114, 182)' // pink-400
	},
	Rose: {
		color: 'Rose',
		text: 'text-rose-400',
		bg: 'bg-rose-900/50 border-rose-600',
		border: 'border-rose-600',
		icon: 'text-rose-400',
		ring: 'ring-rose-400',
		stroke: 'stroke-rose-400',
		rgb: 'rgb(251, 113, 133)' // rose-400
	},
	Red: {
		color: 'Red',
		text: 'text-red-400',
		bg: 'bg-red-900/50 border-red-600',
		border: 'border-red-600',
		icon: 'text-red-400',
		ring: 'ring-red-400',
		stroke: 'stroke-red-400',
		rgb: 'rgb(248, 113, 113)' // red-400
	},
	Orange: {
		color: 'Orange',
		text: 'text-orange-400',
		bg: 'bg-orange-900/50 border-orange-600',
		border: 'border-orange-600',
		icon: 'text-orange-400',
		ring: 'ring-orange-400',
		stroke: 'stroke-orange-400',
		rgb: 'rgb(251, 146, 60)' // orange-400
	},
	Yellow: {
		color: 'Yellow',
		text: 'text-yellow-400',
		bg: 'bg-yellow-900/50 border-yellow-600',
		border: 'border-yellow-600',
		icon: 'text-yellow-400',
		ring: 'ring-yellow-400',
		stroke: 'stroke-yellow-400',
		rgb: 'rgb(250, 204, 21)' // yellow-400
	},
	Green: {
		color: 'Green',
		text: 'text-green-400',
		bg: 'bg-green-900/50 border-green-600',
		border: 'border-green-600',
		icon: 'text-green-400',
		ring: 'ring-green-400',
		stroke: 'stroke-green-400',
		rgb: 'rgb(74, 222, 128)' // green-400
	},
	Emerald: {
		color: 'Emerald',
		text: 'text-emerald-400',
		bg: 'bg-emerald-900/50 border-emerald-600',
		border: 'border-emerald-600',
		icon: 'text-emerald-400',
		ring: 'ring-emerald-400',
		stroke: 'stroke-emerald-400',
		rgb: 'rgb(52, 211, 153)' // emerald-400
	},
	Teal: {
		color: 'Teal',
		text: 'text-teal-400',
		bg: 'bg-teal-900/50 border-teal-600',
		border: 'border-teal-600',
		icon: 'text-teal-400',
		ring: 'ring-teal-400',
		stroke: 'stroke-teal-400',
		rgb: 'rgb(45, 212, 191)' // teal-400
	},
	Cyan: {
		color: 'Cyan',
		text: 'text-cyan-400',
		bg: 'bg-cyan-900/50 border-cyan-600',
		border: 'border-cyan-600',
		icon: 'text-cyan-400',
		ring: 'ring-cyan-400',
		stroke: 'stroke-cyan-400',
		rgb: 'rgb(34, 211, 238)' // cyan-400
	},
	Blue: {
		color: 'Blue',
		text: 'text-blue-400',
		bg: 'bg-blue-900/50 border-blue-600',
		border: 'border-blue-600',
		icon: 'text-blue-400',
		ring: 'ring-blue-400',
		stroke: 'stroke-blue-400',
		rgb: 'rgb(96, 165, 250)' // blue-400
	},
	Indigo: {
		color: 'Indigo',
		text: 'text-indigo-400',
		bg: 'bg-indigo-900/50 border-indigo-600',
		border: 'border-indigo-600',
		icon: 'text-indigo-400',
		ring: 'ring-indigo-400',
		stroke: 'stroke-indigo-400',
		rgb: 'rgb(129, 140, 248)' // indigo-400
	},
	Purple: {
		color: 'Purple',
		text: 'text-purple-400',
		bg: 'bg-purple-900/50 border-purple-600',
		border: 'border-purple-600',
		icon: 'text-purple-400',
		ring: 'ring-purple-400',
		stroke: 'stroke-purple-400',
		rgb: 'rgb(196, 181, 253)' // purple-400
	},
	Gray: {
		color: 'Gray',
		text: 'text-gray-400',
		bg: 'bg-gray-900/50 border-gray-600',
		border: 'border-gray-600',
		icon: 'text-gray-400',
		ring: 'ring-gray-400',
		stroke: 'stroke-gray-400',
		rgb: 'rgb(156, 163, 175)' // gray-400
	}
};

// Light mode color map
const LIGHT_COLOR_MAP: Record<Color, ColorStyle> = {
	Pink: {
		color: 'Pink',
		text: 'text-pink-600',
		bg: 'bg-pink-100 border-pink-300',
		border: 'border-pink-300',
		icon: 'text-pink-600',
		ring: 'ring-pink-400',
		stroke: 'stroke-pink-600',
		rgb: 'rgb(219, 39, 119)' // pink-600
	},
	Rose: {
		color: 'Rose',
		text: 'text-rose-600',
		bg: 'bg-rose-100 border-rose-300',
		border: 'border-rose-300',
		icon: 'text-rose-600',
		ring: 'ring-rose-400',
		stroke: 'stroke-rose-600',
		rgb: 'rgb(225, 29, 72)' // rose-600
	},
	Red: {
		color: 'Red',
		text: 'text-red-600',
		bg: 'bg-red-100 border-red-300',
		border: 'border-red-300',
		icon: 'text-red-600',
		ring: 'ring-red-400',
		stroke: 'stroke-red-600',
		rgb: 'rgb(220, 38, 38)' // red-600
	},
	Orange: {
		color: 'Orange',
		text: 'text-orange-600',
		bg: 'bg-orange-100 border-orange-300',
		border: 'border-orange-300',
		icon: 'text-orange-600',
		ring: 'ring-orange-400',
		stroke: 'stroke-orange-600',
		rgb: 'rgb(234, 88, 12)' // orange-600
	},
	Yellow: {
		color: 'Yellow',
		text: 'text-yellow-600',
		bg: 'bg-yellow-100 border-yellow-300',
		border: 'border-yellow-300',
		icon: 'text-yellow-600',
		ring: 'ring-yellow-400',
		stroke: 'stroke-yellow-600',
		rgb: 'rgb(202, 138, 4)' // yellow-600
	},
	Green: {
		color: 'Green',
		text: 'text-green-600',
		bg: 'bg-green-100 border-green-300',
		border: 'border-green-300',
		icon: 'text-green-600',
		ring: 'ring-green-400',
		stroke: 'stroke-green-600',
		rgb: 'rgb(22, 163, 74)' // green-600
	},
	Emerald: {
		color: 'Emerald',
		text: 'text-emerald-600',
		bg: 'bg-emerald-100 border-emerald-300',
		border: 'border-emerald-300',
		icon: 'text-emerald-600',
		ring: 'ring-emerald-400',
		stroke: 'stroke-emerald-600',
		rgb: 'rgb(5, 150, 105)' // emerald-600
	},
	Teal: {
		color: 'Teal',
		text: 'text-teal-600',
		bg: 'bg-teal-100 border-teal-300',
		border: 'border-teal-300',
		icon: 'text-teal-600',
		ring: 'ring-teal-400',
		stroke: 'stroke-teal-600',
		rgb: 'rgb(13, 148, 136)' // teal-600
	},
	Cyan: {
		color: 'Cyan',
		text: 'text-cyan-600',
		bg: 'bg-cyan-100 border-cyan-300',
		border: 'border-cyan-300',
		icon: 'text-cyan-600',
		ring: 'ring-cyan-400',
		stroke: 'stroke-cyan-600',
		rgb: 'rgb(8, 145, 178)' // cyan-600
	},
	Blue: {
		color: 'Blue',
		text: 'text-blue-600',
		bg: 'bg-blue-100 border-blue-300',
		border: 'border-blue-300',
		icon: 'text-blue-600',
		ring: 'ring-blue-400',
		stroke: 'stroke-blue-600',
		rgb: 'rgb(37, 99, 235)' // blue-600
	},
	Indigo: {
		color: 'Indigo',
		text: 'text-indigo-600',
		bg: 'bg-indigo-100 border-indigo-300',
		border: 'border-indigo-300',
		icon: 'text-indigo-600',
		ring: 'ring-indigo-400',
		stroke: 'stroke-indigo-600',
		rgb: 'rgb(79, 70, 229)' // indigo-600
	},
	Purple: {
		color: 'Purple',
		text: 'text-purple-600',
		bg: 'bg-purple-100 border-purple-300',
		border: 'border-purple-300',
		icon: 'text-purple-600',
		ring: 'ring-purple-400',
		stroke: 'stroke-purple-600',
		rgb: 'rgb(147, 51, 234)' // purple-600
	},
	Gray: {
		color: 'Gray',
		text: 'text-gray-600',
		bg: 'bg-gray-100 border-gray-300',
		border: 'border-gray-300',
		icon: 'text-gray-600',
		ring: 'ring-gray-400',
		stroke: 'stroke-gray-600',
		rgb: 'rgb(75, 85, 99)' // gray-600
	}
};

// Map backend color names to Tailwind classes with RGB values
export const COLOR_MAP: Record<Color, ColorStyle> = DARK_COLOR_MAP;

export function getColorMap(): Record<Color, ColorStyle> {
	if (typeof window === 'undefined') return DARK_COLOR_MAP;
	return document.documentElement.classList.contains('dark') ? DARK_COLOR_MAP : LIGHT_COLOR_MAP;
}

// Export available colors array derived from COLOR_MAP keys
export const AVAILABLE_COLORS = Object.keys(COLOR_MAP) as Color[];

// Convert a string to a validated Color, with fallback to 'gray'
export function toColor(value: string | null | undefined): Color {
	if (!value) return 'Gray';
	else {
		const upperValue = value.charAt(0).toUpperCase() + value.slice(1);
		return AVAILABLE_COLORS.includes(upperValue as Color) ? (upperValue as Color) : 'Gray';
	}
}

// Unified color helper - works everywhere!
export function createColorHelper(colorName: Color | null): ColorStyle {
	const map = getColorMap();
	const color = colorName && map[colorName] ? colorName : 'Gray';

	return map[color];
}

// Icon helper that converts string to component
export function createIconComponent(iconName: string | null): IconComponent {
	if (!iconName || iconName == null) return LucideIcons.HelpCircle;

	// Convert kebab-case to PascalCase for Lucide component names
	const componentName = iconName
		.split('-')
		.map((word) => word.charAt(0).toUpperCase() + word.slice(1))
		.join('');

	// Return the component or fallback
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	return (LucideIcons as any)[componentName] || LucideIcons.HelpCircle;
}

// Icon helper that turns a string into an SVG
export function createLogoIconComponent(
	iconName: string | null,
	iconUrl: string,
	useWhiteBackground: boolean = false
): IconComponent {
	if (!iconName || iconName == null) return LucideIcons.HelpCircle;

	// Create a wrapper component that pre-binds the iconName
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	const BoundLogoIcon = ($$payload: any, $$props: Omit<any, 'iconName'>) => {
		return LogoIcon($$payload, { iconName, iconUrl, useWhiteBackground, ...$$props });
	};

	return BoundLogoIcon;
}

// Convenience wrapper that returns both color and icon
export function createStyle(color: Color | null, icon: string | null) {
	return {
		colors: createColorHelper(color),
		IconComponent: createIconComponent(icon),
		iconName: icon
	};
}

/**
 * Converts a Tailwind color string (e.g. "text-blue-400", "bg-blue-900/50", "blue-500")
 * to an rgba() string with optional alpha override.
 */
export function twColorToRgba(twColor: string, alphaOverride?: number): string | null {
	const match = twColor.match(/([a-zA-Z]+)-(\d{2,3})(?:\/(\d{1,3}))?/);
	if (!match) return null;

	const [, colorName, shade, opacityRaw] = match;

	const palette = (colors as unknown as Record<string, Record<number, string>>)[colorName];
	if (!palette) return null;

	const hex = palette[parseInt(shade)];
	if (!hex) return null;

	const alpha =
		typeof alphaOverride === 'number'
			? alphaOverride
			: opacityRaw
				? parseInt(opacityRaw, 10) / 100
				: 1;

	return hexToRgba(hex, alpha);
}

function hexToRgba(hex: string, alpha = 1): string {
	const cleanHex = hex.replace('#', '');
	const bigint = parseInt(cleanHex, 16);
	const r = (bigint >> 16) & 255;
	const g = (bigint >> 8) & 255;
	const b = bigint & 255;
	return `rgba(${r}, ${g}, ${b}, ${alpha})`;
}
