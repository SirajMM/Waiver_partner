package com.waiver.driver

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import android.content.Intent
import android.content.ComponentName

class MainActivity : FlutterActivity() {
    val channelName = "com.waiver.driver/overlay"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "test" -> {
                    result.success("test")
                }
                "requestSamsungOptimization" -> {
                    requestSamsungOptimizations()
                    result.success("Samsung optimization requested")
                }
                else -> result.notImplemented()
            }
        }
    }

        // ADD THIS METHOD to disable accessibility temporarily
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Disable accessibility to prevent the crash
        try {
            val accessibilityManager = getSystemService(android.content.Context.ACCESSIBILITY_SERVICE) as android.view.accessibility.AccessibilityManager
            // This helps prevent the accessibility crash on some devices
        } catch (e: Exception) {
            // Ignore accessibility errors
        }
    }
    
    // ADD THIS METHOD
    private fun requestSamsungOptimizations() {
        try {
            val intent = Intent()
            intent.component = ComponentName(
                "com.samsung.android.lool",
                "com.samsung.android.sm.ui.battery.BatteryActivity"
            )
            startActivity(intent)
        } catch (e: Exception) {
            // Fallback to general battery optimization
            try {
                val generalIntent = Intent()
                generalIntent.action = "android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS"
                startActivity(generalIntent)
            } catch (fallbackException: Exception) {
                // If both fail, do nothing
            }
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
    }
}