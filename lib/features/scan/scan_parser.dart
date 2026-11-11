import '../../domain/domain.dart';

/// Turns the text rows read from one screenshot / receipt photo into Detected charges
/// (glossary: Detection source *Ảnh chụp*, ADR 0003). Pure: no OCR, no clock — pass [today].
///
/// Works on rows (text on the same line of the picture, left → right, joined by two spaces) in
/// reading order. Handles the store subscription pages (Google Play "Payments & subscriptions",
/// App Store "Subscriptions") and simple receipts, in English and Vietnamese:
/// * an **amount** with its currency ("$9.99", "US$9.99", "9,99 €", "260.000 ₫", "VND 260,000") anchors
///   one record; tax / subtotal / discount rows are ignored;
/// * the **name** is the anchor row without its amount and cycle words, else the nearest row above
///   that is not a heading, a date, a status or store chrome;
/// * the **date** is the nearest date row around it ("Renews on Nov 24, 2026", "24 thg 11, 2026",
///   "24/11/2026", "Nov 24"); an upcoming date — or one after "Renews / Next payment / Gia hạn" — is a
///   renewal ([DetectedCharge.isRenewal]), a past one a charge;
/// * the **cycle** comes from "/month", "per year", "Monthly", "/tháng", "Hằng năm"…
/// Records without a name or a date are dropped (nothing is guessed into the user's money).
class ScanParser {
  const ScanParser({required this.today, this.dayFirst = true, this.defaultDollar = 'USD'});

  final LocalDate today;

  /// Numeric dates "05/11/2026": day first (Vietnamese, most of the world) or month first (US).
  final bool dayFirst;

  /// Currency of a bare "$".
  final String defaultDollar;

  List<DetectedCharge> parse(List<String> rows, {DetectionSource source = DetectionSource.scan}) {
    final lines = [for (final r in rows) r.replaceAll(RegExp(r'\s+'), ' ').trim()].where((r) => r.isNotEmpty).toList();
    final anchors = <int>[];
    final amounts = <int, ({int minor, String currency})>{};
    for (var i = 0; i < lines.length; i++) {
      if (_ignoredAmountRow.hasMatch(lines[i].toLowerCase())) continue;
      final a = amountIn(lines[i]);
      if (a != null) {
        anchors.add(i);
        amounts[i] = a;
      }
    }
    final out = <DetectedCharge>[];
    for (var k = 0; k < anchors.length; k++) {
      final i = anchors[k];
      final lo = k == 0 ? 0 : anchors[k - 1] + 1;
      final hi = k == anchors.length - 1 ? lines.length - 1 : anchors[k + 1] - 1;
      final name = _nameFor(lines, i, lo);
      if (name == null) continue;
      final dated = _dateFor(lines, i, lo, hi);
      if (dated == null) continue;
      final cycle = _cycleFor(lines, i, lo, hi);
      final a = amounts[i]!;
      final renewal = dated.renewal || dated.date.isAfter(today);
      final c = DetectedCharge(
        name: name,
        amountMinor: a.minor,
        currency: a.currency,
        date: dated.date,
        source: source,
        cycle: cycle,
        isRenewal: renewal,
      );
      if (out.any((o) => o.name == c.name && o.date == c.date && o.amountMinor == c.amountMinor)) continue;
      out.add(c);
    }
    return out;
  }

  // ---- Amounts --------------------------------------------------------------------------------

  static final _ignoredAmountRow = RegExp(
    r'\b(sub ?total|tax|vat|discount|credit|refund|balance|saved?|save|savings)\b|thuế|giảm giá|tạm tính|hoàn tiền|tiết kiệm',
  );

  static const _symbols = <String, String>{
    r'US$': 'USD',
    r'A$': 'AUD',
    r'AU$': 'AUD',
    r'CA$': 'CAD',
    r'C$': 'CAD',
    r'NZ$': 'NZD',
    r'S$': 'SGD',
    r'HK$': 'HKD',
    r'R$': 'BRL',
    r'MX$': 'MXN',
    '€': 'EUR',
    '£': 'GBP',
    '₫': 'VND',
    '¥': 'JPY',
    '₹': 'INR',
    '₩': 'KRW',
    '฿': 'THB',
    '₱': 'PHP',
  };

