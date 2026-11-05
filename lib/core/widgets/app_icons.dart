import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

export 'package:lucide_icons_flutter/lucide_icons.dart' show LucideIcons;

/// Lucide icons used by Subnest (design/system/icons/, Lucide ISC). 24 grid, 2px stroke.
/// Sizes: 13–16 inline/badges · 20 rows & buttons · 22 tab bar · 24–26 top bar & FAB.
///
/// **Fixed meanings** — never reuse these for something else:
/// [awaiting] clock · [trial] hourglass · [shared] users · [cancelled] ban · [paid] circle-check ·
/// [savings] piggy-bank · [offline] wifi-off · [remindersOff] bell-off · [privacy] lock ·
/// [external] external-link (leaves the app).
abstract final class AppIcons {
  // Fixed meanings
  static const IconData awaiting = LucideIcons.clock;
  static const IconData trial = LucideIcons.hourglass;
  static const IconData shared = LucideIcons.users;
  static const IconData cancelled = LucideIcons.ban;
  static const IconData paid = LucideIcons.circleCheck;
  static const IconData savings = LucideIcons.piggyBank;
  static const IconData offline = LucideIcons.wifiOff;
  static const IconData remindersOff = LucideIcons.bellOff;
  static const IconData privacy = LucideIcons.lock;
  static const IconData external = LucideIcons.externalLink;

  // Tabs
  static const IconData tabHome = LucideIcons.house;
  static const IconData tabCalendar = LucideIcons.calendarDays;
  static const IconData tabInsights = LucideIcons.chartPie;
  static const IconData tabSettings = LucideIcons.settings;

  // Navigation & actions
  static const IconData back = LucideIcons.chevronLeft;
  static const IconData close = LucideIcons.x;
  static const IconData next = LucideIcons.chevronRight;
  static const IconData expand = LucideIcons.chevronDown;
  static const IconData add = LucideIcons.plus;
  static const IconData remove = LucideIcons.minus;
  static const IconData check = LucideIcons.check;
  static const IconData edit = LucideIcons.pencil;
  static const IconData delete = LucideIcons.trash2;
  static const IconData search = LucideIcons.search;
  static const IconData sort = LucideIcons.arrowUpDown;
  static const IconData restore = LucideIcons.rotateCcw;
  static const IconData refresh = LucideIcons.refreshCw;
  static const IconData library = LucideIcons.layoutGrid;
  static const IconData clear = LucideIcons.circleX;

  // Content
  static const IconData reminder = LucideIcons.bell;
  static const IconData reminderRing = LucideIcons.bellRing;
  static const IconData calendarCheck = LucideIcons.calendarCheck;
  static const IconData calendarClock = LucideIcons.calendarClock;
  static const IconData currency = LucideIcons.coins;
  static const IconData payment = LucideIcons.creditCard;
  static const IconData wallet = LucideIcons.wallet;
  static const IconData category = LucideIcons.tag;
  static const IconData note = LucideIcons.stickyNote;
  static const IconData link = LucideIcons.link;
  static const IconData language = LucideIcons.languages;
  static const IconData globe = LucideIcons.globe;
  static const IconData theme = LucideIcons.sunMoon;
  static const IconData backup = LucideIcons.download;
  static const IconData restoreFile = LucideIcons.upload;
  static const IconData json = LucideIcons.fileJson;
  static const IconData csv = LucideIcons.fileSpreadsheet;
  static const IconData mail = LucideIcons.mail;
  static const IconData rate = LucideIcons.star;
  static const IconData info = LucideIcons.info;
  static const IconData alert = LucideIcons.circleAlert;
  static const IconData tip = LucideIcons.lightbulb;
  static const IconData trend = LucideIcons.trendingUp;
  static const IconData secure = LucideIcons.shieldCheck;
  static const IconData privacyKey = LucideIcons.lockKeyhole;
}
