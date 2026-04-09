package com.ktech.infosha

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat
import com.ktech.infosha.CallService

class BootCompletedReceiver : BroadcastReceiver() {
    
        override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == Intent.ACTION_BOOT_COMPLETED) {
            context?.let { nonNullContext ->
                val serviceIntent = Intent(nonNullContext, CallService::class.java)
                ContextCompat.startForegroundService(nonNullContext, serviceIntent)
            } ?: run {
                // Handle the case where context is null
            }
        }
    

    }
}
