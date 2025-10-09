package com.example.taskly

import android.app.NotificationChannel
import android.app.NotificationManager
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createHighPriorityNotificationChannel()
    }

    private fun createHighPriorityNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "high_priority_channel"
            val channelName = "High Priority Notifications"
            val importance = NotificationManager.IMPORTANCE_HIGH

            val channel = NotificationChannel(channelId, channelName, importance).apply {
                description = "High priority notifications for important messages"

                // إعدادات للشاشة المقفولة
                lockscreenVisibility = NotificationCompat.VISIBILITY_PUBLIC
                setShowBadge(true)

                // إعدادات الاهتزاز
                enableVibration(true)
                vibrationPattern = longArrayOf(1000, 1000, 1000, 1000)

                // إعدادات الضوء
                enableLights(true)
                lightColor = Color.RED

                // تجاوز وضع عدم الإزعاج
                setBypassDnd(true)
            }

            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
            println("✅ High priority notification channel created")
        }
    }
}
