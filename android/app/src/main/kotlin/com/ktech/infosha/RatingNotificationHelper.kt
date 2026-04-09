package com.ktech.infosha

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.view.View
import android.widget.RemoteViews
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.ktech.infosha.R

class RatingNotificationHelper(private val context: Context) {

    private val channelId = "rating_notification_channel"
    private val remoteViewsSmall = RemoteViews(context.packageName, R.layout.layout_rating_notification_small)
    private val remoteViews = RemoteViews(context.packageName, R.layout.layout_rating_notification)

    init {
        createNotificationChannel()
    }

    private fun createNotificationChannel() {
        val channel = NotificationChannel(channelId, "Rating Notification Channel", NotificationManager.IMPORTANCE_HIGH)
        val manager = context.getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(channel)
    }

    fun showNotification(title: String, description: String, userId: String, notificationId: Int) {
        val intents = arrayOf(
            Intent(context, RatingNotificationReceiver::class.java).apply {
                putExtra("imageId", 1)
                putExtra("isAnonymous", true)
                putExtra("notificationId", notificationId)
                putExtra("title", title)
                putExtra("description", description)
                putExtra("userId", userId)
            },
            Intent(context, RatingNotificationReceiver::class.java).apply {
                putExtra("imageId", 2)
                putExtra("isAnonymous", true)
                putExtra("notificationId", notificationId)
                putExtra("title", title)
                putExtra("description", description)
                putExtra("userId", userId)
            },
            Intent(context, RatingNotificationReceiver::class.java).apply {
                putExtra("imageId", 3)
                putExtra("isAnonymous", true)
                putExtra("notificationId", notificationId)
                putExtra("title", title)
                putExtra("description", description)
                putExtra("userId", userId)
            },
            Intent(context, RatingNotificationReceiver::class.java).apply {
                putExtra("imageId", 4)
                putExtra("isAnonymous", true)
                putExtra("notificationId", notificationId)
                putExtra("title", title)
                putExtra("description", description)
                putExtra("userId", userId)
            },
            Intent(context, RatingNotificationReceiver::class.java).apply {
                putExtra("imageId", 5)
                putExtra("isAnonymous", true)
                putExtra("notificationId", notificationId)
                putExtra("title", title)
                putExtra("description", description)
                putExtra("userId", userId)
            },
            Intent(context, RatingNotificationReceiver::class.java).apply {
                putExtra("isAnonymous", true)
                putExtra("notificationId", notificationId)
                putExtra("title", title)
                putExtra("description", description)
                putExtra("userId", userId)
            },
            Intent(context, RatingNotificationReceiver::class.java).apply {
                putExtra("isAnonymous", false)
                putExtra("notificationId", notificationId)
                putExtra("title", title)
                putExtra("description", description)
                putExtra("userId", userId)
            }
        )

        val imageIds = arrayOf(R.id.image1, R.id.image2, R.id.image3, R.id.image4, R.id.image5, R.id.lnAnonymous, R.id.lnNonAnonymous)
        intents.forEachIndexed { index, intent ->
            val pendingIntent = PendingIntent.getBroadcast(context, index, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            remoteViews.setOnClickPendingIntent(imageIds[index], pendingIntent)
        }

        remoteViews.setTextViewText(R.id.txtTitle, title)
        remoteViews.setTextViewText(R.id.txtDescription, description)
        remoteViews.setImageViewResource(R.id.imgAnonymous, R.drawable.ic_radio_button_checked)
        remoteViews.setImageViewResource(R.id.imgNonAnonymous, R.drawable.ic_radio_button_unchecked)

        remoteViewsSmall.setTextViewText(R.id.txtTitle, title)
        remoteViewsSmall.setTextViewText(R.id.txtDescription, description)

        val notification = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(R.drawable.app_icon)
            .setCustomContentView(remoteViewsSmall)
            .setCustomBigContentView(remoteViews)
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()

        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
            return
        }
        NotificationManagerCompat.from(context).notify(notificationId, notification)
    }

