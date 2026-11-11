import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';

/// Icon keys a Category can store (`Category.icon`), in the order of the picker (mockup 107).
const kCategoryIcons = <String, IconData>{
  'film': LucideIcons.film,
  'music': LucideIcons.music,
  'bot': LucideIcons.bot,
  'cloud': LucideIcons.cloud,
  'cpu': LucideIcons.cpu,
  'signal': LucideIcons.signal,
  'graduation-cap': LucideIcons.graduationCap,
  'gamepad-2': LucideIcons.gamepad2,
  'book-open': LucideIcons.bookOpen,
  'heart-pulse': LucideIcons.heartPulse,
  'dumbbell': LucideIcons.dumbbell,
  'receipt': LucideIcons.receipt,
  'shield': LucideIcons.shield,
  'store': LucideIcons.store,
  'users-round': LucideIcons.usersRound,
  'circle-ellipsis': LucideIcons.circleEllipsis,
};

/// Icon of a built-in Category until the user picks another.
const _builtInIcons = <SubscriptionCategory, String>{
  SubscriptionCategory.video: 'film',
  SubscriptionCategory.music: 'music',
  SubscriptionCategory.ai: 'bot',
  SubscriptionCategory.storage: 'cloud',
  SubscriptionCategory.software: 'cpu',
  SubscriptionCategory.gaming: 'gamepad-2',
  SubscriptionCategory.reading: 'book-open',
  SubscriptionCategory.health: 'heart-pulse',
  SubscriptionCategory.education: 'graduation-cap',
  SubscriptionCategory.telecom: 'signal',
  SubscriptionCategory.other: 'circle-ellipsis',
};

/// The icon key shown for [c]: its own, else the built-in one, else "…".
String categoryIconKey(Category c) =>
    (c.icon != null && kCategoryIcons.containsKey(c.icon)) ? c.icon! : (_builtInIcons[c.builtIn] ?? 'circle-ellipsis');

/// Colour choices of the Category / Label pickers (`.swatches`, mockup 107).
const kManageSwatches = <int>[
  0xFFE87BA4,
  0xFFD21F3C,
  0xFFE8590C,
  0xFFC26A00,
  0xFF1F9D55,
  0xFF0F8B8D,
  0xFF3A9BE0,
  0xFF2856D8,
  0xFF7A3FE0,
  0xFF8A5A3C,
  0xFF2D3438,
  0xFF79838A,
];

/// `.ci` / `.lbl-big`: a rounded square in [color] with a white icon at half its size.
class ColorTile extends StatelessWidget {
  const ColorTile({super.key, required this.color, required this.icon, this.size = 32});

  final Color color;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(size * .3)),
      child: Icon(icon, size: (size * .5).roundToDouble(), color: Colors.white),
    ),
  );
}

/// The tile of a Category.
class CategoryTile extends StatelessWidget {
  const CategoryTile(this.category, {super.key, this.size = 32});

  final Category category;
  final double size;

  @override
  Widget build(BuildContext context) =>
      ColorTile(color: Color(category.colorValue), icon: kCategoryIcons[categoryIconKey(category)]!, size: size);
}

/// A row of the manage lists (`.srow`): leading tile, name + "3 subscriptions", trailing icon.
class ManageRow extends StatelessWidget {
  const ManageRow({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.subtitleColor,
    this.trailing,
    this.onTap,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 10),
          child: Row(
            children: [
              leading,
              const SizedBox(width: AppSpace.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppType.body.copyWith(fontWeight: FontWeight.w500, height: 20 / 15, color: c.ink),
                    ),
                    if (subtitle != null)
                      Text(subtitle!, style: AppType.meta.copyWith(color: subtitleColor ?? c.inkMuted)),
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: AppSpace.s2), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}

/// Intro line at the top of a manage list (`.pend-intro`).
class ManageIntro extends StatelessWidget {
  const ManageIntro(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(AppSpace.s1, AppSpace.s2, AppSpace.s1, AppSpace.s4),
    child: Text(text, style: AppType.meta.copyWith(color: context.colors.inkMuted)),
  );
}

/// Name input of the edit sheets: `surface-2`, `brand` ring while focused.
class NameField extends StatelessWidget {
  const NameField({super.key, required this.controller, required this.hint, this.errorText, this.onSubmitted});

  final TextEditingController controller;
  final String hint;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    OutlineInputBorder ring(Color color, double w) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color, width: w),
    );
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      onSubmitted: onSubmitted,
      style: AppType.body.copyWith(color: c.ink),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppType.body.copyWith(color: c.inkMuted),
        errorText: errorText,
        filled: true,
        fillColor: c.surface2,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: ring(c.line, 1),
        focusedBorder: ring(c.brand, 2),
        errorBorder: ring(c.danger, 2),
        focusedErrorBorder: ring(c.danger, 2),
      ),
    );
  }
}

/// `.swatches`: 7 per row, the chosen one with a focus ring and a check.
class SwatchPicker extends StatelessWidget {
  const SwatchPicker({super.key, required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return LayoutBuilder(
      builder: (context, box) {
        const gap = 10.0;
        final size = ((box.maxWidth - gap * 6) / 7).clamp(32.0, 48.0);
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final (i, v) in kManageSwatches.indexed)
              Semantics(
                button: true,
                selected: v == selected,
                label: '${i + 1}',
                child: GestureDetector(
                  onTap: () => onChanged(v),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Color(v),
                      shape: BoxShape.circle,
                      boxShadow: v == selected
                          ? [
                              BoxShadow(color: c.surfaceSheet, spreadRadius: 2),
                              BoxShadow(color: c.focus, spreadRadius: 4),
                            ]
                          : null,
                    ),
                    child: v == selected ? const Icon(LucideIcons.check, size: 16, color: Colors.white) : null,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// "3 subscriptions" / "No subscriptions".
String subCount(AppLocalizations l, int n) => l.manageSubCount(n);

/// Text button in `danger` with the trash icon ("Delete category", mockup 107 `.btn-text.danger-t`).
class DangerTextButton extends StatelessWidget {
  const DangerTextButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(AppIcons.delete, size: 18, color: c.danger),
      label: Text(label, style: AppType.label.copyWith(color: c.danger)),
      style: TextButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSize.buttonH),
        foregroundColor: c.danger,
        shape: const StadiumBorder(),
      ),
    );
  }
}
