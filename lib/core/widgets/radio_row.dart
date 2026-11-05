import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Look of a [RadioRow].
enum RadioRowStyle {
  /// Stand-alone tile (S3 plan sheet): `surface-2`, radius-md; selected = `brand-soft` + 2px `brand` ring.
  card,

  /// Row inside an `AppGroup` (sort sheet, settings choices): transparent; selected = `brand-soft`.
  flat,
}

/// Single-choice row (design `plan` + `radio`): 22px radio, title (`title-sm`) + optional meta
/// subtitle, optional trailing (e.g. a price — see [RadioRow.price]). ≥ 48dp tall, the whole row
/// is the touch target. At large text (≥ 150%) the trailing part moves under the subtitle so
/// titles and amounts never truncate.
///
/// Use several in a [RadioRowGroup], or lay them out yourself with the same [groupValue].
class RadioRow<T> extends StatelessWidget {
  const RadioRow({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.trailing,
    this.style = RadioRowStyle.card,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final RadioRowStyle style;

  /// Trailing price "₫260,000/mo": [amount] in `title-sm` tabular + [suffix] in meta.
  static Widget price(BuildContext context, String amount, {String? suffix}) {
    final c = context.colors;
    return Text.rich(
      TextSpan(
        text: amount,
        style: AppType.titleSm.copyWith(color: c.ink).tabular,
        children: [
          if (suffix != null)
            TextSpan(
              text: suffix,
              style: AppType.meta.copyWith(color: c.inkMuted),
            ),
        ],
      ),
      maxLines: 1,
      softWrap: false,
    );
  }

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final on = _selected;
    final big = MediaQuery.textScalerOf(context).scale(10) >= 15;
    final card = style == RadioRowStyle.card;
    final radius = card ? BorderRadius.circular(AppRadius.md) : BorderRadius.zero;
    final bg = on ? c.brandSoft : (card ? c.surface2 : Colors.transparent);

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: AppType.titleSm.copyWith(color: c.ink)),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(subtitle!, style: AppType.meta.copyWith(color: c.inkMuted)),
          ),
        if (big && trailing != null) Padding(padding: const EdgeInsets.only(top: 4), child: trailing),
      ],
    );

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: on,
      selected: on,
      enabled: onChanged != null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onChanged == null || on ? null : () => onChanged!(value),
          borderRadius: radius,
          child: AnimatedContainer(
            duration: AppMotion.of(context, AppMotion.fast),
            curve: AppMotion.ease,
            constraints: const BoxConstraints(minHeight: 48),
            padding: EdgeInsets.symmetric(horizontal: card ? 14 : AppSpace.s4, vertical: 12),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: radius,
              border: card && on ? Border.all(color: c.brand, width: 2) : null,
            ),
            child: Row(
              children: [
                RadioMark(selected: on, gapColor: on ? c.brandSoft : (card ? c.surface2 : c.surface)),
                const SizedBox(width: AppSpace.s3),
                Expanded(child: text),
                if (!big && trailing != null) ...[const SizedBox(width: AppSpace.s3), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The 22px radio circle: 2px `line-strong` ring; selected = 2px `brand` ring + 10px `brand` dot.
class RadioMark extends StatelessWidget {
  const RadioMark({super.key, required this.selected, this.gapColor});

  final bool selected;

  /// Colour between ring and dot (the row background).
  final Color? gapColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AnimatedContainer(
      duration: AppMotion.of(context, AppMotion.fast),
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: gapColor ?? Colors.transparent,
        border: Border.all(color: selected ? c.brand : c.lineStrong, width: 2),
      ),
      child: selected
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: c.brand, shape: BoxShape.circle),
            )
          : null,
    );
  }
}

/// One option of a [RadioRowGroup].
class RadioOption<T> {
  const RadioOption({required this.value, required this.title, this.subtitle, this.trailing});

  final T value;
  final String title;
  final String? subtitle;
  final Widget? trailing;
}

/// Single-choice list: [RadioRowStyle.card] rows stacked 8px apart (plan sheet), or
/// [RadioRowStyle.flat] rows inside a card with hairlines (sort sheet, settings choices).
class RadioRowGroup<T> extends StatelessWidget {
  const RadioRowGroup({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.style = RadioRowStyle.card,
  });

  final List<RadioOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final RadioRowStyle style;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final rows = [
      for (final o in options)
        RadioRow<T>(
          value: o.value,
          groupValue: value,
          onChanged: onChanged,
          title: o.title,
          subtitle: o.subtitle,
          trailing: o.trailing,
          style: style,
        ),
    ];
    if (style == RadioRowStyle.card) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < rows.length; i++) ...[if (i > 0) const SizedBox(height: AppSpace.s2), rows[i]],
        ],
      );
    }
    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: context.elevation.card,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) Divider(height: 1, thickness: 1, indent: 50, color: c.line),
                rows[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
