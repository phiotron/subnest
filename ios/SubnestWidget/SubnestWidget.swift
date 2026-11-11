import SwiftUI
import UIKit
import WidgetKit

// Subnest home-screen widget (product.md §4.12, mockups v14 122–125), one kind in three sizes:
// - small: the next subscription (logo, "2 days", name, price + cycle chip, "12 Nov · 2 days left");
//   waiting for confirmation → warning card + "Tap to confirm";
// - medium: month, "≈ $144.89/mo" (the Overview's Month spend), the next 3 subscriptions;
// - large: month, total, "1 to confirm", Paid / Still to pay + bar, the next 6 subscriptions.
//
// Data: one JSON string the app writes into the App Group (`lib/features/widget_sync/widget_snapshot.dart`,
// key `subnest.widget`, format v2), already formatted in the app's language. No network, no database. The
// widget only works out "2 days" / "To confirm" from each Due date, so the text stays right after midnight
// while the app is closed (one timeline entry per day).
// App lock on: the snapshot holds only "Locked with PIN"; nothing else exists to be drawn.
// Taps open `subnest://widget/…?homeWidget`; Dart maps the link to a go_router location
// (`widget_link.dart`) — the widget never opens a screen by itself.
// Logos: the bundled PNG is read from the containing app's Flutter assets when the extension can read
// them; Custom logo files need the App Group (not yet) — otherwise the monogram.

enum SubnestWidgetStore {
  static let appGroup = "group.com.phiotron.subnest"
  static let key = "subnest.widget"
  static let overviewURL = URL(string: "subnest://widget/overview?homeWidget")!
  static let addURL = URL(string: "subnest://widget/add?homeWidget")!

  static func subscriptionURL(_ id: String) -> URL {
    let safe = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    return URL(string: "subnest://widget/subscription/\(safe)?homeWidget") ?? overviewURL
  }

  /// A bundled logo (`assets/logos/png/<id>.png`) from the app this extension ships in:
  /// Runner.app/PlugIns/SubnestWidgetExtension.appex → Runner.app/Frameworks/App.framework/flutter_assets.
  static func bundledLogo(_ asset: String) -> UIImage? {
    guard !asset.isEmpty, !asset.contains("..") else { return nil }
    let app = Bundle.main.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
    let url = app.appendingPathComponent("Frameworks/App.framework/flutter_assets").appendingPathComponent(asset)
    return UIImage(contentsOfFile: url.path)
  }
}

// MARK: - Snapshot

struct WidgetItem: Hashable {
  let id: String
  let name: String
  let mono: String
  let color: Color
  let onColor: Color
  let price: String
  let cycle: String
  let date: String
  let dateShort: String
  let due: Date?
  let trial: Bool
  let trialEnds: String
  let logo: String
}

struct WidgetSnapshot {
  enum State { case list, empty, locked, missing }

  var state: State = .missing
  var strings: [String: String] = [:]
  var paidShare: Double?
  var items: [WidgetItem] = []

  func text(_ key: String) -> String { strings[key] ?? "" }

  /// Days from [day] to the item's Due date (≤ 0 = awaiting, as in the app); nil when unreadable.
  func days(_ item: WidgetItem, on day: Date) -> Int? {
    guard let due = item.due else { return nil }
    let cal = Calendar.current
    return cal.dateComponents([.day], from: cal.startOfDay(for: day), to: cal.startOfDay(for: due)).day
  }

  /// Small widget, top right — same rule as `WidgetSnapshot.dueText` in Dart.
  func shortWhen(_ days: Int) -> String {
    if days <= 0 { return text("awaiting") }
    if days == 1 { return text("tomorrow") }
    return text("inDays").replacingOccurrences(of: "{n}", with: String(days))
  }

  /// Small widget, last line — same rule as `WidgetSnapshot.smallMeta` in Dart.
  func smallMeta(_ item: WidgetItem, days: Int?) -> String {
    guard let days = days else { return item.date }
    if days <= 0 { return text("tapToConfirm") }
    if !item.trialEnds.isEmpty { return item.trialEnds }
    let left =
      days == 1 ? text("leftTomorrow") : text("leftDays").replacingOccurrences(of: "{n}", with: String(days))
    return "\(item.dateShort) · \(left)"
  }

