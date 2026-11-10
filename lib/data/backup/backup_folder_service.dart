import 'package:flutter/services.dart';

/// Why a write into the backup folder failed.
enum BackupFolderError {
  /// Write permission was revoked.
  permissionDenied,

  /// The folder was deleted or cannot be reached.
  folderMissing,

  /// Anything else, or no platform channel (tests).
  unavailable,
}

class BackupFolderException implements Exception {
  BackupFolderException(this.error, [this.detail]);

  final BackupFolderError error;
  final String? detail;

  @override
  String toString() => 'BackupFolderException: ${error.name} $detail';
}

/// A folder the user just picked.
class PickedFolder {
  const PickedFolder({required this.uri, this.name, this.inICloud});

  /// Android: the tree URI (Storage Access Framework). iOS: an `ios-bookmark:<uuid>`
  /// code pointing at a bookmark kept by the native side.
  final String uri;

  /// Friendly name for Settings; null when the system does not provide one.
  final String? name;

  /// iOS only: the folder is in iCloud Drive (survives losing the phone). `false`:
  /// "On My iPhone" or another provider (Google Drive, Dropbox…) — iOS cannot tell
  /// those apart. Android: null.
  final bool? inICloud;
}

/// Writes files into the folder the user picked, over the `subnest/backup_folder`
/// channel. Android is `BackupFolderChannel.kt`; iOS is `BackupFolderChannel.swift`
/// (Files picker, bookmark). Errors become [BackupFolderException]; tests replace
/// this class with a fake.
class BackupFolderService {
  const BackupFolderService([this.channel = const MethodChannel(channelName)]);

  static const channelName = 'subnest/backup_folder';

  final MethodChannel channel;

  Future<T?> _invoke<T>(String method, [Map<String, Object?>? args]) async {
    try {
      return await channel.invokeMethod<T>(method, args);
    } on MissingPluginException {
      throw BackupFolderException(BackupFolderError.unavailable, 'no channel');
    } on PlatformException catch (e) {
      throw BackupFolderException(switch (e.code) {
        'permission_denied' => BackupFolderError.permissionDenied,
        'folder_missing' => BackupFolderError.folderMissing,
        _ => BackupFolderError.unavailable,
      }, e.message);
    }
  }

  /// Opens the system folder picker and keeps read+write access. Null when cancelled.
  Future<PickedFolder?> pickFolder() async {
    final map = await _invoke<Map<Object?, Object?>>('pickFolder');
    final uri = map?['uri'];
    if (uri is! String) return null;
    final name = map?['name'];
    final inICloud = map?['inICloud'];
    return PickedFolder(
      uri: uri,
      name: name is String ? name : null,
      inICloud: inICloud is bool ? inICloud : null,
    );
  }

  /// Writes [bytes] to [name] inside the folder (overwrites a file with the same name).
  Future<void> writeFile(String treeUri, String name, Uint8List bytes) =>
      _invoke<void>('writeFile', {'treeUri': treeUri, 'name': name, 'bytes': bytes});

  /// Names of the folder's direct children.
  Future<List<String>> listFiles(String treeUri) async {
    final list = await _invoke<List<Object?>>('listFiles', {'treeUri': treeUri});
    return [for (final n in list ?? const []) n as String];
  }

  Future<void> deleteFile(String treeUri, String name) =>
      _invoke<void>('deleteFile', {'treeUri': treeUri, 'name': name});

  /// Releases the permission held for the folder (deletes nothing inside it).
  Future<void> releaseFolder(String treeUri) => _invoke<void>('releaseFolder', {'treeUri': treeUri});
}
