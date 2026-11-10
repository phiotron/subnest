import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../core/router/routes.dart';

/// Taps on the home-screen widgets (product.md §10.7, APP.md decision 2026-11-10 item 9).
///
/// The widgets open the app with a `subnest://widget/…?homeWidget` link (the `homeWidget` query
/// is what the `home_widget` plugin recognises on iOS); Android sends it in a
/// `HomeWidgetLaunchIntent`, iOS through `widgetURL` / `Link`. Native code never opens a screen:
/// the link reaches Dart, [widgetRouteFor] turns it into an [AppRoutes] location, and the app
/// navigates with go_router — so a lock screen added later sits in front of it like any route.
abstract final class WidgetLinks {
  static const scheme = 'subnest';
  static const host = 'widget';

  /// Link of the parts that open the Overview (title, total, empty state, locked widget).
  static const overview = 'subnest://widget/overview?homeWidget';

  /// Link of one subscription row.
  static String subscription(String id) => 'subnest://widget/subscription/${Uri.encodeComponent(id)}?homeWidget';
}

/// Where the app goes for a widget link; `null` for anything that is not one of ours.
/// Subscription ids are UUIDs: anything else is refused rather than pushed into the router.
String? widgetRouteFor(Uri? uri) {
  if (uri == null || uri.scheme != WidgetLinks.scheme || uri.host != WidgetLinks.host) return null;
  final parts = uri.pathSegments;
  if (parts.length == 1 && parts[0] == 'overview') return AppRoutes.home;
  if (parts.length == 2 && parts[0] == 'subscription' && _id.hasMatch(parts[1])) {
    return AppRoutes.subscriptionDetail(parts[1]);
  }
  return null;
}

final _id = RegExp(r'^[A-Za-z0-9_-]{1,64}$');

/// Source of widget taps: the link that launched the app (cold start) and later taps.
abstract class WidgetLinkSource {
  /// Link that started the app, if it was a widget tap. Read once.
  Future<Uri?> initialLink();

  /// Taps while the app runs (Android `onNewIntent`, iOS `openURL`).
  Stream<Uri?> get taps;
}

class HomeWidgetLinkSource implements WidgetLinkSource {
  const HomeWidgetLinkSource();

  @override
  Future<Uri?> initialLink() async {
    try {
      return await HomeWidget.initiallyLaunchedFromHomeWidget();
    } on MissingPluginException {
      return null;
    } on PlatformException catch (e) {
      debugPrint('widget link: $e');
      return null;
    }
  }

  @override
  Stream<Uri?> get taps => HomeWidget.widgetClicked.handleError((Object e) => debugPrint('widget link: $e'));
}

final widgetLinkSourceProvider = Provider<WidgetLinkSource>((ref) => const HomeWidgetLinkSource());
