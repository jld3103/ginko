import 'package:flutter/material.dart';
import 'package:ginko/views/timetable/row.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// TimetableSelectDialog class
/// display the dialog to select the subject of a lesson
class TimetableSelectDialog extends StatelessWidget {
  // ignore: public_member_api_docs
  const TimetableSelectDialog({
    @required this.weekday,
    @required this.lesson,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final int weekday;

  // ignore: public_member_api_docs
  final TimetableLesson lesson;

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text(
            // ignore: lines_longer_than_80_chars
            '${AppTranslations.of(context).weekdays[weekday]} ${lesson.unit + 1}.'),
        children: [
          ..._abSubjects
              .map(
                (subject) => GestureDetector(
                  onTap: () => Navigator.of(context).pop([subject]),
                  child: TimetableRow(
                    subject: subject,
                  ),
                ),
              )
              .toList(),
          for (final subject1 in _aSubjects)
            Column(
              children: [
                for (final subject2 in _bSubjects)
                  if (subject1.subject != subject2.subject &&
                      (subject1.room ?? '') != (subject2.room ?? '') &&
                      subject1.teacher != subject2.teacher)
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pop([subject1, subject2]),
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  // ignore: lines_longer_than_80_chars
                                  '${_bSubjects.indexOf(subject2) + _aSubjects.indexOf(subject1) * _bSubjects.length + 1}. ${AppTranslations.of(context).homeAAndBWeeksCombination}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  TimetableRow(
                                    subject: subject1,
                                  ),
                                  TimetableRow(
                                    subject: subject2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              ],
            ),
        ],
      );

  List<TimetableSubject> get _aSubjects => lesson.subjects
      .where((subject) => subject.weeks == 'A' || subject.subject == 'FR')
      .toList();

  List<TimetableSubject> get _bSubjects => lesson.subjects
      .where((subject) => subject.weeks == 'B' || subject.subject == 'FR')
      .toList();

  List<TimetableSubject> get _abSubjects =>
      lesson.subjects.where((subject) => subject.weeks == 'AB').toList();
}
