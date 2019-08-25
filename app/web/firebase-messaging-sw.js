// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here, other Firebase libraries
// are not available in the service worker.
importScripts('https://www.gstatic.com/firebasejs/6.3.4/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/6.3.4/firebase-messaging.js');

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
        body: payload.data.bigBody.replace('<br/>', '\n').replace(/<[^>]*>?/gm, ''),
        icon: '/assets/images/logo_green.png',
        badge: '/assets/images/logo_green.png',
        data: data,
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
