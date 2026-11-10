import SwiftUI
import WidgetKit

// Subnest home-screen widget (S11, product.md §10.7, mockups v13 89/91/92), one kind in three sizes:
// - small: the next subscription (tile, "Next", name, days left, price);
// - medium: "This month" total on the left, the next 3 subscriptions on the right;
// - large: "This month" + total + awaiting badge, then the next 5 subscriptions.
//
// Data: one JSON string the app writes into the App Group (`lib/features/widget_sync/widget_snapshot.dart`,
// key `subnest.widget`), already formatted in the app's language. No network, no database. The widget
// only works out "In N days" / "Tomorrow" / "To confirm" from each Due date, so the text stays right
// after midnight while the app is closed (one timeline entry per day).
// App lock on: the snapshot holds only "Locked with PIN"; nothing else exists to be drawn.
// Taps open `subnest://widget/…?homeWidget`; Dart maps the link to a go_router location
// (`widget_link.dart`) — the widget never opens a screen by itself.

enum SubnestWidgetStore {
  static let appGroup = "group.com.phiotron.subnest"
  static let key = "subnest.widget"
  static let overviewURL = URL(string: "subnest://widget/overview?homeWidget")!

  static func subscriptionURL(_ id: String) -> URL {
    let safe = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    return URL(string: "subnest://widget/subscription/\(safe)?homeWidget") ?? overviewURL
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
  let date: String
  let due: Date?
  let trial: Bool
}

struct WidgetSnapshot {
  enum State { case list, empty, locked, missing }

  var state: State = .missing
  var strings: [String: String] = [:]
  var items: [WidgetItem] = []

  func text(_ key: String) -> String { strings[key] ?? "" }

