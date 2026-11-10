package com.phiotron.subnest

import android.content.Intent
import android.os.Bundle
import android.view.WindowManager
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var backupFolder: BackupFolderChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        // Home-screen widget tap (SubnestWidgetProvider.kt): Dart reads the link from this intent once
        // (`HomeWidget.initiallyLaunchedFromHomeWidget`). Reopened from Recents, or rebuilt after the
        // process died, the system hands back the same intent: drop the link so the old screen is not
        // opened again.
        val fromHistory = intent.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY != 0
        if ((fromHistory || savedInstanceState != null) &&
            intent.action == HomeWidgetLaunchIntent.HOME_WIDGET_LAUNCH_ACTION
        ) {
            intent = Intent(intent).setAction(Intent.ACTION_MAIN).setData(null)
        }
        super.onCreate(savedInstanceState)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // Widget tap while the task exists but the process was killed: the system rebuilds this
        // activity with its old intent, then delivers the tap here — before Dart listens to
        // `HomeWidget.widgetClicked`. Keep it as the current intent so Dart's start-up read
        // (`initiallyLaunchedFromHomeWidget`) still finds the link. Dart ignores a repeat of the
        // same link that arrives twice (stream + start-up read).
        if (intent.action == HomeWidgetLaunchIntent.HOME_WIDGET_LAUNCH_ACTION) setIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        backupFolder = BackupFolderChannel(this, messenger)
        BackupAlarm.registerChannel(messenger, this)
        // Privacy screen: FLAG_SECURE blocks screenshots and hides the app in Recents.
        MethodChannel(messenger, "subnest/secure").setMethodCallHandler { call, result ->
            if (call.method != "setSecure") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            when (call.arguments as? Boolean) {
                true -> window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                false -> window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                null -> {
                    result.error("bad_args", "setSecure needs true/false", null)
                    return@setMethodCallHandler
                }
            }
            result.success(null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (backupFolder?.onActivityResult(requestCode, resultCode, data) == true) return
        super.onActivityResult(requestCode, resultCode, data)
    }

    override fun onDestroy() {
        backupFolder?.dispose()
        backupFolder = null
        super.onDestroy()
    }
}
