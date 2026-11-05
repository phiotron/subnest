import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens.g.dart';

export 'motion.dart';
export 'tokens.g.dart';

/// Subnest Material 3 theme built from the Claude Design tokens (design/system/tokens.json →
/// tokens.g.dart). Mapping follows design/system/README.md § Flutter mapping; every token without
/// a ColorScheme slot lives in [AppColors] (`context.colors`) and shadows in [AppElevation]
/// (`context.elevation`).
abstract final class AppTheme {
  static ThemeData light() => build(AppColors.light, AppElevation.light, Brightness.light);

  static ThemeData dark() => build(AppColors.dark, AppElevation.dark, Brightness.dark);

  /// Old placeholder constants, kept so not-yet-restyled screens compile. Use
  /// `context.colors.warning…` / `context.colors.success…` instead.
  @Deprecated('Use context.colors.warning / warningSoft / warningInk')
  static const Color warning = Color(0xFFC26A00);
  @Deprecated('Use context.colors.success / successSoft')
  static const Color success = Color(0xFF13773A);

  static ColorScheme colorScheme(AppColors c, Brightness brightness) => ColorScheme(
    brightness: brightness,
    primary: c.brand,
    onPrimary: c.onBrand,
    primaryContainer: c.brandSoft,
    onPrimaryContainer: c.onBrandSoft,
    secondary: c.brand,
    onSecondary: c.onBrand,
    secondaryContainer: c.brandSoft,
    onSecondaryContainer: c.onBrandSoft,
    tertiary: c.warning,
    onTertiary: c.onBrand,
    tertiaryContainer: c.warningSoft,
    onTertiaryContainer: c.warningInk,
    error: c.danger,
    onError: c.onDanger,
    errorContainer: c.dangerSoft,
    onErrorContainer: c.danger,
    surface: c.surface,
    onSurface: c.ink,
    onSurfaceVariant: c.inkMuted,
    surfaceDim: c.bg,
    surfaceBright: c.surface,
    surfaceContainerLowest: c.surface,
    surfaceContainerLow: c.surface,
    surfaceContainer: c.surface,
    surfaceContainerHigh: c.surfaceSheet,
    surfaceContainerHighest: c.surface2,
    outline: c.lineStrong,
    outlineVariant: c.line,
    shadow: const Color(0xFF000000),
    scrim: c.scrim,
    inverseSurface: c.ink,
    onInverseSurface: c.bg,
    inversePrimary: c.brandSoft,
    surfaceTint: Colors.transparent,
  );

  /// Type styles → Material roles (so stock widgets pick up Be Vietnam Pro at the right size).
  static TextTheme textTheme(AppColors c) => TextTheme(
    displayLarge: AppType.display,
    displayMedium: AppType.amountLg,
    displaySmall: AppType.headline,
    headlineLarge: AppType.headline,
    headlineMedium: AppType.headline,
    headlineSmall: AppType.title,
    titleLarge: AppType.title,
    titleMedium: AppType.titleSm,
    titleSmall: AppType.label,
    bodyLarge: AppType.body,
    bodyMedium: AppType.body,
    bodySmall: AppType.meta.copyWith(color: c.inkMuted),
    labelLarge: AppType.label,
    labelMedium: AppType.meta,
    labelSmall: AppType.caption,
  ).apply(bodyColor: c.ink, displayColor: c.ink);

