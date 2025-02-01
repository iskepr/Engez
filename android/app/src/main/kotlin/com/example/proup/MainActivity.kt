package com.example.proup

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
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    private fun getInstalledUserApps(): List<Map<String, String>> {
        val apps = mutableListOf<Map<String, String>>()
        val packageManager: PackageManager = packageManager
        val packages: List<ApplicationInfo> =
            packageManager.getInstalledApplications(PackageManager.GET_META_DATA)

        for (appInfo in packages) {
            if (appInfo.flags and ApplicationInfo.FLAG_SYSTEM == 0) { // فقط التطبيقات غير النظامية
                val appName = packageManager.getApplicationLabel(appInfo).toString()
                val packageName = appInfo.packageName
                apps.add(mapOf("name" to appName, "package" to packageName))
            }
        }
        return apps
    }
}
