import 'package:http/http.dart' as http;
import 'package:models/models.dart';
import 'package:server/config.dart';

/// TeachersParser class
/// handles all teachers parsing
class TeachersParser {
  static const String _url =
      'https://viktoriaschule-aachen.de/dokumente/upload/5c04d_Kollegiumsliste_mit_Angabe_des_Namens,_des_K%C3%BCrzels_und_der_unterrichten_F%C3%A4cher,_Stand_vom_28.08.2019.pdf';

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
      date: DateTime(2019, 8, 28),
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
