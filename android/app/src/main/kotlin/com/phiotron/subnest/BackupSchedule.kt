package com.phiotron.subnest

import android.app.AlarmManager
import android.app.PendingIntent
import android.app.job.JobInfo
import android.app.job.JobParameters
import android.app.job.JobScheduler
import android.app.job.JobService
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar
import java.util.TimeZone

/**
 * Automatic backup at the time the user chose, the part of Android that runs while the app is
 * CLOSED.
 *
 * Chain: Dart sends the time over `subnest/backup_schedule` → [BackupAlarm.save] stores it (not
 * secret) in its own SharedPreferences and sets an INEXACT `setAndAllowWhileIdle` alarm (runs in
 * Doze too; the system may delay it by a few minutes; no exact-alarm permission) → the alarm
 * fires, [BackupAlarmReceiver] immediately sets tomorrow's alarm (the chain does not depend on
 * Dart) and queues [BackupJobService] (expedited on Android 12+) → the job builds a headless
 * FlutterEngine and runs `autoBackupBackgroundMain` (lib/main.dart): opens the DB, reads the
 * password from Keystore, encrypts, writes through SAF using the same `AutoBackupService` (once
 * per slot, only when data changed, keeps 2 files).
 *
 * Reboot, app update, time or time-zone change: [BackupAlarmReceiver] recomputes the slot in the
 * new local time. No new permission: RECEIVE_BOOT_COMPLETED already exists; JobScheduler and
 * AlarmManager need no manifest permission. No new library.
 */
object BackupAlarm {
    const val SCHEDULE_CHANNEL = "subnest/backup_schedule"
    const val ACTION_FIRE = "com.phiotron.subnest.action.AUTO_BACKUP_ALARM"
    const val JOB_ID = 4302
    private const val REQUEST_CODE = 4301
    private const val PREFS = "subnest_auto_backup_schedule"
    private const val KEY_ENABLED = "enabled"
    private const val KEY_HOUR = "hour"
    private const val KEY_MINUTE = "minute"

    private fun prefs(ctx: Context) = ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    fun isEnabled(ctx: Context) = prefs(ctx).getBoolean(KEY_ENABLED, false)

    /** Stores the time and sets the next alarm (replaces the old one with the same PendingIntent). */
    fun save(ctx: Context, hour: Int, minute: Int) {
        prefs(ctx).edit()
            .putBoolean(KEY_ENABLED, true)
            .putInt(KEY_HOUR, hour)
            .putInt(KEY_MINUTE, minute)
            .apply()
        scheduleNext(ctx)
    }

    /** Turns it off: clears the time, cancels the alarm and any queued job. */
    fun disable(ctx: Context) {
        prefs(ctx).edit().clear().apply()
        try {
            ctx.getSystemService(AlarmManager::class.java)?.cancel(pendingIntent(ctx))
        } catch (_: Exception) {}
        try {
            ctx.getSystemService(JobScheduler::class.java)?.cancel(JOB_ID)
        } catch (_: Exception) {}
    }

    /**
     * The next slot at [hour]:[minute] in [zone], strictly after [nowMillis]. Calendar pushes a
     * nonexistent time (DST jump) past the gap.
     */
    fun nextTrigger(nowMillis: Long, hour: Int, minute: Int, zone: TimeZone): Long {
        val cal = Calendar.getInstance(zone).apply {
            timeInMillis = nowMillis
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        if (cal.timeInMillis <= nowMillis) {
            cal.add(Calendar.DAY_OF_MONTH, 1)
            cal.set(Calendar.HOUR_OF_DAY, hour)
            cal.set(Calendar.MINUTE, minute)
        }
        return cal.timeInMillis
    }

    /** Sets the next alarm if enabled. [zone]: the new time zone right after a change. */
    fun scheduleNext(ctx: Context, zone: TimeZone = TimeZone.getDefault()) {
        val p = prefs(ctx)
        if (!p.getBoolean(KEY_ENABLED, false)) return
        val at = nextTrigger(
            System.currentTimeMillis(),
            p.getInt(KEY_HOUR, 21),
            p.getInt(KEY_MINUTE, 0),
            zone,
        )
        try {
            // INEXACT (no exact-alarm permission): may arrive a few minutes late.
            ctx.getSystemService(AlarmManager::class.java)
                ?.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, at, pendingIntent(ctx))
        } catch (_: Exception) {
            // The system refused: the open/resume catch-up still works.
        }
    }

    private fun pendingIntent(ctx: Context): PendingIntent = PendingIntent.getBroadcast(
        ctx,
        REQUEST_CODE,
        Intent(ctx, BackupAlarmReceiver::class.java).setAction(ACTION_FIRE),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )

