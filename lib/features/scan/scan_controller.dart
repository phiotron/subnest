import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../data/subscription_repository.dart';
import '../../domain/domain.dart';
import '../home/home_list.dart' show homeAutoUndoProvider;
import 'scan_parser.dart';
import 'scan_service.dart';

/// Where the scan flow is (mockups v14 114–121).
enum ScanStage {
  /// 114 — how it works.
  intro,

  /// 115 — before the system photo picker.
  picker,

  /// 116 — reading on the device.
  reading,

  /// 118 / 119 / 120 — what was added, confirmed, left to the user.
  results,

  /// 121 — nothing found.
  nothing,
}

/// A charge the app did not act on, with why (the "Not added" group).
enum NotAddedReason { seenOnce, notBilling, dismissed, alreadyTracked }

class NotAddedRow {
  const NotAddedRow(this.charge, this.reason, {this.subscription});
  final DetectedCharge charge;
  final NotAddedReason reason;
  final Subscription? subscription;
}

/// A charge that probably belongs to [subscription] but not surely ("Needs your check").
class ReviewRow {
  const ReviewRow(this.charge, this.subscription);
  final DetectedCharge charge;
  final Subscription subscription;
}

/// An auto-confirmed (or user-confirmed) period with the subscription it belongs to.
class ConfirmedRow {
  const ConfirmedRow(this.period, this.subscription);
  final ConfirmedPeriod period;
  final Subscription? subscription;

  /// Charged amount differs from the usual one (My share of the same currency) → "Different amount".
  bool get differentAmount {
    final s = subscription;
    if (s == null || period.currency.toUpperCase() != s.currency.toUpperCase()) {
      return false;
    }
    return period.amountMinor != s.myShareMinor;
  }
}

@immutable
class ScanState {
  const ScanState({
    this.stage = ScanStage.intro,
    this.screens = 0,
    this.receipts = 0,
    this.toRead = 0,
    this.read = 0,
    this.preview = const [],
    this.added = const [],
    this.confirmed = const [],
    this.review = const [],
    this.notAdded = const [],
    this.undone = const {},
    this.busy = false,
    this.failed = 0,
  });

  final ScanStage stage;

  /// Screenshots / receipt photos read in this session.
  final int screens;
  final int receipts;

  /// Pictures in the current batch, and how many are read.
  final int toRead;
  final int read;

  /// Charges read so far in the batch (the reading screen's list).
  final List<DetectedCharge> preview;

  final List<Subscription> added;
  final List<ConfirmedRow> confirmed;
  final List<ReviewRow> review;
  final List<NotAddedRow> notAdded;

  /// Ids of added subscriptions / confirmed periods the user undid.
  final Set<String> undone;

  /// A repository call is running (buttons wait).
  final bool busy;

  /// Pictures of the batch that could not be read.
  final int failed;

  int get pictures => screens + receipts;
  double get progress => toRead == 0 ? 0 : read / toRead;

  List<Subscription> get keptAdded => [
    for (final s in added)
      if (!undone.contains(s.id)) s,
  ];
  List<ConfirmedRow> get keptConfirmed => [
    for (final c in confirmed)
      if (!undone.contains(c.period.id)) c,
  ];

  ScanState copyWith({
    ScanStage? stage,
    int? screens,
    int? receipts,
    int? toRead,
    int? read,
    List<DetectedCharge>? preview,
    List<Subscription>? added,
    List<ConfirmedRow>? confirmed,
    List<ReviewRow>? review,
    List<NotAddedRow>? notAdded,
    Set<String>? undone,
    bool? busy,
    int? failed,
  }) => ScanState(
    stage: stage ?? this.stage,
    screens: screens ?? this.screens,
    receipts: receipts ?? this.receipts,
    toRead: toRead ?? this.toRead,
    read: read ?? this.read,
    preview: preview ?? this.preview,
    added: added ?? this.added,
    confirmed: confirmed ?? this.confirmed,
    review: review ?? this.review,
    notAdded: notAdded ?? this.notAdded,
    undone: undone ?? this.undone,
    busy: busy ?? this.busy,
    failed: failed ?? this.failed,
  );
}

