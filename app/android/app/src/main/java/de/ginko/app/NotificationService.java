package de.ginko.app;

import android.app.PendingIntent;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.text.Html;
import android.text.SpannableString;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.FlutterView;

import static de.ginko.app.MainActivity.CHANNEL;

public class NotificationService extends FirebaseMessagingService {
    static public FlutterView flutterView;

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);

        System.out.println("Notification received: " + remoteMessage.getData());
        if (flutterView != null) {
            System.out.println("Updating UI");
            new Handler(Looper.getMainLooper()).post(() -> new MethodChannel(flutterView, CHANNEL).invokeMethod("notification", remoteMessage.getData()));
        }
        System.out.println("Showing notification");

        int channelId = 0;
        int notificationId = 0;
        Intent intent = new Intent(this, MainActivity.class);
        intent.putExtra("channel", channelId);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        int uniqueInt = (int) (System.currentTimeMillis() & 0xfffffff);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, uniqueInt, intent, PendingIntent.FLAG_CANCEL_CURRENT);


        String title = remoteMessage.getData().get("title");
        String body = remoteMessage.getData().get("body");

        NotificationCompat.Builder notification = new NotificationCompat.Builder(getApplicationContext(), String.valueOf(channelId))
                .setContentTitle(title)
                .setContentText(body)
                .setSmallIcon(android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.O ? R.mipmap.ic_launcher : R.mipmap.logo_white)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setContentIntent(pendingIntent)
                .setTicker(title + " " + body)
                .setColor(Color.parseColor("#ff5bc638"))
                .setGroup("group" + notificationId)
                .setAutoCancel(true)
                .setColorized(true);

        if (remoteMessage.getData().get("bigBody") != null) {
            String bigBody = remoteMessage.getData().get("bigBody");
            SpannableString formattedBigBody = new SpannableString(
                    Build.VERSION.SDK_INT < Build.VERSION_CODES.N ? Html.fromHtml(bigBody)
                            : Html.fromHtml(bigBody, Html.FROM_HTML_MODE_LEGACY)
            );
            notification.setStyle(new NotificationCompat.BigTextStyle().bigText(formattedBigBody));
        }

        NotificationManagerCompat manager = NotificationManagerCompat.from(getApplicationContext());
        manager.notify(notificationId, notification.build());
    }

}
