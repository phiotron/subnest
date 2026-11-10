import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/service_tile_logo.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/logos/logo_providers.dart';
import 'package:subnest/features/subscription_form/widgets/custom_logo_picker.dart';
import 'package:subnest/features/subscription_form/widgets/tile_sheet.dart';

import '../../core/design_system_test.dart' show pumpUi;
import '../catalog/add_harness.dart';

/// A valid 8×8 PNG.
final Uint8List png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAEUlEQVR4nGMQVHqHFTEMLQkABCxIQSPERjoAAAAASUVORK5CYII=',
);

/// Custom logo store in memory (no files inside the fake-async widget tests).
class MemoryLogoStore extends CustomLogoStore {
  MemoryLogoStore() : super(() async => Directory.systemTemp);

  final saved = <String, Uint8List>{};

  @override
  bool has(String subscriptionId) => saved.containsKey(subscriptionId);

  @override
  File? fileOf(String subscriptionId) => null;

  @override
  Future<void> save(String subscriptionId, Uint8List bytes) async {
    saved[subscriptionId] = bytes;
    notifyListeners();
  }

  @override
  Future<void> remove(String subscriptionId) async {
    if (saved.remove(subscriptionId) != null) notifyListeners();
  }
}

/// Tile logo source that shows the in-memory store's pictures.
class _Source extends ChangeNotifier implements ServiceLogoSource {
  _Source(this.store) {
    store.addListener(notifyListeners);
  }

  final MemoryLogoStore store;

  @override
  ImageProvider? serviceLogo(String serviceId) => null;

  @override
  ImageProvider? customLogo(String subscriptionId) {
    final b = store.saved[subscriptionId];
    return b == null ? null : MemoryImage(b);
  }
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadFonts();
  });

  addTest('S4 custom service: Choose photo → preview → saved with the subscription', (tester) async {
    final f = await AddFixture.create();
    final store = MemoryLogoStore();
    var picks = 0;
    await pumpAdd(
      tester,
      f,
      location: '/home',
      push: '/subscription/new?name=Gym club',
      extraOverrides: [
        customLogoStoreProvider.overrideWithValue(store),
        customLogoPickerProvider.overrideWithValue((_) async {
          picks++;
          return png;
        }),
      ],
    );
    await tester.tap(find.bySemanticsLabel('Change tile'));
    await settle(tester);
    expect(find.text('Choose photo'), findsOneWidget);
    expect(find.text('Remove photo'), findsNothing);
    await tester.tap(find.text('Choose photo'));
    await settle(tester);
    expect(picks, 1);
    expect(find.text('Change photo'), findsOneWidget);
    expect(find.text('Remove photo'), findsOneWidget);
    expect(find.byType(ServiceTileLogo), findsNWidgets(2), reason: 'both previews show the photo');
    await tester.tap(find.text('Done'));
    await settle(tester);
    expect(find.byType(ServiceTileLogo), findsOneWidget, reason: 'form header tile shows it');

    await tester.enterText(find.descendant(of: find.byType(AmountField), matching: find.byType(TextField)), '15');
    await settle(tester);
    await tester.tap(find.text('Add subscription'));
    await settle(tester);
    final s = (await f.subs.all()).single;
    expect(store.saved.keys, [s.id]);
    expect(store.saved[s.id], png);
  });

  addTest('S4 edit: deleting the subscription deletes its photo', (tester) async {
    final f = await AddFixture.create();
    await f.addNetflix();
    final store = MemoryLogoStore()..saved['netflix'] = png;
    await pumpAdd(
      tester,
      f,
      location: '/home',
      push: '/subscription/netflix/edit',
      extraOverrides: [customLogoStoreProvider.overrideWithValue(store)],
    );
    final list = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(find.text('Delete subscription'), 300, scrollable: list);
    await settle(tester);
    await tester.tap(find.text('Delete subscription'));
    await settle(tester);
    await tester.tap(find.text('Delete'));
    await settle(tester);
    expect(await f.subs.all(), isEmpty);
    expect(store.saved, isEmpty);
  });

  testWidgets('tile sheet with a saved photo: Remove photo → choice says remove', (tester) async {
    final store = MemoryLogoStore()..saved['s1'] = png;
    TileChoiceProbe.result = null;
    await pumpUi(
      tester,
      ServiceLogoScope(
        source: _Source(store),
        child: Builder(
          builder: (context) => TileChoiceProbe(photo: ServiceLogoScope.of(context).customLogo('s1')),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(ServiceTileLogo), findsNWidgets(2));
    await tester.tap(find.text('Remove photo'));
    await tester.pumpAndSettle();
    expect(find.byType(ServiceTileLogo), findsNothing);
    expect(find.text('Choose photo'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(TileChoiceProbe.result!.removePhoto, isTrue);
    expect(TileChoiceProbe.result!.photo, isNull);
  });

  testWidgets('crop screen renders the square to a 256 px PNG', (tester) async {
    Uint8List? out;
    await pumpUi(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () async => out = await pickCustomLogo(context, pickBytes: () async => png),
          child: const Text('pick'),
        ),
      ),
    );
    await tester.tap(find.text('pick'));
    await tester.pumpAndSettle();
    expect(find.text('Move and zoom'), findsOneWidget);
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50))); // decode
    await tester.pump();
    await tester.tap(find.text('Use photo'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 300))); // toImage + PNG
    await tester.pumpAndSettle();
    expect(out, isNotNull);
    final image = await tester.runAsync(() async {
      final codec = await ui.instantiateImageCodec(out!);
      return (await codec.getNextFrame()).image;
    });
    expect(image!.width, customLogoSide);
    expect(image.height, customLogoSide);
  });
}

/// Opens the tile sheet with a saved photo and keeps what it returns.
class TileChoiceProbe extends StatelessWidget {
  const TileChoiceProbe({super.key, required this.photo});

  final ImageProvider? photo;
  static TileChoice? result;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () async => result = await showTileSheet(
      context,
      name: 'Gym',
      colorValue: 0xFF0F8B8D,
      iconText: null,
      previewMeta: '15/mo',
      canUsePhoto: true,
      photo: photo,
    ),
    child: const Text('open'),
  );
}
