/// Every location in the app (product.md §4). Navigate with these helpers only, e.g.
/// `context.push(AppRoutes.subscriptionDetail(id))`, so paths change in one place.
abstract final class AppRoutes {
  // S1
  static const onboarding = '/onboarding';

  // Tabs (S2, S8, S9, S10)
  static const home = '/home';
  static const calendar = '/calendar';
  static const insights = '/insights';
  static const settings = '/settings';

  // S10 sub-pages
  static const settingsCurrency = '/settings/currency';
  static const settingsRates = '/settings/rates';
  static const settingsBackup = '/settings/backup';

  // S3 — "+" step 1
  static const catalog = '/catalog';

  // S7
  static const awaiting = '/awaiting';

  /// Debug-only component gallery (registered only when `kDebugMode`).
  /// Query: `page` (0–5), `dark=1`, `vi=1`, `large=1` (130% text), `narrow=1` (360 frame).
  static const devGallery = '/dev/gallery';

  /// S4 add. [serviceId]/[planId] pre-fill from the Catalog; none = custom service ([name] pre-filled).
  static String subscriptionNew({String? serviceId, String? planId, String? name}) {
    final q = <String, String>{'service': ?serviceId, 'plan': ?planId, 'name': ?name};
    return Uri(path: '/subscription/new', queryParameters: q.isEmpty ? null : q).toString();
  }

  /// S5
  static String subscriptionDetail(String id) => '/subscription/$id';

  /// S4 edit
  static String subscriptionEdit(String id) => '/subscription/$id/edit';

  /// S6 — confirm the current pending period (also the "due today" notification deep link).
  static String confirm(String id) => '/confirm/$id';
}
