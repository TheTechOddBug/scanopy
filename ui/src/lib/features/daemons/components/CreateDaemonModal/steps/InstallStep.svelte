<script lang="ts">
	import CodeContainer from '$lib/shared/components/data/CodeContainer.svelte';
	import DocsHint from '$lib/shared/components/feedback/DocsHint.svelte';
	import InlineInfo from '$lib/shared/components/feedback/InlineInfo.svelte';
	import InlineWarning from '$lib/shared/components/feedback/InlineWarning.svelte';
	import SupportOptions from '$lib/features/support/SupportOptions.svelte';
	import { useConfigQuery } from '$lib/shared/stores/config-query';
	import type { DaemonOS } from '../../../utils';
	import { trackEvent } from '$lib/shared/utils/analytics';
	import OsSelector from '../../OsSelector.svelte';
	import { Loader2, CheckCircle2, AlertTriangle } from 'lucide-svelte';
	import type { DaemonConnectionStatus } from '../../../stores/daemon-setup';
	import {
		common_stepNumber,
		daemons_advancedHint,
		daemons_dockerLinuxOnly,
		daemons_dockerLinuxOnlyBody,
		daemons_docsMacvlan,
		daemons_docsMacvlanLinkText,
		daemons_docsMultiVlan,
		daemons_docsMultiVlanLinkText,
		daemons_downloadDaemon,
		daemons_fixValidationErrors,
		daemons_fixValidationErrorsBody,
		daemons_runDaemon,
		daemons_runInPowershell,
		daemons_wslWarning,
		daemons_wslWarningBody
	} from '$lib/paraglide/messages';

	interface Props {
		selectedOS: DaemonOS;
		onOsSelect: (os: DaemonOS) => void;
		runCommand: string;
		dockerCompose: string;
		hasErrors: boolean;
		isFirstDaemon?: boolean;
		connectionStatus?: DaemonConnectionStatus;
		onInstalled?: () => void;
		onTrouble?: () => void;
		onReviewCommands?: () => void;
		onViewDiscovery?: () => void;
		hasEmailSupport?: boolean;
	}

	let {
		selectedOS,
		onOsSelect,
		runCommand,
		dockerCompose,
		hasErrors,
		isFirstDaemon = false,
		connectionStatus = 'idle',
		onInstalled,
		onTrouble,
		onReviewCommands,
		onViewDiscovery,
		hasEmailSupport = false
	}: Props = $props();

	const configQuery = useConfigQuery();
	let hasEmail = $derived(configQuery.data?.has_email_service ?? false);

	type LinuxMethod = 'binary' | 'docker';
	let linuxMethod: LinuxMethod = $state('binary');

	const windowsDownloadUrl =
		'https://github.com/scanopy/scanopy/releases/latest/download/scanopy-daemon-windows-amd64.exe';
	const windowsInstallCommand = `Invoke-WebRequest -Uri "${windowsDownloadUrl}" -OutFile "scanopy-daemon-windows-amd64.exe"`;
	const installScript = `bash -c "$(curl -fsSL https://raw.githubusercontent.com/scanopy/scanopy/refs/heads/main/install.sh)"`;

	let showTroubleshooting = $state(false);

	function handleOsSelect(os: DaemonOS) {
		onOsSelect(os);
		trackEvent('daemon_install_os_selected', { os });
	}

	function handleCopy(context: string) {
		trackEvent('daemon_install_command_copied', { os: selectedOS, context });
	}

	// Show waiting UI when connection status is not idle (first daemon only)
	let showWaitingUI = $derived(isFirstDaemon && connectionStatus !== 'idle');
</script>

