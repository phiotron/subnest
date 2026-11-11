import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import 'settings_format.dart';

/// Opens the override sheet for "1 [from] = ? [to]" (png 53).
Future<void> showRateOverrideSheet(BuildContext context, {required String from, required String to}) =>
    showAppSheet<void>(
      context,
      builder: (_) => RateOverrideSheet(from: from, to: to),
    );

/// Use the automatic rate, or set your own; preview what one subscription then costs a month.
/// [from] is the subscription currency, [to] the main currency; the sheet shows and stores the rate
/// as "1 «stronger» = X «weaker»" ([SettingsFormat.ratePair]) — the domain reads either direction.
class RateOverrideSheet extends ConsumerStatefulWidget {
  const RateOverrideSheet({super.key, required this.from, required this.to});

  final String from;
  final String to;

  @override
  ConsumerState<RateOverrideSheet> createState() => _RateOverrideSheetState();
}

class _RateOverrideSheetState extends ConsumerState<RateOverrideSheet> {
  late final TextEditingController _controller;
  late bool _useAuto;
  late final bool _wasOverridden;

  /// Display / storage direction: (1 [_a] = X [_b]).
  late final String _a;
  late final String _b;
  bool _showError = false;

  ExchangeRates get _rates => ref.read(ratesProvider).value ?? ExchangeRates.empty;

  /// Provider rate, ignoring any override.
  double? get _autoRate => ExchangeRates(usdRates: _rates.usdRates).rate(_a, _b);

  @override
  void initState() {
    super.initState();
    final pair = SettingsFormat.ratePair(_rates, widget.from, widget.to);
    _a = pair.$1;
    _b = pair.$2;
    _wasOverridden = _rates.isOverridden(widget.from, widget.to);
    _useAuto = !_wasOverridden;
    final start = _rates.rate(_a, _b);
    _controller = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || start == null) return;
      _controller.text = SettingsFormat.rate(start, context.l10n.localeName);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double? get _typed => SettingsFormat.parseRate(_controller.text, context.l10n.localeName);

