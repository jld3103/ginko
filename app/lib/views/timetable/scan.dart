import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:ginko/utils/selection.dart';
import 'package:ginko/utils/static.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// ScanDialog class
/// scan an image of a paper timetable
/// and insert all selections if possible using OCR
class ScanDialog extends StatefulWidget {
  // ignore: public_member_api_docs
  const ScanDialog({
    @required this.teachers,
    @required this.timetable,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final Teachers teachers;

  // ignore: public_member_api_docs
  final TimetableForGrade timetable;

  @override
  _ScanDialogState createState() => _ScanDialogState();
}

class _ScanDialogState extends State<ScanDialog> {
  bool _scanned = false;
  bool _scanning = false;
  bool _allDetected = true;

  Future<File> _selectImage() =>
      ImagePicker.pickImage(source: ImageSource.camera);

  Future<String> _scanImage(File file) async {
    final visionImage = FirebaseVisionImage.fromFile(file);
    final textRecognizer = FirebaseVision.instance.textRecognizer();
    final visionText = await textRecognizer.processImage(visionImage);
    return visionText.text;
  }

  void _insertData(List<String> matches) {
    for (final match in matches) {
      var subject = '';
      try {
        subject = Subjects.getSubject(
            RegExp(Subjects.regex).firstMatch(match).group(0).toUpperCase() ??
                RegExp(Subjects.regex).firstMatch(match).group(0));
        // ignore: avoid_catches_without_on_clauses, empty_catches
      } catch (e) {}
      final teacher = RegExp(widget.teachers.regex)
          .firstMatch(match)
          .group(0)
          .toUpperCase();
      final room = Rooms.getRoom(match.substring(match.indexOf(
                  RegExp(widget.teachers.regex).firstMatch(match).group(0)) +
              3) ??
          match.substring(match.indexOf(
                  RegExp(widget.teachers.regex).firstMatch(match).group(0)) +
              3));
      final matchingSubjects = [];
      for (final day in widget.timetable.days) {
        for (final lesson in day.lessons) {
          for (final s in lesson.subjects) {
            final sRoom = Rooms.getRoom(s.room ?? '');
            final sTeacher = (s.teacher ?? '')
                .toUpperCase()
                .replaceAll('Ä', 'A')
                .replaceAll('Ö', 'O')
                .replaceAll('Ü', 'U');
            final sSubject = Subjects.getSubject(s.subject ?? '');
            if ((subject == sSubject && room == sRoom && teacher == sTeacher) ||
                (room == sRoom && teacher == sTeacher) ||
                (subject == sSubject && teacher == sTeacher)) {
              matchingSubjects.add(MatchingSubject(
                subject: s,
                lesson: lesson,
              ));
            }
          }
        }
      }

      if (matchingSubjects.length <= 4 && matchingSubjects.isNotEmpty) {
        for (final match in matchingSubjects) {
          final subject = match.subject;
          final lesson = match.lesson;
          for (final weekA
              in subject.weeks.split('').map((i) => i == 'A').toList()) {
            TimetableSelection.set(lesson.block, weekA, subject.identifier);
          }
        }
        Static.rebuildTimetable();
        for (final day in widget.timetable.days) {
          if (!_allDetected) {
            break;
          }
          for (final lesson in day.lessons) {
            if (!_allDetected) {
              break;
            }
            for (final weekA in [true, false]) {
              if (TimetableSelection.get(lesson.block, weekA) == null) {
                setState(() {
                  _allDetected = false;
                });
                break;
              }
            }
          }
        }
      }
    }
  }

  String _removeFoundMatches(String text, List<Match> matches) {
    for (final match in _createStringMatches(matches)) {
      text = text.replaceAll(match, '');
    }
    return text;
  }

  List<String> _createStringMatches(List<Match> matches) => matches
      .map((match) => match.group(0).replaceAll(RegExp('sp[0-9]\/'), 'sp/'))
      .toSet()
      .toList();

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text(
          AppTranslations.of(context).scanTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: _scanning
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 75,
                          height: 75,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(AppTranslations.of(context).scanScanning),
                        ),
                      ],
                    ),
                  )
                : !_scanned
                    ? Column(
                        children: [
                          Text(
                            AppTranslations.of(context).scanDescription,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.justify,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                color: Theme.of(context).accentColor,
                                onPressed: () async {
                                  setState(() {
                                    _scanning = true;
                                  });
                                  var text =
                                      await _scanImage(await _selectImage());
                                  setState(() {
                                    _scanning = false;
                                    _scanned = true;
                                  });
                                  text = text
                                      .toLowerCase()
                                      .replaceAll(' ', '')
                                      .replaceAll('.', '')
                                      .replaceAll(',', '')
                                      .replaceAll('/', '')
                                      .replaceAll('ä', 'a')
                                      .replaceAll('ö', 'o')
                                      .replaceAll('ü', 'u');
                                  final regExp = RegExp(
                                      // ignore: lines_longer_than_80_chars
                                      '${Subjects.regex}([0-9]).{0,2}${widget.teachers.regex}${Rooms.regex}');
                                  final maybeRegExp = RegExp(
                                      '${widget.teachers.regex}${Rooms.regex}');
                                  final matches =
                                      regExp.allMatches(text).toList();
                                  final maybeMatches =
                                      maybeRegExp.allMatches(text).toList();
                                  text = _removeFoundMatches(text, matches);
                                  text =
                                      _removeFoundMatches(text, maybeMatches);
                                  _insertData(_createStringMatches(matches));
                                  _insertData(
                                      _createStringMatches(maybeMatches));
                                },
                                child: Text(
                                    AppTranslations.of(context).scanSubmit),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                            _allDetected
                                ? AppTranslations.of(context).scanAllDetected
                                : AppTranslations.of(context)
                                    .scanNotAllDetected,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.justify,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                color: Theme.of(context).accentColor,
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(AppTranslations.of(context).ok),
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      );
}