<div class="space-y-4">
	{#if showWaitingUI}
		<!-- Waiting / Connected / Trouble states -->
		{#if connectionStatus === 'waiting'}
			<div class="flex flex-col items-center gap-4 py-8 text-center">
				<Loader2 class="text-primary h-10 w-10 animate-spin" />
				<div>
					<h3 class="text-primary text-base font-semibold">
						Waiting for your daemon to connect...
					</h3>
					<p class="text-secondary mt-1 text-sm">
						This usually takes less than a minute. Run the install commands and start the daemon.
					</p>
				</div>
				<div class="flex items-center gap-3">
					<button type="button" class="btn-link text-sm" onclick={() => onReviewCommands?.()}>
						Review install commands
					</button>
					<span class="text-tertiary">·</span>
					<button
						type="button"
						class="btn-link text-sm"
						onclick={() => {
							showTroubleshooting = true;
							onTrouble?.();
						}}
					>
						Still not connecting?
					</button>
				</div>
			</div>
			{#if showTroubleshooting}
				<div class="border-primary/10 border-t pt-4">
					<p class="text-secondary mb-3 text-sm font-medium">Need help?</p>
					<SupportOptions isTroubleshooting={true} {hasEmailSupport} />
				</div>
			{/if}
		{:else if connectionStatus === 'connected'}
			<div class="flex flex-col items-center gap-4 py-8 text-center">
				<CheckCircle2 class="h-10 w-10 text-green-400" />
				<div>
					<h3 class="text-primary text-base font-semibold">Your daemon is connected!</h3>
					<p class="text-secondary mt-1 text-sm">
						Discovery has automatically started. You can view the progress in real time.
					</p>
				</div>
				<button type="button" class="btn-primary" onclick={() => onViewDiscovery?.()}>
					View Discovery Progress
				</button>
			</div>
		{:else if connectionStatus === 'trouble'}
			<div class="flex flex-col items-center gap-4 py-8 text-center">
				<AlertTriangle class="h-10 w-10 text-yellow-400" />
				<div>
					<h3 class="text-primary text-base font-semibold">Your daemon hasn't connected yet</h3>
					<p class="text-secondary mt-1 text-sm">
						It's been a while. Check that the daemon is running and can reach this server.
					</p>
				</div>
				<button type="button" class="btn-link text-sm" onclick={() => onReviewCommands?.()}>
					Review install commands
				</button>
			</div>
			<SupportOptions isTroubleshooting={true} {hasEmailSupport} />
		{/if}
	{:else}
		<!-- Normal install commands view -->
		<InlineInfo
			title=""
			body={daemons_advancedHint()}
			dismissableKey="daemon-wizard-advanced-hint"
		/>

		{#if hasEmail && isFirstDaemon}
			<InlineInfo
				title="We'll email you when your daemon connects and your network map is ready."
				dismissableKey="daemon-install-email-hint"
			/>
		{/if}

		{#if hasErrors}
			<InlineWarning
				title={daemons_fixValidationErrors()}
				body={daemons_fixValidationErrorsBody()}
			/>
		{:else}
			<DocsHint
				text={daemons_docsMultiVlan()}
				href="https://scanopy.net/docs/setting-up-daemons/planning-daemon-deployment/"
				linkText={daemons_docsMultiVlanLinkText()}
			/>
			<OsSelector
				{selectedOS}
				onOsSelect={handleOsSelect}
				{linuxMethod}
				onLinuxMethodChange={(method) => (linuxMethod = method)}
			>
				{#if selectedOS === 'linux'}
					{#if linuxMethod === 'binary'}
						<div class="text-secondary">
							<b>{common_stepNumber({ number: '1' })}</b>
							{daemons_downloadDaemon()}
						</div>
						<CodeContainer
							language="bash"
							expandable={false}
							code={installScript}
							onCopy={() => handleCopy('install-script')}
						/>
						<div class="text-secondary">
							<b>{common_stepNumber({ number: '2' })}</b>
							{daemons_runDaemon()}
						</div>
						<CodeContainer
							language="bash"
							expandable={false}
							code={runCommand}
							onCopy={() => handleCopy('run-command')}
						/>
					{:else if linuxMethod === 'docker' && dockerCompose}
						<DocsHint
							text={daemons_docsMacvlan()}
							href="https://scanopy.net/docs/guides/macvlan-setup/"
							linkText={daemons_docsMacvlanLinkText()}
						/>
						<CodeContainer
							language="yaml"
							expandable={false}
							code={dockerCompose}
							onCopy={() => handleCopy('docker-compose')}
						/>
					{/if}
				{:else if selectedOS === 'macos'}
					<div class="text-secondary">
						<b>{common_stepNumber({ number: '1' })}</b>
						{daemons_downloadDaemon()}
					</div>
					<CodeContainer
						language="bash"
						expandable={false}
						code={installScript}
						onCopy={() => handleCopy('install-script')}
					/>
					<div class="text-secondary">
						<b>{common_stepNumber({ number: '2' })}</b>
						{daemons_runDaemon()}
					</div>
					<CodeContainer
						language="bash"
						expandable={false}
						code={runCommand}
						onCopy={() => handleCopy('run-command')}
					/>

					<InlineInfo title={daemons_dockerLinuxOnly()} body={daemons_dockerLinuxOnlyBody()} />
				{:else if selectedOS === 'windows'}
					<div class="text-secondary">
						<b>{common_stepNumber({ number: '1' })}</b>
						{daemons_downloadDaemon()}
					</div>
					<CodeContainer
						language="powershell"
						expandable={false}
						code={windowsInstallCommand}
						onCopy={() => handleCopy('windows-download')}
					/>

					<div class="text-secondary">
						<b>{common_stepNumber({ number: '2' })}</b>
						{daemons_runInPowershell()}
					</div>
					<CodeContainer
						language="powershell"
						expandable={false}
						code={runCommand}
						onCopy={() => handleCopy('run-command')}
					/>

					<InlineWarning title={daemons_wslWarning()} body={daemons_wslWarningBody()} />
					<InlineInfo title={daemons_dockerLinuxOnly()} body={daemons_dockerLinuxOnlyBody()} />
				{/if}
			</OsSelector>

			<!-- Footer CTAs for first daemon flow -->
			{#if isFirstDaemon}
				<div class="border-primary/10 flex items-center gap-3 border-t pt-4">
					<button type="button" class="btn-primary" onclick={() => onInstalled?.()}>
						I've installed it
					</button>
					<button
						type="button"
						class="btn-link text-sm"
						onclick={() => {
							showTroubleshooting = true;
							onTrouble?.();
						}}
					>
						I'm having trouble
					</button>
				</div>
				{#if showTroubleshooting}
					<SupportOptions isTroubleshooting={true} {hasEmailSupport} />
				{/if}
			{/if}
		{/if}
	{/if}
</div>
