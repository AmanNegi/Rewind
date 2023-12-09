package com.aster.rewind;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import io.flutter.view.FlutterMain;

public class BootReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        if ("android.intent.action.BOOT_COMPLETED"
                .equals(intent.getAction())) {

            System.out.println("In broadcast receiver [BirthDayReminder]");

            FlutterMain.startInitialization(context);
            FlutterMain.ensureInitializationComplete(context, null);

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(new Intent(context, RestartService.class));
            } else {
                context.startService(new Intent(context, RestartService.class));
            }

        }
    }
}
