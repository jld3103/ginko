let deferredPrompt;
window.addEventListener('beforeinstallprompt', (e) => {
    e.preventDefault();
    deferredPrompt = e;
});
const pwaChannel = new BroadcastChannel('pwa');
pwaChannel.onmessage = (e) => {
    const data = JSON.parse(e.data);
    if (data.method === 'is_setup') {
        pwaChannel.postMessage(JSON.stringify({'method': 'is_setup'}));
    } else if (data.method === 'install') {
        if (deferredPrompt) {
            deferredPrompt.prompt();
            deferredPrompt.userChoice.then((choiceResult) => {
                pwaChannel.postMessage(JSON.stringify({
                    'method': 'install',
                    'result': choiceResult.outcome === 'accepted'
                }));
                deferredPrompt = null;
            });
        }
    } else if (data.method === 'can_install') {
        pwaChannel.postMessage(JSON.stringify({'method': 'can_install', 'result': deferredPrompt != null}));
    }
};