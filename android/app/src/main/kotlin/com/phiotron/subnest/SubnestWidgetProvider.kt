package com.phiotron.subnest

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Bundle
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
 * Home-screen widgets (S11, product.md §10.7, mockups v13 89/91/92) — one provider per size so the
 * picker offers three widgets:
 * - [SubnestWidgetSmall] 2×2: the next subscription (tile, "Next", name, days left, price);
 * - [SubnestWidgetMedium] 4×2: "Upcoming", the next rows, monthly total;
 * - [SubnestWidgetLarge] 4×4: "This month", monthly total, awaiting badge, the next rows.
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

    /** Locked, empty, or nothing written yet (widget added before the app's first run). */
    private fun message(context: Context, s: JSONObject?): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_message)
        val title: String
        var body: String? = null
        when (s?.optString("state")) {
            "locked" -> {
                title = s.optString("locked")
                views.setImageViewResource(R.id.widget_msg_icon, R.drawable.widget_ic_lock)
            }
            "empty", "list" -> {
                title = s.optString("emptyTitle").ifEmpty { context.getString(R.string.widget_open_app) }
                body = s.optString("emptyBody").ifEmpty { null }
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
        views.setOnClickPendingIntent(R.id.widget_root, open(context, OVERVIEW))
        return views
    }

    private fun small(context: Context, s: JSONObject, item: JSONObject, today: LocalDate): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_small)
        views.setTextViewText(R.id.widget_title, s.optString("next"))
        val (whenText, awaiting) = dueText(s, item, today)
        val withTrial =
            if (!awaiting && item.optBoolean("trial")) "$whenText · ${s.optString("firstCharge")}" else whenText
        fillItem(views, item, withTrial, awaiting)
        views.setContentDescription(
            R.id.widget_root,
            listOf(s.optString("next"), item.optString("name"), item.optString("price"), withTrial).joinToString(", "),
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
        views.setOnClickPendingIntent(R.id.widget_total, overview)

        views.setTextViewText(R.id.widget_title, s.optString(if (large) "title" else "upcoming"))
        views.setTextViewText(R.id.widget_total, s.optString(if (large) "total" else "totalPerMonth"))
        views.setContentDescription(R.id.widget_total, s.optString("totalA11y"))
        if (large) {
            val badge = s.optString("badge")
            if (badge.isNotEmpty()) {
                views.setTextViewText(R.id.widget_badge_text, badge)
                views.setViewVisibility(R.id.widget_badge, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.widget_badge, View.GONE)
            }
        }

        views.removeAllViews(R.id.widget_rows)
        val count = minOf(items.length(), rowsThatFit(options))
        for (i in 0 until count) {
            val item = items.getJSONObject(i)
            val row = RemoteViews(context.packageName, R.layout.widget_row)
            val (whenText, awaiting) = dueText(s, item, today)
            // Rows show the date; the awaiting ones say "To confirm" instead (mockup 92).
            fillItem(row, item, if (awaiting) whenText else item.optString("date"), awaiting)
            row.setContentDescription(
                R.id.row_root,
                listOf(item.optString("name"), item.optString("price"), if (awaiting) whenText else item.optString("date"))
                    .joinToString(", "),
            )
            row.setOnClickPendingIntent(R.id.row_root, open(context, subscriptionLink(item.optString("id"))))
            views.addView(R.id.widget_rows, row)
        }
        return views
    }

    /** Fills the tile, name, when line (normal or awaiting colour) and price of one item. */
    private fun fillItem(views: RemoteViews, item: JSONObject, whenText: String, awaiting: Boolean) {
        views.setInt(R.id.row_tile, "setColorFilter", item.optInt("color", DEFAULT_TILE))
        views.setTextViewText(R.id.row_mono, item.optString("mono"))
        views.setTextColor(R.id.row_mono, item.optInt("onColor", DEFAULT_ON_TILE))
        views.setTextViewText(R.id.row_name, item.optString("name"))
        views.setTextViewText(R.id.row_price, item.optString("price"))
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
    private fun rowsThatFit(options: Bundle?): Int {
        val height = options?.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT, 0) ?: 0
        val fallback = if (size == Size.LARGE) 5 else 2
        if (height <= 0) return fallback
        val chrome = if (size == Size.LARGE) LARGE_CHROME_DP else MEDIUM_CHROME_DP
        return ((height - chrome) / ROW_DP).coerceIn(1, 5)
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
        private const val DEFAULT_TILE = 0xFF2D3438.toInt()
        private const val DEFAULT_ON_TILE = 0xFFFFFFFF.toInt()
        private const val ROW_DP = 42
        private const val MEDIUM_CHROME_DP = 22 + 24 + 24
        private const val LARGE_CHROME_DP = 26 + 24 + 40

        private fun readSnapshot(prefs: SharedPreferences): JSONObject? =
            prefs.getString(KEY, null)?.let { runCatching { JSONObject(it) }.getOrNull() }

        private fun subscriptionLink(id: String) =
            "subnest://widget/subscription/${Uri.encode(id)}?homeWidget"

        /**
         * "To confirm" when the Due date has come (as the app: due date ≤ today awaits), else
         * "Tomorrow" / "In N days". Returns the text and whether it is the awaiting state.
         */
        private fun dueText(s: JSONObject, item: JSONObject, today: LocalDate): Pair<String, Boolean> {
            val due = runCatching { LocalDate.parse(item.optString("due")) }.getOrNull()
                ?: return item.optString("date") to false
            val days = ChronoUnit.DAYS.between(today, due)
            return when {
                days <= 0 -> s.optString("awaiting") to true
                days == 1L -> s.optString("tomorrow") to false
                else -> s.optString("inDays").replace("{n}", days.toString()) to false
            }
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
