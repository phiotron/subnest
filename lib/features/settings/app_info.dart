/// App facts shown in Settings › About. One place to change them.
library;

/// Version shown in Settings (`version:` in pubspec.yaml is `1.0.0+1`).
/// `package_info_plus` is not a dependency yet, so this is kept in sync by
/// `test/features/settings/app_info_test.dart`, which fails when pubspec changes.
const String kAppVersion = '1.0.0';
const String kAppBuild = '2';

/// TODO(A001-subnest): set the public privacy-policy URL once it is hosted (store/legal/
/// privacy-policy.*.html). While `null`, "Privacy policy" opens the bundled copy in the app
/// (`legal_content.dart`, same text as store/legal/privacy-policy.*.md).
const String? kPrivacyPolicyUrl = null;

/// TODO(A001-subnest): set the public terms URL once hosted. While `null`, opens the bundled copy.
const String? kTermsUrl = null;

/// Support address (store listing + legal texts).
const String kSupportEmail = 'phamphuongphuongnd@gmail.com';

/// Android application id (Play listing).
const String kAndroidPackage = 'com.phiotron.subnest';

/// TODO(A001-subnest): numeric App Store id once the iOS app exists. While `null` the
/// "Rate Subnest" row is hidden on iOS (no dead button).
const String? kAppStoreId = null;

/// "1.0.0 (2)".
String get appVersionLabel => '$kAppVersion ($kAppBuild)';
