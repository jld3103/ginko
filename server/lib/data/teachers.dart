import 'dart:convert';
import 'dart:io';

import 'package:models/models.dart';
import 'package:server/parsers/teachers.dart';

// ignore: avoid_classes_with_only_static_members
/// TeachersData class
/// handles all teachers storing
class TeachersData {
  // ignore: public_member_api_docs
  static Teachers teachers;

  /// Load teachers
  static Future load() async {
    Directory('build').createSync();
    File('build/teachers.pdf')
        .writeAsBytesSync(await TeachersParser.download());
    await Process.run('node', [
      'js/pdf_table.js',
      'build/teachers.pdf',
      'build/teachers.json',
    ]);

    teachers = await TeachersParser.extract(
        json.decode(File('build/teachers.json').readAsStringSync()));
  }
}
