/**
 * Suggested application group names based on organization use case.
 */
export const USE_CASE_SUGGESTIONS: Record<string, string[]> = {
	homelab: [
		'Media Stack',
		'Home Automation',
		'Monitoring',
		'Network Infrastructure',
		'Development',
		'Gaming',
		'Productivity',
		'Backup',
		'Security/Cameras',
		'DNS/Ad Blocking',
		'VPN',
		'File Storage'
	],
	company: [
		'Production',
		'Staging',
		'Internal Tools',
		'Monitoring',
		'CI/CD',
		'Shared Services',
		'Authentication',
		'Database',
		'API Gateway',
		'Logging',
		'Security',
		'Backup'
	],
	msp: [
		'Shared Infrastructure',
		'Monitoring',
		'Backup',
		'Security',
		'VPN',
		'DNS',
		'Logging',
		'Authentication',
		'File Storage',
		'Communication'
	]
};

export const DEFAULT_SUGGESTIONS = [
	'Web Services',
	'Database',
	'Monitoring',
	'Storage',
	'Infrastructure',
	'Authentication',
	'Logging',
	'Backup'
];

export function getSuggestions(useCase: string | null | undefined): string[] {
	if (useCase && useCase in USE_CASE_SUGGESTIONS) {
		return USE_CASE_SUGGESTIONS[useCase];
	}
	return DEFAULT_SUGGESTIONS;
}
