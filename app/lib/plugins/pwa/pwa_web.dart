import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:ginko/plugins/pwa/pwa_base.dart';
import 'package:ginko/views/cloud/directory_overhead.dart';

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
  void download(String fileName, Uri uri) {
    final link = document.createElement('a')
      ..setAttribute('download', fileName)
      ..setAttribute('href', uri.toString())
      ..setAttribute('target', '_blank');
    document.body.append(link);
    link.click();
  }

  @override
  Future<DummyFile> selectFile() {
    final completer = Completer<DummyFile>();
    final InputElement link = document.createElement('input')
      ..setAttribute('type', 'file');
    link.onChange.listen((e) {
      final files = link.files;
      if (files.isNotEmpty) {
        final file = files[0];
        final reader = FileReader();
        reader.onLoad.listen((e) {
          completer.complete(DummyFile(file.name, reader.result));
        });
        reader.onError.listen((e) {
          print(reader.error.message);
          completer.complete(DummyFile('', Uint8List(0)));
        });
        reader.readAsArrayBuffer(file);
      } else {
        completer.complete(DummyFile('', Uint8List(0)));
      }
    });
    link.click();
    return completer.future;
  }
}
