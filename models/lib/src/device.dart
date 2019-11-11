import 'package:meta/meta.dart';

/// class Device
/// describes the user's device
class Device {
  // ignore: public_member_api_docs
  Device({
    @required this.token,
    @required this.language,
    @required this.os,
  });

  // ignore: public_member_api_docs
  factory Device.fromJSON(json) => Device(
        token: json['token'],
        language: json['language'],
        os: json['os'],
      );

  // ignore: public_member_api_docs
  Map<String, String> toJSON() => {
        'token': token,
        'language': language,
        'os': os,
      };

  // ignore: public_member_api_docs
  final String token;

  // ignore: public_member_api_docs
  final String language;

  // ignore: public_member_api_docs
  final String os;
}
