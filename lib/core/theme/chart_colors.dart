import 'package:flutter/painting.dart';

import '../../domain/category.dart';
import 'tokens.g.dart';

/// Chart colour by category (design README § Colour): fixed slots — AI, Storage, Telecom,
/// Software, Video, Music → `chart-1`…`chart-6`; everything else folds into `chart-other`.
/// Colour follows the category, never its rank. Light slots 3–5 are < 3:1 on white, so a chart
/// always shows its full legend with labels and values.
extension AppChartColors on AppColors {
  /// Category order of the six fixed slots.
  static const slots = [
    SubscriptionCategory.ai,
    SubscriptionCategory.storage,
    SubscriptionCategory.telecom,
    SubscriptionCategory.software,
    SubscriptionCategory.video,
    SubscriptionCategory.music,
  ];

  Color chartFor(SubscriptionCategory category) => switch (slots.indexOf(category)) {
    0 => chart1,
    1 => chart2,
    2 => chart3,
    3 => chart4,
    4 => chart5,
    5 => chart6,
    _ => chartOther,
  };

  /// Whether [category] has its own slot (otherwise it is summed into "Other").
  static bool hasSlot(SubscriptionCategory category) => slots.contains(category);
}