  static ThemeData build(AppColors c, AppElevation e, Brightness brightness) {
    final scheme = colorScheme(c, brightness);
    final text = textTheme(c);
    final isDark = brightness == Brightness.dark;
    const md = BorderRadius.all(Radius.circular(AppRadius.md));
    const lg = BorderRadius.all(Radius.circular(AppRadius.lg));
    const xl = BorderRadius.all(Radius.circular(AppRadius.xl));
    final buttonText = AppType.label.copyWith(fontSize: 16, height: 20 / 16);
    const buttonMin = Size(64, AppSize.buttonH);
    const buttonPad = EdgeInsets.symmetric(horizontal: AppSpace.s5);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppType.fontFamily,
      textTheme: text,
      primaryTextTheme: text,
      scaffoldBackgroundColor: c.bg,
      canvasColor: c.bg,
      dividerColor: c.line,
      splashFactory: InkSparkle.splashFactory,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      extensions: [c, e],
      iconTheme: IconThemeData(color: c.ink, size: 20),
      appBarTheme: AppBarTheme(
        backgroundColor: c.bg,
        foregroundColor: c.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 52,
        titleTextStyle: AppType.titleSm.copyWith(color: c.ink),
        iconTheme: IconThemeData(color: c.ink, size: 24),
        systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: lg,
          side: isDark ? BorderSide(color: c.line) : BorderSide.none,
        ),
      ),
      dividerTheme: DividerThemeData(color: c.line, thickness: 1, space: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.brand,
          foregroundColor: c.onBrand,
          disabledBackgroundColor: c.brand.withValues(alpha: .45),
          disabledForegroundColor: c.onBrand,
          minimumSize: buttonMin,
          padding: buttonPad,
          textStyle: buttonText,
          shape: const RoundedRectangleBorder(borderRadius: md),
          iconSize: 20,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.ink,
          minimumSize: buttonMin,
          padding: buttonPad,
          textStyle: buttonText,
          side: BorderSide(color: c.lineStrong, width: 1.5),
          shape: const RoundedRectangleBorder(borderRadius: md),
          iconSize: 20,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.brand,
          minimumSize: const Size(64, AppSize.tapMin),
          textStyle: AppType.label,
          shape: const RoundedRectangleBorder(borderRadius: md),
          iconSize: 20,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.brandSoft,
          foregroundColor: c.onBrandSoft,
          elevation: 0,
          minimumSize: buttonMin,
          padding: buttonPad,
          textStyle: buttonText,
          shape: const RoundedRectangleBorder(borderRadius: md),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: c.ink,
          minimumSize: const Size.square(AppSize.tapMin),
          iconSize: 24,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.brand,
        foregroundColor: c.onBrand,
        elevation: isDark ? 6 : 4,
        highlightElevation: 6,
        shape: const RoundedRectangleBorder(borderRadius: lg),
        sizeConstraints: const BoxConstraints.tightFor(width: AppSize.fabSize, height: AppSize.fabSize),
        iconSize: 26,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface2,
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        hintStyle: AppType.body.copyWith(color: c.inkMuted),
        labelStyle: AppType.label.copyWith(color: c.inkMuted),
        floatingLabelStyle: AppType.label.copyWith(color: c.brand),
        helperStyle: AppType.meta.copyWith(color: c.inkMuted),
        errorStyle: AppType.meta.copyWith(color: c.danger),
        prefixIconColor: c.inkMuted,
        suffixIconColor: c.inkMuted,
        border: OutlineInputBorder(borderRadius: md, borderSide: BorderSide(color: c.line)),
        enabledBorder: OutlineInputBorder(borderRadius: md, borderSide: BorderSide(color: c.line)),
        focusedBorder: OutlineInputBorder(borderRadius: md, borderSide: BorderSide(color: c.brand, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: md, borderSide: BorderSide(color: c.danger, width: 2)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: md, borderSide: BorderSide(color: c.danger, width: 2)),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.brand,
        selectionColor: c.brand.withValues(alpha: .25),
        selectionHandleColor: c.brand,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.onBrand : c.lineStrong),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.brand : c.surface2),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Colors.transparent : c.lineStrong,
        ),
        trackOutlineWidth: const WidgetStatePropertyAll(2),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.brand : c.lineStrong),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.brand : null),
        checkColor: WidgetStatePropertyAll(c.onBrand),
        side: BorderSide(color: c.lineStrong, width: 2),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.surface2,
        selectedColor: c.brand,
        labelStyle: AppType.label.copyWith(fontWeight: FontWeight.w500, color: c.ink),
        secondaryLabelStyle: AppType.label.copyWith(color: c.onBrand),
        checkmarkColor: c.onBrand,
        side: BorderSide.none,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 6),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: c.inkMuted,
        textColor: c.ink,
        titleTextStyle: AppType.titleSm.copyWith(color: c.ink),
        subtitleTextStyle: AppType.meta.copyWith(color: c.inkMuted),
        leadingAndTrailingTextStyle: AppType.titleSm.copyWith(color: c.ink),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
        minVerticalPadding: 12,
        horizontalTitleGap: AppSpace.s3,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surfaceSheet,
        modalBackgroundColor: c.surfaceSheet,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: c.scrim,
        elevation: 0,
        modalElevation: 0,
        showDragHandle: true,
        dragHandleColor: c.lineStrong.withValues(alpha: .5),
        dragHandleSize: const Size(36, 5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surfaceSheet,
        surfaceTintColor: Colors.transparent,
        barrierColor: c.scrim,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: xl),
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSpace.s6, vertical: AppSpace.s6),
        titleTextStyle: AppType.title.copyWith(color: c.ink),
        contentTextStyle: AppType.body.copyWith(color: c.inkMuted),
      ),
      snackBarTheme: SnackBarThemeData(
        // Design "toast": ink fill, bg text, radius-md, floats above the tab bar.
        backgroundColor: c.ink,
        contentTextStyle: AppType.label.copyWith(fontWeight: FontWeight.w500, color: c.bg),
        actionTextColor: isDark ? AppColors.light.brand : AppColors.dark.brand,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: md),
        insetPadding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, AppSpace.s4),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.surface,
        indicatorColor: c.brandSoft,
        surfaceTintColor: Colors.transparent,
        height: AppSize.tabbarH,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => AppType.caption.copyWith(
            letterSpacing: 0,
            fontWeight: s.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
            color: s.contains(WidgetState.selected) ? c.ink : c.inkMuted,
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: c.surface2,
          foregroundColor: c.inkMuted,
          selectedBackgroundColor: c.brandSoft,
          selectedForegroundColor: c.onBrandSoft,
          side: BorderSide.none,
          textStyle: AppType.label,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.brand,
        linearTrackColor: c.surface2,
        circularTrackColor: Colors.transparent,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: c.ink, borderRadius: md),
        textStyle: AppType.meta.copyWith(color: c.bg),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: c.surfaceSheet,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: md),
        textStyle: AppType.body.copyWith(color: c.ink),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: c.surfaceSheet,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: xl),
        todayForegroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.onBrand : c.brand,
        ),
        todayBorder: BorderSide(color: c.brand, width: 1.5),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: c.surfaceSheet,
        shape: const RoundedRectangleBorder(borderRadius: xl),
        dialBackgroundColor: c.surface2,
        hourMinuteColor: c.surface2,
      ),
    );
  }
}

