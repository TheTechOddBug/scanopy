const STORAGE_KEY = 'scanopy-theme';

type ThemeMode = 'system' | 'light' | 'dark';
type ResolvedTheme = 'light' | 'dark';

class ThemeStore {
	themeMode = $state<ThemeMode>('system');
	resolvedTheme = $derived<ResolvedTheme>(this.resolve());

	private mediaQuery: MediaQueryList | null = null;

	constructor() {
		if (typeof window !== 'undefined') {
			const stored = localStorage.getItem(STORAGE_KEY) as ThemeMode | null;
			if (stored === 'light' || stored === 'dark' || stored === 'system') {
				this.themeMode = stored;
			}

			this.mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
			this.mediaQuery.addEventListener('change', () => this.applyTheme());

			$effect.root(() => {
				$effect(() => {
					this.applyTheme();
				});
			});
		}
	}

	private resolve(): ResolvedTheme {
		if (this.themeMode === 'system') {
			if (typeof window === 'undefined') return 'dark';
			return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
		}
		return this.themeMode;
	}

	private applyTheme() {
		const resolved = this.resolvedTheme;
		document.documentElement.classList.toggle('dark', resolved === 'dark');
		document.documentElement.style.colorScheme = resolved;
	}

	setTheme(mode: ThemeMode) {
		this.themeMode = mode;
		localStorage.setItem(STORAGE_KEY, mode);
	}
}

export const themeStore = new ThemeStore();

export function getResolvedTheme(): ResolvedTheme {
	return themeStore.resolvedTheme;
}
