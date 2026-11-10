import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../subscription_form/widgets/currency_sheet.dart';
import 'onboarding_parts.dart';

/// S1.0 Language (S-90): the very first screen. Its own text is English only (no translation —
/// the choice is made here); the language names stay native. Only English and Tiếng Việt exist;
/// the choice applies at once.
class LanguageStep extends StatelessWidget {
  const LanguageStep({super.key, required this.code, required this.onChanged, required this.onNext});

  /// `en` or `vi` (defaults to `en` for a new install).
  final String code;
  final ValueChanged<String> onChanged;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return OnboardingStepScaffold(
      step: 1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpace.s8),
          OnboardingTitle(l.onboardingLanguageTitle),
          const SizedBox(height: AppSpace.s2),
          Text(l.onboardingLanguageHint, style: AppType.body.copyWith(color: c.inkMuted)),
          const SizedBox(height: AppSpace.s5),
          RadioRowGroup<String>(
            style: RadioRowStyle.flat,
            value: code,
            onChanged: (v) => onChanged(v),
            options: [
              RadioOption(value: 'en', title: l.commonLanguageEnglish),
              RadioOption(value: 'vi', title: l.commonLanguageVietnamese),
            ],
          ),
        ],
      ),
      footer: OnboardingFooter(
        children: [AppButton.primary(label: l.commonContinue, expand: true, onPressed: onNext)],
      ),
    );
  }
}

/// S1.1 Welcome (png 02): nest art with tiles, title, three benefits, "Get started".
class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key, required this.onNext, required this.onSkip});

  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return OnboardingStepScaffold(
      step: 2,
      onSkip: onSkip,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpace.s4),
          LayoutBuilder(
            builder: (_, box) => Center(
              child: NestArt(kind: NestArtKind.welcome, width: box.maxWidth.clamp(0, 280)),
            ),
          ),
          const SizedBox(height: AppSpace.s6),
          OnboardingTitle(l.onboardingWelcomeTitle, center: true),
          const SizedBox(height: AppSpace.s6),
          _Benefit(icon: AppIcons.reminderRing, title: l.onboardingBenefitRemind, body: l.onboardingBenefitRemindSub),
          _Benefit(icon: AppIcons.wallet, title: l.onboardingBenefitTotal, body: l.onboardingBenefitTotalSub),
          _Benefit(icon: AppIcons.privacy, title: l.onboardingBenefitPrivate, body: l.onboardingBenefitPrivateSub),
        ],
      ),
      footer: OnboardingFooter(
        children: [AppButton.primary(label: l.onboardingStart, expand: true, onPressed: onNext)],
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpace.s4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: c.brandSoft, borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Icon(icon, size: 20, color: c.onBrandSoft),
            ),
            const SizedBox(width: AppSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppType.titleSm.copyWith(color: c.ink)),
                  const SizedBox(height: 2),
                  Text(body, style: AppType.meta.copyWith(color: c.inkMuted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// S1.2 Main currency (png 03–04): USD (the global default) or VND in one tap, "Choose another
/// currency" (searchable sheet), rates note, Continue. Never suggested from the device region
/// (S-90).
class CurrencyStep extends StatelessWidget {
  const CurrencyStep({
    super.key,
    required this.currency,
    required this.knownCodes,
    required this.onChanged,
    required this.onNext,
    required this.onSkip,
  });

  /// One tap for the two currencies this app is built around; anything else via the sheet.
  static const _quick = ['USD', 'VND'];

  final String currency;
  final Iterable<String> knownCodes;
  final ValueChanged<String> onChanged;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  Future<void> _change(BuildContext context) async {
    final l = context.l10n;
    final code = await showCurrencySheet(
      context,
      title: l.onboardingCurrencySheetTitle,
      searchHint: l.onboardingCurrencySearch,
      selected: currency,
      known: knownCodes,
    );
    if (code != null) onChanged(code);
  }

  String _label(AppLocalizations l, String code) {
    final name = currencyName(l, code);
    return name == null ? code : '$code — $name';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final codes = [..._quick, if (!_quick.contains(currency)) currency];
    return OnboardingStepScaffold(
      step: 3,
      onSkip: onSkip,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpace.s8),
          OnboardingTitle(l.onboardingCurrencyTitle),
          const SizedBox(height: AppSpace.s2),
          Text(l.onboardingCurrencyHint, style: AppType.body.copyWith(color: c.inkMuted)),
          const SizedBox(height: AppSpace.s5),
          RadioRowGroup<String>(
            style: RadioRowStyle.flat,
            value: currency,
            onChanged: (v) => onChanged(v),
            options: [
              for (final code in codes)
                RadioOption(
                  value: code,
                  title: _label(l, code),
                  subtitle: code == 'USD'
                      ? l.onboardingCurrencyDefault
                      : code == currency
                      ? l.onboardingCurrencyChosen
                      : null,
                ),
            ],
          ),
          const SizedBox(height: AppSpace.s4),
          Center(
            child: AppButton.text(
              label: l.onboardingCurrencyChange,
              icon: AppIcons.globe,
              onPressed: () => _change(context),
            ),
          ),
          const SizedBox(height: AppSpace.s4),
          Container(
            padding: const EdgeInsets.all(AppSpace.s4),
            decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(AppRadius.lg)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(AppIcons.refresh, size: 16, color: c.inkMuted),
                ),
                const SizedBox(width: AppSpace.s3),
                Expanded(
                  child: Text(l.onboardingCurrencyRatesNote, style: AppType.meta.copyWith(color: c.inkMuted)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.s4),
        ],
      ),
      footer: OnboardingFooter(
        children: [AppButton.primary(label: l.commonContinue, expand: true, onPressed: onNext)],
      ),
    );
  }
}

