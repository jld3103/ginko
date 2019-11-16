package de.ginko.app;

import android.app.ActivityManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.text.Html;
import android.text.SpannableString;
import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import io.flutter.plugin.common.MethodChannel;

import java.util.Objects;

import static de.ginko.app.MainActivity.CHANNEL;

public class NotificationService extends FirebaseMessagingService {

    @SuppressWarnings("deprecation")
    @Override
    public void onMessageReceived(@NonNull RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);

        String type = remoteMessage.getData().get("type");

        if (type != null && (type.equals("substitutionplan") || type.equals("cafetoria") || type.equals("aixformation"))) {
            System.out.println("Notification received: " + remoteMessage.getData());
            if (MainActivity.dartExecutor != null && getCurrentClass().startsWith(getApplication().getPackageName())) {
                System.out.println("Updating UI");
                new Handler(Looper.getMainLooper()).post(() -> new MethodChannel(MainActivity.dartExecutor, CHANNEL).invokeMethod("foreground_notification", remoteMessage.getData()));
                return;
            }
            System.out.println("Showing notification");

            Intent intent = new Intent(this, MainActivity.class);
            intent.putExtra("channel", type);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            int uniqueInt = (int) (System.currentTimeMillis() & 0xfffffff);
            PendingIntent pendingIntent = PendingIntent.getActivity(this, uniqueInt, intent, PendingIntent.FLAG_CANCEL_CURRENT);


            String title = remoteMessage.getData().get("title");
            String body = remoteMessage.getData().get("body");
            String bigBody = remoteMessage.getData().get("bigBody");
            int group = uniqueInt;
            switch (type) {
                case "substitutionplan":
                    group = Integer.parseInt(Objects.requireNonNull(remoteMessage.getData().get("weekday")));
                    break;
                case "cafetoria":
                    group = 5;
                    break;
                case "aixformation":
                    group = 6;
                    break;
            }
            SpannableString formattedBody = new SpannableString(
                    Build.VERSION.SDK_INT < Build.VERSION_CODES.N ? Html.fromHtml(body)
                            : Html.fromHtml(body, Html.FROM_HTML_MODE_LEGACY)
            );
            SpannableString formattedBigBody = new SpannableString(
                    Build.VERSION.SDK_INT < Build.VERSION_CODES.N ? Html.fromHtml(bigBody)
                            : Html.fromHtml(bigBody, Html.FROM_HTML_MODE_LEGACY)
            );

            NotificationCompat.Builder notification = new NotificationCompat.Builder(getApplicationContext(), type)
                    .setContentTitle(title)
                    .setContentText(formattedBody)
                    .setSmallIcon(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O ? R.mipmap.ic_launcher : R.mipmap.logo_white)
                    .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                    .setStyle(new NotificationCompat.BigTextStyle().bigText(formattedBigBody))
                    .setContentIntent(pendingIntent)
                    .setTicker(title + " " + formattedBody)
                    .setColor(Color.parseColor("#ff5bc638"))
                    .setGroup(String.valueOf(group))
                    .setAutoCancel(true)
                    .setColorized(true);

            NotificationManagerCompat manager = NotificationManagerCompat.from(getApplicationContext());
            manager.notify(group, notification.build());
        } else {
            System.out.println("Got unknown notification: \n" + remoteMessage.getData().get("title") + "\n" + remoteMessage.getData().get("body") + "\n" + remoteMessage.getData().get("bigBody"));
        }
    }

    @SuppressWarnings("deprecation")
    String getCurrentClass() {
        return ((ActivityManager) getSystemService(ACTIVITY_SERVICE)).getRunningTasks(1).get(0).topActivity.getClassName();
    }

}
