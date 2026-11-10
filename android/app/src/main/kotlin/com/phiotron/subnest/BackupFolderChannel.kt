package com.phiotron.subnest

import android.app.Activity
import android.app.Application
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.provider.DocumentsContract
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.FileNotFoundException
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

/**
 * Channel `subnest/backup_folder`: writes backup files into a folder the user picked with the
 * Storage Access Framework. No manifest permission, no network; Google Drive, Dropbox… upload the
 * file themselves because they are the folder's document provider.
 *
 * Methods: pickFolder, writeFile, listFiles, deleteFile, releaseFolder.
 * Error codes: permission_denied, folder_missing, busy, bad_args, io_error.
 * All reads/writes run on a background thread; results return on the main thread.
 *
 * Writing is safe when the process is killed mid-way: data goes to a temporary
 * `subnest-auto-tmp-<ms>.part` file (which does NOT match `subnest-auto-YYYYMMDD-HHmm.subnest`
 * that the Dart pruner counts), and only after it is written and closed is it renamed. An old
 * file with the same name is dropped only after the rename succeeded (restored on error).
 * Orphan `.part`/`.old` files older than a day are removed. The app only writes/deletes names
 * matching its own pattern and never touches other files in the folder.
 */
class BackupFolderChannel(
    context: Context,
    hostActivity: Activity?,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {
    /** In the app (has a screen): can open the folder picker. */
    constructor(hostActivity: Activity, messenger: BinaryMessenger) :
        this(hostActivity.applicationContext, hostActivity, messenger)

    companion object {
        const val CHANNEL = "subnest/backup_folder"
        private const val REQUEST_PICK_FOLDER = 4201
        private const val FILE_MIME = "application/octet-stream"
        private const val TMP_PREFIX = "subnest-auto-tmp-"
        private const val ORPHAN_MAX_AGE_MS = 24L * 60 * 60 * 1000

        /** Automatic backup file name set by Dart. */
        private val AUTO_NAME = Regex("^subnest-auto-\\d{8}-\\d{4}\\.subnest$")

        /** Temporary/backup files created by Kotlin; group 1 is the timestamp (ms). */
        private val TMP_NAME = Regex("^subnest-auto-tmp-(\\d{1,19})\\.(part|old)$")

        private fun ownedName(name: String) = AUTO_NAME.matches(name) || TMP_NAME.matches(name)
    }

    // Keep the Activity only for what needs it (opening the picker); reads/writes use the
    // applicationContext so background threads do not hold the Activity. Both are dropped when
    // the Activity is destroyed (see dispose).
    // Background runs (BackupJobService) have no Activity: only write/list/delete, never pick.
    private val appContext: Context = context.applicationContext
    private var activity: Activity? = hostActivity
    private val resolver: ContentResolver get() = appContext.contentResolver
    private val main = Handler(Looper.getMainLooper())
    private val worker: ExecutorService = Executors.newSingleThreadExecutor()
    private val channel = MethodChannel(messenger, CHANNEL)
    private var pendingPick: MethodChannel.Result? = null

    private val lifecycle = object : Application.ActivityLifecycleCallbacks {
        override fun onActivityDestroyed(a: Activity) {
            if (a === activity) dispose()
        }

        override fun onActivityCreated(a: Activity, savedInstanceState: Bundle?) {}
        override fun onActivityStarted(a: Activity) {}
        override fun onActivityResumed(a: Activity) {}
        override fun onActivityPaused(a: Activity) {}
        override fun onActivityStopped(a: Activity) {}
        override fun onActivitySaveInstanceState(a: Activity, outState: Bundle) {}
    }

    init {
        channel.setMethodCallHandler(this)
        if (hostActivity != null) {
            (appContext as? Application)?.registerActivityLifecycleCallbacks(lifecycle)
        }
    }

    /**
     * Called when the Activity is destroyed: stop accepting calls, drop the Activity reference,
     * stop the worker (running work finishes, new work is refused). A new instance is built in
     * `configureFlutterEngine`.
     */
    fun dispose() {
        (appContext as? Application)?.unregisterActivityLifecycleCallbacks(lifecycle)
        channel.setMethodCallHandler(null)
        pendingPick?.error("io_error", "Screen closed", null)
        pendingPick = null
        activity = null
        worker.shutdown()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "pickFolder" -> pickFolder(result)
            "writeFile" -> {
                val tree = call.argument<String>("treeUri")
                val name = call.argument<String>("name")
                val bytes = call.argument<ByteArray>("bytes")
                if (tree == null || name == null || bytes == null || !AUTO_NAME.matches(name)) {
                    result.error("bad_args", "writeFile needs treeUri, a subnest-auto-YYYYMMDD-HHmm.subnest name and bytes", null)
                } else {
                    runAsync(result) { writeFile(Uri.parse(tree), name, bytes) }
                }
            }
            "listFiles" -> {
                val tree = call.argument<String>("treeUri")
                if (tree == null) {
                    result.error("bad_args", "listFiles needs treeUri", null)
                } else {
                    runAsync(result) { listFiles(Uri.parse(tree)).map { it.second } }
                }
            }
            "deleteFile" -> {
                val tree = call.argument<String>("treeUri")
                val name = call.argument<String>("name")
                // Only delete files matching this app's name: never touch other user files.
                if (tree == null || name == null || !ownedName(name)) {
                    result.error("bad_args", "deleteFile needs treeUri and a Subnest file name", null)
                } else {
                    runAsync(result) { deleteFile(Uri.parse(tree), name) }
                }
            }
            "releaseFolder" -> {
                val tree = call.argument<String>("treeUri")
                if (tree == null) {
                    result.error("bad_args", "releaseFolder needs treeUri", null)
                } else {
                    runAsync(result) { releaseFolder(Uri.parse(tree)) }
                }
            }
            else -> result.notImplemented()
        }
    }

    /** Passes the folder-picker result from `Activity.onActivityResult`; true if handled. */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_PICK_FOLDER) return false
        val result = pendingPick ?: return true
        pendingPick = null
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            result.success(null)
            return true
        }
        try {
            // Keep read+write across app restarts and reboots.
            resolver.takePersistableUriPermission(
                uri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION,
            )
            result.success(mapOf("uri" to uri.toString(), "name" to folderName(uri)))
        } catch (e: SecurityException) {
            result.error("permission_denied", "Could not keep write access to the folder", null)
        } catch (e: Exception) {
            result.error("io_error", e.message, null)
        }
        return true
    }

    private fun pickFolder(result: MethodChannel.Result) {
        if (pendingPick != null) {
            result.error("busy", "Folder picker already open", null)
            return
        }
        val host = activity
        if (host == null) {
            result.error("io_error", "Screen closed", null)
            return
        }
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).addFlags(
            Intent.FLAG_GRANT_READ_URI_PERMISSION or
                Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION or
                Intent.FLAG_GRANT_PREFIX_URI_PERMISSION,
        )
        pendingPick = result
        try {
            @Suppress("DEPRECATION")
            host.startActivityForResult(intent, REQUEST_PICK_FOLDER)
        } catch (e: Exception) {
            // No folder picker on this device.
            pendingPick = null
            result.error("io_error", e.message, null)
        }
    }

    private fun runAsync(result: MethodChannel.Result, block: () -> Any?) {
        if (worker.isShutdown) {
            result.error("io_error", "Screen closed", null)
            return
        }
        worker.execute {
            try {
                // A function returning nothing yields kotlin.Unit; StandardMessageCodec cannot
                // encode Unit and throws on the main thread → the app crashed after every
                // successful automatic backup (D9, Galaxy A13 2026-11-05).
                val value = block().let { if (it == Unit) null else it }
                main.post { result.success(value) }
            } catch (e: SecurityException) {
                main.post { result.error("permission_denied", e.message, null) }
            } catch (e: FileNotFoundException) {
                main.post { result.error("folder_missing", e.message, null) }
            } catch (e: IllegalArgumentException) {
                // The document provider reports that the folder is gone.
                main.post { result.error("folder_missing", e.message, null) }
            } catch (e: Exception) {
                main.post { result.error("io_error", e.message, null) }
            }
        }
    }

    /** Whether write access to [tree] is still held (the user may revoke it in system settings). */
    private fun requireWritePermission(tree: Uri) {
        val ok = resolver.persistedUriPermissions.any { it.uri == tree && it.isWritePermission }
        if (!ok) throw SecurityException("Write access to the folder was revoked")
    }

    private fun rootDocument(tree: Uri): Uri =
        DocumentsContract.buildDocumentUriUsingTree(tree, DocumentsContract.getTreeDocumentId(tree))

    private fun docUri(tree: Uri, id: String): Uri =
        DocumentsContract.buildDocumentUriUsingTree(tree, id)

    private fun folderName(tree: Uri): String? {
        val cursor = resolver.query(
            rootDocument(tree),
            arrayOf(DocumentsContract.Document.COLUMN_DISPLAY_NAME),
            null,
            null,
            null,
        ) ?: return null
        cursor.use { return if (it.moveToFirst()) it.getString(0) else null }
    }

    /** (document id, display name) of the folder's direct children. */
    private fun listFiles(tree: Uri): List<Pair<String, String>> {
        requireWritePermission(tree)
        val children = DocumentsContract.buildChildDocumentsUriUsingTree(
            tree,
            DocumentsContract.getTreeDocumentId(tree),
        )
        val cursor = resolver.query(
            children,
            arrayOf(
                DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                DocumentsContract.Document.COLUMN_DISPLAY_NAME,
            ),
            null,
            null,
            null,
        ) ?: throw FileNotFoundException("Could not open the folder")
        val out = ArrayList<Pair<String, String>>()
        cursor.use {
            while (it.moveToNext()) out.add(Pair(it.getString(0), it.getString(1)))
        }
        return out
    }

    /** Renames a document; throws if the provider cannot. Returns the new Uri. */
    private fun rename(doc: Uri, newName: String): Uri =
        DocumentsContract.renameDocument(resolver, doc, newName)
            ?: throw FileNotFoundException("Could not rename the file in the folder")

    private fun deleteQuietly(doc: Uri) {
        try {
            DocumentsContract.deleteDocument(resolver, doc)
        } catch (_: Exception) {
        }
    }

    private fun writeFile(tree: Uri, name: String, bytes: ByteArray) {
        val stamp = System.currentTimeMillis()
        val parent = rootDocument(tree)
        // 1) Write all data to a temporary file, then close the stream. If killed mid-way only
        //    a `.part` file remains (does not match the name pattern, so not counted by the
        //    pruner; cleaned after a day).
        val tmp = DocumentsContract.createDocument(resolver, parent, FILE_MIME, "$TMP_PREFIX$stamp.part")
            ?: throw FileNotFoundException("Could not create a file in the folder")
        try {
            val stream = resolver.openOutputStream(tmp, "wt")
                ?: throw FileNotFoundException("Could not open the file for writing")
            stream.use {
                it.write(bytes)
                it.flush()
            }
            // 2) Same name (two backups in one minute): move the old one to a backup name (the
            //    provider does not auto-rename to "(1)"), rename the temp file to the target;
            //    only on success drop the old file, on error restore the old file.
            val existing = listFiles(tree).filter { it.second == name }
            var backedUp: Uri? = null
            for ((i, e) in existing.withIndex()) {
                val old = docUri(tree, e.first)
                if (i == 0) {
                    backedUp = rename(old, "$TMP_PREFIX$stamp.old")
                } else {
                    DocumentsContract.deleteDocument(resolver, old)
                }
            }
            try {
                rename(tmp, name)
            } catch (e: Exception) {
                if (backedUp != null) {
                    try {
                        rename(backedUp, name)
                    } catch (_: Exception) {
                    }
                }
                throw e
            }
            if (backedUp != null) deleteQuietly(backedUp)
        } catch (e: Exception) {
            // On any error drop the temp file (if already renamed the old Uri is gone: harmless).
            deleteQuietly(tmp)
            throw e
        }
        cleanOrphans(tree, stamp)
    }

    /** Removes orphan `.part`/`.old` files older than a day; only touches this app's temp names. */
    private fun cleanOrphans(tree: Uri, now: Long) {
        try {
            for ((id, display) in listFiles(tree)) {
                val m = TMP_NAME.matchEntire(display) ?: continue
                val ts = m.groupValues[1].toLongOrNull() ?: continue
                if (now - ts > ORPHAN_MAX_AGE_MS) deleteQuietly(docUri(tree, id))
            }
        } catch (_: Exception) {
            // Clean-up never spoils a write that finished.
        }
    }

    private fun deleteFile(tree: Uri, name: String) {
        for ((id, display) in listFiles(tree)) {
            if (display == name) {
                DocumentsContract.deleteDocument(resolver, docUri(tree, id))
            }
        }
    }

    private fun releaseFolder(tree: Uri) {
        try {
            resolver.releasePersistableUriPermission(
                tree,
                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION,
            )
        } catch (_: SecurityException) {
            // Permission was already lost: treat as released.
        }
    }
}
