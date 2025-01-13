package com.example.proup

import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.proup/installed_apps"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInstalledApps" -> {
                        val apps = getInstalledUserApps()
                        result.success(apps)
                    }
                    "openDefaultAppsSettings" -> {
                        openDefaultAppsSettings()
                        result.success(null)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    private fun getInstalledUserApps(): List<String> {
        val apps = mutableListOf<String>()
        val packageManager: PackageManager = packageManager
        val packages: List<ApplicationInfo> = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)

        for (appInfo in packages) {
            // تحقق إذا كان التطبيق ليس نظاميًا
            if (appInfo.flags and ApplicationInfo.FLAG_SYSTEM == 0) {
                apps.add(packageManager.getApplicationLabel(appInfo).toString())
            }
        }
        return apps
    }

    private fun openDefaultAppsSettings() {
        val intent = Intent("android.settings.MANAGE_DEFAULT_APPS_SETTINGS")
        startActivity(intent)
    }
}
