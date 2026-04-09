package com.ktech.infosha

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.localbroadcastmanager.content.LocalBroadcastManager

class RatingNotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val imageId = intent.getIntExtra("imageId", -1)
        val rating = intent.getIntExtra("rating", -1)
        val isAnonymous = intent.getBooleanExtra("isAnonymous", false)
        val userId = intent.getStringExtra("userId").orEmpty()
        val notificationId = intent.getIntExtra("notificationId", -1)
        val title = intent.getStringExtra("title").orEmpty()
        val description = intent.getStringExtra("description").orEmpty()
        val isDone = intent.getBooleanExtra("isDone", false)

        if (isDone) {
            (context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).cancel(notificationId)

            //Send Rating Notification Data
            val intent2 = Intent()
            intent2.action = "Rating Notification Done Callback"
            intent2.putExtra("rating", rating)
            intent2.putExtra("isAnonymous", isAnonymous)
            intent2.putExtra("userId", userId)
            LocalBroadcastManager.getInstance(context).sendBroadcast(intent2)
        } else {
            RatingNotificationHelper(context).updateNotification(imageId, isAnonymous, title, description, userId, notificationId)
        }
    }
}