import Flutter
import UIKit
import UniformTypeIdentifiers
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // flutter_local_notifications: deliver taps / foreground presentation to the plugin.
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    SubnestNative.register(registry: engineBridge.pluginRegistry)
  }
}

/// iOS side of the features Dart reaches over method channels.
enum SubnestNative {
  /// Strong reference: the registrar does not guarantee it keeps the handler alive.
  private static var folder: BackupFolderChannel?
  private static var secure: SecureSceneHandler?

  static func register(registry: FlutterPluginRegistry) {
    guard let registrar = registry.registrar(forPlugin: "SubnestNative") else { return }
    folder = BackupFolderChannel(messenger: registrar.messenger())
    // Privacy screen: scene life-cycle events reach the handler through `FlutterSceneDelegate`.
    let handler = SecureSceneHandler(messenger: registrar.messenger())
    registrar.addSceneDelegate(handler)
    secure = handler
  }
}

// MARK: - Privacy screen

/// Channel `subnest/secure` (same protocol as `MainActivity.kt`): `setSecure(Bool)`. When on, a
/// cover view hides the app while it is not active — the app switcher takes its snapshot then.
/// iOS does not let apps block screenshots. Same as A002 `VigonSceneHandler` (F-22).
final class SecureSceneHandler: NSObject, FlutterSceneLifeCycleDelegate {
  private let channel: FlutterMethodChannel
  private var enabled = false
  private var cover: UIView?

  init(messenger: FlutterBinaryMessenger) {
    channel = FlutterMethodChannel(name: "subnest/secure", binaryMessenger: messenger)
    super.init()
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "setSecure" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let on = call.arguments as? Bool else {
        result(FlutterError(code: "bad_args", message: "setSecure needs true/false", details: nil))
        return
      }
      self?.enabled = on
      if !on { self?.hideCover() }
      NSLog("SubnestSecure: enabled=%@", on ? "1" : "0")
      result(nil)
    }
  }

  func sceneWillResignActive(_ scene: UIScene) {
    showCover(in: scene)
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    showCover(in: scene)
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    hideCover()
  }

  private func showCover(in scene: UIScene) {
    guard enabled, cover == nil,
      let window = (scene as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow })
        ?? (scene as? UIWindowScene)?.windows.first
    else { return }
    let view = PrivacyCoverView(frame: window.bounds)
    window.addSubview(view)
    cover = view
  }

  private func hideCover() {
    cover?.removeFromSuperview()
    cover = nil
  }
}

/// The cover: app background (`bg` token, light/dark) with the splash logo in the middle.
final class PrivacyCoverView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    autoresizingMask = [.flexibleWidth, .flexibleHeight]
    backgroundColor = UIColor { traits in
      traits.userInterfaceStyle == .dark
        ? UIColor(red: 0x0D / 255, green: 0x11 / 255, blue: 0x13 / 255, alpha: 1)
        : UIColor(red: 0xF4 / 255, green: 0xF6 / 255, blue: 0xF6 / 255, alpha: 1)
    }
    isAccessibilityElement = false
    let logo = UIImageView(image: UIImage(named: "LaunchImage"))
    logo.contentMode = .scaleAspectFit
    logo.translatesAutoresizingMaskIntoConstraints = false
    addSubview(logo)
    NSLayoutConstraint.activate([
      logo.widthAnchor.constraint(equalToConstant: 96),
      logo.heightAnchor.constraint(equalToConstant: 96),
      logo.centerXAnchor.constraint(equalTo: centerXAnchor),
      logo.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }

  required init?(coder: NSCoder) { nil }
}

// MARK: - Backup folder (auto backup)

/// Channel `subnest/backup_folder` (same protocol as `BackupFolderChannel.kt`). The folder is
/// picked with `UIDocumentPickerViewController` (Files app: iCloud Drive, On My iPhone, other
/// providers). Access is kept with a bookmark stored in the app's UserDefaults; Dart only keeps
/// an `ios-bookmark:<uuid>` code (a stale bookmark is refreshed in place, Dart never needs to
/// know). Errors use the same codes as Android: `permission_denied`, `folder_missing`, `busy`,
/// `bad_args`, `io_error`.
final class BackupFolderChannel: NSObject, UIDocumentPickerDelegate {
  static let prefix = "ios-bookmark:"
  private let channel: FlutterMethodChannel
  private let queue = DispatchQueue(label: "com.phiotron.subnest.backupFolder")
  private var pickResult: FlutterResult?

