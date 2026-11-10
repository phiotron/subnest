import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'custom_logo_store.dart';

export 'custom_logo_store.dart';

/// The Custom logo files (overridden in tests with a store on a temp folder).
final customLogoStoreProvider = Provider<CustomLogoStore>((ref) => CustomLogoStore.instance);
