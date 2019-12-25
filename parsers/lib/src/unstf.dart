import 'dart:convert';
import 'dart:io';

// ignore: public_member_api_docs
Future<List<List<String>>> loadUNSTFFile() async {
  final lines = [];
  await for (final line in File('../parsers/Schuldatentransfer UNSTF.TXT')
      .openRead()
      .transform(latin1.decoder)
      .transform(LineSplitter())) {
    lines.add(line.split(';'));
  }
  return lines.cast<List<String>>();
}
