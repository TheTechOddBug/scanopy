import type { components } from '$lib/api/schema';

export type GroupingRule = components['schemas']['GroupingRule'];

export type GroupingRuleType = 'BySubnet' | 'ByServiceCategory' | 'ByVirtualizingService' | 'ByTag';

export function getGroupingRuleType(rule: GroupingRule): GroupingRuleType {
	if ('BySubnet' in rule) return 'BySubnet';
	if ('ByServiceCategory' in rule) return 'ByServiceCategory';
	if ('ByVirtualizingService' in rule) return 'ByVirtualizingService';
	return 'ByTag';
}

export function getGroupingRuleTitle(rule: GroupingRule): string | null | undefined {
	if ('BySubnet' in rule) return rule.BySubnet.title;
	if ('ByServiceCategory' in rule) return rule.ByServiceCategory.title;
	if ('ByVirtualizingService' in rule) return rule.ByVirtualizingService.title;
	return rule.ByTag.title;
}

export function setGroupingRuleTitle(rule: GroupingRule, title: string | null): GroupingRule {
	if ('BySubnet' in rule) return { BySubnet: { ...rule.BySubnet, title } };
	if ('ByServiceCategory' in rule)
		return { ByServiceCategory: { ...rule.ByServiceCategory, title } };
	if ('ByVirtualizingService' in rule)
		return { ByVirtualizingService: { ...rule.ByVirtualizingService, title } };
	return { ByTag: { ...rule.ByTag, title } };
}