/// S1.4 Reminders explainer (png 06) shown *before* the OS permission dialog (png 07, S-40).
/// "Not now" finishes onboarding without asking; the app works the same.
class RemindersStep extends StatelessWidget {
  const RemindersStep({
    super.key,
    required this.time,
    required this.demoName,
    required this.demoPrice,
    required this.trialName,
    required this.busy,
    required this.onEnable,
    required this.onNotNow,
  });

  /// Reminder time from Settings ("9:00").
  final String time;
  final String demoName;
  final String demoPrice;
  final String trialName;
  final bool busy;
  final VoidCallback onEnable;
  final VoidCallback onNotNow;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return OnboardingStepScaffold(
      step: 5,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpace.s6),
          Semantics(
            label: l.onboardingDemoLabel,
            container: true,
            child: Container(
              padding: const EdgeInsets.fromLTRB(AppSpace.s3 + 2, AppSpace.s5, AppSpace.s3 + 2, AppSpace.s5),
              decoration: BoxDecoration(color: c.brand, borderRadius: BorderRadius.circular(AppRadius.xl)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ExcludeSemantics(
                    child: Text(
                      time,
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.noScaling,
                      style: AppType.display.copyWith(color: c.onBrand).tabular,
                    ),
                  ),
                  const SizedBox(height: AppSpace.s4),
                  _DemoNotification(when: l.onboardingDemoNow, text: l.onboardingDemoRenews(demoName, demoPrice)),
                  const SizedBox(height: AppSpace.s3),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpace.s2),
                    child: _DemoNotification(
                      when: l.onboardingDemoAgo,
                      text: l.onboardingDemoTrial(trialName),
                      faded: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpace.s8),
          OnboardingTitle(l.onboardingRemindersTitle, center: true),
          const SizedBox(height: AppSpace.s3),
          Text(
            l.onboardingRemindersBody(time),
            textAlign: TextAlign.center,
            style: AppType.body.copyWith(color: c.inkMuted),
          ),
          const SizedBox(height: AppSpace.s4),
        ],
      ),
      footer: OnboardingFooter(
        children: [
          AppButton.primary(
            label: l.onboardingEnableReminders,
            icon: AppIcons.reminder,
            expand: true,
            loading: busy,
            onPressed: busy ? null : onEnable,
          ),
          AppButton.text(label: l.onboardingNoThanks, expand: true, onPressed: busy ? null : onNotNow),
        ],
      ),
    );
  }
}

/// Sample lock-screen notification (design `.notif`, `.notif.ghost`).
class _DemoNotification extends StatelessWidget {
  const _DemoNotification({required this.when, required this.text, this.faded = false});

  final String when;
  final String text;
  final bool faded;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final bg = faded ? Color.alphaBlend(c.surface.withValues(alpha: .7), c.brand) : c.surface;
    return Container(
      padding: const EdgeInsets.all(AppSpace.s3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubnestMark(size: faded ? 34 : 38),
          const SizedBox(width: AppSpace.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.commonAppName,
                        style: AppType.label.copyWith(color: c.ink, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(when, style: AppType.meta.copyWith(color: c.inkMuted)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(text, style: AppType.body.copyWith(color: c.ink).tabular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