  private struct Failure: Error {
    let code: String
    let message: String
  }

  init(messenger: FlutterBinaryMessenger) {
    channel = FlutterMethodChannel(name: "subnest/backup_folder", binaryMessenger: messenger)
    super.init()
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "pickFolder" {
      pick(result: result)
      return
    }
    let args = call.arguments as? [String: Any] ?? [:]
    guard let uri = args["treeUri"] as? String else {
      result(FlutterError(code: "bad_args", message: "treeUri required", details: nil))
      return
    }
    let name = args["name"] as? String
    let bytes = (args["bytes"] as? FlutterStandardTypedData)?.data
    queue.async {
      let reply: Any?
      do {
        switch call.method {
        case "writeFile":
          guard let name = name, Self.safeName(name), let bytes = bytes else {
            throw Failure(code: "bad_args", message: "name and bytes required")
          }
          try self.write(uri: uri, name: name, data: bytes)
          reply = nil
        case "listFiles":
          reply = try self.list(uri: uri)
        case "deleteFile":
          guard let name = name, Self.safeName(name) else {
            throw Failure(code: "bad_args", message: "name required")
          }
          try self.delete(uri: uri, name: name)
          reply = nil
        case "releaseFolder":
          UserDefaults.standard.removeObject(forKey: Self.key(uri))
          reply = nil
        default:
          DispatchQueue.main.async { result(FlutterMethodNotImplemented) }
          return
        }
      } catch let f as Failure {
        NSLog("SubnestBackupFolder: %@ failed %@", call.method, f.code)
        DispatchQueue.main.async {
          result(FlutterError(code: f.code, message: f.message, details: nil))
        }
        return
      } catch {
        let f = Self.failure(from: error)
        NSLog("SubnestBackupFolder: %@ failed %@", call.method, f.code)
        DispatchQueue.main.async {
          result(FlutterError(code: f.code, message: f.message, details: nil))
        }
        return
      }
      DispatchQueue.main.async { result(reply) }
    }
  }

  // MARK: Folder picker

  private func pick(result: @escaping FlutterResult) {
    guard pickResult == nil else {
      result(FlutterError(code: "busy", message: "picker already open", details: nil))
      return
    }
    guard let top = Self.topViewController() else {
      result(FlutterError(code: "io_error", message: "no view controller", details: nil))
      return
    }
    let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
    picker.allowsMultipleSelection = false
    picker.delegate = self
    pickResult = result
    top.present(picker, animated: true)
  }

  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let result = pickResult else { return }
    pickResult = nil
    guard let url = urls.first else {
      result(nil)
      return
    }
    let accessing = url.startAccessingSecurityScopedResource()
    defer { if accessing { url.stopAccessingSecurityScopedResource() } }
    do {
      let bookmark = try url.bookmarkData(
        options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
      let uri = Self.prefix + UUID().uuidString
      UserDefaults.standard.set(bookmark, forKey: Self.key(uri))
      let inICloud =
        (try? url.resourceValues(forKeys: [.isUbiquitousItemKey]))?.isUbiquitousItem ?? false
      NSLog("SubnestBackupFolder: picked iCloud=%@", inICloud ? "1" : "0")
      result(["uri": uri, "name": url.lastPathComponent, "inICloud": inICloud])
    } catch {
      result(FlutterError(code: "permission_denied", message: error.localizedDescription, details: nil))
    }
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    pickResult?(nil)
    pickResult = nil
  }

