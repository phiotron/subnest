/// App facts shown in Settings › About. One place to change them.
library;

/// Version shown in Settings (`version:` in pubspec.yaml is `1.0.0`).
/// `package_info_plus` is not a dependency yet, so this is kept in sync by
/// `test/features/settings/settings_content_test.dart`, which fails when pubspec changes.
const String kAppVersion = '1.0.0';

/// Build number after `+` in pubspec; empty until the first store upload needs one
/// (Android then uses versionCode 1).
const String kAppBuild = '';

/// Public privacy policy (GitHub Pages repo phamphuongphuongnd/legal, source: store/legal/).
/// The EN page links to the VI page. Set to `null` to open the bundled copy (`legal_content.dart`).
// Nullable on purpose: `null` switches back to the bundled copy.
// ignore: unnecessary_nullable_for_final_variable_declarations
const String? kPrivacyPolicyUrl = 'https://phamphuongphuongnd.github.io/legal/subnest/privacy-policy.en.html';

/// Public terms of use (same site). `null` opens the bundled copy.
// ignore: unnecessary_nullable_for_final_variable_declarations
const String? kTermsUrl = 'https://phamphuongphuongnd.github.io/legal/subnest/terms.en.html';

/// Support address (store listing + legal texts).
const String kSupportEmail = 'phamphuongphuongnd@gmail.com';

/// Android application id (Play listing).
const String kAndroidPackage = 'com.phiotron.subnest';

/// TODO(A001-subnest): numeric App Store id once the iOS app exists. While `null` the
/// "Rate Subnest" row is hidden on iOS (no dead button).
const String? kAppStoreId = null;

/// "1.0.0" (or "1.0.0 (3)" once a build number is set).
String get appVersionLabel => kAppBuild.isEmpty ? kAppVersion : '$kAppVersion ($kAppBuild)';