  /// "To confirm" when the Due date has come (as in the app: due ≤ today awaits), else
  /// "Tomorrow" / "In N days". Returns the text and whether the item is awaiting.
  func dueText(_ item: WidgetItem, on day: Date) -> (String, Bool) {
    guard let due = item.due else { return (item.date, false) }
    let cal = Calendar.current
    let days = cal.dateComponents([.day], from: cal.startOfDay(for: day), to: cal.startOfDay(for: due)).day ?? 0
    if days <= 0 { return (text("awaiting"), true) }
    if days == 1 { return (text("tomorrow"), false) }
    return (text("inDays").replacingOccurrences(of: "{n}", with: String(days)), false)
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
      // Locked: keep nothing but the two texts the app wrote.
      return WidgetSnapshot(state: .locked, strings: ["locked": snap.text("locked"), "open": snap.text("open")])
    default: return WidgetSnapshot()
    }
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
          date: raw["date"] as? String ?? "",
          due: (raw["due"] as? String).flatMap { parser.date(from: $0) },
          trial: raw["trial"] as? Bool ?? false))
    }
    if snap.state == .list && snap.items.isEmpty { snap.state = .empty }
    return snap
  }

  /// What the widget gallery shows (never the user's data).
  static var preview: WidgetSnapshot {
    var s = WidgetSnapshot(state: .list)
    s.strings = [
      "title": "This month", "upcoming": "Upcoming", "next": "Next", "total": "$42.97",
      "totalPerMonth": "$42.97/mo", "awaiting": "To confirm", "tomorrow": "Tomorrow",
      "inDays": "In {n} days", "firstCharge": "first charge", "open": "Open Subnest",
    ]
    let day: TimeInterval = 86_400
    s.items = [
      WidgetItem(
        id: "", name: "Music", mono: "M", color: Color(argb: 0xFF1F_9D55), onColor: .white, price: "$10.99",
        date: "", due: Date().addingTimeInterval(2 * day), trial: false),
      WidgetItem(
        id: "", name: "Cloud", mono: "C", color: Color(argb: 0xFF28_56D8), onColor: .white, price: "$2.99",
        date: "", due: Date().addingTimeInterval(5 * day), trial: false),
      WidgetItem(
        id: "", name: "Video", mono: "V", color: Color(argb: 0xFFD2_1F3C), onColor: .white, price: "$15.49",
        date: "", due: Date().addingTimeInterval(9 * day), trial: false),
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

// MARK: - Palette (tokens: lib/core/theme/tokens.g.dart; same values as Android res/values*/widget_colors.xml)

struct SubnestPalette {
  let surface, ink, inkMuted, brand, warningInk, warningSoft, chip: Color

  init(_ scheme: ColorScheme) {
    if scheme == .dark {
      surface = Color(argb: 0xFF11_312D)
      ink = Color(argb: 0xFFEE_F2F3)
      inkMuted = Color(argb: 0xFFA1_ACB1)
      brand = Color(argb: 0xFF8F_E8D9)
      warningInk = Color(argb: 0xFFFF_C966)
      warningSoft = Color(argb: 0xFF36_270B)
      chip = Color(argb: 0xFF0D_2522)
    } else {
      surface = .white
      ink = Color(argb: 0xFF10_1618)
      inkMuted = Color(argb: 0xFF56_6065)
      brand = Color(argb: 0xFF0E_6B63)
      warningInk = Color(argb: 0xFF8A_4700)
      warningSoft = Color(argb: 0xFFFF_F1D6)
      chip = Color(argb: 0xFFD9_F1EC)
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

  /// Today plus the next 3 midnights ("In N days" moves on); the app reloads the timeline every
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

  var body: some View {
    content.subnestBackground(palette)
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
      message(icon: Image(systemName: "lock.fill"), title: snap.text("locked"), body: nil)
    case .empty:
      message(icon: nil, title: snap.text("emptyTitle"), body: snap.text("emptyBody"))
    case .missing:
      message(icon: nil, title: String(localized: "widgetOpenApp"), body: nil)
    }
  }

  // Locked / empty / never synced: whole widget opens the Overview.
  private func message(icon: Image?, title: String, body: String?) -> some View {
    VStack(alignment: .leading, spacing: 6) {
      if let icon = icon {
        icon.font(.system(size: 22, weight: .semibold)).foregroundColor(palette.brand)
          .accessibilityHidden(true)
      } else {
        AppMark(size: 28)
      }
      Spacer(minLength: 0)
      Text(title)
        .font(.system(size: 16, weight: .bold))
        .foregroundColor(palette.brand)
        .lineLimit(3)
      if let body = body, !body.isEmpty {
        Text(body)
          .font(.system(size: 13))
          .foregroundColor(palette.inkMuted)
          .lineLimit(3)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .accessibilityElement(children: .combine)
    .widgetURL(SubnestWidgetStore.overviewURL)
  }

  // Small: the next subscription; the whole widget opens it.
  private var small: some View {
    let item = snap.items[0]
    let (due, awaiting) = snap.dueText(item, on: entry.date)
    let when = !awaiting && item.trial ? "\(due) · \(snap.text("firstCharge"))" : due
    return VStack(alignment: .leading, spacing: 2) {
      HStack(alignment: .top) {
        Tile(item: item, size: 40)
        Spacer(minLength: 0)
        AppMark(size: 20)
      }
      Spacer(minLength: 4)
      Text(snap.text("next").uppercased())
        .font(.system(size: 11, weight: .bold))
        .kerning(0.8)
        .foregroundColor(palette.brand)
      Text(item.name)
        .font(.system(size: 17, weight: .bold))
        .foregroundColor(palette.ink)
        .lineLimit(1)
      Text(when)
        .font(.system(size: 13, weight: awaiting ? .semibold : .regular))
        .foregroundColor(awaiting ? palette.warningInk : palette.inkMuted)
        .lineLimit(1)
      Text(item.price)
        .font(.system(size: 17, weight: .bold))
        .foregroundColor(palette.brand)
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(Capsule().fill(palette.chip))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(Text([snap.text("next"), item.name, item.price, when].joined(separator: ", ")))
    .widgetURL(SubnestWidgetStore.subscriptionURL(item.id))
  }

  // Medium: total on the left (opens the Overview), the next 3 rows on the right.
  private var medium: some View {
    HStack(alignment: .top, spacing: 14) {
      Link(destination: SubnestWidgetStore.overviewURL) {
        VStack(alignment: .leading, spacing: 4) {
          header(snap.text("title"))
          Spacer(minLength: 0)
          total(size: 22)
          if let badge = snap.strings["badge"] { badgeView(badge) }
        }
        .frame(maxHeight: .infinity, alignment: .leading)
      }
      VStack(alignment: .leading, spacing: 6) {
        ForEach(Array(snap.items.prefix(3).enumerated()), id: \.offset) { _, item in row(item) }
        Spacer(minLength: 0)
      }
      .frame(maxWidth: .infinity)
    }
    .widgetURL(SubnestWidgetStore.overviewURL)
  }

  // Large: header + badge, total, the next 5 rows.
  private var large: some View {
    VStack(alignment: .leading, spacing: 6) {
      Link(destination: SubnestWidgetStore.overviewURL) {
        VStack(alignment: .leading, spacing: 4) {
          HStack {
            header(snap.text("title"))
            Spacer(minLength: 4)
            if let badge = snap.strings["badge"] { badgeView(badge) }
          }
          total(size: 28)
        }
      }
      ForEach(Array(snap.items.prefix(5).enumerated()), id: \.offset) { _, item in row(item) }
      Spacer(minLength: 0)
    }
    .widgetURL(SubnestWidgetStore.overviewURL)
  }

  private func header(_ title: String) -> some View {
    HStack(spacing: 6) {
      AppMark(size: 18)
      Text(title.uppercased())
        .font(.system(size: 12, weight: .bold))
        .kerning(0.6)
        .foregroundColor(palette.brand)
        .lineLimit(1)
    }
  }

  private func total(size: CGFloat) -> some View {
    Text(snap.text("total"))
      .font(.system(size: size, weight: .bold))
      .foregroundColor(palette.ink)
      .lineLimit(1)
      .minimumScaleFactor(0.6)
      .accessibilityLabel(Text(snap.text("totalA11y")))
  }

  private func badgeView(_ text: String) -> some View {
    HStack(spacing: 4) {
      Image(systemName: "clock").font(.system(size: 11, weight: .semibold)).accessibilityHidden(true)
      Text(text).font(.system(size: 12, weight: .bold)).lineLimit(1)
    }
    .foregroundColor(palette.warningInk)
    .padding(.horizontal, 8)
    .padding(.vertical, 3)
    .background(Capsule().fill(palette.warningSoft))
  }

  /// One subscription; tapping it opens that subscription.
  private func row(_ item: WidgetItem) -> some View {
    let (due, awaiting) = snap.dueText(item, on: entry.date)
    let sub = awaiting ? due : item.date
    return Link(destination: SubnestWidgetStore.subscriptionURL(item.id)) {
      HStack(spacing: 8) {
        Tile(item: item, size: 28)
        VStack(alignment: .leading, spacing: 0) {
          Text(item.name)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(palette.ink)
            .lineLimit(1)
          Text(sub)
            .font(.system(size: 12, weight: awaiting ? .semibold : .regular))
            .foregroundColor(awaiting ? palette.warningInk : palette.inkMuted)
            .lineLimit(1)
        }
        Spacer(minLength: 4)
        Text(item.price)
          .font(.system(size: 14, weight: .semibold))
          .foregroundColor(palette.ink)
          .lineLimit(1)
      }
      .accessibilityElement(children: .ignore)
      .accessibilityLabel(Text([item.name, item.price, sub].joined(separator: ", ")))
    }
  }
}

/// Monogram tile in the subscription colour (no brand logos, product.md §7.4).
struct Tile: View {
  let item: WidgetItem
  let size: CGFloat

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: (size * 0.275).rounded(), style: .continuous).fill(item.color)
      Text(item.mono)
        .font(.system(size: size * (item.mono.count <= 1 ? 0.48 : 0.38), weight: .bold))
        .foregroundColor(item.onColor)
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .padding(2)
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
  @ViewBuilder func subnestBackground(_ palette: SubnestPalette) -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      containerBackground(for: .widget) { palette.surface }
    } else {
      padding(14).background(palette.surface)
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
