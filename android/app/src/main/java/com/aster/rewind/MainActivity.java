package com.aster.rewind;

import android.app.NotificationManager;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String TAG = "MainActivity";
    private static final String CHANNEL = "birthdayReminder.app.mainMethodChannel";

    AlarmClass alarmClass = new AlarmClass(this);
    Handler handler = new Handler();
    NotificationManager mNotificationManager;

    void setUpEventChannel(FlutterEngine engine) {
        new EventChannel(engine.getDartExecutor()
                .getBinaryMessenger(), "birthdayReminder/permit/event.channel")
                .setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        handler.postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                HashMap<String, Boolean> hashMap = new HashMap<>();
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                    hashMap.put("dnd", mNotificationManager.isNotificationPolicyAccessGranted());
                                    events.success(hashMap);
                                    handler.postDelayed(this, 1000);
                                }
                            }
                        }, 1000);
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        handler.removeCallbacksAndMessages(null);
                    }
                });
    }

    void setUpMethodChannel(FlutterEngine flutterEngine) {
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);

        channel.setMethodCallHandler((call, result) -> {
            if (call.method.equals("addBirthDay")) {
                System.out.println("In addBirthday(); [MainActivity.java]");
                String jsonObject = call.argument("map");
                System.out.println(jsonObject);

                try {
                    JSONObject json = new JSONObject(jsonObject);
                    String nameOfPerson = json.getString("nameOfPerson");
                    String aMessageForPerson = json.getString("aMessageForPerson");
                    String stringDate = json.getString("dateOfBirthday");
                    int uniqueId = json.getInt("uniqueId");

                    long dateFinalValue = Long.parseLong(stringDate);

                    Calendar date = getCalendarDate(dateFinalValue);
                    alarmClass.setBirthdayReminder(date, nameOfPerson,
                            uniqueId, aMessageForPerson, true);

                } catch (JSONException e) {
                    System.out.println("An error occurred while deciphering the json data");
                    e.printStackTrace();
                }
            } else if (call.method.equals("requestDnD")) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {

                    if (!mNotificationManager.isNotificationPolicyAccessGranted()) {
                        Intent intent = new Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS);

                        startActivity(intent);
                        Toast.makeText(this, "Grant the DnD access", Toast.LENGTH_SHORT).show();
                    }
                }
            } else if (call.method.equals("requestAutoStartUp")) {
                getGlobalPermit(this);
                Toast.makeText(this, "Grant autoStartUp permission", Toast.LENGTH_SHORT).show();
            } else if (call.method.equals("disableAlarm")) {
                int uniqueId = call.argument("uniqueId");
                alarmClass.disableAlarm(uniqueId);
                Toast.makeText(this, "Deleted reminder", Toast.LENGTH_SHORT).show();
            } else if (call.method.equals("isDnDEnabled")) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    result.success(mNotificationManager.isNotificationPolicyAccessGranted());
                }
                result.success(true);
            }
        });
    }

    Calendar getCalendarDate(long milliseconds) {
        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss.SSS");

        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(milliseconds);
        String finalDate = formatter.format(calendar.getTime());
        System.out.println(finalDate);
        return calendar;
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mNotificationManager = (NotificationManager) getActivity()
                .getSystemService(Context.NOTIFICATION_SERVICE);

        System.out.println(" In onCreate() [MainActivity.java]");

        // EngineClass.createFlutterEngine(this);

        //TODO: Uncomment this permission line
        // getGlobalPermit(getApplicationContext());
        // Check if the notification policy access has been granted for the app.

    }

    void getGlobalPermit(Context context) {
        try {
            //Open the specific App Info page:
            Intent intent = new Intent(android.provider
                    .Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            intent.setData(Uri.parse("package:" + context.getPackageName()));
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);

        } catch (ActivityNotFoundException e) {
            //Open the generic Apps page:
            Intent intent = new Intent(android.provider.Settings.ACTION_MANAGE_APPLICATIONS_SETTINGS);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        Log.d(TAG, "Caching the MainEngine");
        FlutterLoader.getInstance().startInitialization(this);
        FlutterLoader.getInstance()
                .ensureInitializationComplete(this, null);
        setUpEventChannel(flutterEngine);
        setUpMethodChannel(flutterEngine);
        FlutterEngineCache.getInstance().put("mainEngine", flutterEngine);
        super.configureFlutterEngine(flutterEngine);
    }


}

