package com.aster.rewind;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.media.AudioAttributes;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;

import java.util.Random;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class BirthdayService extends Service {
    private static final String CHANNEL = "birthdayReminder.app.restartReceiver";
    private static final String TAG = "BirthdayService";
    String name = "Check";
    String description = "Check des";
    int uniqueId = 787898;
    long timeInMillis = 0;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null) {
            name = intent.getStringExtra("name");
            description = intent.getStringExtra("description");
            uniqueId = intent.getIntExtra("uniqueId", 787898);
            timeInMillis = intent.getLongExtra("timeInMillis", 0);
        }
        if (uniqueId != 787898) {
            showNotification();
        } else {
            stopSelf();
        }

        return START_STICKY;
    }

    void showNotification() {
        NotificationManager mNotificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!mNotificationManager.isNotificationPolicyAccessGranted()) {
                mNotificationManager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_ALL);
            }
        }

          Intent intent = new Intent(this, BirthdayPage.class);

        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP
                | Intent.FLAG_ACTIVITY_SINGLE_TOP);

        intent.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);

        intent.putExtra("name", name);
        intent.putExtra("description", description);
        intent.putExtra("timeInMillis", timeInMillis);
        intent.putExtra("uniqueId", uniqueId);

        Random random = new Random();
        int notifyID = random.nextInt(9999 - 1000) + 1000;

        PendingIntent pendingIntent = PendingIntent.getActivity(getApplicationContext(),
                random.nextInt(9999 - 1000) + 1000,
                intent, PendingIntent.FLAG_UPDATE_CURRENT);

        String CHANNEL_ID = "my_channel_02";

        Uri soundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel mChannel = new NotificationChannel(CHANNEL_ID,
                    "Birthday inform Channel", importance);

            AudioAttributes att = new AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                    .setContentType(AudioAttributes.CONTENT_TYPE_UNKNOWN)
                    .build();

            mChannel.enableVibration(true);
            mChannel.enableLights(true);
            mChannel.setLightColor(Color.RED);
            mChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);
            mChannel.setBypassDnd(true);
            mChannel.setShowBadge(true);
            mChannel.setSound(soundUri, att);
            mChannel.setImportance(NotificationManager.IMPORTANCE_HIGH);

            mNotificationManager.createNotificationChannel(mChannel);
            Notification channelledNotification = new Notification.Builder(this)
                    .setContentTitle("Hey it's the birthday of " + name + " today. \uD83D\uDE0D ")
                    .setContentText(description)
                    .setChannelId(CHANNEL_ID)
                    .setContentIntent(pendingIntent)
                    .setShowWhen(true)
                    .setAutoCancel(true)
                    .setVisibility(Notification.VISIBILITY_PUBLIC)
                    .setCategory(Notification.CATEGORY_ALARM)
                    .setSmallIcon(R.drawable.notification).setColor(ContextCompat.getColor(this,
                            R.color.purple))
                    .setLargeIcon(BitmapFactory.decodeResource(this.getResources(), R.mipmap.ic_launcher))
                    .build();

            mNotificationManager.notify(notifyID, channelledNotification);
        } else {
            Notification normalNotification = new Notification.Builder(this)
                    .setContentTitle(name)
                    .setContentText(description)
                    .setSmallIcon(R.drawable.icon)
                    .setContentIntent(pendingIntent)
                    .setAutoCancel(true)
                    .setSound(soundUri)
                    .setPriority(Notification.PRIORITY_HIGH)
                    .build();

            mNotificationManager.notify(notifyID, normalNotification);
        }
        FlutterEngine engine;
        engine = FlutterEngineCache.getInstance().get("mainEngine");
        if (engine == null) {
            Log.d(TAG, "No Main Engine found.");
            engine = FlutterEngineCache.getInstance().get("birthdayEngine");
            if (engine == null) {
                Log.d(TAG, "No Birthday Engine found.\nCreating new engine.");
                engine = new FlutterEngine(this);
                //Warming engine before executing dart code
                engine.getDartExecutor().executeDartEntrypoint(DartExecutor
                        .DartEntrypoint.createDefault());
            }
        }
        GeneratedPluginRegistrant.registerWith(engine);
        MethodChannel channel = new MethodChannel(engine.getDartExecutor()
                .getBinaryMessenger(), CHANNEL);

        channel.invokeMethod("deleteData", uniqueId,
                null);
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