  static func read() -> WidgetSnapshot {
    guard let json = UserDefaults(suiteName: SubnestWidgetStore.appGroup)?.string(forKey: SubnestWidgetStore.key),
      let data = json.data(using: .utf8),
      let root = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    else { return WidgetSnapshot() }
    var snap = WidgetSnapshot()
    for (k, v) in root { if let s = v as? String { snap.strings[k] = s } }
    switch root["state"] as? String {
    case "list": snap.state = .list
    case "empty": snap.state = .empty
    case "locked":
      // Locked: keep nothing but the texts the app wrote.
      return WidgetSnapshot(
        state: .locked,
        strings: ["locked": snap.text("locked"), "lockedLong": snap.text("lockedLong"), "open": snap.text("open")])
    default: return WidgetSnapshot()
    }
    snap.paidShare = (root["paidShare"] as? NSNumber)?.doubleValue
    let parser = DateFormatter()
    parser.calendar = Calendar(identifier: .gregorian)
    parser.locale = Locale(identifier: "en_US_POSIX")
    parser.timeZone = .current
    parser.dateFormat = "yyyy-MM-dd"
    for raw in root["items"] as? [[String: Any]] ?? [] {
      snap.items.append(
        WidgetItem(
          id: raw["id"] as? String ?? "",
          name: raw["name"] as? String ?? "",
          mono: raw["mono"] as? String ?? "",
          color: Color(argb: raw["color"] as? Int ?? 0xFF2D_3438),
          onColor: Color(argb: raw["onColor"] as? Int ?? 0xFFFF_FFFF),
          price: raw["price"] as? String ?? "",
          cycle: raw["cycle"] as? String ?? "",
          date: raw["date"] as? String ?? "",
          dateShort: raw["dateShort"] as? String ?? "",
          due: (raw["due"] as? String).flatMap { parser.date(from: $0) },
          trial: raw["trial"] as? Bool ?? false,
          trialEnds: raw["trialEnds"] as? String ?? "",
          logo: raw["logo"] as? String ?? ""))
    }
    if snap.state == .list && snap.items.isEmpty { snap.state = .empty }
    return snap
  }

  /// What the widget gallery shows (never the user's data).
  static var preview: WidgetSnapshot {
    var s = WidgetSnapshot(state: .list)
    s.strings = [
      "title": "November", "total": "$42.97", "per": "/mo", "awaiting": "To confirm",
      "tapToConfirm": "Tap to confirm", "tomorrow": "Tomorrow", "inDays": "{n} days",
      "leftTomorrow": "tomorrow", "leftDays": "{n} days left", "open": "Open Subnest",
    ]
    let day: TimeInterval = 86_400
    func item(_ name: String, _ mono: String, _ argb: Int, _ price: String, _ inDays: Double) -> WidgetItem {
      WidgetItem(
        id: "", name: name, mono: mono, color: Color(argb: argb), onColor: .white, price: price, cycle: "Monthly",
        date: "", dateShort: "", due: Date().addingTimeInterval(inDays * day), trial: false, trialEnds: "", logo: "")
    }
    s.items = [
      item("Music", "M", 0xFF1F_9D55, "$10.99", 2), item("Cloud", "C", 0xFF28_56D8, "$2.99", 5),
      item("Video", "V", 0xFFD2_1F3C, "$15.49", 9),
    ]
    return s
  }
}

extension Color {
  init(argb: Int) {
    let v = UInt32(truncatingIfNeeded: argb)
    self.init(
      .sRGB,
      red: Double((v >> 16) & 0xFF) / 255,
      green: Double((v >> 8) & 0xFF) / 255,
      blue: Double(v & 0xFF) / 255,
      opacity: 1)
  }
}

// MARK: - Palette (tokens: lib/core/theme/tokens.g.dart — iOS widgets sit on `surface`, mockups 122 / 123)

struct SubnestPalette {
  let surface, ink, inkMuted, brand, warningInk, warningSoft, chipLine, barDue: Color

  init(_ scheme: ColorScheme) {
    if scheme == .dark {
      surface = Color(argb: 0xFF16_1B1E)
      ink = Color(argb: 0xFFEE_F2F3)
      inkMuted = Color(argb: 0xFFA1_ACB1)
      brand = Color(argb: 0xFF46_CDB9)
      warningInk = Color(argb: 0xFFFF_C966)
      warningSoft = Color(argb: 0xFF36_270B)
      chipLine = Color(argb: 0xFF3F_4A4F)
      barDue = Color(argb: 0xFF1F_3E3B)
    } else {
      surface = .white
      ink = Color(argb: 0xFF10_1618)
      inkMuted = Color(argb: 0xFF56_6065)
      brand = Color(argb: 0xFF0E_6B63)
      warningInk = Color(argb: 0xFF8A_4700)
      warningSoft = Color(argb: 0xFFFF_F1D6)
      chipLine = Color(argb: 0xFFC9_D0D3)
      barDue = Color(argb: 0xFFC9_E0DD)
    }
  }
}

