import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/l10n/l10n.dart';
import '../../core/utils/currencies.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';

/// Pick the Primary currency (S10; same look as the S1 currency list, png 04).
/// Pass [onPicked] to use it as a picker (onboarding); default saves the Primary currency and pops.
class CurrencyScreen extends ConsumerStatefulWidget {
  const CurrencyScreen({super.key, this.onPicked});

  final ValueChanged<String>? onPicked;

  @override
  ConsumerState<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends ConsumerState<CurrencyScreen> {
  String _query = '';

  Future<void> _pick(String code) async {
    if (widget.onPicked != null) {
      widget.onPicked!(code);
      return;
    }
    await ref.read(settingsRepositoryProvider).setPrimaryCurrency(code);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final rates = ref.watch(ratesProvider).value;
    final primary = ref.watch(primaryCurrencyProvider);
    final vi = l.localeName.startsWith('vi');
    String? name(String code) => (vi ? currencyNamesVi[code] : null) ?? currencyNames[code];
    final others = ({...?rates?.usdRates.keys}..removeAll(commonCurrencies)).toList()..sort();
    final all = [...commonCurrencies, ...others];
    final q = _fold(_query.trim());
    final list = [
      for (final code in all)
        if (q.isEmpty || _fold(code).contains(q) || _fold(name(code) ?? '').contains(q)) code,
    ];

    return Scaffold(
      appBar: AppTopBar(title: l.settingsPrimaryCurrency),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s2, AppSpace.s4, AppSpace.s2),
              sliver: SliverList.list(
                children: [
                  Text(l.settingsCurrencyNote, style: AppType.meta.copyWith(color: c.inkMuted)),
                  const SizedBox(height: AppSpace.s3),
                  TextField(
                    onChanged: (v) => setState(() => _query = v),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: l.settingsSearchCurrency,
                      prefixIcon: Icon(AppIcons.search, size: 20, color: c.inkMuted),
                    ),
                  ),
                ],
              ),
            ),
            if (list.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.all(AppSpace.s6),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    l.settingsCurrencyNoMatch(_query.trim()),
                    textAlign: TextAlign.center,
                    style: AppType.body.copyWith(color: c.inkMuted),
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: AppSpace.s6),
              sliver: SliverList.builder(
                itemCount: list.length,
                itemBuilder: (_, i) => _CurrencyRow(
                  code: list[i],
                  name: name(list[i]),
                  selected: list[i] == primary,
                  onTap: () => _pick(list[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Lower-case, Vietnamese diacritics removed ("đồng" → "dong").
  static String _fold(String s) {
    final b = StringBuffer();
    for (final ch in s.toLowerCase().split('')) {
      b.write(_plain[ch] ?? ch);
    }
    return b.toString();
  }

  static final Map<String, String> _plain = {
    for (final e in const {
      'a': 'àáạảãâầấậẩẫăằắặẳẵ',
      'e': 'èéẹẻẽêềếệểễ',
      'i': 'ìíịỉĩ',
      'o': 'òóọỏõôồốộổỗơờớợởỡ',
      'u': 'ùúụủũưừứựửữ',
      'y': 'ỳýỵỷỹ',
      'd': 'đ',
    }.entries)
      for (final ch in e.value.split('')) ch: e.key,
  };
}

/// Symbol tile · code + name · check when selected (png 04).
class _CurrencyRow extends StatelessWidget {
  const _CurrencyRow({required this.code, required this.name, required this.selected, required this.onTap});

  final String code;
  final String? name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    var symbol = NumberFormat.simpleCurrency(name: code).currencySymbol;
    if (symbol.length > 3 || symbol == code) symbol = code.substring(0, 1);
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4 + AppSpace.s2, vertical: AppSpace.s2),
            child: Row(
              children: [
                ExcludeSemantics(
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(AppRadius.sm)),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          symbol,
                          style: AppType.label.copyWith(color: c.ink),
                          textScaler: TextScaler.noScaling,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpace.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        code,
                        style: AppType.titleSm.copyWith(color: c.ink, fontWeight: FontWeight.w500),
                      ),
                      if (name != null) Text(name!, style: AppType.meta.copyWith(color: c.inkMuted)),
                    ],
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: AppSpace.s3),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(color: c.brand, shape: BoxShape.circle),
                    child: Icon(AppIcons.check, size: 16, color: c.onBrand),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Vietnamese names for the currencies offered first (core `currencyNames` is English only).
const Map<String, String> currencyNamesVi = {
  'VND': 'Việt Nam đồng',
  'USD': 'Đô la Mỹ',
  'EUR': 'Euro',
  'GBP': 'Bảng Anh',
  'JPY': 'Yên Nhật',
  'KRW': 'Won Hàn Quốc',
  'CNY': 'Nhân dân tệ',
  'SGD': 'Đô la Singapore',
  'THB': 'Baht Thái',
  'AUD': 'Đô la Úc',
  'CAD': 'Đô la Canada',
  'HKD': 'Đô la Hồng Kông',
  'TWD': 'Đô la Đài Loan',
  'MYR': 'Ringgit Malaysia',
  'IDR': 'Rupiah Indonesia',
  'PHP': 'Peso Philippines',
  'INR': 'Rupee Ấn Độ',
  'CHF': 'Franc Thuỵ Sĩ',
};
