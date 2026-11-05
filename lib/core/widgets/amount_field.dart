import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../domain/money.dart' show currencyDecimals;
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'app_icons.dart';

/// Large money input (design S4 `price-row`, S6 `amount-box`): optional label (meta), the amount in
/// `amount-lg` tabular with the locale's currency symbol around it (`₫280,000` · `280.000đ` ·
/// `$20.00`), grouped as you type, then a currency pill ("VND ⌄", when [onCurrencyTap] is set)
/// or a pencil button ([showEditButton], S6). Under it: [conversion] ("≈ ₫508,000"), [helper]
/// (with [helperIcon]) and/or [errorText] (danger + alert icon).
///
/// Reports the value in **major units** (`null` when empty) — store with `toMinorUnits`.
/// Grows ≤ 38px at 130%+ text and shrinks to fit narrow widths; every control is ≥ 48dp.
class AmountField extends StatefulWidget {
  const AmountField({
    super.key,
    required this.value,
    required this.currency,
    required this.onChanged,
    this.label,
    this.onCurrencyTap,
    this.showEditButton = false,
    this.conversion,
    this.helper,
    this.helperIcon,
    this.errorText,
    this.boxed = false,
    this.autofocus = false,
    this.focusNode,
    this.enabled = true,
    this.maxIntegerDigits = 12,
  });

  /// Current amount in major units; `null` = empty (placeholder "0").
  final double? value;

  /// ISO 4217 code ("VND", "USD") — drives symbol, decimals and the pill label.
  final String currency;
  final ValueChanged<double?> onChanged;

  /// "Price" / "Amount paid".
  final String? label;

  /// Shows the "VND ⌄" pill; open your currency picker here.
  final VoidCallback? onCurrencyTap;

  /// Shows a pencil button that focuses the field (confirm sheet).
  final bool showEditButton;

  /// Secondary converted amount, already formatted: "≈ ₫508,000".
  final String? conversion;
  final String? helper;
  final IconData? helperIcon;
  final String? errorText;

  /// `surface-2` panel with padding (S6 confirm sheet). Unboxed = sits in a form `AppGroup` field.
  final bool boxed;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool enabled;
  final int maxIntegerDigits;

  @override
  State<AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<AmountField> {
  late final TextEditingController _controller = TextEditingController();
  FocusNode? _ownFocus;
  FocusNode get _focus => widget.focusNode ?? (_ownFocus ??= FocusNode());
  String? _lang;

  AmountFormat _format(BuildContext context) =>
      AmountFormat(currency: widget.currency, localeName: Localizations.localeOf(context).toString());

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = Localizations.localeOf(context).toString();
    if (lang != _lang) {
      _lang = lang;
      _controller.text = _format(context).editText(widget.value);
    }
  }

