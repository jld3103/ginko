import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:ginko/utils/pwa/pwa_base.dart';

// ignore: avoid_annotating_with_dynamic
typedef Callback = void Function(dynamic result);

// ignore: public_member_api_docs
class PWA extends PWABase {
  // ignore: public_member_api_docs
  PWA() {
    var canceled = false;
    var timer = Timer(Duration(milliseconds: 100), () {
      if (!canceled) {
        _channel.postMessage(json.encode({'method': 'is_setup'}));
      }
    });
    _channel.onMessage.listen((event) {
      final data = json.decode(event.data);
      if (data['method'] == 'is_setup') {
        canceled = true;
        if (timer != null) {
          timer.cancel();
          timer = null;
        }
      } else if (data['method'] == 'install') {
        _installCallbacks[0](data['result']);
        _installCallbacks.removeAt(0);
      } else if (data['method'] == 'can_install') {
        _canInstallCallbacks[0](data['result']);
        _canInstallCallbacks.removeAt(0);
      } else {
        print(data);
      }
    });
  }

  final _channel = BroadcastChannel('pwa');

  final List<Callback> _installCallbacks = [];
  final List<Callback> _canInstallCallbacks = [];

  @override
  Future<bool> install() {
    final completer = Completer<bool>();
    // ignore: unnecessary_lambdas
    _installCallbacks.add((data) => completer.complete(data));
    _channel.postMessage(json.encode({'method': 'install'}));
    return completer.future;
  }

  @override
  Future<bool> canInstall() {
    final completer = Completer<bool>();
    // ignore: unnecessary_lambdas
    _canInstallCallbacks.add((data) => completer.complete(data));
    _channel.postMessage(json.encode({'method': 'can_install'}));
    return completer.future;
  }

  @override
  Future<bool> navigateLoadingIfNeeded() async {
    final hash = window.location.hash;
    final needsToNavigate = hash != '#/';
    if (needsToNavigate) {
      window.location.hash = '#/';
      window.location.reload();
    }
    return needsToNavigate;
  }
}