    /** Queues the backup job to run now: expedited (Android 12+), normal job if over quota. */
    fun startJob(ctx: Context) {
        val js = ctx.getSystemService(JobScheduler::class.java) ?: return
        val component = ComponentName(ctx, BackupJobService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            try {
                val job = JobInfo.Builder(JOB_ID, component).setExpedited(true).build()
                if (js.schedule(job) == JobScheduler.RESULT_SUCCESS) return
            } catch (_: Exception) {}
        }
        try {
            js.schedule(JobInfo.Builder(JOB_ID, component).setOverrideDeadline(60_000).build())
        } catch (_: Exception) {}
    }

    /** In-app channel: Dart schedules/cancels. */
    fun registerChannel(messenger: BinaryMessenger, ctx: Context) {
        val app = ctx.applicationContext
        MethodChannel(messenger, SCHEDULE_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "schedule" -> {
                    val hour = call.argument<Int>("hour")
                    val minute = call.argument<Int>("minute")
                    if (hour == null || minute == null || hour !in 0..23 || minute !in 0..59) {
                        result.error("bad_args", "schedule needs hour 0..23 and minute 0..59", null)
                    } else {
                        save(app, hour, minute)
                        result.success(null)
                    }
                }
                "cancel" -> {
                    disable(app)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}

/**
 * Receives the backup alarm (explicit intent, no filter needed) and system events that drop or
 * shift alarms: reboot, app update, time change, time-zone change. `exported="false"`: only the
 * system can send these.
 */
class BackupAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            BackupAlarm.ACTION_FIRE -> {
                // Set tomorrow's alarm BEFORE running: a Dart error or a killed process does not
                // break the chain.
                BackupAlarm.scheduleNext(context)
                if (BackupAlarm.isEnabled(context)) BackupAlarm.startJob(context)
            }
            Intent.ACTION_TIMEZONE_CHANGED -> {
                val zone = intent.getStringExtra("time-zone")?.let { TimeZone.getTimeZone(it) }
                BackupAlarm.scheduleNext(context, zone ?: TimeZone.getDefault())
            }
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_MY_PACKAGE_REPLACED,
            Intent.ACTION_TIME_CHANGED,
            "android.intent.action.QUICKBOOT_POWERON",
            "com.htc.intent.action.QUICKBOOT_POWERON",
            -> BackupAlarm.scheduleNext(context)
        }
    }
}

/**
 * Runs a backup while the app is closed: builds a headless FlutterEngine (plugins register
 * themselves: Keystore via flutter_secure_storage, database path…), attaches
 * [BackupFolderChannel] without an Activity and runs `autoBackupBackgroundMain`. Dart reports
 * `done` over `subnest/backup_job`; the job then finishes and destroys the engine. After
 * [TIMEOUT_MS] it also finishes. If the system stops the job, nothing is rescheduled (the next
 * open/leave of the app catches up).
 */
class BackupJobService : JobService() {
    companion object {
        const val JOB_CHANNEL = "subnest/backup_job"
        const val ENTRYPOINT = "autoBackupBackgroundMain"
        private const val TIMEOUT_MS = 9L * 60 * 1000
    }

    private val main = Handler(Looper.getMainLooper())
    private var engine: FlutterEngine? = null
    private var folder: BackupFolderChannel? = null
    private var params: JobParameters? = null
    private val timeout = Runnable { finish() }

    override fun onStartJob(params: JobParameters): Boolean {
        if (this.params != null) return false
        this.params = params
        return try {
            val loader = FlutterInjector.instance().flutterLoader()
            loader.startInitialization(applicationContext)
            loader.ensureInitializationCompleteAsync(applicationContext, null, main) {
                startDart(loader.findAppBundlePath())
            }
            main.postDelayed(timeout, TIMEOUT_MS)
            true
        } catch (_: Exception) {
            this.params = null
            false
        }
    }

    private fun startDart(bundlePath: String) {
        if (params == null) return // stopped while Flutter was loading
        try {
            val e = FlutterEngine(applicationContext)
            engine = e
            val messenger = e.dartExecutor.binaryMessenger
            folder = BackupFolderChannel(applicationContext, null, messenger)
            MethodChannel(messenger, JOB_CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "done") {
                    // Only the result name (ok, failed…; null = not due / data unchanged), never
                    // data or the password. Inspect: adb logcat -s SubnestBackup
                    Log.i("SubnestBackup", "scheduled backup result=${call.arguments}")
                    result.success(null)
                    main.post { finish() }
                } else {
                    result.notImplemented()
                }
            }
            e.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint(bundlePath, ENTRYPOINT),
            )
        } catch (_: Exception) {
            finish()
        }
    }

    private fun finish() {
        main.removeCallbacks(timeout)
        val p = params
        params = null
        cleanUp()
        if (p != null) jobFinished(p, false)
    }

    private fun cleanUp() {
        folder?.dispose()
        folder = null
        engine?.destroy()
        engine = null
    }

    override fun onStopJob(params: JobParameters): Boolean {
        main.removeCallbacks(timeout)
        this.params = null
        cleanUp()
        return false
    }

    override fun onDestroy() {
        main.removeCallbacks(timeout)
        cleanUp()
        super.onDestroy()
    }
}