/// `context.colors.surface2`, `context.elevation.card`, `context.isDark`.
extension AppThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>() ?? AppColors.light;

  AppElevation get elevation => Theme.of(this).extension<AppElevation>() ?? AppElevation.light;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

/// Text-style helpers.
extension AppTextStyleX on TextStyle {
  /// Tabular figures — use for every amount (bundled Be Vietnam Pro has a `tnum` feature).
  TextStyle get tabular => copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

  TextStyle withColor(Color c) => copyWith(color: c);
}

/// Large-text rules (design README § Type): text grows with the system factor, but the big
/// numbers grow less so they stay on one line — at 130% `display` 40→44, `amount-lg` 34→38,
/// `headline` 28→32. Wrap the widget with [TextScaleCap] or pass `textScaler:` from [capped].
abstract final class AppTextScale {
  static const display = 44 / 40;
  static const amountLg = 38 / 34;
  static const headline = 32 / 28;

  /// The ambient scaler clamped to [max] (a factor like [display]).
  static TextScaler capped(BuildContext context, double max) =>
      MediaQuery.textScalerOf(context).clamp(maxScaleFactor: max);
}

/// Caps the system text scale for its subtree (see [AppTextScale]).
class TextScaleCap extends StatelessWidget {
  const TextScaleCap({super.key, required this.max, required this.child});

  /// Max scale factor; 1.0 = never grow (tiles, tab bar).
  final double max;
  final Widget child;

  @override
  Widget build(BuildContext context) => MediaQuery.withClampedTextScaling(maxScaleFactor: max, child: child);
}
