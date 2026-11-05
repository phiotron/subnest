import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../data/rates/exchange_rate_repository.dart';

/// What the Exchange rates screen knows about the network: a fetch is running, and whether the
/// last attempt failed (no connection or the service is down — shown as "You're offline").
class RatesStatus {
  const RatesStatus({this.updating = false, this.offline = false});

  final bool updating;
  final bool offline;
}

/// Runs rate refreshes for the Settings screens and remembers if the last one failed.
class RatesStatusNotifier extends Notifier<RatesStatus> {
  @override
  RatesStatus build() => const RatesStatus();

  /// [force] = "Update now"; otherwise only fetches when the cache is older than a day.
  Future<RatesRefreshResult> refresh({bool force = false}) async {
    if (state.updating) return RatesRefreshResult.notNeeded;
    state = RatesStatus(updating: true, offline: state.offline);
    final r = await ref.read(exchangeRateRepositoryProvider).refreshIfStale(force: force);
    if (!ref.mounted) return r;
    state = RatesStatus(
      offline: switch (r) {
        RatesRefreshResult.failed => true,
        RatesRefreshResult.updated => false,
        RatesRefreshResult.notNeeded => state.offline,
      },
    );
    return r;
  }
}

final ratesStatusProvider = NotifierProvider<RatesStatusNotifier, RatesStatus>(RatesStatusNotifier.new);
