import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icons.dart';

/// Shows a standard bottom sheet (design Components › BottomSheet): `surface-sheet`, radius-xl top
/// corners, 36×5 grabber, 20px side padding, slides up 240 ms over the `scrim`.
///
/// [required] = a choice must be made (confirm-all, restore): no drag-down, no scrim tap.
/// The builder's content is wrapped in [AppSheet] padding unless [bare] is true.
Future<T?> showAppSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool required = false,
  bool bare = false,
  bool useRootNavigator = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: useRootNavigator,
    isDismissible: !required,
    enableDrag: !required,
    showDragHandle: true,
    sheetAnimationStyle: AnimationStyle(
      duration: AppMotion.of(context, AppMotion.sheet),
      reverseDuration: AppMotion.of(context, AppMotion.fast),
      curve: AppMotion.sheetCurve,
    ),
    builder: bare ? builder : (ctx) => AppSheet(child: builder(ctx)),
  );
}

/// Standard sheet body: optional [title] (`title` 20/600, 16 below), [child], optional [actions]
/// stacked full-width with 8px gaps. Pads 20px sides and the bottom safe area + keyboard.
class AppSheet extends StatelessWidget {
  const AppSheet({super.key, this.title, required this.child, this.actions = const []});

  final String? title;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpace.s5,
        0,
        AppSpace.s5,
        AppSpace.s4 + mq.viewPadding.bottom + mq.viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Semantics(header: true, child: Text(title!, style: AppType.title.copyWith(color: context.colors.ink))),
            const SizedBox(height: AppSpace.s4),
          ],
          Flexible(child: child),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: AppSpace.s4),
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpace.s2),
              actions[i],
            ],
          ],
        ],
      ),
    );
  }
}

/// Shows a dialog (design Components › Dialog): `surface-sheet`, radius-xl, 24px from the screen
/// edges, scales in 0.94 → 1 + fades over 200 ms on the `scrim`. Actions stack full-width.
Future<T?> showAppDialog<T>(
  BuildContext context, {
  required String title,
  String? body,
  Widget? content,
  required List<Widget> actions,
  bool dismissible = true,
}) {
  final duration = AppMotion.of(context, AppMotion.dialog);
  // Carry local Theme overrides (e.g. the gallery's dark preview) into the dialog route.
  final themes = InheritedTheme.capture(from: context, to: Navigator.of(context, rootNavigator: true).context);
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: context.colors.scrim,
    transitionDuration: duration,
    pageBuilder: (ctx, _, _) => themes.wrap(AppDialog(title: title, body: body, content: content, actions: actions)),
    transitionBuilder: (ctx, anim, _, child) {
      final a = CurvedAnimation(parent: anim, curve: AppMotion.ease);
      return FadeTransition(
        opacity: a,
        child: ScaleTransition(scale: Tween(begin: .94, end: 1.0).animate(a), child: child),
      );
    },
  );
}

/// Dialog box used by [showAppDialog]; can also be placed directly (gallery, tests).
class AppDialog extends StatelessWidget {
  const AppDialog({super.key, required this.title, this.body, this.content, required this.actions});

  final String title;
  final String? body;

  /// Extra content under the body (e.g. the `surface-2` amount list of "Confirm all").
  final Widget? content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s6),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                padding: const EdgeInsets.fromLTRB(AppSpace.s5, AppSpace.s6, AppSpace.s5, AppSpace.s4),
                decoration: BoxDecoration(
                  color: c.surfaceSheet,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: context.elevation.float,
                ),
                child: SingleChildScrollView(
                  child: Semantics(
                    scopesRoute: true,
                    namesRoute: true,
                    explicitChildNodes: true,
                    label: title,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(title, style: AppType.title.copyWith(color: c.ink)),
                        if (body != null) ...[
                          const SizedBox(height: AppSpace.s2),
                          Text(body!, style: AppType.body.copyWith(color: c.inkMuted)),
                        ],
                        if (content != null) ...[const SizedBox(height: AppSpace.s3), content!],
                        const SizedBox(height: AppSpace.s5),
                        for (var i = 0; i < actions.length; i++) ...[
                          if (i > 0) const SizedBox(height: AppSpace.s1),
                          actions[i],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Toast (design `toast`): `ink` fill, `bg` text 14/500, radius-md, circle-check icon, floats
/// above the tab bar. Thin wrapper over a floating SnackBar.
void showAppToast(BuildContext context, String message, {IconData icon = AppIcons.paid, SnackBarAction? action}) {
  final c = context.colors;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        action: action,
        content: Row(
          children: [
            Icon(icon, size: 18, color: c.bg),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}
