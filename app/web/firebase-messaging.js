const messaging = firebase.messaging();
const channel = new BroadcastChannel('firebase_messaging');

navigator.serviceWorker.register('assets/web/firebase-messaging-sw.js')
    .then((registration) => {
        messaging.useServiceWorker(registration);

        channel.onmessage = (e) => {
            const data = JSON.parse(e.data);
            if (data.method === 'is_setup') {
                channel.postMessage(JSON.stringify({'method': 'is_setup'}));
            } else if (data.method === 'request_permissions') {
                Notification.requestPermission().then((permission) => {
                    if (permission === 'granted') {
                        console.log('Notification permission granted.');
                        channel.postMessage(JSON.stringify({'method': 'request_permissions', 'result': true}));
                    } else {
                        console.log('Unable to get permission to notify.');
                        channel.postMessage(JSON.stringify({'method': 'request_permissions', 'result': false}));
                    }
                });
            } else if (data.method === 'get_token') {
                messaging.getToken().then((currentToken) => {
                    if (currentToken) {
                        channel.postMessage(JSON.stringify({'method': 'get_token', 'result': currentToken}));
                    } else {
                        channel.postMessage(JSON.stringify({'method': 'get_token', 'result': null}));
                    }
                }).catch((err) => {
                    console.log('An error occurred while retrieving token. ', err);
                    channel.postMessage(JSON.stringify({'method': 'get_token', 'result': null}));
                });
            }
        };
        messaging.onTokenRefresh(() => {
            messaging.getToken().then((currentToken) => {
                if (currentToken) {
                    channel.postMessage(JSON.stringify({'method': 'token_refresh', 'result': currentToken}));
                } else {
                    channel.postMessage(JSON.stringify({'method': 'token_refresh', 'result': null}));
                }
            }).catch((err) => {
                console.log('An error occurred while retrieving token. ', err);
                channel.postMessage(JSON.stringify({'method': 'token_refresh', 'result': null}));
            });
        });
        messaging.onMessage((payload) => {
            const data = 'data' in payload ? payload.data : payload;
            try {
                channel.postMessage(JSON.stringify({'method': 'on_message', 'result': data}));
            } catch (e) {

            }
        });
    });