// MARK: - Timeline

struct SubnestEntry: TimelineEntry {
  let date: Date
  let snapshot: WidgetSnapshot
}

struct SubnestProvider: TimelineProvider {
  func placeholder(in context: Context) -> SubnestEntry {
    SubnestEntry(date: Date(), snapshot: .preview)
  }

  func getSnapshot(in context: Context, completion: @escaping (SubnestEntry) -> Void) {
    // The gallery shows sample data, never the user's.
    completion(SubnestEntry(date: Date(), snapshot: context.isPreview ? .preview : .read()))
  }

  /// Today plus the next 3 midnights ("2 days" moves on); the app reloads the timeline every
  /// time its data changes (`HomeWidget.updateWidget` → WidgetCenter).
  func getTimeline(in context: Context, completion: @escaping (Timeline<SubnestEntry>) -> Void) {
    let snapshot = WidgetSnapshot.read()
    let cal = Calendar.current
    let now = Date()
    var entries = [SubnestEntry(date: now, snapshot: snapshot)]
    if snapshot.state == .list {
      for day in 1...3 {
        if let midnight = cal.date(byAdding: .day, value: day, to: cal.startOfDay(for: now)) {
          entries.append(SubnestEntry(date: midnight.addingTimeInterval(60), snapshot: snapshot))
        }
      }
    }
    completion(Timeline(entries: entries, policy: .atEnd))
  }
}

// MARK: - Views

struct SubnestWidgetView: View {
  @Environment(\.widgetFamily) private var family
  @Environment(\.colorScheme) private var scheme
  let entry: SubnestEntry

  private var palette: SubnestPalette { SubnestPalette(scheme) }
  private var snap: WidgetSnapshot { entry.snapshot }

  /// The small widget's next subscription waits for confirmation → warning card (mockup 125).
  private var smallAwaiting: Bool {
    guard family == .systemSmall, snap.state == .list, let first = snap.items.first,
      let days = snap.days(first, on: entry.date)
    else { return false }
    return days <= 0
  }

  var body: some View {
    content.subnestBackground(smallAwaiting ? palette.warningSoft : palette.surface)
  }

  @ViewBuilder private var content: some View {
    switch snap.state {
    case .list:
      switch family {
      case .systemSmall: small
      case .systemMedium: medium
      default: large
      }
    case .locked:
      locked
    case .empty:
      empty
    case .missing:
      locked.hidden().overlay(
        Text(String(localized: "widgetOpenApp")).font(.system(size: 15, weight: .bold)).foregroundColor(palette.ink)
      )
      .widgetURL(SubnestWidgetStore.overviewURL)
    }
  }