  static final _codes = RegExp(r'\b(USD|EUR|GBP|VND|JPY|INR|KRW|AUD|CAD|SGD|THB|PHP|IDR|MYR|BRL|MXN|HKD|NZD|CHF)\b');
  static final _number = RegExp(r'\d{1,3}(?:[.,\s]\d{3})+(?:[.,]\d{1,2})?|\d+(?:[.,]\d{1,2})?');

  /// The amount and currency of a row, or `null` when it has none (a bare number is no amount).
  ({int minor, String currency})? amountIn(String row) {
    String? currency;
    var at = -1;
    for (final e in _symbols.entries) {
      final i = row.indexOf(e.key);
      if (i >= 0 && (at < 0 || e.key.length > 1)) {
        currency = e.value;
        at = i;
        if (e.key.length > 1) break;
      }
    }
    if (currency == null) {
      final code = _codes.firstMatch(row);
      if (code != null) {
        currency = code.group(1);
        at = code.start;
      }
    }
    if (currency == null) {
      final dong = RegExp(r'\d[\d.,]*\s?(đ|vnđ|vnd)(?![A-Za-z])', caseSensitive: false).firstMatch(row);
      if (dong != null) {
        currency = 'VND';
        at = dong.start;
      } else {
        final dollar = row.indexOf(r'$');
        if (dollar >= 0) {
          currency = defaultDollar;
          at = dollar;
        }
      }
    }
    if (currency == null) return null;
    // The number closest to the currency mark.
    Match? best;
    var bestGap = 1 << 30;
    for (final m in _number.allMatches(row)) {
      final gap = m.start >= at ? m.start - at : at - m.end;
      if (gap < bestGap && gap <= 4) {
        best = m;
        bestGap = gap;
      }
    }
    if (best == null) return null;
    final minor = _toMinor(best.group(0)!, currency);
    if (minor == null || minor <= 0) return null;
    return (minor: minor, currency: currency);
  }

  static int? _toMinor(String raw, String currency) {
    final decimals = currencyDecimals(currency);
    final s = raw.replaceAll(' ', '');
    if (decimals == 0) return int.tryParse(s.replaceAll(RegExp('[.,]'), ''));
    final last = s.lastIndexOf(RegExp('[.,]'));
    String whole;
    var frac = '';
    if (last >= 0 && s.length - last - 1 <= 2) {
      whole = s.substring(0, last).replaceAll(RegExp('[.,]'), '');
      frac = s.substring(last + 1);
    } else {
      whole = s.replaceAll(RegExp('[.,]'), '');
    }
    final w = int.tryParse(whole.isEmpty ? '0' : whole);
    if (w == null) return null;
    final f = int.tryParse(frac.padRight(decimals, '0').substring(0, decimals)) ?? 0;
    var unit = 1;
    for (var i = 0; i < decimals; i++) {
      unit *= 10;
    }
    return w * unit + f;
  }

  // ---- Names ----------------------------------------------------------------------------------

  static final _chrome = RegExp(
    r'^(subscriptions?|active|inactive|expired|cancell?ed|payments?( & subscriptions| and subscriptions)?|manage|cancel( subscription)?'
    r'|google play|app store|apple( account| id)?|account|settings|order receipt|receipt|invoice|order|total|billed to|payment method'
    r'|see all|edit|done|back|renew(s|al)?|next payment|next billing|free trial|trial|price|plan|options'
    r'|gói thuê bao|gói đăng ký|đang hoạt động|đã hết hạn|đã huỷ|đã hủy|thanh toán( & gói thuê bao| và gói thuê bao)?|quản lý'
    r'|huỷ gói|hủy gói|hoá đơn|hóa đơn|biên nhận|tổng( cộng)?|gia hạn|dùng thử)$',
  );

  static final _cycleWords = RegExp(
    r'(/|per |every |a |each |mỗi )?\b(week|month|year|mo|yr|wk|weekly|monthly|yearly|annually|annual|quarterly'
    r'|tuần|tháng|năm|quý|hằng tuần|hằng tháng|hằng năm|hàng tháng|hàng năm)\b',
    caseSensitive: false,
  );

