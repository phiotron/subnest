import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

/// Where the pictures come from: the system photo picker (only the photos the user picks are
/// readable — no storage permission) or the system camera for a receipt.
abstract class ScanImageSource {
  /// Paths of the screenshots picked; empty when the user backed out.
  Future<List<String>> pickScreenshots();

  /// Path of the receipt photo taken; `null` when the user backed out.
  Future<String?> takeReceiptPhoto();
}

class SystemScanImageSource implements ScanImageSource {
  const SystemScanImageSource();

  void _usePhotoPicker() {
    final platform = ImagePickerPlatform.instance;
    if (platform is ImagePickerAndroid) platform.useAndroidPhotoPicker = true;
  }

  @override
  Future<List<String>> pickScreenshots() async {
    _usePhotoPicker();
    try {
      final files = await ImagePicker().pickMultiImage(limit: 20);
      return [for (final f in files) f.path];
    } on PlatformException catch (e) {
      debugPrint('scan pick: ${e.code}');
      return const [];
    }
  }

  @override
  Future<String?> takeReceiptPhoto() async {
    try {
      final f = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 2400, maxHeight: 2400);
      return f?.path;
    } on PlatformException catch (e) {
      debugPrint('scan camera: ${e.code}');
      return null;
    }
  }
}

final scanImageSourceProvider = Provider<ScanImageSource>((ref) => const SystemScanImageSource());

/// Reads the text of one picture on the device, as rows in reading order (see [ScanRows.group]).
abstract class ScanTextReader {
  Future<List<String>> read(String path);

  /// Frees the recogniser.
  Future<void> close();
}

/// On-device ML Kit text recognition (Latin script, works offline; nothing leaves the phone).
class MlKitScanTextReader implements ScanTextReader {
  MlKitScanTextReader();

  TextRecognizer? _recognizer;

  @override
  Future<List<String>> read(String path) async {
    final r = _recognizer ??= TextRecognizer(script: TextRecognitionScript.latin);
    final text = await r.processImage(InputImage.fromFilePath(path));
    return ScanRows.group([
      for (final b in text.blocks)
        for (final l in b.lines) (text: l.text, box: l.boundingBox),
    ]);
  }

  @override
  Future<void> close() async {
    await _recognizer?.close();
    _recognizer = null;
  }
}

final scanTextReaderProvider = Provider<ScanTextReader>((ref) {
  final reader = MlKitScanTextReader();
  ref.onDispose(reader.close);
  return reader;
});

/// Puts recognised lines back into rows: lines whose vertical centres are within half a line
/// height sit on one row (a name on the left, its price on the right), left → right, joined by two
/// spaces; rows top → bottom.
abstract final class ScanRows {
  static List<String> group(List<({String text, Rect box})> lines) {
    final sorted = [...lines.where((l) => l.text.trim().isNotEmpty)]
      ..sort((a, b) => a.box.center.dy.compareTo(b.box.center.dy));
    final rows = <List<({String text, Rect box})>>[];
    for (final l in sorted) {
      final last = rows.isEmpty ? null : rows.last;
      if (last != null) {
        final ref = last.first.box;
        final tolerance = (ref.height < l.box.height ? ref.height : l.box.height) / 2;
        if ((l.box.center.dy - ref.center.dy).abs() <= tolerance) {
          last.add(l);
          continue;
        }
      }
      rows.add([l]);
    }
    return [
      for (final r in rows) (r..sort((a, b) => a.box.left.compareTo(b.box.left))).map((l) => l.text.trim()).join('  '),
    ];
  }
}