  @override
  void didUpdateWidget(AmountField old) {
    super.didUpdateWidget(old);
    final f = _format(context);
    if (old.currency != widget.currency || f.parse(_controller.text) != widget.value) {
      final text = f.editText(widget.value);
      _controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
    if (old.focusNode != widget.focusNode) {
      old.focusNode?.removeListener(_onFocus);
      _focus.addListener(_onFocus);
    }
  }

  void _onFocus() => setState(() {});

  @override
  void dispose() {
    _focus.removeListener(_onFocus);
    _ownFocus?.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _requestFocus() {
    if (!widget.enabled) return;
    _focus.requestFocus();
    _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final f = _format(context);
    final error = widget.errorText != null;
    final empty = _controller.text.isEmpty;
    final textColor = empty ? c.inkMuted : c.ink;

    Widget? trailing;
    if (widget.onCurrencyTap != null) {
      trailing = _CurrencyPill(code: widget.currency, onTap: widget.onCurrencyTap, tooltip: l.coreChangeCurrency);
    } else if (widget.showEditButton) {
      trailing = IconButton(
        tooltip: l.coreEditAmount,
        onPressed: widget.enabled ? _requestFocus : null,
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        icon: Icon(AppIcons.edit, size: 20, color: c.ink),
      );
    }

    final amountRow = LayoutBuilder(
      builder: (context, box) {
        // Big numbers grow less with system text (design: amount-lg ≤ 38px) …
        final scaler = AppTextScale.capped(context, AppTextScale.amountLg);
        var style = AppType.amountLg.copyWith(color: textColor).tabular;
        // … and shrink to fit the room left beside the pill.
        final shown = '${f.prefix}${empty ? f.zero : _controller.text}${f.suffix}';
        final room =
            box.maxWidth - (trailing == null ? 0 : _CurrencyPill.estimateWidth(context, widget.currency) + 12) - 4;
        final natural = _width(shown, style, scaler, context);
        if (natural > room && room > 0) {
          style = style.copyWith(fontSize: math.max(20, style.fontSize! * room / natural));
        }
        final affix = style.copyWith(color: empty ? c.inkMuted : c.ink);
        final field = IntrinsicWidth(
          child: TextField(
            controller: _controller,
            focusNode: _focus,
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            keyboardType: TextInputType.numberWithOptions(decimal: f.decimals > 0),
            textInputAction: TextInputAction.done,
            inputFormatters: [AmountInputFormatter(f, maxIntegerDigits: widget.maxIntegerDigits)],
            onChanged: (t) {
              setState(() {});
              widget.onChanged(f.parse(t));
            },
            style: style,
            cursorColor: c.brand,
            cursorWidth: 2,
            cursorHeight: style.fontSize! * 0.95,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.zero, // theme input padding would push digits off the symbol
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: f.zero,
              hintStyle: style.copyWith(color: c.inkMuted),
            ),
          ),
        );
        return Row(
          children: [
            Expanded(
              child: TextScaleCap(
                max: AppTextScale.amountLg,
                // One accessibility node for the whole ≥ 48dp row (not just the digits), labelled.
                child: MergeSemantics(
                  child: Semantics(
                    label: widget.label,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _requestFocus,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 48),
                        child: Row(
                          children: [
                            if (f.prefix.isNotEmpty) Text(f.prefix, style: affix),
                            Flexible(child: field),
                            if (f.suffix.isNotEmpty) Text(f.suffix, style: affix),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 12), trailing],
          ],
        );
      },
    );

    final lines = <Widget>[
      if (widget.conversion != null) Text(widget.conversion!, semanticsLabel: context.l10n.spokenLabel(widget.conversion!), style: AppType.meta.copyWith(color: c.inkMuted).tabular),
      if (widget.helper != null)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.helperIcon != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(widget.helperIcon, size: 14, color: c.inkMuted),
              ),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Text(widget.helper!, style: AppType.meta.copyWith(color: c.inkMuted)),
            ),
          ],
        ),
      if (error)
        Semantics(
          liveRegion: true,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(AppIcons.alert, size: 14, color: c.danger),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(widget.errorText!, style: AppType.meta.copyWith(color: c.danger)),
              ),
            ],
          ),
        ),
    ];

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          ExcludeSemantics(
            child: Text(widget.label!, style: AppType.meta.copyWith(color: c.inkMuted)),
          ),
        amountRow,
        for (final w in lines) Padding(padding: const EdgeInsets.only(top: 4), child: w),
      ],
    );

    if (!widget.boxed) return content;
    return AnimatedContainer(
      duration: AppMotion.of(context, AppMotion.fast),
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 14),
      decoration: BoxDecoration(
        color: c.surface2,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: error
            ? Border.all(color: c.danger, width: 2)
            : (_focus.hasFocus
                  ? Border.all(color: c.brand, width: 2)
                  : Border.all(color: Colors.transparent, width: 2)),
      ),
      child: content,
    );
  }

  static double _width(String text, TextStyle style, TextScaler scaler, BuildContext context) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      textScaler: scaler,
      maxLines: 1,
    )..layout();
    final w = tp.width + 4; // caret
    tp.dispose();
    return w;
  }
}

/// "VND ⌄" pill: `surface-2`, 40px tall, 15/600, inside a 48dp touch target.
class _CurrencyPill extends StatelessWidget {
  const _CurrencyPill({required this.code, required this.onTap, required this.tooltip});

  final String code;
  final VoidCallback? onTap;
  final String tooltip;

  static TextStyle _style(BuildContext context) =>
      AppType.body.copyWith(fontWeight: FontWeight.w600, color: context.colors.ink);

