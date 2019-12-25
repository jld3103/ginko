import 'package:meta/meta.dart';

/// class Device
/// describes the user's device
class Device {
  // ignore: public_member_api_docs
  Device({
    @required this.token,
    @required this.os,
    @required this.version,
  });

  // ignore: public_member_api_docs
  factory Device.fromJSON(json) => Device(
        token: json['token'],
        os: json['os'],
        version: json['version'],
      );

  // ignore: public_member_api_docs
  Map<String, String> toJSON() => {
        'token': token,
        'os': os,
        'version': version,
      };

  // ignore: public_member_api_docs
  final String token;

  // ignore: public_member_api_docs
  final String os;

  // ignore: public_member_api_docs
  final String version;
}
