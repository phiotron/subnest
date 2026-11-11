package com.phiotron.subnest

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.PorterDuff
import android.graphics.PorterDuffXfermode
import android.graphics.Rect
import android.graphics.RectF
import android.net.Uri
import android.os.Bundle
import android.view.Gravity
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONObject
import java.time.LocalDate
import java.time.ZoneId
import java.time.temporal.ChronoUnit

/**
 * Home-screen widgets (product.md §4.12, mockups v14 122–125) — one provider per size so the
 * picker offers three widgets:
 * - [SubnestWidgetSmall] 2×2: the next subscription (logo, "2 days", name, price + cycle, date · days
 *   left; waiting for confirmation → warning card and "Tap to confirm");
 * - [SubnestWidgetMedium] 4×2: month, "≈ $144.89/mo", the next 3 rows;
 * - [SubnestWidgetLarge] 4×4: month, total, "1 to confirm", Paid / Still to pay + bar, the next 6 rows.
 * Logos: the bundled PNG is read from the APK (`flutter_assets/assets/logos/png/<id>.png`), a Custom
 * logo from its file, drawn on the light plate; no logo → the monogram.
 *
 * Everything shown comes ready-formatted from the app (`lib/features/widget_sync/widget_snapshot.dart`)
 * as one JSON string in the `home_widget` store (private SharedPreferences). This class never reads
 * the database and never formats money. The only thing it works out itself is "In N days" /
 * "Tomorrow" / "To confirm" from each Due date, so the text stays right after midnight while the app
 * is closed (an inexact alarm re-draws at the next midnight; no permission needed).
 *
 * App lock: the app then writes a snapshot that holds only "Locked with PIN" — nothing else is left
 * in the store, so nothing else can be drawn.
 *
 * Taps never open a screen directly: they launch MainActivity with a `subnest://widget/…?homeWidget`
 * link; Dart (`widget_link.dart`) maps it to a go_router location.
 */
abstract class SubnestWidgetProvider : HomeWidgetProvider() {
    protected abstract val size: Size

