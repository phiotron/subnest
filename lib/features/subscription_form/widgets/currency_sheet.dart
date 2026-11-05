import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../../core/l10n/l10n.dart';
import '../../../core/utils/currencies.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import '../../settings/currency_screen.dart' show currencyNamesVi;

/// Currency picker sheet with search — S1 main currency (png 04) and S4 "Currency for this
/// subscription" (png 25). Returns the picked ISO code, or `null` when dismissed.
///
/// [used] (S4) are listed first under "Used by your subscriptions", each with "Main currency" or
/// "1 USD ≈ ₫25,400"; then every other known currency. Search matches code and EN/VI names,
/// accent-insensitive.
Future<String?> showCurrencySheet(
  BuildContext context, {
  required String title,
  required String searchHint,
  required String selected,
  String? primary,
  List<String> used = const [],
  Iterable<String> known = const [],
  ExchangeRates? rates,
  String? footnote,
}) {
  return showAppSheet<String>(
    context,
    bare: true,
    builder: (ctx) => SizedBox(
      height: MediaQuery.sizeOf(ctx).height * 0.86,
      child: AppSheet(
        title: title,
        child: CurrencyList(
          searchHint: searchHint,
          selected: selected,
          primary: primary,
          used: used,
          known: known,
          rates: rates,
          footnote: footnote,
          onPicked: (code) => Navigator.pop(ctx, code),
        ),
      ),
    ),
  );
}

/// Display name of [code] in the UI language (falls back to English, then nothing).
String? currencyName(AppLocalizations l, String code) {
  final vi = l.localeName.startsWith('vi');
  return (vi ? currencyNamesVi[code] : null) ?? currencyNames[code];
}

/// Short symbol for the badge: ₫, $, €, S$… (the code's first letter when intl has none).
String currencySymbol(String code) {
  var symbol = NumberFormat.simpleCurrency(name: code).currencySymbol;
  if (symbol.length > 3 || symbol == code) symbol = code.substring(0, 1);
  return symbol;
}

class CurrencyList extends StatefulWidget {
  const CurrencyList({
    super.key,
    required this.searchHint,
    required this.selected,
    required this.onPicked,
    this.primary,
    this.used = const [],
    this.known = const [],
    this.rates,
    this.footnote,
  });

  final String searchHint;
  final String selected;
  final String? primary;
  final List<String> used;
  final Iterable<String> known;
  final ExchangeRates? rates;
  final String? footnote;
  final ValueChanged<String> onPicked;

  @override
  State<CurrencyList> createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final q = normalizeForSearch(_query);
    bool hit(String code) {
      if (q.isEmpty) return true;
      return normalizeForSearch(code).contains(q) ||
          normalizeForSearch(currencyNames[code] ?? '').contains(q) ||
          normalizeForSearch(currencyNamesVi[code] ?? '').contains(q);
    }

    final used = <String>{...widget.used}.where(hit).toList();
    final others = <String>{
      widget.selected,
      ...commonCurrencies,
      ...(widget.known.toList()..sort()),
    }.where((code) => !used.contains(code) && hit(code)).toList();
    final twoSections = widget.used.isNotEmpty;

    Widget row(String code) => _CurrencyRow(
      code: code,
      selected: code == widget.selected,
      inline: twoSections,
      sub: _sub(l, code, twoSections),
      onTap: () => widget.onPicked(code),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          onChanged: (v) => setState(() => _query = v),
          textInputAction: TextInputAction.search,
          style: AppType.body.copyWith(color: c.ink),
          decoration: InputDecoration(
            hintText: widget.searchHint,
            prefixIcon: Icon(AppIcons.search, size: 20, color: c.inkMuted),
          ),
        ),
        const SizedBox(height: AppSpace.s2),
        Expanded(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              if (used.isNotEmpty) ...[
                SectionHeader(label: l.subscriptionFormCurrencyUsed, padding: _headerPadding),
                for (final code in used) row(code),
              ],
              if (others.isNotEmpty) ...[
                if (twoSections) SectionHeader(label: l.subscriptionFormCurrencyAll, padding: _headerPadding),
                for (final code in others) row(code),
              ],
              if (used.isEmpty && others.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppSpace.s6),
                  child: Text(
                    l.subscriptionFormCurrencyNoMatch(_query.trim()),
                    textAlign: TextAlign.center,
                    style: AppType.body.copyWith(color: c.inkMuted),
                  ),
                ),
              if (widget.footnote != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpace.s3),
                  child: Text(widget.footnote!, style: AppType.meta.copyWith(color: c.inkMuted)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  static const _headerPadding = EdgeInsets.fromLTRB(AppSpace.s2, AppSpace.s4, AppSpace.s2, AppSpace.s1);

  /// Second line: S4 → "Main currency" / "1 USD ≈ ₫25,400" / name; S1 → the name.
  String? _sub(AppLocalizations l, String code, bool s4) {
    if (!s4) return currencyName(l, code);
    final primary = widget.primary;
    if (code == primary) return l.subscriptionFormCurrencyMain;
    final rate = primary == null ? null : widget.rates?.convert(1, code, primary);
    if (rate == null) return null;
    return l.subscriptionFormCurrencyRate(code, l.amount(rate, primary!));
  }
}

/// Symbol badge · "VND · Vietnamese đồng" (S4) or "VND" over the name (S1) · check when selected.
class _CurrencyRow extends StatelessWidget {
  const _CurrencyRow({
    required this.code,
    required this.selected,
    required this.inline,
    required this.sub,
    required this.onTap,
  });

  final String code;
  final bool selected;
  final bool inline;
  final String? sub;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final name = currencyName(l, code);
    final title = inline && name != null ? '$code · $name' : code;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: AppSpace.s2),
            child: Row(
              children: [
                ExcludeSemantics(
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(AppRadius.sm)),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          currencySymbol(code),
                          style: AppType.label.copyWith(color: c.ink),
                          textScaler: TextScaler.noScaling,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpace.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppType.titleSm.copyWith(color: c.ink, fontWeight: FontWeight.w500),
                      ),
                      if (sub != null) Text(sub!, style: AppType.meta.copyWith(color: c.inkMuted).tabular),
                    ],
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: AppSpace.s3),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(color: c.brand, shape: BoxShape.circle),
                    child: Icon(AppIcons.check, size: 16, color: c.onBrand),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