    fun updateNotification(imageId: Int, isAnonymous: Boolean, title: String, description: String, userId: String, notificationId: Int) {
        val intents = arrayOf(
            Intent(context, RatingNotificationReceiver::class.java).apply {
                putExtra("imageId", 1)
                putExtra("isAnonymous", isAnonymous)
                putExtra("notificationId", notificationId)
                putExtra("title", title)
                putExtra("description", description)
                putExtra("userId", userId)
                putExtra("rating", imageId)
            },
            Intent(context, RatingNotificationReceiver::class.java).apply {
                putExtra("imageId", 2)
                putExtra("isAnonymous", isAnonymous)
                putExtra("notificationId", notificationId)
                putExtra("title", title)
                putExtra("description", description)
                putExtra("userId", userId)
                putExtra("rating", imageId)
            },
            Intent(context, RatingNotificationReceiver::class.java).apply {
                putExtra("imageId", 3)
                putExtra("isAnonymous", isAnonymous)
                putExtra("notificationId", notificationId)
                putExtra("title", title)
                putExtra("description", description)
                putExtra("userId", userId)
                putExtra("rating", imageId)
            },
            Intent(context, RatingNotificationReceiver::class.java).apply {
                putExtra("imageId", 4)
                putExtra("isAnonymous", isAnonymous)
                putExtra("notificationId", notificationId)
                putExtra("title", title)
                putExtra("description", description)
                putExtra("userId", userId)
                putExtra("rating", imageId)
            },
            Intent(context, RatingNotificationReceiver::class.java).apply {
                putExtra("imageId", 5)
                putExtra("isAnonymous", isAnonymous)
                putExtra("notificationId", notificationId)
                putExtra("title", title)
                putExtra("description", description)
                putExtra("userId", userId)
                putExtra("rating", imageId)
            },
            Intent(context, RatingNotificationReceiver::class.java).apply {
                putExtra("imageId", imageId)
                putExtra("isAnonymous", true)
                putExtra("notificationId", notificationId)
                putExtra("title", title)
                putExtra("description", description)
                putExtra("userId", userId)
                putExtra("rating", imageId)
            },
            Intent(context, RatingNotificationReceiver::class.java).apply {
                putExtra("imageId", imageId)
                putExtra("isAnonymous", false)
                putExtra("notificationId", notificationId)
                putExtra("title", title)
                putExtra("description", description)
                putExtra("userId", userId)
                putExtra("rating", imageId)
            },
            Intent(context, RatingNotificationReceiver::class.java).apply {
                putExtra("imageId", imageId)
                putExtra("isAnonymous", isAnonymous)
                putExtra("notificationId", notificationId)
                putExtra("title", title)
                putExtra("description", description)
                putExtra("userId", userId)
                putExtra("rating", imageId)
                putExtra("isDone", true)
            }
        )

        val imageIds = arrayOf(R.id.image1, R.id.image2, R.id.image3, R.id.image4, R.id.image5, R.id.lnAnonymous, R.id.lnNonAnonymous, R.id.txtDone)
        intents.forEachIndexed { index, intent ->
            val pendingIntent = PendingIntent.getBroadcast(context, index, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            remoteViews.setOnClickPendingIntent(imageIds[index], pendingIntent)
        }

        remoteViews.setTextViewText(R.id.txtTitle, title)
        remoteViews.setTextViewText(R.id.txtDescription, description)

        if (isAnonymous) {
            remoteViews.setImageViewResource(R.id.imgAnonymous, R.drawable.ic_radio_button_checked)
            remoteViews.setImageViewResource(R.id.imgNonAnonymous, R.drawable.ic_radio_button_unchecked)
        } else {
            remoteViews.setImageViewResource(R.id.imgAnonymous, R.drawable.ic_radio_button_unchecked)
            remoteViews.setImageViewResource(R.id.imgNonAnonymous, R.drawable.ic_radio_button_checked)
        }

        if (imageId == -1) {
            remoteViews.setViewVisibility(R.id.txtDone, View.GONE)
        } else {
            remoteViews.setViewVisibility(R.id.txtDone, View.VISIBLE)
        }

        when (imageId) {
            1 -> {
                remoteViews.setImageViewResource(R.id.image1, R.drawable.ic_star)
            }

            2 -> {
                remoteViews.setImageViewResource(R.id.image1, R.drawable.ic_star)
                remoteViews.setImageViewResource(R.id.image2, R.drawable.ic_star)
            }

            3 -> {
                remoteViews.setImageViewResource(R.id.image1, R.drawable.ic_star)
                remoteViews.setImageViewResource(R.id.image2, R.drawable.ic_star)
                remoteViews.setImageViewResource(R.id.image3, R.drawable.ic_star)
            }

            4 -> {
                remoteViews.setImageViewResource(R.id.image1, R.drawable.ic_star)
                remoteViews.setImageViewResource(R.id.image2, R.drawable.ic_star)
                remoteViews.setImageViewResource(R.id.image3, R.drawable.ic_star)
                remoteViews.setImageViewResource(R.id.image4, R.drawable.ic_star)
            }

            5 -> {
                remoteViews.setImageViewResource(R.id.image1, R.drawable.ic_star)
                remoteViews.setImageViewResource(R.id.image2, R.drawable.ic_star)
                remoteViews.setImageViewResource(R.id.image3, R.drawable.ic_star)
                remoteViews.setImageViewResource(R.id.image4, R.drawable.ic_star)
                remoteViews.setImageViewResource(R.id.image5, R.drawable.ic_star)
            }
        }

        remoteViewsSmall.setTextViewText(R.id.txtTitle, title)
        remoteViewsSmall.setTextViewText(R.id.txtDescription, description)

        val notification = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(R.drawable.app_icon)
            .setCustomContentView(remoteViewsSmall)
            .setCustomBigContentView(remoteViews)
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()

        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
            return
        }
        NotificationManagerCompat.from(context).notify(notificationId, notification)
    }
}