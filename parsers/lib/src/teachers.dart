import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// TeachersParser class
/// handles all teachers parsing
class TeachersParser {
  static const String _url =
      'https://viktoriaschule-aachen.de/dokumente/upload/1e6b3_Lehrer_Fakultenliste_20191107.pdf';
  static final Dio _dio = Dio();

  /// Download pdf teachers list
  static Future<List<int>> download(String username, String password) async {
    final response = await _dio
        .get(_url,
            options: Options(
              headers: {
                'authorization':
                    'Basic ${base64Encode(utf8.encode('$username:$password'))}',
              },
              responseType: ResponseType.bytes,
            ))
        .timeout(Duration(seconds: 10));
    return response.data;
  }

  /// Extract teachers
  // ignore: avoid_annotating_with_dynamic
  static Future<Teachers> extract(List<int> raw) async {
    Directory('build').createSync();
    File('build/teachers.pdf').writeAsBytesSync(raw);
    await Process.run('node', [
      '../parsers/js/pdf_table.js',
      'build/teachers.pdf',
      'build/teachers.json',
    ]);
    final data = json.decode(File('build/teachers.json').readAsStringSync());
    final entries = [];
    data['pageTables'].map((x) => x['tables']).toList().forEach(entries.addAll);

    return Teachers(
      date: DateTime(2019, 11, 7),
      teachers: entries
          .map((i) => i[0])
          .where((i) => i != 'Fakultenliste' && i.isNotEmpty)
          .toList()
          .map((i) => Teacher(shortName: i.substring(i.length - 3)))
          .toList()
          .cast<Teacher>(),
    );
  }
}
