// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here, other Firebase libraries
// are not available in the service worker.
importScripts('https://www.gstatic.com/firebasejs/6.6.2/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/6.6.2/firebase-messaging.js');

// Initialize the Firebase app in the service worker by passing in the
// messagingSenderId.
firebase.initializeApp({
    'messagingSenderId': '324907216916'
});

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(payload => {

    const data = {
        'firebase-messaging-msg-data': payload.data,
        'firebase-messaging-msg-type': 'push-msg-received',
    };

    const notificationOptions = {
        body: payload.data.bigBody.replace(/<br\/>/g, '\n').replace(/<[^>]*>?/gm, ''),
        icon: '/assets/images/logo_green.png',
        badge: '/assets/images/logo_green.png',
        data: data,
        tag: payload.data.type === 'substitutionplan' ? payload.data.type + '-' + payload.data.weekday : payload.data.type,
    };

    return self.registration.showNotification(payload.data.title, notificationOptions);
});

self.addEventListener('notificationclick', event => {
    const clickedNotification = event.notification;
    clickedNotification.close();

    const urlToOpen = new URL(self.location.origin);

    const data = clickedNotification.data;

    const promiseChain = clients.matchAll({
        type: 'window',
        includeUncontrolled: true
    }).then(windowClients => {
        let matchingClient = windowClients.filter(client => new URL(client.url).hostname === urlToOpen.hostname)[0];
        // Check if window already open or has to be opened
        if (matchingClient) {
            return matchingClient.focus();
        } else {
            return clients.openWindow(urlToOpen.href);
        }
    });

    event.waitUntil(promiseChain);
    sendData(urlToOpen, event, data);
});

// Retry sending data to the client until a client is available to send to
function sendData(urlToOpen, event, data) {
    const promiseChain = clients.matchAll({
        type: 'window',
        includeUncontrolled: true
    }).then(windowClients => {
        let matchingClient = windowClients.filter(client => new URL(client.url).hostname === urlToOpen.hostname)[0];
        if (matchingClient) {
            matchingClient.postMessage(data);
        } else {
            setTimeout(() => sendData(urlToOpen, event, data), 100);
        }
    });

    try {
        event.waitUntil(promiseChain);
    } catch (e) {

    }
}

importScripts('https://storage.googleapis.com/workbox-cdn/releases/4.3.1/workbox-sw.js');

if (workbox) {
    workbox.precaching.precacheAndRoute([
        '/assets/images/logo_green.svg',
        '/assets/images/logo_green.png',
        '/assets/images/logo_green_192x192.png',
        '/assets/images/logo_white.svg',
        '/assets/fonts/Roboto/Roboto.ttf',
        '/assets/fonts/MaterialIcons-Regular.ttf',
        '/assets/packages/material_design_icons_flutter/lib/fonts/materialdesignicons-webfont.ttf',
        '/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf',
        '/assets/FontManifest.json',
        '/assets/web/manifest.json',
    ], {
        // Ignore all URL parameters.
        ignoreURLParametersMatching: [/.*/]
    });
    workbox.routing.registerRoute(
        /^https:\/\/cloud\.viktoria\.schule.*/,
        new workbox.strategies.NetworkOnly()
    );
    workbox.routing.registerRoute(
        /.*\.js/,
        new workbox.strategies.NetworkFirst(),
    );
    workbox.routing.registerRoute(
        /.*/,
        new workbox.strategies.CacheFirst({
            cacheName: 'assets',
            plugins: [
                new workbox.expiration.Plugin({
                    maxEntries: 60,
                    maxAgeSeconds: 30 * 24 * 60 * 60, // 30 Days
                }),
            ],
        }),
    );
}