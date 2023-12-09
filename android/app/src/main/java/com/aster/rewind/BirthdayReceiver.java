package com.aster.rewind;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class BirthdayReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        System.out.println("In Birthday Receiver [BirthdayReceiver.java]");
        EngineClass.createFlutterEngine(context);

        Intent toSendIntent = new Intent(context, BirthdayService.class);
        /* Passing values to foreground service*/
        toSendIntent.putExtra("name", intent.getStringExtra("name"));
        toSendIntent.putExtra("description", intent.getStringExtra("description"));
        toSendIntent.putExtra("uniqueId", intent.getIntExtra("uniqueId", 787898));
        toSendIntent.putExtra("timeInMillis", intent.getLongExtra("timeInMillis", 0));

        context.startService(toSendIntent);
    }

}