/// The scan flow: pick → read on the device ([ScanTextReader] + [ScanParser]) →
/// `SubscriptionRepository.applyDetections` (ADR 0003) → grouped results with Undo per row.
/// "Done" hands what is kept to the Overview's Undo bar ([homeAutoUndoProvider]).
class ScanController extends Notifier<ScanState> {
  var _pickerSeen = false;

  @override
  ScanState build() => const ScanState();

  SubscriptionRepository get _repo => ref.read(subscriptionRepositoryProvider);

  /// "Choose screenshots": the privacy explainer first (once per visit), then the system picker.
  Future<void> chooseScreenshots() async {
    if (!_pickerSeen) {
      _pickerSeen = true;
      state = state.copyWith(stage: ScanStage.picker);
      return;
    }
    await pickScreenshots();
  }

  /// "Not now" on the explainer.
  void backToIntro() => state = state.copyWith(stage: ScanStage.intro);

  Future<void> pickScreenshots() async {
    final paths = await ref.read(scanImageSourceProvider).pickScreenshots();
    if (paths.isEmpty) {
      if (state.stage == ScanStage.picker) state = state.copyWith(stage: ScanStage.intro);
      return;
    }
    await read(paths, receipt: false);
  }

  Future<void> photographReceipt() async {
    final path = await ref.read(scanImageSourceProvider).takeReceiptPhoto();
    if (path == null) return;
    await read([path], receipt: true);
  }

  /// Reads [paths] on the device, then applies what was found.
  Future<void> read(List<String> paths, {required bool receipt}) async {
    final settings = ref.read(settingsProvider).value;
    final parser = ScanParser(today: ref.read(todayProvider), dayFirst: settings?.localeCode == 'vi');
    final reader = ref.read(scanTextReaderProvider);
    state = state.copyWith(
      stage: ScanStage.reading,
      toRead: paths.length,
      read: 0,
      preview: const [],
      failed: 0,
      screens: receipt ? null : state.screens + paths.length,
      receipts: receipt ? state.receipts + paths.length : null,
    );
    final charges = <DetectedCharge>[];
    var failed = 0;
    for (final p in paths) {
      try {
        charges.addAll(parser.parse(await reader.read(p)));
      } catch (e) {
        debugPrint('scan read: $e');
        failed++;
      }
      if (!ref.mounted) return;
      state = state.copyWith(read: state.read + 1, preview: List.unmodifiable(charges), failed: failed);
    }
    if (charges.isEmpty) {
      state = state.copyWith(stage: ScanStage.nothing);
      return;
    }
    await _apply(charges);
  }

  Future<void> _apply(List<DetectedCharge> charges) async {
    final catalog = await ref.read(catalogProvider.future).catchError((Object _) => const <CatalogService>[]);
    final report = await _repo.applyDetections(charges, catalog: catalog, region: ref.read(catalogRegionProvider));
    final kept = report.keptUnmatched == 0 ? const <DetectedCharge>[] : await _repo.unmatchedCharges();
    final subs = await _repo.all();
    if (!ref.mounted) return;
    Subscription? subOf(String id) => subs.where((s) => s.id == id).firstOrNull;

    final review = <ReviewRow>[];
    final notAdded = <NotAddedRow>[];
    for (final skip in report.skipped) {
      final candidate = skip.candidate;
      switch (skip.reason) {
        case DetectionSkipReason.unsure when candidate != null:
          review.add(ReviewRow(skip.charge, subOf(candidate.id) ?? candidate));
        case DetectionSkipReason.notBilling:
          notAdded.add(NotAddedRow(skip.charge, NotAddedReason.notBilling, subscription: candidate));
        case DetectionSkipReason.dismissed:
          notAdded.add(NotAddedRow(skip.charge, NotAddedReason.dismissed));
        case DetectionSkipReason.alreadyTracked:
          notAdded.add(NotAddedRow(skip.charge, NotAddedReason.alreadyTracked, subscription: candidate));
        case DetectionSkipReason.unsure:
          notAdded.add(NotAddedRow(skip.charge, NotAddedReason.seenOnce));
      }
    }
    // Unknown payees stored until a repeat: the ones read in this batch.
    for (final c in charges) {
      final stored = kept.any(
        (k) => k.name == c.name && k.amountMinor == c.amountMinor && k.date == c.date && k.currency == c.currency,
      );
      if (stored) notAdded.add(NotAddedRow(c, NotAddedReason.seenOnce));
    }
    final added = [for (final s in report.added) subOf(s.id) ?? s];
    final confirmed = [for (final p in report.confirmed) ConfirmedRow(p, subOf(p.subscriptionId))];
    final anything = added.isNotEmpty || confirmed.isNotEmpty || review.isNotEmpty || notAdded.isNotEmpty;
    state = state.copyWith(
      stage: anything ? ScanStage.results : ScanStage.nothing,
      added: [...state.added, ...added],
      confirmed: [...state.confirmed, ...confirmed],
      review: [...state.review, ...review],
      notAdded: [...state.notAdded, ...notAdded],
    );
  }

