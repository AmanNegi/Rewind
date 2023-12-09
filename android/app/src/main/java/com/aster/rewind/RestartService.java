package com.aster.rewind;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Build;
import android.os.IBinder;

import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;

public class RestartService extends Service {
    private static final String CHANNEL = "birthdayReminder.app.restartReceiver";

    @Override
    public void onCreate() {
        super.onCreate();

        NotificationManager mNotificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        int notifyID = 8963;
        String CHANNEL_ID = "my_channel_01";

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel mChannel = new NotificationChannel(CHANNEL_ID,
                    "Re-start channel", importance);

            if (!mNotificationManager.isNotificationPolicyAccessGranted()) {
                mNotificationManager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_ALL);
            }
            mChannel.enableVibration(true);
            mChannel.enableLights(true);
            mChannel.setLightColor(Color.RED);
            mChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);
            mChannel.setBypassDnd(true);
            mChannel.setShowBadge(true);
            mChannel.setImportance(NotificationManager.IMPORTANCE_HIGH);

            mNotificationManager.createNotificationChannel(mChannel);
            Notification channelledNotification = new Notification.Builder(this)
                    .setContentTitle("Re-starting all the birthday timers")
                    .setContentText("You restarted your phone.")
                    .setAutoCancel(true)
                    .setChannelId(CHANNEL_ID)
                    .setSmallIcon(R.drawable.notification)
                    .setColor(ContextCompat.getColor(this,
                            R.color.purple))
                    .setLargeIcon(BitmapFactory.decodeResource(this.getResources(), R.mipmap.ic_launcher))
                    .build();

            startForeground(notifyID, channelledNotification);
        } else {
            Notification normalNotification = new Notification.Builder(this)
                    .setContentTitle("Re-starting all the birthday timers")
                    .setContentText("You restarted your phone.")
                    .setAutoCancel(true)
                    .setSmallIcon(R.drawable.icon)

                    .build();

            mNotificationManager.notify(notifyID, normalNotification);
        }

        EngineClass.createFlutterEngine(this);

        System.out.println("Initializing the flutter Engine");
        FlutterEngine engine = new FlutterEngine(this);

        //Warming engine before going to dart code
        engine.getDartExecutor().executeDartEntrypoint(DartExecutor
                .DartEntrypoint.createDefault());

        FlutterEngineCache.getInstance().put("restartEngine", engine);

        MethodChannel channel = new MethodChannel(engine.getDartExecutor()
                .getBinaryMessenger(), CHANNEL);

        channel.invokeMethod("getData", null,
                new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object result) {
                        System.out.println(result.getClass().toString());
                        ArrayList list = (ArrayList) result;
                        if (list.size() > 0) {
                            AlarmClass alarmClass = new AlarmClass(getApplicationContext());

                            for (Object o : list) {

                                Map map = (Map) o;
                                String name = (String) map.get("nameOfPerson");
                                int uniqueId = (int) map.get("uniqueId");
                                String message = (String) map.get("aMessageForPerson");
                                String stringDate = (String) map.get("dateOfBirthday");
                                long dateOfBirthDay = Long.parseLong(stringDate);
                                System.out.println(map);

                                Timestamp timestamp = new Timestamp(dateOfBirthDay);
                                Timestamp currentTimeStamp =
                                        new Timestamp(Calendar.getInstance().getTimeInMillis());

                                System.out.println("Comparing this " + timestamp.toString() + " to " + currentTimeStamp.toString());
                                if (currentTimeStamp.after(timestamp)) {
                                    System.out.println("\n User missed an alarm \n");

                                    Calendar calendar = getCalendarDate(dateOfBirthDay);
                                    SimpleDateFormat format = new SimpleDateFormat("EEEE, MMMM d, yyyy");
                                    String stringDateValue = format.format(calendar.getTime());
                                    alarmClass.disableAlarm(uniqueId);

                                    Intent intent = new Intent(getApplicationContext(), ForgotService.class);
                                    intent.putExtra("name", name);
                                    intent.putExtra("date",
                                            stringDateValue);
                                    intent.putExtra("uniqueId", uniqueId);
                                    intent.putExtra("description", message);
                                    intent.putExtra("timeInMillis", calendar.getTimeInMillis());

                                    getApplicationContext().startService(intent);

                                } else {
                                    System.out.println("\n Re-Setting the alarm \n");
                                    alarmClass.setBirthdayReminder(getCalendarDate(dateOfBirthDay),
                                            name, uniqueId, message,false);
                                }

                            }
                            mNotificationManager.cancelAll();
                            stopForeground(true);
                        } else {
                            engine.destroy();
                            stopForeground(true);
                        }
                    }

                    @Override
                    public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {

                    }

                    @Override
                    public void notImplemented() {

                    }
                });

    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        stopForeground(true);
        super.onDestroy();
        System.out.println("The restart service got destroyed!!");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_STICKY;
    }

    Calendar getCalendarDate(long milliseconds) {
        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss.SSS");

        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(milliseconds);
        String finalDate = formatter.format(calendar.getTime());
        System.out.println(finalDate);
        return calendar;
    }

}
