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

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;

import java.util.Random;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;

public class ForgotService extends Service {
    private static final String CHANNEL = "birthdayReminder.app.restartReceiver";
    String name;
    int uniqueId;
    String date;
    long timeInMillis;
    String description;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null) {
            name = intent.getStringExtra("name");
            uniqueId = intent.getIntExtra("uniqueId", 787898);
            date = intent.getStringExtra("date");
            timeInMillis = intent.getLongExtra("timeInMillis", 0);
            description = intent.getStringExtra("description");
            System.out.println("Forgot service values : " + name);
        }

        if (uniqueId == 787898) stopSelf();
        else showNotification();

        return START_STICKY;
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }

    void showNotification() {
        Random random = new Random();
        int notifyID = random.nextInt(9999 - 1000) + 1000;

        Intent intent = new Intent(this, BirthdayPage.class);

        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        intent.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);

        intent.putExtra("name", name);
        intent.putExtra("description", description);
        intent.putExtra("timeInMillis", timeInMillis);
        intent.putExtra("uniqueId", uniqueId);

        PendingIntent pendingIntent = PendingIntent.getActivity(getApplicationContext(),
                random.nextInt(9999 - 1000) + 1000,
                intent, PendingIntent.FLAG_UPDATE_CURRENT);


        String CHANNEL_ID = "my_channel_03";
        Uri soundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);


        NotificationManager mNotificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            if (!mNotificationManager.isNotificationPolicyAccessGranted()) {
                mNotificationManager.
                        setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_ALL);
            }
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel mChannel = new NotificationChannel(CHANNEL_ID,
                    "Forgot alarm Channel", importance);

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
            mChannel.setSound(soundUri,att);
            mChannel.setImportance(NotificationManager.IMPORTANCE_HIGH);

            mNotificationManager.createNotificationChannel(mChannel);
            Notification notification = new Notification.Builder(this)
                    .setContentTitle("Hey you missed a reminder \uD83D\uDE31")
                    .setAutoCancel(true)
                    .setVisibility(Notification.VISIBILITY_PUBLIC)
                    .setCategory(NotificationCompat.CATEGORY_ALARM)
                    .setSmallIcon(R.drawable.notification)
                    .setChannelId(CHANNEL_ID)
                    .setShowWhen(true)
                    .setColor(ContextCompat.getColor(this,
                            R.color.purple))
                    .setLargeIcon(BitmapFactory.decodeResource(this.getResources(), R.mipmap.ic_launcher))
                    .setContentIntent(pendingIntent)
                    .build();

            mNotificationManager.notify(notifyID, notification);

        } else {
            Notification notification = new Notification.Builder(this)
                    .setContentTitle("Hey you missed a reminder \uD83D\uDE41")
                    .setContentText("It was the birthday of " + name + " on " + date)
                    .setAutoCancel(true)
                    .setContentIntent(pendingIntent)
                    .setSound(soundUri)
                    .setSmallIcon(R.drawable.notification)
                    .build();

            mNotificationManager.notify(notifyID, notification);
        }
        FlutterEngine engine;
        engine = FlutterEngineCache.getInstance().get("mainEngine");
        if (engine == null) {
            engine = FlutterEngineCache.getInstance().get("restartEngine");
            if (engine == null) {
                engine = new FlutterEngine(this);
                //Warming engine before going to dart code
                engine.getDartExecutor().executeDartEntrypoint(DartExecutor
                        .DartEntrypoint.createDefault());
            }
        }

        MethodChannel channel = new MethodChannel(engine.getDartExecutor()
                .getBinaryMessenger(), CHANNEL);
        System.out.println("Deleting data at " + uniqueId);
        channel.invokeMethod("deleteData", uniqueId,
                null);
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
