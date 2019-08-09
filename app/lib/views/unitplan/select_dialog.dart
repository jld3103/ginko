import 'package:app/views/unitplan/row.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// UnitPlanSelectDialog class
/// display the dialog to select the subject of a lesson
class UnitPlanSelectDialog extends StatelessWidget {
  // ignore: public_member_api_docs
  const UnitPlanSelectDialog({
    @required this.weekday,
    @required this.lesson,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final int weekday;

  // ignore: public_member_api_docs
  final Lesson lesson;

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text(
            // ignore: lines_longer_than_80_chars
            '${AppTranslations.of(context).weekdays[weekday]} ${lesson.unit + 1}.'),
        contentPadding: EdgeInsets.all(10),
        children: [
          ..._abSubjects
              .map(
                (subject) => GestureDetector(
                  onTap: () => Navigator.of(context).pop([subject]),
                  child: UnitPlanRow(
                    subject: subject,
                    showUnit: false,
                    addPadding: false,
                  ),
                ),
              )
              .toList(),
          for (final subject1 in _aSubjects)
            Column(
              children: [
                for (final subject2 in _bSubjects)
                  if (Subjects.getSubject(subject1.subject) !=
                          Subjects.getSubject(subject2.subject) &&
                      Rooms.getRoom(subject1.room ?? '') !=
                          Rooms.getRoom(subject2.room ?? '') &&
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
                                  UnitPlanRow(
                                    subject: subject1,
                                    showUnit: false,
                                    addPadding: false,
                                  ),
                                  UnitPlanRow(
                                    subject: subject2,
                                    showUnit: false,
                                    addPadding: false,
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

  List<Subject> get _aSubjects => lesson.subjects
      .where((subject) => subject.weeks == 'A' || subject.subject == 'FR')
      .toList();

  List<Subject> get _bSubjects => lesson.subjects
      .where((subject) => subject.weeks == 'B' || subject.subject == 'FR')
      .toList();

  List<Subject> get _abSubjects =>
      lesson.subjects.where((subject) => subject.weeks == 'AB').toList();
}
