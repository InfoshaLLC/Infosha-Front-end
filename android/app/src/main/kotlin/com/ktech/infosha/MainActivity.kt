package com.ktech.infosha

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.random.Random

class MainActivity : FlutterActivity() {
    private val CHANNEL_ID = "custom_notification"
    private val CHANNEL_NAME = "Custom Notification"
    private val CHANNEL_DESCRIPTION = "Custom notifications for rating"
    private var rating = 0
    private var isAnonymous = false
    private var userId = ""

    private lateinit var methodChannel: MethodChannel

    companion object {
        var sharedFlutterEngine: FlutterEngine? = null
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        sharedFlutterEngine = flutterEngine

        // Initialize the MethodChannel
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "custom_notifications"
        )

        methodChannel.setMethodCallHandler { call, result ->
            if (call.method == "showCustomNotification") {
                val param1 = call.argument<String>("param1") ?: "Title"
                val param2 = call.argument<String>("param2") ?: "Description"
                val param3 = call.argument<String>("param3") ?: "Description"

                // Show the notification
                RatingNotificationHelper(this).showNotification(
                    param1,
                    param2,
                    param3,
                    Random.nextInt(10000)
                )

                // Register the BroadcastReceiver for the callback
                val intentFilter = IntentFilter()
                intentFilter.addAction("Rating Notification Done Callback")
                LocalBroadcastManager.getInstance(this)
                    .registerReceiver(getRatingNotificationDoneCallback, intentFilter)

                result.success("Notification sent successfully")
            } else {
                result.notImplemented()
            }
        }
    }

    // BroadcastReceiver to handle rating callback
    private val getRatingNotificationDoneCallback: BroadcastReceiver =
        object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                rating = intent?.getIntExtra("rating", -1) ?: 0
                isAnonymous = intent?.getBooleanExtra("isAnonymous", false) ?: false
                userId = intent?.getStringExtra("userId").orEmpty()

                Log.e("TAG", "onReceive: $rating === $isAnonymous === $userId")

                // Send the data back to Flutter using the MethodChannel
                val map = mapOf(
                    "rating" to rating,
                    "isAnonymous" to isAnonymous,
                    "userId" to userId
                )
                methodChannel.invokeMethod("ratingCallback", map)
            }
        }

    override fun onDestroy() {
        try {
            LocalBroadcastManager.getInstance(this)
                .unregisterReceiver(getRatingNotificationDoneCallback)
        } catch (e: Exception) {
            e.printStackTrace()
        }
        super.onDestroy()
    }
}
