package com.aster.rewind;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.Window;
import android.view.WindowManager;
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
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class BirthdayPage extends FlutterActivity {

    String name = "default";
    String description = "default";
    long timeInMillis = 0;
    int uniqueId = 787898;

    @Override
    public void onAttachedToWindow() {
        System.out.println("Attached to window BirthdayPage");
        Window window = getWindow();
        window.addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
                | WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
                | WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
                | WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD);

    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        name = intent.getStringExtra("name");
        description = intent.getStringExtra("description");
        timeInMillis = intent.getLongExtra("timeInMillis", 0);
        uniqueId = intent.getIntExtra("uniqueId", 787898);
        System.out.println(" On new intent [BirthdayPage.java] " + name);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        System.out.println("On create [BirthdayPage.java]");
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public FlutterEngine provideFlutterEngine(@NonNull Context context) {
        System.out.println("\n-- Providing flutter Engine[BirthdayPage.java] --\n");
        return EngineClass.getFlutterEngine(context);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        System.out.println("Configure Engine [BirthdayPage.java]");
        onNewIntent(getIntent());
        super.configureFlutterEngine(flutterEngine);
        setUpEventChannel(flutterEngine);
        setUpMethodChannel(flutterEngine);
        System.out.println("in BirthdayPage.java " + name + description);
    }

    void setUpEventChannel(FlutterEngine engine) {
        System.out.println("Setting method channel [BirthdayPage.java]");
        new EventChannel(engine.getDartExecutor()
                .getBinaryMessenger(), "eventChannel/birthday")
                .setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        System.out.println("\n Listening to events now: \n");
                        HashMap<String, String> hashMap = new HashMap();
                        hashMap.put("name", name);
                        hashMap.put("description", description);
                        hashMap.put("uniqueId", String.valueOf(uniqueId));
                        hashMap.put("timeInMillis", String.valueOf(timeInMillis));
                        events.success(hashMap);
                    }

                    @Override
                    public void onCancel(Object arguments) {

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

    void setUpMethodChannel(FlutterEngine engine) {
        new MethodChannel(engine.getDartExecutor().getBinaryMessenger(),
                "birthdayReminder/birthday.MethodChannel").
                setMethodCallHandler((call, result) -> {
                    if (call.method.equals("remindNextYear")) {
                     if(uniqueId != 787898){
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
                            //TODO: Make Changes Here
                              date.add(Calendar.YEAR, 1);
                             new AlarmClass(this)
                                     .setBirthdayReminder(date, nameOfPerson,
                                             uniqueId, aMessageForPerson,true);

                         } catch (JSONException e) {
                             System.out.println("An error occurred while" +
                                     " deciphering the json data");
                             e.printStackTrace();
                         }
                     }
                    else{
                         Toast.makeText(this, "Sorry an error occurred\nReset the alarm for next year manually", Toast.LENGTH_SHORT).show();
                     }
                    }
                });

    }
}
