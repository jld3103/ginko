package de.ginko.app;

import android.content.Intent;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    static final String CHANNEL = "de.ginko.app";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        NotificationService.flutterView = getFlutterView();

        boolean[] registered = new boolean[]{false};

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler((call, result) -> {
            if (call.method.equals("channel_registered")) {
                if (registered[0]) {
                    return;
                }
                registered[0] = true;
                String data = getIntent().getStringExtra("channel");
                if (data != null) {
                    new MethodChannel(getFlutterView(), CHANNEL).invokeMethod("background_notification", data);
                }
                System.out.println("Data: " + data);
            }
        });
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        String data = getIntent().getStringExtra("channel");
        new MethodChannel(getFlutterView(), CHANNEL).invokeMethod("background_notification", data);
    }
}