  static double estimateWidth(BuildContext context, String code) {
    final tp = TextPainter(
      text: TextSpan(text: code, style: _style(context)),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    final w = tp.width + 14 + 4 + 16 + 10;
    tp.dispose();
    return math.max(48, w);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: '$tooltip: $code',
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(minHeight: 40),
              padding: const EdgeInsets.fromLTRB(14, 4, 10, 4),
              decoration: ShapeDecoration(color: c.surface2, shape: const StadiumBorder()),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(code, style: _style(context), maxLines: 1, softWrap: false),
                  const SizedBox(width: 4),
                  Icon(AppIcons.expand, size: 16, color: c.ink),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Locale + currency number shape used by [AmountField]: symbol placement, separators, decimals.
@immutable
class AmountFormat {
  AmountFormat({required this.currency, required String localeName}) : lang = localeName.split(RegExp('[_-]')).first {
    decimals = currencyDecimals(currency.toUpperCase());
    final symbols = NumberFormat.decimalPattern(lang).symbols;
    group = symbols.GROUP_SEP;
    decimal = symbols.DECIMAL_SEP;
    // Symbol placement from the app's own money format (core/utils/format.dart).
    final sample = Fmt.money(1, currency, lang);
    final first = sample.indexOf(RegExp(r'\d'));
    final last = sample.lastIndexOf(RegExp(r'\d'));
    prefix = first < 0 ? '' : sample.substring(0, first);
    suffix = last < 0 ? '' : sample.substring(last + 1);
  }

  final String currency;
  final String lang;
  late final int decimals;
  late final String group;
  late final String decimal;
  late final String prefix;
  late final String suffix;

  /// Placeholder digits: "0" / "0.00".
  String get zero => decimals == 0 ? '0' : '0$decimal${'0' * decimals}';

  /// Editable text for [value] (grouped, no symbol); `''` for null.
  String editText(double? value) {
    if (value == null) return '';
    final fixed = value.toStringAsFixed(decimals);
    final parts = fixed.split('.');
    var frac = parts.length > 1 ? parts[1] : '';
    frac = frac.replaceFirst(RegExp(r'0+$'), '');
    return groupInt(parts[0]) + (frac.isEmpty ? '' : '$decimal$frac');
  }

  /// "1234567" → "1,234,567" / "1.234.567".
  String groupInt(String digits) {
    final d = digits.replaceFirst(RegExp(r'^0+(?=\d)'), '');
    final b = StringBuffer();
    for (var i = 0; i < d.length; i++) {
      if (i > 0 && (d.length - i) % 3 == 0) b.write(group);
      b.write(d[i]);
    }
    return b.toString();
  }

  /// Text produced by [editText] / the formatter → major units; `null` when empty.
  double? parse(String text) {
    if (text.trim().isEmpty) return null;
    final cleaned = text.replaceAll(group, '');
    final parts = cleaned.split(decimal);
    final i = parts[0].replaceAll(RegExp(r'\D'), '');
    final fr = parts.length > 1 ? parts[1].replaceAll(RegExp(r'\D'), '') : '';
    if (i.isEmpty && fr.isEmpty) return null;
    return double.tryParse('${i.isEmpty ? '0' : i}.${fr.isEmpty ? '0' : fr}');
  }
}

/// Keeps [AmountField] text grouped by locale while typing. Either `.` or `,` typed by the user
/// becomes the decimal separator (only for currencies with decimals); backspacing a group
/// separator deletes the digit before it; the caret keeps its place counted from the right.
class AmountInputFormatter extends TextInputFormatter {
  AmountInputFormatter(this.f, {this.maxIntegerDigits = 12});

  final AmountFormat f;
  final int maxIntegerDigits;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final old = oldValue.text;
    var text = newValue.text;

    // What changed (common prefix / suffix).
    var p = 0;
    while (p < old.length && p < text.length && old[p] == text[p]) {
      p++;
    }
    var s = 0;
    while (s < old.length - p && s < text.length - p && old[old.length - 1 - s] == text[text.length - 1 - s]) {
      s++;
    }
    final inserted = text.substring(p, text.length - s);
    final removed = old.substring(p, old.length - s);

    var caret = (newValue.selection.baseOffset < 0 ? text.length : newValue.selection.baseOffset).clamp(0, text.length);

    // Backspace over a group separator → also delete the digit before it.
    if (inserted.isEmpty && removed == f.group && p > 0) {
      text = text.substring(0, p - 1) + text.substring(p);
      p--;
      caret = p;
    }

    // Normalise what was typed: any . or , → decimal marker '\u0000'; drop other non-digits.
    final hadDecimal = f.decimals > 0 && old.contains(f.decimal);
    final b = StringBuffer();
    var caretFromRight = 0;
    final logical = <String>[]; // digits and at most one '.'
    var seenDecimal = false;
    for (var i = 0; i < text.length; i++) {
      final ch = text[i];
      final inInsert = i >= p && i < p + inserted.length;
      String? out;
      if (RegExp(r'\d').hasMatch(ch)) {
        out = ch;
      } else if (f.decimals > 0 && !seenDecimal) {
        final isOldDecimal = !inInsert && ch == f.decimal && hadDecimal;
        final typedSep = inInsert && (ch == '.' || ch == ',') && !hadDecimal;
        if (isOldDecimal || typedSep) out = '.';
      }
      if (out == null) continue;
      if (out == '.') seenDecimal = true;
      logical.add(out);
      if (i >= caret) caretFromRight++;
    }
    b.writeAll(logical);
    final raw = b.toString();

    // Split, limit, regroup.
    var intPart = raw.contains('.') ? raw.substring(0, raw.indexOf('.')) : raw;
    var frac = raw.contains('.') ? raw.substring(raw.indexOf('.') + 1) : null;
    if (intPart.length > maxIntegerDigits) return oldValue;
    if (frac != null && frac.length > f.decimals) {
      final cut = frac.length - f.decimals;
      frac = frac.substring(0, f.decimals);
      caretFromRight = math.max(0, caretFromRight - cut);
    }
    if (intPart.isEmpty && frac != null) intPart = '0';
    final grouped = intPart.isEmpty ? '' : f.groupInt(intPart);
    final result = frac == null ? grouped : '$grouped${f.decimal}$frac';

    // Map caret: count logical chars from the right.
    var offset = result.length;
    var count = 0;
    while (offset > 0 && count < caretFromRight) {
      offset--;
      if (result[offset] != f.group) count++;
    }
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
