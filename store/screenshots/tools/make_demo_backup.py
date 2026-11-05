"""Demo backups for store screenshots (product.md §8 data, no personal data).

    python -I store/screenshots/tools/make_demo_backup.py assets/catalog/services.json <out dir> <today YYYY-MM-DD>

Writes demo-vi.json (VND, §8 data shifted to <today>) and demo-en.json (USD, US catalog prices).
Restore one with Settings → Restore from file → Replace (it also sets language, currency, 9:00, theme System).
"""
import json, sys, datetime as dt, calendar

cat_path, out_dir, today_s = sys.argv[1:4]
TODAY = dt.date.fromisoformat(today_s)
NOW = dt.datetime.combine(TODAY, dt.time(10, 0)).isoformat() + 'Z'
catalog = {s['id']: s for s in json.load(open(cat_path, encoding='utf-8'))['services']}


def add_months(d, n):
    m = d.month - 1 + n
    y, m = d.year + m // 12, m % 12 + 1
    return dt.date(y, m, min(d.day, calendar.monthrange(y, m)[1]))


def color(hexs):
    return int('FF' + hexs.lstrip('#'), 16)


def build(spec, lang):
    subs, periods = [], []
    n = 0
    for (sid, svc, name, price, cur, unit, due_off, cat, extra) in spec:
        c = catalog.get(svc, {})
        due = TODAY + dt.timedelta(days=due_off) if isinstance(due_off, int) else due_off
        s = {
            'id': sid, 'name': name, 'serviceId': svc if c else None,
            'color': color(c.get('color', '#607D8B')), 'iconText': c.get('monogram'),
            'category': cat, 'priceMinor': price, 'currency': cur,
            'cycleEvery': 1, 'cycleUnit': unit, 'anchorDate': due.isoformat(), 'periodIndex': 0,
            'status': extra.get('status', 'active'), 'trialEndDate': None,
            'sharedWith': extra.get('shared', 1), 'reminderDays': None, 'paymentMethod': extra.get('pm'),
            'manageUrl': c.get('manageUrl'), 'notes': None,
            'startDate': '2025-06-01', 'cancelledOn': None, 'createdAt': NOW, 'updatedAt': NOW,
        }
        if s['status'] == 'trial':
            s['trialEndDate'] = due.isoformat()
            s['startDate'] = (due - dt.timedelta(days=30)).isoformat()
        if s['status'] == 'cancelled':
            s['cancelledOn'] = extra['cancelledOn'].isoformat()
        subs.append(s)
        share = price // s['sharedWith']
        # history: monthly plans pay 11 previous periods, yearly ones once a year ago
        hist = extra.get('history', 11 if unit == 'month' and s['status'] == 'active' else 0)
        for i in range(1, hist + 1):
            n += 1
            skip = extra.get('skip') == i
            periods.append({
                'id': f'demo-p{n}', 'subscriptionId': sid,
                'dueDate': add_months(due, -i).isoformat(),
                'outcome': 'skipped' if skip else 'payment', 'amountMinor': 0 if skip else share,
                'currency': cur, 'confirmedAt': NOW,
            })
        if unit == 'year' and s['status'] == 'active':
            n += 1
            periods.append({'id': f'demo-p{n}', 'subscriptionId': sid,
                            'dueDate': add_months(due, -12).isoformat(), 'outcome': 'payment',
                            'amountMinor': share, 'currency': cur, 'confirmedAt': NOW})
    primary = 'VND' if lang == 'vi' else 'USD'
    return {
        'format': 'subnest-backup', 'version': 1, 'exportedAt': NOW,
        'settings': {'primaryCurrency': primary, 'locale': lang, 'reminderTime': '09:00', 'defaultReminderDays': '3', 'themeMode': 'system'},
        'rateOverrides': {}, 'subscriptions': subs, 'periods': periods,
    }


D = dt.date
VI = [
    ('demo-viettel', 'viettel-mobile', 'Viettel 5G', 150000, 'VND', 'month', -4, 'telecom', {'history': 10}),
    ('demo-netflix', 'netflix', 'Netflix Premium', 260000, 'VND', 'month', 0, 'video', {'shared': 4, 'pm': 'Visa •• 4821'}),
    ('demo-spotify', 'spotify', 'Spotify Premium', 59000, 'VND', 'month', 2, 'music', {'status': 'trial'}),
    ('demo-youtube', 'youtube-premium', 'YouTube Premium Family', 179000, 'VND', 'month', 18, 'video', {'shared': 5, 'skip': 1}),
    ('demo-chatgpt', 'chatgpt', 'ChatGPT Plus', 2000, 'USD', 'month', 3, 'ai', {}),
    ('demo-icloud', 'icloud', 'iCloud+ 200GB', 59000, 'VND', 'month', 11, 'storage', {}),
    ('demo-google1', 'google-one', 'Google One 2TB', 1690000, 'VND', 'year', D(2027, 3, 21), 'storage', {}),
    ('demo-canva', 'canva', 'Canva Pro', 1390000, 'VND', 'year', D(2027, 2, 3), 'software', {}),
    ('demo-duolingo', 'duolingo', 'Duolingo Super', 699000, 'VND', 'year', D(2027, 1, 9), 'education', {'status': 'cancelled', 'cancelledOn': D(2026, 10, 12)}),
    ('demo-applemusic', 'apple-music', 'Apple Music', 65000, 'VND', 'month', 15, 'music', {'status': 'cancelled', 'cancelledOn': D(2026, 8, 20)}),
]
EN = [
    ('demo-xbox', 'xbox-game-pass', 'Xbox Game Pass Ultimate', 2299, 'USD', 'month', -4, 'gaming', {'history': 10}),
    ('demo-netflix', 'netflix', 'Netflix Premium', 2699, 'USD', 'month', 0, 'video', {'shared': 4, 'pm': 'Visa •• 4821'}),
    ('demo-spotify', 'spotify', 'Spotify Premium', 1299, 'USD', 'month', 2, 'music', {'status': 'trial'}),
    ('demo-youtube', 'youtube-premium', 'YouTube Premium Family', 2699, 'USD', 'month', 18, 'video', {'shared': 5, 'skip': 1}),
    ('demo-chatgpt', 'chatgpt', 'ChatGPT Plus', 2000, 'USD', 'month', 3, 'ai', {}),
    ('demo-icloud', 'icloud', 'iCloud+ 200GB', 299, 'USD', 'month', 11, 'storage', {}),
    ('demo-google1', 'google-one', 'Google One 2TB', 9999, 'USD', 'year', D(2027, 3, 21), 'storage', {}),
    ('demo-notion', 'notion', 'Notion Plus', 12000, 'USD', 'year', D(2027, 2, 3), 'software', {}),
    ('demo-duolingo', 'duolingo', 'Duolingo Super', 8388, 'USD', 'year', D(2027, 1, 9), 'education', {'status': 'cancelled', 'cancelledOn': D(2026, 10, 12)}),
    ('demo-applemusic', 'apple-music', 'Apple Music', 1099, 'USD', 'month', 15, 'music', {'status': 'cancelled', 'cancelledOn': D(2026, 8, 20)}),
]
for lang, spec in (('vi', VI), ('en', EN)):
    with open(f'{out_dir}/demo-{lang}.json', 'w', encoding='utf-8') as f:
        json.dump(build(spec, lang), f, ensure_ascii=False, indent=1)
print('ok')
