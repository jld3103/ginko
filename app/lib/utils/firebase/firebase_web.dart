library firebase;

// ignore_for_file: uri_does_not_exist

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ginko/utils/firebase/firebase_base.dart';

// ignore: avoid_annotating_with_dynamic
typedef Callback = void Function(dynamic result);

/// FirebaseMessaging class
/// Firebase messaging for Android and iOS
class FirebaseMessaging extends FirebaseMessagingBase {
  // ignore: public_member_api_docs
  FirebaseMessaging() {
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
        timer.cancel();
        timer = null;
      } else if (data['method'] == 'get_token') {
        _tokenGetCallbacks[0](data['result']);
        _tokenGetCallbacks.removeAt(0);
      } else if (data['method'] == 'token_refresh') {
        for (final callback in _tokenRefreshCallbacks) {
          callback(data['result']);
        }
      } else if (data['method'] == 'request_permissions') {
        _permissionsRequestCallbacks[0](data['result']);
        _permissionsRequestCallbacks.removeAt(0);
      } else if (data['method'] == 'on_message') {
        _onMessage(data['result']);
      } else {
        print(data);
      }
    });
  }

  // ignore: undefined_method
  final _channel = BroadcastChannel('firebase_messaging');

  final List<Callback> _tokenGetCallbacks = [];
  final List<Callback> _tokenRefreshCallbacks = [];
  final List<Callback> _permissionsRequestCallbacks = [];

  MessageHandler _onMessage;

  // ignore: unused_field
  MessageHandler _onLaunch;

  // ignore: unused_field
  MessageHandler _onResume;

  @override
  Future<bool> requestNotificationPermissions(
      [IosNotificationSettings iosSettings =
          const IosNotificationSettings()]) async {
    final completer = Completer<bool>();
    _channel.postMessage(json.encode({'method': 'request_permissions'}));
    // ignore: unnecessary_lambdas
    _permissionsRequestCallbacks.add((data) => completer.complete(data));
    return completer.future;
  }

  @override
  // ignore: missing_return
  Stream<IosNotificationSettings> get onIosSettingsRegistered {
    // No need to implement, because it's never going to be called
  }

  @override
  void configure(
      {MessageHandler onMessage,
      MessageHandler onLaunch,
      MessageHandler onResume}) {
    _onMessage = onMessage;
    _onLaunch = onLaunch;
    _onResume = onResume;
  }

  @override
  Future<String> getToken() {
    final completer = Completer<String>();
    _channel.postMessage(json.encode({'method': 'get_token'}));
    _tokenGetCallbacks.add((data) {
      completer.complete(data.toString());
    });
    return completer.future;
  }

  @override
  Stream<String> get onTokenRefresh {
    final controller = StreamController<String>();
    final callback = controller.add;
    _tokenRefreshCallbacks.add(callback);
    controller.onCancel = () {
      _tokenRefreshCallbacks.remove(callback);
      controller.close();
    };
    return controller.stream;
  }
}