  String? _nameFor(List<String> lines, int anchor, int lo) {
    final own = cleanName(_withoutAmount(lines[anchor]));
    if (own != null) return own;
    // The top line of the card above the price (a store card: name, then publisher / plan, then price).
    for (var j = anchor - 3 < lo ? lo : anchor - 3; j < anchor; j++) {
      final line = lines[j];
      if (dateIn(line) != null || _money.hasMatch(line) || _ignoredAmountRow.hasMatch(line.toLowerCase())) continue;
      final n = cleanName(lines[j]);
      if (n != null) return n;
    }
    return null;
  }

  String _withoutAmount(String row) {
    var s = row;
    for (final k in _symbols.keys) {
      s = s.replaceAll(k, ' ');
    }
    return s
        .replaceAll(r'$', ' ')
        .replaceAll(_codes, ' ')
        .replaceAll(RegExp(r'\d[\d.,\s]*\s?(đ|vnđ|vnd)(?![A-Za-z])', caseSensitive: false), ' ')
        .replaceAll(_number, ' ');
  }

  /// Any currency mark — such a row is a price row, never a name.
  static final _money = RegExp(r'[$€£¥₫₹₩]|\d\s?(đ|vnđ|vnd)(?![A-Za-z])', caseSensitive: false);

  /// A service name from a row ("Max · Monthly" → "Max"), or `null` for chrome / status / dates.
  String? cleanName(String row) {
    if (dateIn(row) != null && RegExp(r'\d').hasMatch(row)) {
      // "Renews 24 Nov 2026" — never a name.
      return null;
    }
    var s = row.split(RegExp(r'\s[·•|–—-]\s|\s{2,}')).first;
    s = s.replaceAll(_cycleWords, ' ').replaceAll(RegExp(r'[()\[\]:,/·•]'), ' ');
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (s.length < 2 || !RegExp(r'[A-Za-zÀ-ỹ]').hasMatch(s)) return null;
    if (_chrome.hasMatch(s.toLowerCase())) return null;
    if (RegExp(r'^\d').hasMatch(s) && !RegExp(r'^\d+[A-Za-z]').hasMatch(s)) return null; // "9:41", "100 %"
    return s;
  }

  // ---- Dates ----------------------------------------------------------------------------------

  static const _months = <String, int>{
    'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6, //
    'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
  };

  static final _renewWords = RegExp(
    r'renew|next (payment|billing|charge)|will be charged|expires|ends on|starts|gia hạn|thanh toán tiếp|kỳ tới|lần tới|hết hạn',
    caseSensitive: false,
  );

  static final _enMonthFirst = RegExp(r'\b([A-Za-z]{3,9})\.? (\d{1,2})(?:st|nd|rd|th)?(?:,? (\d{4}))?\b');
  static final _enDayFirst = RegExp(r'\b(\d{1,2}) ([A-Za-z]{3,9})\.?(?:,? (\d{4}))?\b');
  static final _viWords = RegExp(r'\b(\d{1,2}) (?:thg|tháng) (\d{1,2}),? (?:năm )?(\d{4})?', caseSensitive: false);
  static final _numeric = RegExp(r'\b(\d{1,4})[/.-](\d{1,2})(?:[/.-](\d{2,4}))?\b');

  /// The date written in a row, with whether the row speaks of a renewal; `null` when none.
  ({LocalDate date, bool renewal})? dateIn(String row) {
    final renewal = _renewWords.hasMatch(row);
    LocalDate? d;
    var m = _viWords.firstMatch(row);
    if (m != null) d = _make(int.parse(m.group(1)!), int.parse(m.group(2)!), m.group(3), renewal);
    if (d == null) {
      m = _enMonthFirst.firstMatch(row);
      final month = m == null ? null : _monthOf(m.group(1)!);
      if (m != null && month != null) d = _make(int.parse(m.group(2)!), month, m.group(3), renewal);
    }
    if (d == null) {
      m = _enDayFirst.firstMatch(row);
      final month = m == null ? null : _monthOf(m.group(2)!);
      if (m != null && month != null) d = _make(int.parse(m.group(1)!), month, m.group(3), renewal);
    }
    if (d == null) {
      m = _numeric.firstMatch(row);
      // "24/11", "24/11/2026", "24.11.2026", "2026-11-24" — never "12.11" (an amount) or one glued to a currency.
      final glued = m != null && m.start > 0 && RegExp(r'[$€£¥₫₹₩]').hasMatch(row[m.start - 1]);
      if (m != null && !glued && (m.group(3) != null || m.group(0)!.contains('/'))) {
        final a = int.parse(m.group(1)!), b = int.parse(m.group(2)!);
        if (a > 31) {
          // ISO-ish 2026-11-24
          d = _make(int.tryParse(m.group(3) ?? '') ?? 0, b, '$a', renewal);
        } else {
          final dayFirstHere = dayFirst ? a <= 31 && !(b > 12 && a <= 12) : a > 12;
          d = dayFirstHere ? _make(a, b, m.group(3), renewal) : _make(b, a, m.group(3), renewal);
        }
      }
    }
    return d == null ? null : (date: d, renewal: renewal);
  }

