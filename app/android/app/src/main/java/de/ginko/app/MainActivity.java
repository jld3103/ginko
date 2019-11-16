package de.ginko.app;

import android.content.Intent;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    static final String CHANNEL = "de.ginko.app";
    static DartExecutor dartExecutor;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        dartExecutor = flutterEngine.getDartExecutor();

        boolean[] registered = new boolean[]{false};

        new MethodChannel(dartExecutor, CHANNEL).setMethodCallHandler((call, result) -> {
            if (call.method.equals("channel_registered")) {
                if (registered[0]) {
                    return;
                }
                registered[0] = true;
                String data = getIntent().getStringExtra("channel");
                if (data != null) {
                    new MethodChannel(dartExecutor, CHANNEL).invokeMethod("background_notification", data);
                }
                System.out.println("Data: " + data);
            }
        });
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        String data = getIntent().getStringExtra("channel");
        new MethodChannel(dartExecutor, CHANNEL).invokeMethod("background_notification", data);
    }

}
