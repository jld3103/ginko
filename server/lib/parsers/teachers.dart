import 'package:http/http.dart' as http;
import 'package:models/models.dart';
import 'package:server/config.dart';

/// TeachersParser class
/// handles all teachers parsing
class TeachersParser {
  static const String _url =
      'https://www.viktoriaschule-aachen.de/dokumente/upload/513b6_Lehrer_Fakultenliste_breites_Namensfeld_08_17.rtm_20191001.pdf';

  /// Download pdf teachers list
  static Future<List<int>> download() async {
    final response = await http
        .get(_url, headers: Config.headers)
        .timeout(Duration(seconds: 3));
    return response.bodyBytes;
  }

  /// Extract teachers
  // ignore: avoid_annotating_with_dynamic
  static Future<Teachers> extract(dynamic data) async {
    final entries = [];
    data['pageTables'].map((x) => x['tables']).toList().forEach(entries.addAll);

    return Teachers(
      date: DateTime(2019, 10, 1),
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