    enum class Size(val requestCode: Int) { SMALL(10), MEDIUM(11), LARGE(12) }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val snapshot = readSnapshot(widgetData)
        for (id in appWidgetIds) {
            appWidgetManager.updateAppWidget(id, render(context, snapshot, appWidgetManager.getAppWidgetOptions(id)))
        }
        scheduleMidnight(context)
    }

    // Resized: the number of rows that fit changes.
    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle,
    ) {
        val snapshot = readSnapshot(HomeWidgetPlugin.getData(context))
        appWidgetManager.updateAppWidget(appWidgetId, render(context, snapshot, newOptions))
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        alarms(context).cancel(midnightIntent(context))
    }

    private fun render(context: Context, s: JSONObject?, options: Bundle?): RemoteViews {
        if (s == null || s.optString("state") != "list") return message(context, s)
        val items = s.optJSONArray("items")
        if (items == null || items.length() == 0) return message(context, s)
        val today = LocalDate.now()
        return when (size) {
            Size.SMALL -> small(context, s, items.getJSONObject(0), today)
            Size.MEDIUM, Size.LARGE -> list(context, s, items, today, options)
        }
    }

    /** Locked (centred lock), nothing due (opens "+"), or nothing written yet (widget added before the first run). */
    private fun message(context: Context, s: JSONObject?): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_message)
        val title: String
        var body: String? = null
        var link = OVERVIEW
        when (s?.optString("state")) {
            "locked" -> {
                title = if (size == Size.SMALL) {
                    s.optString("locked")
                } else {
                    s.optString("lockedLong").ifEmpty { s.optString("locked") }
                }
                views.setViewVisibility(R.id.widget_msg_icon, View.VISIBLE)
                views.setTextColor(R.id.widget_msg_title, context.getColor(R.color.widget_ink_muted))
                views.setFloat(R.id.widget_msg_title, "setTextSize", 12f)
                views.setInt(R.id.widget_msg_title, "setGravity", Gravity.CENTER_HORIZONTAL)
            }
            "empty", "list" -> {
                title = s.optString("emptyTitle").ifEmpty { context.getString(R.string.widget_open_app) }
                body = s.optString("emptyBody").ifEmpty { null }
                link = ADD
                // Empty (mockup 125): mark at the top-left, the texts at the bottom.
                views.setInt(R.id.widget_msg_box, "setGravity", Gravity.START)
                views.setViewVisibility(R.id.widget_msg_gap, View.VISIBLE)
            }
            else -> title = context.getString(R.string.widget_open_app)
        }
        views.setTextViewText(R.id.widget_msg_title, title)
        if (body != null) {
            views.setTextViewText(R.id.widget_msg_body, body)
            views.setViewVisibility(R.id.widget_msg_body, View.VISIBLE)
        } else {
            views.setViewVisibility(R.id.widget_msg_body, View.GONE)
        }
        views.setContentDescription(R.id.widget_root, listOfNotNull(title, body).joinToString(". "))
        views.setOnClickPendingIntent(R.id.widget_root, open(context, link))
        return views
    }

    private fun small(context: Context, s: JSONObject, item: JSONObject, today: LocalDate): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_small)
        val days = daysUntil(item, today)
        val awaiting = days != null && days <= 0
        // Top right: "2 days" / "Tomorrow", or a clock when it waits (mockups 124 / 125).
        if (awaiting) {
            views.setViewVisibility(R.id.widget_when, View.GONE)
            views.setViewVisibility(R.id.widget_when_icon, View.VISIBLE)
            views.setInt(R.id.widget_root, "setBackgroundResource", R.drawable.widget_bg_warn)
        } else {
            views.setTextViewText(R.id.widget_when, if (days == null) "" else shortWhen(s, days))
        }
        val meta = smallMeta(s, item, days)
        fillItem(context, views, item, meta, awaiting, 32)
        views.setContentDescription(
            R.id.widget_root,
            listOf(item.optString("name"), item.optString("price"), item.optString("cycle"), meta).joinToString(", "),
        )
        views.setOnClickPendingIntent(R.id.widget_root, open(context, subscriptionLink(item.optString("id"))))
        return views
    }

    private fun list(
        context: Context,
        s: JSONObject,
        items: org.json.JSONArray,
        today: LocalDate,
        options: Bundle?,
    ): RemoteViews {
        val large = size == Size.LARGE
        val views = RemoteViews(context.packageName, if (large) R.layout.widget_large else R.layout.widget_medium)
        val overview = open(context, OVERVIEW)
        views.setOnClickPendingIntent(R.id.widget_root, overview)
        views.setOnClickPendingIntent(R.id.widget_header, overview)

        views.setTextViewText(R.id.widget_title, s.optString("title"))
        views.setTextViewText(R.id.widget_total_text, s.optString("total"))
        views.setTextViewText(R.id.widget_per, s.optString("per"))
        views.setContentDescription(R.id.widget_total, s.optString("totalA11y"))
        var chrome = MEDIUM_CHROME_DP
        if (large) {
            chrome = LARGE_CHROME_DP
            val badge = s.optString("badge")
            if (badge.isNotEmpty()) {
                views.setTextViewText(R.id.widget_badge_text, badge)
                views.setViewVisibility(R.id.widget_badge, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.widget_badge, View.GONE)
            }
            if (s.has("paid")) {
                views.setViewVisibility(R.id.widget_cash, View.VISIBLE)
                views.setTextViewText(R.id.widget_paid_label, s.optString("paidLabel"))
                views.setTextViewText(R.id.widget_paid, s.optString("paid"))
                views.setTextViewText(R.id.widget_due_label, s.optString("dueLabel"))
                views.setTextViewText(R.id.widget_due, s.optString("due"))
                views.setProgressBar(R.id.widget_cash_bar, 1000, (s.optDouble("paidShare", 0.0) * 1000).toInt(), false)
                views.setContentDescription(
                    R.id.widget_cash,
                    "${s.optString("paidLabel")} ${s.optString("paid")}, ${s.optString("dueLabel")} ${s.optString("due")}",
                )
                chrome += CASH_DP
            }
        }

        views.removeAllViews(R.id.widget_rows)
        val count = minOf(items.length(), rowsThatFit(options, chrome))
        for (i in 0 until count) {
            val item = items.getJSONObject(i)
            val row = RemoteViews(context.packageName, R.layout.widget_row)
            val days = daysUntil(item, today)
            val awaiting = days != null && days <= 0
            // Rows show the date; the awaiting ones say "To confirm" instead.
            val whenText = if (awaiting) s.optString("awaiting") else item.optString("date")
            fillItem(context, row, item, whenText, awaiting, 24)
            row.setContentDescription(
                R.id.row_root,
                listOf(item.optString("name"), item.optString("price"), item.optString("cycle"), whenText)
                    .joinToString(", "),
            )
            row.setOnClickPendingIntent(R.id.row_root, open(context, subscriptionLink(item.optString("id"))))
            views.addView(R.id.widget_rows, row)
        }
        return views
    }

    /** Fills the tile (logo or monogram), name, when line (normal or awaiting colour), price and cycle chip. */
    private fun fillItem(
        context: Context,
        views: RemoteViews,
        item: JSONObject,
        whenText: String,
        awaiting: Boolean,
        tileDp: Int,
    ) {
        val mono = item.optString("mono")
        views.setInt(R.id.row_tile, "setColorFilter", item.optInt("color", DEFAULT_TILE))
        views.setTextViewText(R.id.row_mono, mono)
        views.setTextColor(R.id.row_mono, item.optInt("onColor", DEFAULT_ON_TILE))
        views.setFloat(R.id.row_mono, "setTextSize", tileDp * (if (mono.length <= 1) 0.48f else 0.38f))
        val logo = logoBitmap(context, item, tileDp)
        if (logo != null) {
            views.setImageViewBitmap(R.id.row_logo, logo)
            views.setViewVisibility(R.id.row_logo, View.VISIBLE)
        }
        views.setTextViewText(R.id.row_name, item.optString("name"))
        views.setTextViewText(R.id.row_price, item.optString("price"))
        val cycle = item.optString("cycle")
        views.setTextViewText(R.id.row_cycle, cycle)
        views.setViewVisibility(R.id.row_cycle, if (cycle.isEmpty()) View.GONE else View.VISIBLE)
        if (awaiting) {
            views.setTextViewText(R.id.row_await, whenText)
            views.setViewVisibility(R.id.row_await, View.VISIBLE)
            views.setViewVisibility(R.id.row_date, View.GONE)
        } else {
            views.setTextViewText(R.id.row_date, whenText)
            views.setViewVisibility(R.id.row_date, View.VISIBLE)
            views.setViewVisibility(R.id.row_await, View.GONE)
        }
    }

    /** Rows that fit the current height (portrait height = max height on launchers). */
    private fun rowsThatFit(options: Bundle?, chromeDp: Int): Int {
        val height = options?.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT, 0) ?: 0
        val max = if (size == Size.LARGE) 6 else 3
        val fallback = if (size == Size.LARGE) 5 else 2
        if (height <= 0) return fallback
        return ((height - chromeDp) / ROW_DP).coerceIn(1, max)
    }

    private fun scheduleMidnight(context: Context) {
        val next = LocalDate.now().plusDays(1).atStartOfDay(ZoneId.systemDefault()).toInstant().toEpochMilli()
        alarms(context).set(AlarmManager.RTC, next + 60_000, midnightIntent(context))
    }

    private fun alarms(context: Context) = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

    /** Re-draw of this size at midnight (the provider is not exported: only the system and the app reach it). */
    private fun midnightIntent(context: Context): PendingIntent {
        val component = ComponentName(context, javaClass)
        val ids = AppWidgetManager.getInstance(context).getAppWidgetIds(component)
        val intent = Intent(context, javaClass)
            .setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE)
            .putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
        return PendingIntent.getBroadcast(
            context,
            size.requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    companion object {
        /** Same key as `WidgetSnapshot.storageKey`. */
        private const val KEY = "subnest.widget"
        private const val OVERVIEW = "subnest://widget/overview?homeWidget"
        private const val ADD = "subnest://widget/add?homeWidget"
        private const val DEFAULT_TILE = 0xFF2D3438.toInt()
        private const val DEFAULT_ON_TILE = 0xFFFFFFFF.toInt()
        private const val ROW_DP = 38
        private const val MEDIUM_CHROME_DP = 26 + 16 + 30
        private const val LARGE_CHROME_DP = 26 + 16 + 30
        private const val CASH_DP = 46

        private fun readSnapshot(prefs: SharedPreferences): JSONObject? =
            prefs.getString(KEY, null)?.let { runCatching { JSONObject(it) }.getOrNull() }

        private fun subscriptionLink(id: String) =
            "subnest://widget/subscription/${Uri.encode(id)}?homeWidget"

        /** Days from today to the item's Due date (≤ 0 = awaiting confirmation, as in the app); null when unreadable. */
        private fun daysUntil(item: JSONObject, today: LocalDate): Long? {
            val due = runCatching { LocalDate.parse(item.optString("due")) }.getOrNull() ?: return null
            return ChronoUnit.DAYS.between(today, due)
        }

        /** Small widget, top right: "Tomorrow" / "2 days" (same rule as `WidgetSnapshot.dueText`). */
        private fun shortWhen(s: JSONObject, days: Long): String = when {
            days <= 0 -> s.optString("awaiting")
            days == 1L -> s.optString("tomorrow")
            else -> s.optString("inDays").replace("{n}", days.toString())
        }

        /** Small widget, last line (same rule as `WidgetSnapshot.smallMeta`). */
        private fun smallMeta(s: JSONObject, item: JSONObject, days: Long?): String {
            if (days == null) return item.optString("date")
            if (days <= 0) return s.optString("tapToConfirm")
            val trial = item.optString("trialEnds")
            if (trial.isNotEmpty()) return trial
            val left = if (days == 1L) s.optString("leftTomorrow") else s.optString("leftDays").replace("{n}", days.toString())
            return "${item.optString("dateShort")} · $left"
        }

        /**
         * The tile's logo on its light plate, rounded like the tile (radius 28%): the bundled logo read
         * straight from the APK's Flutter assets, else the Custom logo file. Null → the monogram stays.
         */
        private fun logoBitmap(context: Context, item: JSONObject, tileDp: Int): Bitmap? {
            val asset = item.optString("logo")
            val file = item.optString("logoFile")
            val source = runCatching {
                when {
                    asset.isNotEmpty() -> context.assets.open("flutter_assets/$asset").use { BitmapFactory.decodeStream(it) }
                    file.isNotEmpty() -> BitmapFactory.decodeFile(file)
                    else -> null
                }
            }.getOrNull() ?: return null
            val px = (tileDp * context.resources.displayMetrics.density).toInt().coerceIn(16, 160)
            val out = Bitmap.createBitmap(px, px, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(out)
            val paint = Paint(Paint.ANTI_ALIAS_FLAG or Paint.FILTER_BITMAP_FLAG)
            val rect = RectF(0f, 0f, px.toFloat(), px.toFloat())
            val radius = px * 0.28f
            paint.color = Color.WHITE
            canvas.drawRoundRect(rect, radius, radius, paint)
            paint.xfermode = PorterDuffXfermode(PorterDuff.Mode.SRC_ATOP)
            canvas.drawBitmap(source, Rect(0, 0, source.width, source.height), rect, paint)
            source.recycle()
            return out
        }

        /** Launches MainActivity with a widget link; distinct links give distinct PendingIntents. */
        private fun open(context: Context, link: String): PendingIntent =
            HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse(link))
    }
}

class SubnestWidgetSmall : SubnestWidgetProvider() {
    override val size = Size.SMALL
}

class SubnestWidgetMedium : SubnestWidgetProvider() {
    override val size = Size.MEDIUM
}

class SubnestWidgetLarge : SubnestWidgetProvider() {
    override val size = Size.LARGE
}
