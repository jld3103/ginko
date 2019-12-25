// ignore: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:models/models.dart';

// ignore: public_member_api_docs
enum OS {
  // ignore: public_member_api_docs
  linux,
  // ignore: public_member_api_docs
  mac,
  // ignore: public_member_api_docs
  windows,
}

// ignore: public_member_api_docs
String getFileExtension(Asset asset) => asset.name.split('.').last;

// ignore: public_member_api_docs
OS getOS(Asset asset) {
  if (getFileExtension(asset) == 'AppImage' ||
      getFileExtension(asset) == 'deb' ||
      getFileExtension(asset) == 'rpm' ||
      getFileExtension(asset) == 'snap') {
    return OS.linux;
  } else if (getFileExtension(asset) == 'dmg' ||
      getFileExtension(asset) == 'pkg') {
    return OS.mac;
  } else if (getFileExtension(asset) == 'msi') {
    return OS.windows;
  } else {
    return null;
  }
}

// ignore: public_member_api_docs
IconData getOSIcon(Asset asset) => getOS(asset) == OS.linux
    ? MdiIcons.linux
    : getOS(asset) == OS.mac ? MdiIcons.apple : MdiIcons.windows;

// ignore: public_member_api_docs
String getOSName(Asset asset) => getOS(asset) == OS.linux
    ? 'Linux'
    : getOS(asset) == OS.mac ? 'Mac' : 'Windows';
