package de.ginko.app;

import android.app.ActivityManager;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Build;
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

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler((call, result) -> {
            if (call.method.equals("applyTheme")) {
                if (Build.VERSION.SDK_INT >= 21) {
                    MainActivity.this.setTaskDescription(new ActivityManager.TaskDescription(
                            "Ginko",
                            BitmapFactory.decodeResource(getResources(), R.drawable.logo_white),
                            Color.parseColor("#" + call.argument("color"))
                    ));
                }
            }
        });
    }
}
