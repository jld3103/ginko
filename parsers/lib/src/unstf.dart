import 'dart:convert';
import 'dart:io';

final _file = File('../parsers/Schuldatentransfer UNSTF.TXT');

// ignore: public_member_api_docs
Future<List<List<String>>> loadUNSTFFile() async {
  final lines = [];
  await for (final line
      in _file.openRead().transform(latin1.decoder).transform(LineSplitter())) {
    lines.add(line.split(';'));
  }
  return lines.cast<List<String>>();
}

// ignore: non_constant_identifier_names, public_member_api_docs
DateTime get UNSTFDate => DateTime(2020, 2, 3);