  // Locked: mark, lock, "Locked with PIN" (medium / large: the long text), centred; opens the Overview.
  private var locked: some View {
    let title = family == .systemSmall ? snap.text("locked") : snap.text("lockedLong")
    return VStack(spacing: 6) {
      AppMark(size: family == .systemSmall ? 28 : 16)
      Image(systemName: "lock")
        .font(.system(size: 24, weight: .semibold))
        .foregroundColor(palette.brand)
        .accessibilityHidden(true)
      Text(title.isEmpty ? snap.text("locked") : title)
        .font(.system(size: 12))
        .foregroundColor(palette.inkMuted)
        .multilineTextAlignment(.center)
        .lineLimit(3)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .accessibilityElement(children: .combine)
    .widgetURL(SubnestWidgetStore.overviewURL)
  }

  // Nothing due: mark, "Nothing due", "Tap to add your first subscription"; opens "+" step 1.
  private var empty: some View {
    VStack(alignment: .leading, spacing: 2) {
      AppMark(size: 28)
      Spacer(minLength: 0)
      Text(snap.text("emptyTitle"))
        .font(.system(size: 15, weight: .bold))
        .foregroundColor(palette.ink)
        .lineLimit(2)
      Text(snap.text("emptyBody"))
        .font(.system(size: 12))
        .foregroundColor(palette.inkMuted)
        .lineLimit(3)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .accessibilityElement(children: .combine)
    .widgetURL(SubnestWidgetStore.addURL)
  }

  // Small: the next subscription; the whole widget opens it.
  private var small: some View {
    let item = snap.items[0]
    let days = snap.days(item, on: entry.date)
    let awaiting = (days ?? 1) <= 0
    let meta = snap.smallMeta(item, days: days)
    let ink = awaiting ? palette.warningInk : palette.ink
    return VStack(alignment: .leading, spacing: 2) {
      HStack(alignment: .top) {
        Tile(item: item, size: 32)
        Spacer(minLength: 0)
        if awaiting {
          Image(systemName: "clock").font(.system(size: 12, weight: .bold)).foregroundColor(palette.warningInk)
            .accessibilityHidden(true)
        } else if let days = days {
          Text(snap.shortWhen(days)).font(.system(size: 12, weight: .bold)).foregroundColor(palette.brand)
            .lineLimit(1)
        }
      }
      Spacer(minLength: 4)
      Text(item.name)
        .font(.system(size: 17, weight: .bold))
        .foregroundColor(ink)
        .lineLimit(1)
      HStack(spacing: 6) {
        Text(item.price)
          .font(.system(size: 17, weight: .bold))
          .foregroundColor(ink)
          .lineLimit(1)
          .minimumScaleFactor(0.7)
        CycleChip(text: item.cycle, palette: palette, small: false)
      }
      Text(meta)
        .font(.system(size: 12, weight: awaiting ? .bold : .regular))
        .foregroundColor(awaiting ? palette.warningInk : palette.inkMuted)
        .lineLimit(1)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(Text([item.name, item.price, item.cycle, meta].joined(separator: ", ")))
    .widgetURL(SubnestWidgetStore.subscriptionURL(item.id))
  }

  // Medium: month + total (opens the Overview), the next 3 rows.
  private var medium: some View {
    VStack(alignment: .leading, spacing: 6) {
      Link(destination: SubnestWidgetStore.overviewURL) {
        VStack(alignment: .leading, spacing: 2) {
          header(snap.text("title"))
          total(size: 22)
        }
      }
      ForEach(Array(snap.items.prefix(3).enumerated()), id: \.offset) { _, item in row(item) }
      Spacer(minLength: 0)
    }
    .widgetURL(SubnestWidgetStore.overviewURL)
  }

  // Large: month + badge, total, Paid / Still to pay + bar, the next 6 rows.
  private var large: some View {
    VStack(alignment: .leading, spacing: 6) {
      Link(destination: SubnestWidgetStore.overviewURL) {
        VStack(alignment: .leading, spacing: 4) {
          HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
              header(snap.text("title"))
              total(size: 22)
            }
            Spacer(minLength: 4)
            if let badge = snap.strings["badge"] { badgeView(badge) }
          }
          if let paid = snap.strings["paid"], let due = snap.strings["due"] { cash(paid: paid, due: due) }
        }
      }
      ForEach(Array(snap.items.prefix(6).enumerated()), id: \.offset) { _, item in row(item) }
      Spacer(minLength: 0)
    }
    .widgetURL(SubnestWidgetStore.overviewURL)
  }

  private func header(_ title: String) -> some View {
    HStack(spacing: 6) {
      AppMark(size: 16)
      Text(title.uppercased())
        .font(.system(size: 11, weight: .bold))
        .kerning(0.4)
        .foregroundColor(palette.brand)
        .lineLimit(1)
    }
  }

  private func total(size: CGFloat) -> some View {
    HStack(alignment: .firstTextBaseline, spacing: 2) {
      Text(snap.text("total"))
        .font(.system(size: size, weight: .bold))
        .foregroundColor(palette.ink)
        .lineLimit(1)
        .minimumScaleFactor(0.6)
      Text(snap.text("per"))
        .font(.system(size: 13, weight: .medium))
        .foregroundColor(palette.inkMuted)
        .lineLimit(1)
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(Text(snap.text("totalA11y")))
  }

  private func cash(paid: String, due: String) -> some View {
    let share = max(0, min(1, snap.paidShare ?? 0))
    return VStack(alignment: .leading, spacing: 2) {
      cashRow(snap.text("paidLabel"), paid)
      cashRow(snap.text("dueLabel"), due)
      GeometryReader { geo in
        ZStack(alignment: .leading) {
          Capsule().fill(palette.barDue)
          Capsule().fill(palette.brand).frame(width: geo.size.width * CGFloat(share))
        }
      }
      .frame(height: 6)
      .padding(.top, 4)
      .accessibilityHidden(true)
    }
  }

  private func cashRow(_ label: String, _ amount: String) -> some View {
    HStack {
      Text(label).font(.system(size: 12)).foregroundColor(palette.inkMuted).lineLimit(1)
      Spacer(minLength: 4)
      Text(amount).font(.system(size: 12, weight: .bold)).foregroundColor(palette.ink).lineLimit(1)
    }
    .accessibilityElement(children: .combine)
  }

  private func badgeView(_ text: String) -> some View {
    HStack(spacing: 4) {
      Image(systemName: "clock").font(.system(size: 11, weight: .semibold)).accessibilityHidden(true)
      Text(text).font(.system(size: 12, weight: .bold)).lineLimit(1)
    }
    .foregroundColor(palette.warningInk)
    .padding(.horizontal, 10)
    .frame(height: 28)
    .background(Capsule().fill(palette.warningSoft))
  }

  /// One subscription; tapping it opens that subscription.
  private func row(_ item: WidgetItem) -> some View {
    let awaiting = (snap.days(item, on: entry.date) ?? 1) <= 0
    let sub = awaiting ? snap.text("awaiting") : item.date
    return Link(destination: SubnestWidgetStore.subscriptionURL(item.id)) {
      HStack(spacing: 8) {
        Tile(item: item, size: 24)
        VStack(alignment: .leading, spacing: 0) {
          Text(item.name)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(palette.ink)
            .lineLimit(1)
          Text(sub)
            .font(.system(size: 12, weight: awaiting ? .semibold : .regular))
            .foregroundColor(awaiting ? palette.warningInk : palette.inkMuted)
            .lineLimit(1)
        }
        Spacer(minLength: 4)
        VStack(alignment: .trailing, spacing: 1) {
          Text(item.price)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(palette.ink)
            .lineLimit(1)
          CycleChip(text: item.cycle, palette: palette, small: true)
        }
      }
      .accessibilityElement(children: .ignore)
      .accessibilityLabel(Text([item.name, item.price, item.cycle, sub].joined(separator: ", ")))
    }
  }
}

/// Outlined cycle chip under / next to a price ("Monthly"), design `.cyc`.
struct CycleChip: View {
  let text: String
  let palette: SubnestPalette
  let small: Bool

  var body: some View {
    if !text.isEmpty {
      Text(text)
        .font(.system(size: small ? 10 : 11, weight: .semibold))
        .foregroundColor(palette.inkMuted)
        .lineLimit(1)
        .padding(.horizontal, small ? 4 : 6)
        .frame(height: small ? 15 : 18)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(palette.chipLine, lineWidth: 1))
        .accessibilityHidden(true)
    }
  }
}

/// Service tile: the bundled logo on its light plate when the extension can read it, else the
/// monogram in the subscription colour.
struct Tile: View {
  let item: WidgetItem
  let size: CGFloat

