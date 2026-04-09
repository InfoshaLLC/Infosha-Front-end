package com.ktech.infosha

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.TelephonyManager
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.embedding.engine.dart.DartExecutor
import android.app.NotificationManager
import androidx.core.app.NotificationCompat
import android.app.NotificationChannel
import android.app.Service
import android.os.IBinder
import androidx.core.content.ContextCompat
import android.os.Build
import android.app.Notification
import android.content.pm.ServiceInfo
import android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE


class CallDetectionReceiver : BroadcastReceiver() {
    private var methodChannel: MethodChannel? = null
    
    override fun onReceive(context: Context?, intent: Intent?) {
    if (intent?.action == TelephonyManager.ACTION_PHONE_STATE_CHANGED) {
        val state = intent.getStringExtra(TelephonyManager.EXTRA_STATE)
        val phoneNumber = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)

        if (state == TelephonyManager.EXTRA_STATE_RINGING) {
            // Incoming call detected
            // startCallService(context)
            Log.d("CallDetectionReceiver", "Incoming call detected: $phoneNumber")                    
            sendToFlutter(context, "incomingCall", phoneNumber)
        } else if (state == TelephonyManager.EXTRA_STATE_OFFHOOK) {
            // Outgoing call or call answered
            // startCallService(context)
            Log.d("CallDetectionReceiver", "Outgoing call detected: $phoneNumber")
            sendToFlutter(context, "outgoingCall", phoneNumber)            
        } else if (state == TelephonyManager.EXTRA_STATE_IDLE) {
            // Call ended
            Log.d("CallDetectionReceiver", "Call ended: $phoneNumber")
            sendToFlutter(context, "callEnded", phoneNumber)    
            // ✅ Stop the foreground service here
            val stopIntent = Intent(context, CallService::class.java)
            context?.stopService(stopIntent)        
            //val serviceIntent = Intent(context, CallService::class.java)
            //context?.stopService(serviceIntent)

        }
    }
}


   private fun sendToFlutter(context: Context?, method: String, phoneNumber: String?) {
        context?.let {
            val flutterEngine = MainActivity.sharedFlutterEngine
            if (flutterEngine != null) {
                if (methodChannel == null) {
                    methodChannel = MethodChannel(flutterEngine.dartExecutor, "call_detecting")
                }
            }
            methodChannel?.invokeMethod(method, phoneNumber)
        }
    }

    private fun startCallService(context: Context?) {
        context?.let {
            val serviceIntent = Intent(context, CallService::class.java)
            ContextCompat.startForegroundService(context, serviceIntent)
        }
    }


}


class CallService : Service() {

   companion object {
        private const val NOTIFICATION_CHANNEL_ID = "ForegroundServiceChannel"
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (Build.VERSION.SDK_INT >= 34) {
            startForeground(1, createNotification(), FOREGROUND_SERVICE_TYPE_SPECIAL_USE);
        } else {
            startForeground(1, createNotification());
        }
        return START_STICKY
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                "Foreground Service Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle("Foreground Service")
            .setContentText("Service is running in the background")
            .setSmallIcon(R.drawable.ic_notification)
            .build()
    }

    override fun onDestroy() {
        super.onDestroy()
        stopForeground(true)
    }

}

