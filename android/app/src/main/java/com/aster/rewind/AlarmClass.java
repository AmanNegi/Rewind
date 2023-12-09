package com.aster.rewind;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.widget.Toast;

import java.util.Calendar;

public class AlarmClass {
    private final Context context;

    AlarmClass(Context context) {
        this.context = context;
    }

    void setBirthdayReminder(Calendar date, String name,
                             int uniqueId, String description,boolean showToast) {

        ComponentName receiver = new ComponentName(context, BootReceiver.class);
        PackageManager pm = context.getPackageManager();

        pm.setComponentEnabledSetting(receiver,
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                PackageManager.DONT_KILL_APP);

        System.out.println("SettingBirthDayReminder [AlarmClass.java]");
        AlarmManager alarmManager = (AlarmManager) context.
                getSystemService(Context.ALARM_SERVICE);

        Intent intent = new Intent(context, BirthdayReceiver.class);
        intent.putExtra("name", name);
        intent.putExtra("description", description);
        intent.putExtra("uniqueId", uniqueId);
        intent.putExtra("timeInMillis", date.getTimeInMillis());

        PendingIntent pendingIntent = PendingIntent.getBroadcast(context,
                uniqueId, intent,PendingIntent.FLAG_UPDATE_CURRENT);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,
                    date.getTimeInMillis(), pendingIntent);
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, date.getTimeInMillis(), pendingIntent);
        } else {
            alarmManager.set(AlarmManager.RTC_WAKEUP,
                    date.getTimeInMillis(), pendingIntent);
        }
        if(showToast){
            showToast("Set the reminder successfully");
        }

    }


    void disableAlarm(int uniqueId) {
        if (uniqueId != 787898) {
            AlarmManager alarmManager = (AlarmManager)
                    context.getSystemService(Context.ALARM_SERVICE);

            PendingIntent intent = PendingIntent.getBroadcast(context, uniqueId,
                    new Intent(context, BirthdayReceiver.class), PendingIntent.FLAG_UPDATE_CURRENT);
            alarmManager.cancel(intent);
        }
    }

    void showToast(String text) {
        Toast.makeText(context, text, Toast.LENGTH_SHORT).show();
    }
}