  var body: some View {
    let shape = RoundedRectangle(cornerRadius: (size * 0.28).rounded(), style: .continuous)
    ZStack {
      if let logo = SubnestWidgetStore.bundledLogo(item.logo) {
        shape.fill(Color.white)
        Image(uiImage: logo).resizable().scaledToFill().frame(width: size, height: size).clipShape(shape)
      } else {
        shape.fill(item.color)
        Text(item.mono)
          .font(.system(size: size * (item.mono.count <= 1 ? 0.48 : 0.38), weight: .bold))
          .foregroundColor(item.onColor)
          .lineLimit(1)
          .minimumScaleFactor(0.5)
          .padding(2)
      }
    }
    .frame(width: size, height: size)
    .accessibilityHidden(true)
  }
}

/// The Subnest mark (asset `WidgetMark`, from the app icon).
struct AppMark: View {
  let size: CGFloat

  var body: some View {
    Image("WidgetMark")
      .resizable()
      .frame(width: size, height: size)
      .clipShape(RoundedRectangle(cornerRadius: size * 0.25, style: .continuous))
      .accessibilityHidden(true)
  }
}

extension View {
  /// iOS 17 requires `containerBackground` (without it the system shows an error instead of the widget).
  @ViewBuilder func subnestBackground(_ color: Color) -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      containerBackground(for: .widget) { color }
    } else {
      padding(14).background(color)
    }
  }
}

@main
struct SubnestWidget: Widget {
  /// Same as `HomeWidgetStore.iOSKind` in Dart.
  let kind = "SubnestWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: SubnestProvider()) { entry in
      SubnestWidgetView(entry: entry)
    }
    .configurationDisplayName("widgetPickerName")
    .description("widgetPickerDescription")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
  }
}