  static int? _monthOf(String word) {
    final w = word.toLowerCase();
    if (w.length < 3) return null;
    final m = _months[w.substring(0, 3)];
    if (m == null) return null;
    // "March" / "Mar" but not "Marketing".
    const full = [
      'january', 'february', 'march', 'april', 'may', 'june', //
      'july', 'august', 'september', 'october', 'november', 'december',
    ];
    final f = full[m - 1];
    return (f.startsWith(w) || w == 'sept') ? m : null;
  }

  LocalDate? _make(int day, int month, String? yearText, bool renewal) {
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    var year = int.tryParse(yearText ?? '');
    if (year != null && year < 100) year += 2000;
    if (year != null) {
      if (year < 2000 || year > 2100) return null;
      return _valid(year, month, day);
    }
    // No year: a renewal is the next such day, a charge the last one.
    final thisYear = _valid(today.year, month, day);
    if (thisYear == null) return null;
    if (renewal) return thisYear.isBefore(today) ? _valid(today.year + 1, month, day) : thisYear;
    return thisYear.isAfter(today) ? _valid(today.year - 1, month, day) : thisYear;
  }

  static LocalDate? _valid(int y, int m, int d) {
    final dt = DateTime.utc(y, m, d);
    return dt.month == m ? LocalDate(y, m, d) : null;
  }

  ({LocalDate date, bool renewal})? _dateFor(List<String> lines, int anchor, int lo, int hi) {
    final order = [
      anchor,
      for (var d = 1; d <= 3; d++) ...[anchor + d, anchor - d],
    ];
    for (final j in order) {
      if (j < lo || j > hi) continue;
      final d = dateIn(lines[j]);
      if (d != null) return d;
    }
    return null;
  }

  // ---- Cycles ---------------------------------------------------------------------------------

  static final _every = RegExp(r'(?:every|mỗi) (\d+) (day|week|month|year|ngày|tuần|tháng|năm)', caseSensitive: false);

  BillingCycle? cycleIn(String row) {
    final s = row.toLowerCase();
    final e = _every.firstMatch(s);
    if (e != null) {
      final n = int.parse(e.group(1)!);
      final unit = switch (e.group(2)) {
        'day' || 'ngày' => CycleUnit.day,
        'week' || 'tuần' => CycleUnit.week,
        'year' || 'năm' => CycleUnit.year,
        _ => CycleUnit.month,
      };
      if (n > 0) return BillingCycle(n, unit);
    }
    if (RegExp(r'quarter|\bquý\b|3 months|3 tháng').hasMatch(s)) return const BillingCycle.quarterly();
    if (RegExp(r'/ ?(year|yr)\b|per year|a year|yearly|annual|/ ?năm\b|hằng năm|hàng năm|mỗi năm').hasMatch(s)) {
      return const BillingCycle.yearly();
    }
    if (RegExp(r'/ ?(month|mo)\b|per month|a month|monthly|/ ?tháng\b|hằng tháng|hàng tháng|mỗi tháng').hasMatch(s)) {
      return const BillingCycle.monthly();
    }
    if (RegExp(r'/ ?(week|wk)\b|per week|weekly|/ ?tuần\b|hằng tuần|mỗi tuần').hasMatch(s)) {
      return const BillingCycle.weekly();
    }
    return null;
  }

  BillingCycle? _cycleFor(List<String> lines, int anchor, int lo, int hi) {
    final order = [
      anchor,
      for (var d = 1; d <= 2; d++) ...[anchor + d, anchor - d],
    ];
    for (final j in order) {
      if (j < lo || j > hi) continue;
      final c = cycleIn(lines[j]);
      if (c != null) return c;
    }
    return null;
  }
}
