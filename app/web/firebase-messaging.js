const firebaseMessagingChannel = new BroadcastChannel('firebase_messaging');
firebaseMessagingChannel.onmessage = (e) => {
    const data = JSON.parse(e.data);
    if (data.method === 'is_setup') {
        firebaseMessagingChannel.postMessage(JSON.stringify({'method': 'is_setup'}));
    } else if (data.method === 'request_permissions') {
        console.log('Could not request permission, because firebase is not supported in some way');
        firebaseMessagingChannel.postMessage(JSON.stringify({'method': 'request_permissions', 'result': null}));
    } else if (data.method === 'get_token') {
        console.log('Could not get token, because firebase is not supported in some way');
        firebaseMessagingChannel.postMessage(JSON.stringify({'method': 'get_token', 'result': null}));
    }
};
let messaging;
try {
    messaging = firebase.messaging();
} catch (e) {

}
navigator.serviceWorker.register('/sw.js')
    .then((registration) => {
        if (messaging != null) {
            messaging.useServiceWorker(registration);

            firebaseMessagingChannel.onmessage = (e) => {
                const data = JSON.parse(e.data);
                if (data.method === 'is_setup') {
                    firebaseMessagingChannel.postMessage(JSON.stringify({'method': 'is_setup'}));
                } else if (data.method === 'request_permissions') {
                    Notification.requestPermission().then((permission) => {
                        if (permission === 'granted') {
                            console.log('Notification permission granted.');
                            firebaseMessagingChannel.postMessage(JSON.stringify({
                                'method': 'request_permissions',
                                'result': true
                            }));
                        } else {
                            console.log('Unable to get permission to notify.');
                            firebaseMessagingChannel.postMessage(JSON.stringify({
                                'method': 'request_permissions',
                                'result': false
                            }));
                        }
                    });
                } else if (data.method === 'has_permissions') {
                    firebaseMessagingChannel.postMessage(JSON.stringify({
                        'method': 'has_permissions',
                        'result': Notification.permission === 'granted'
                    }));
                } else if (data.method === 'get_token') {
                    messaging.getToken().then((currentToken) => {
                        if (currentToken) {
                            firebaseMessagingChannel.postMessage(JSON.stringify({
                                'method': 'get_token',
                                'result': currentToken
                            }));
                        } else {
                            firebaseMessagingChannel.postMessage(JSON.stringify({
                                'method': 'get_token',
                                'result': null
                            }));
                        }
                    }).catch((err) => {
                        console.log('An error occurred while retrieving token. ', err);
                        firebaseMessagingChannel.postMessage(JSON.stringify({'method': 'get_token', 'result': null}));
                    });
                }
            };
            messaging.onTokenRefresh(() => {
                messaging.getToken().then((currentToken) => {
                    if (currentToken) {
                        firebaseMessagingChannel.postMessage(JSON.stringify({
                            'method': 'token_refresh',
                            'result': currentToken
                        }));
                    } else {
                        firebaseMessagingChannel.postMessage(JSON.stringify({
                            'method': 'token_refresh',
                            'result': null
                        }));
                    }
                }).catch((err) => {
                    console.log('An error occurred while retrieving token. ', err);
                    firebaseMessagingChannel.postMessage(JSON.stringify({'method': 'token_refresh', 'result': null}));
                });
            });
            messaging.onMessage((payload) => {
                const data = 'data' in payload ? payload.data : payload;
                try {
                    firebaseMessagingChannel.postMessage(JSON.stringify({'method': 'on_message', 'result': data}));
                } catch (e) {

                }
            });
        }
    });