  Future<void> _guard(Future<void> Function() body) async {
    if (state.busy) return;
    state = state.copyWith(busy: true);
    try {
      await body();
    } finally {
      if (ref.mounted) state = state.copyWith(busy: false);
    }
  }

  /// Undo of one added subscription: deleted and never auto-added again (ADR 0003).
  Future<void> undoAdded(Subscription s) => _guard(() async {
    await _repo.undoAutoAdd(s.id);
    if (ref.mounted) state = state.copyWith(undone: {...state.undone, s.id});
  });

  /// Undo of one confirmed period: the period is pending again.
  Future<void> undoConfirmed(ConfirmedRow row) => _guard(() async {
    await _repo.undoAutoConfirm(row.period.id);
    if (ref.mounted) state = state.copyWith(undone: {...state.undone, row.period.id});
  });

  /// "It's this period": confirms the candidate's pending period with the charged amount (same
  /// currency) — the row moves to Confirmed / Different amount, with Undo.
  Future<void> confirmReview(ReviewRow row) => _guard(() async {
    final sameCurrency = row.charge.currency.toUpperCase() == row.subscription.currency.toUpperCase();
    final period = await _repo.confirm(
      row.subscription.id,
      PeriodOutcome.payment,
      amountMinor: sameCurrency ? row.charge.amountMinor : null,
    );
    if (!ref.mounted) return;
    state = state.copyWith(
      review: [...state.review]..remove(row),
      confirmed: [...state.confirmed, ConfirmedRow(period, row.subscription)],
    );
  });

  /// "Not this": nothing is recorded.
  void dismissReview(ReviewRow row) => state = state.copyWith(review: [...state.review]..remove(row));

  Future<void> undoAll() => _guard(() async {
    final undone = {...state.undone};
    for (final s in state.keptAdded) {
      await _repo.undoAutoAdd(s.id);
      undone.add(s.id);
    }
    for (final c in state.keptConfirmed) {
      await _repo.undoAutoConfirm(c.period.id);
      undone.add(c.period.id);
    }
    if (ref.mounted) state = state.copyWith(undone: undone);
  });

  /// "Done": the Overview flashes the new rows and offers Undo once more for what is kept.
  void finish() {
    final report = DetectionReport(added: state.keptAdded, confirmed: [for (final c in state.keptConfirmed) c.period]);
    ref.read(homeAutoUndoProvider.notifier).show(report);
  }
}

final scanControllerProvider = NotifierProvider.autoDispose<ScanController, ScanState>(ScanController.new);

/// Catalog match of a read name (logo + colour of the reading-screen rows).
final scanCatalogMatchProvider = Provider.autoDispose<CatalogService? Function(String name)>((ref) {
  final catalog = ref.watch(catalogProvider).value ?? const <CatalogService>[];
  final matcher = ChargeMatcher(catalog: catalog, region: ref.watch(catalogRegionProvider));
  return matcher.matchService;
});
