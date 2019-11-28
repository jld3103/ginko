package de.ginko;

import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import java.util.HashMap;
import java.util.Map;

public class MainActivity extends FlutterActivity {
    static final String CHANNEL = "de.ginko";
    static DartExecutor dartExecutor;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        dartExecutor = flutterEngine.getDartExecutor();

        boolean[] registered = new boolean[]{false};

        new MethodChannel(dartExecutor, CHANNEL).setMethodCallHandler((call, result) -> {
            if (call.method.equals("channel_registered")) {
                if (registered[0]) {
                    result.success(null);
                    return;
                }
                registered[0] = true;
                result.success(sendMessageFromIntent("onLaunch", getIntent()));
            }
        });
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        sendMessageFromIntent("onResume", intent);
    }

    private boolean sendMessageFromIntent(String method, Intent intent) {
        Bundle extras = intent.getExtras();

        if (extras == null || extras.get("type") == null) {
            return false;
        }

        Map<String, Object> data = new HashMap<>();

        for (String key : extras.keySet()) {
            Object extra = extras.get(key);
            if (extra != null) {
                data.put(key, extra);
            }
        }
        new MethodChannel(dartExecutor, "plugins.flutter.io/firebase_messaging").invokeMethod(method, data);
        return true;
    }
}