  private static func topViewController() -> UIViewController? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    let window = scenes.flatMap { $0.windows }.first { $0.isKeyWindow }
      ?? scenes.flatMap { $0.windows }.first
    var top = window?.rootViewController
    while let presented = top?.presentedViewController { top = presented }
    return top
  }

  // MARK: Write, list, delete

  static func key(_ uri: String) -> String { "subnest.backupFolder." + uri }

  /// Accepts only a single file name (no `/`, no `..`) so nothing is written outside the folder.
  static func safeName(_ name: String) -> Bool {
    !name.isEmpty && !name.contains("/") && name != "." && name != ".."
  }

  /// Opens the folder from its bookmark, takes access, checks it still exists, runs [body].
  private func withFolder<T>(_ uri: String, _ body: (URL) throws -> T) throws -> T {
    guard uri.hasPrefix(Self.prefix), let data = UserDefaults.standard.data(forKey: Self.key(uri))
    else { throw Failure(code: "folder_missing", message: "unknown folder") }
    var stale = false
    let url: URL
    do {
      url = try URL(
        resolvingBookmarkData: data, options: [], relativeTo: nil, bookmarkDataIsStale: &stale)
    } catch {
      throw Failure(code: "folder_missing", message: error.localizedDescription)
    }
    guard url.startAccessingSecurityScopedResource() else {
      throw Failure(code: "permission_denied", message: "security scope refused")
    }
    defer { url.stopAccessingSecurityScopedResource() }
    if stale,
      let fresh = try? url.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
    {
      UserDefaults.standard.set(fresh, forKey: Self.key(uri))
    }
    var isDir: ObjCBool = false
    guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir), isDir.boolValue
    else { throw Failure(code: "folder_missing", message: "folder not found") }
    return try body(url)
  }

  private func coordinate(
    _ url: URL, writing: Bool, options: NSFileCoordinator.WritingOptions = [],
    _ body: @escaping (URL) throws -> Void
  ) throws {
    var coordError: NSError?
    var bodyError: Error?
    let coordinator = NSFileCoordinator(filePresenter: nil)
    if writing {
      coordinator.coordinate(writingItemAt: url, options: options, error: &coordError) { u in
        do { try body(u) } catch { bodyError = error }
      }
    } else {
      coordinator.coordinate(readingItemAt: url, options: [], error: &coordError) { u in
        do { try body(u) } catch { bodyError = error }
      }
    }
    if let e = coordError { throw e }
    if let e = bodyError { throw e }
  }

  private func write(uri: String, name: String, data: Data) throws {
    try withFolder(uri) { folder in
      try coordinate(folder.appendingPathComponent(name), writing: true, options: .forReplacing) {
        try data.write(to: $0, options: .atomic)
      }
    }
  }

  /// Names of items in the folder. A not-yet-downloaded iCloud file is `.<name>.icloud`: report
  /// the real name so keeping 2 files still counts and prunes them.
  private func list(uri: String) throws -> [String] {
    try withFolder(uri) { folder in
      var names: [String] = []
      try coordinate(folder, writing: false) { u in
        names = try FileManager.default.contentsOfDirectory(atPath: u.path).map(Self.logicalName)
      }
      return names
    }
  }

  static func logicalName(_ name: String) -> String {
    if name.hasPrefix("."), name.hasSuffix(".icloud"), name.count > ".icloud".count + 1 {
      return String(name.dropFirst().dropLast(".icloud".count))
    }
    return name
  }

  private func delete(uri: String, name: String) throws {
    try withFolder(uri) { folder in
      var target = folder.appendingPathComponent(name)
      let placeholder = folder.appendingPathComponent("." + name + ".icloud")
      if !FileManager.default.fileExists(atPath: target.path),
        FileManager.default.fileExists(atPath: placeholder.path)
      {
        target = placeholder
      }
      guard FileManager.default.fileExists(atPath: target.path) else { return }
      try coordinate(target, writing: true, options: .forDeleting) {
        try FileManager.default.removeItem(at: $0)
      }
    }
  }

  private static func failure(from error: Error) -> Failure {
    let ns = error as NSError
    if ns.domain == NSCocoaErrorDomain {
      switch ns.code {
      case NSFileWriteNoPermissionError, NSFileReadNoPermissionError:
        return Failure(code: "permission_denied", message: ns.localizedDescription)
      case NSFileNoSuchFileError, NSFileReadNoSuchFileError:
        return Failure(code: "folder_missing", message: ns.localizedDescription)
      default:
        break
      }
    }
    if ns.domain == NSPOSIXErrorDomain, ns.code == Int(EACCES) || ns.code == Int(EPERM) {
      return Failure(code: "permission_denied", message: ns.localizedDescription)
    }
    return Failure(code: "io_error", message: ns.localizedDescription)
  }
}
