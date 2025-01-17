package  com.waiver.driver

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    val channelName = "com.waiver.driver/overlay";

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "test" -> {
                    // Handle the "test" method here
                    result.success("test")
                }
                else -> result.notImplemented()
            }
        }
    }
}

//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.plugin.common.MethodCall
//import io.flutter.plugin.common.MethodChannel
//import io.flutter.embedding.engine.FlutterEngine
//import androidx.annotation.NonNull
//import android.app.*
//import android.content.*
//import android.graphics.*
//import android.os.*
//import android.view.*
//import android.widget.*
//import androidx.annotation.*
//import io.flutter.embedding.android.*
//
//class MainActivity: FlutterActivity() {
//
//    private val overlayChannel = "com.waiver.driver/overlay"
//
//    private var overlayView: View? = null
//
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, overlayChannel)
//            .setMethodCallHandler { call: MethodCall?, result: MethodChannel.Result? ->
//
//                if (call?.method == "showOverlay") {
//                    println("vz")
////                    showOverlay()
//                    println("vz")
//                    result?.success(null)
//                }
//                else if(call?.method == "close")
//                {
////                    closeSystemOverlay()
//                }
//                else {
//                    result?.notImplemented()
//                }
//            }
//    }
//
//    private fun showOverlay() {
//        val inflater = getSystemService(LAYOUT_INFLATER_SERVICE) as LayoutInflater
//        overlayView = inflater.inflate(R.layout.overlay_layout, null)
//
//        val overlayLayoutParams = FrameLayout.LayoutParams(
//            FrameLayout.LayoutParams.MATCH_PARENT,
//            FrameLayout.LayoutParams.WRAP_CONTENT,
//            Gravity.BOTTOM
//        )
//
//        val mainLayout = findViewById<ViewGroup>(android.R.id.content) // Main activity content view
//        mainLayout.addView(overlayView, overlayLayoutParams)
//    }
//
//
////    override fun onDestroy() {
////        // Remove overlay when the activity is destroyed
////        val windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
////        if (overlayView != null) {
////            windowManager.removeView(overlayView)
////            overlayView = null
////        }
////        super.onDestroy()
////    }
//
////    private fun closeSystemOverlay() {
////        val windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
////        if (overlayView != null) {
////            windowManager.removeView(overlayView)
////            overlayView = null
////        }
////    }
//
//}