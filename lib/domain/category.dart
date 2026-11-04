/// Category of a Subscription (product.md §5 S3). Stored by [key].
enum SubscriptionCategory {
  video('video'),
  music('music'),
  ai('ai'),
  storage('storage'),
  software('software'),
  gaming('gaming'),
  reading('reading'),
  health('health'),
  education('education'),
  telecom('telecom'),
  other('other');

  const SubscriptionCategory(this.key);

  final String key;

  /// Unknown keys (e.g. from an older catalog or backup) map to [other].
  static SubscriptionCategory fromKey(String? key) =>
      values.firstWhere((c) => c.key == key, orElse: () => SubscriptionCategory.other);
}