  Future<void> _save() async {
    final repo = ref.read(exchangeRateRepositoryProvider);
    if (_useAuto) {
      if (_wasOverridden) await repo.clearOverride(widget.from, widget.to);
    } else {
      final v = _typed;
      if (v == null) {
        setState(() => _showError = true);
        return;
      }
      await repo.setOverride(_a, _b, v);
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _restoreAuto() async {
    await ref.read(exchangeRateRepositoryProvider).clearOverride(widget.from, widget.to);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final now = ref.watch(clockProvider)();
    final rates = ref.watch(ratesProvider).value ?? ExchangeRates.empty;
    final auto = _autoRate;
    final autoText = auto == null ? '–' : SettingsFormat.rate(auto, l.localeName);
    final autoMeta = rates.fetchedAt == null
        ? l.settingsRateAutoValueBuiltIn(autoText)
        : l.settingsRateAutoValue(autoText, SettingsFormat.ago(l, rates.fetchedAt!, now, short: true));

    final titleStyle = AppType.title.copyWith(color: c.ink);
    return AppSheet(
      actions: [
        if (_useAuto)
          AppButton.primary(label: l.commonDone, expand: true, onPressed: _save)
        else ...[
          AppButton.primary(label: l.settingsRateSave, expand: true, onPressed: _save),
          if (_wasOverridden) AppButton.text(label: l.settingsRateRestoreAuto, expand: true, onPressed: _restoreAuto),
        ],
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // "USD → VND" — the arrow is an icon: Be Vietnam Pro has no U+2192.
            Semantics(
              header: true,
              label: '$_a → $_b',
              excludeSemantics: true,
              child: Row(
                children: [
                  Text(_a, style: titleStyle),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpace.s2),
                    child: Icon(LucideIcons.arrowRight, size: 20, color: c.ink),
                  ),
                  Text(_b, style: titleStyle),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.s4),
            MergeSemantics(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.settingsRateUseAuto, style: AppType.label.copyWith(color: c.ink)),
                        const SizedBox(height: 2),
                        Text(autoMeta, style: AppType.meta.copyWith(color: c.inkMuted)),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpace.s3),
                  AppToggle(
                    value: _useAuto,
                    semanticLabel: l.settingsRateUseAuto,
                    onChanged: (v) => setState(() {
                      _useAuto = v;
                      _showError = false;
                    }),
                  ),
                ],
              ),
            ),
            if (!_useAuto) ...[
              const SizedBox(height: AppSpace.s5),
              _RateBox(
                controller: _controller,
                from: _a,
                to: _b,
                preview: _preview(l, rates),
                error: _showError ? l.settingsRateInvalid : null,
                onChanged: () => setState(() => _showError = false),
                onSubmitted: _save,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// "ChatGPT Plus becomes ≈ ₫500,000/month" for the first subscription in [from].
  String? _preview(AppLocalizations l, ExchangeRates rates) {
    final v = _typed;
    if (v == null) return null;
    final today = ref.read(todayProvider);
    final subs = ref.read(subscriptionsProvider).value ?? const <Subscription>[];
    final s = subs
        .where(
          (s) => s.currency == widget.from && BillingRules.effectiveStatus(s, today) != SubscriptionStatus.cancelled,
        )
        .firstOrNull;
    if (s == null) return null;
    final calc = SpendingCalculator(
      rates: rates.copyWith(
        overrides: {
          for (final e in rates.overrides.entries)
            if (e.key != ExchangeRates.pairKey(_a, _b) && e.key != ExchangeRates.pairKey(_b, _a)) e.key: e.value,
          ExchangeRates.pairKey(_a, _b): v,
        },
      ),
      primaryCurrency: widget.to,
    );
    final monthly = calc.monthlyCost(s);
    if (monthly == null) return null;
    return l.settingsRatePreview(s.name, l.amount(monthly, widget.to, approx: true));
  }
}

/// `amount-box`: "Your rate · 1 USD =", big editable number + currency, preview / error line.
class _RateBox extends StatelessWidget {
  const _RateBox({
    required this.controller,
    required this.from,
    required this.to,
    required this.preview,
    required this.error,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String from;
  final String to;
  final String? preview;
  final String? error;
  final VoidCallback onChanged;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final label = l.settingsRateYours(from);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 14),
      decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: AppType.meta.copyWith(color: c.inkMuted)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                // Screen readers hear "Your rate · 1 USD =" as the field's name.
                child: Semantics(
                  label: label,
                  child: MediaQuery(
                    // amount-lg grows at most to 38px (design README › Type).
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: AppTextScale.capped(context, AppTextScale.amountLg)),
                    child: TextField(
                      controller: controller,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\s]'))],
                      textInputAction: TextInputAction.done,
                      onChanged: (_) => onChanged(),
                      onSubmitted: (_) => onSubmitted(),
                      style: AppType.amountLg.copyWith(color: c.ink).tabular,
                      cursorColor: c.brand,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: AppSpace.s1),
                        hintText: '0',
                        hintStyle: AppType.amountLg.copyWith(color: c.inkMuted).tabular,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.s3),
              Text(to, style: AppType.titleSm.copyWith(color: c.ink)),
            ],
          ),
          if (error != null)
            Row(
              children: [
                Icon(AppIcons.alert, size: 14, color: c.danger),
                const SizedBox(width: AppSpace.s1),
                Expanded(
                  child: Text(error!, style: AppType.meta.copyWith(color: c.danger)),
                ),
              ],
            )
          else if (preview != null)
            Text(preview!, semanticsLabel: context.l10n.spokenLabel(preview!), style: AppType.meta.copyWith(color: c.inkMuted)),
        ],
      ),
    );
  }
}
