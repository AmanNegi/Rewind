package com.aster.rewind;

import android.content.Context;
import android.util.Log;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.view.FlutterMain;

class EngineClass {
    private static String TAG = "EngineClass";
    String name;
    String description;
    int uniqueId;
    long timeInMillis;

    static void createFlutterEngine(Context context) {
        Log.d(TAG, "\n---Creating A Flutter Engine---\n");
        FlutterMain.startInitialization(context);
        FlutterMain.ensureInitializationComplete(context, null);

        FlutterEngine cachedEngine = FlutterEngineCache.getInstance()
                .get("birthdayEngine");
        if (cachedEngine != null) {
            Log.d(TAG, "Engine already exists using old engine");
            return;
        }
        FlutterEngine engine = new FlutterEngine(context);
        engine.getNavigationChannel().setInitialRoute("/BirthdayPage");
        engine.getDartExecutor().executeDartEntrypoint(DartExecutor
                .DartEntrypoint
                .createDefault());
        FlutterEngineCache.getInstance()
                .put("birthdayEngine", engine);
    }

    static void destroyEngine() {
        FlutterEngineCache cache = FlutterEngineCache.getInstance();
        FlutterEngine enginePrivate = cache.get("birthdayEngine");
        if (enginePrivate != null)
            enginePrivate.destroy();
    }

    static FlutterEngine getFlutterEngine(Context context) {
        Log.d(TAG, "\n---Getting A Flutter Engine---\n");

        FlutterEngine engine = FlutterEngineCache
                .getInstance().get("birthdayEngine");
        if (engine != null) {
            return engine;
        }
        System.out.println("-- :Creating a new Engine: --");
        createFlutterEngine(context);
        engine = FlutterEngineCache
                .getInstance().get("birthdayEngine");
        return engine;

    }
}
