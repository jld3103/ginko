import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ginko/utils/custom_row.dart';
import 'package:ginko/utils/static.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:models/models.dart';

// ignore: public_member_api_docs
class SubstitutionPlanRow extends StatelessWidget {
  // ignore: public_member_api_docs
  const SubstitutionPlanRow({
    @required this.change,
    this.showUnit = true,
    this.keepPadding = false,
    Key key,
  })  : assert(change != null, 'change must not be null'),
        super(key: key);

  // ignore: public_member_api_docs
  final SubstitutionPlanChange change;

  // ignore: public_member_api_docs
  final bool showUnit;

  // ignore: public_member_api_docs
  final bool keepPadding;

  @override
  Widget build(BuildContext context) {
    final infoText = [];
    if (change.changed.subject != null &&
        (change.subject != null && change.subject != change.changed.subject)) {
      infoText.add(Static.subjects.data.subjects[change.subject]);
    }
    switch (change.type) {
      case SubstitutionPlanChangeTypes.exam:
        infoText.add(Static.subjects.data.subjects['kl']);
        break;
      case SubstitutionPlanChangeTypes.freeLesson:
        infoText.add(Static.subjects.data.subjects['fr']);
        break;
      case SubstitutionPlanChangeTypes.changed:
        break;
    }
    if (change.changed.info != null) {
      infoText.add(change.changed.info);
    }
    return CustomRow(
      splitColor: change.type == SubstitutionPlanChangeTypes.freeLesson
          ? Theme.of(context).accentColor
          : (change.type == SubstitutionPlanChangeTypes.exam
              ? Colors.red
              : Colors.orange),
      leading: showUnit
          ? Center(
              child: Text(
                (change.unit + 1).toString(),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          : keepPadding ? Container() : null,
      title: Static.subjects.hasLoadedData
          ? (infoText.isNotEmpty
              ? infoText.join(' ')
              : Static.subjects.data.subjects[change.subject])
          : null,
      subtitle: Static.subjects.hasLoadedData &&
              infoText.join(' ') !=
                  Static.subjects.data.subjects[change.subject] &&
              infoText.isNotEmpty
          ? Text(
              Static.subjects.data.subjects[change.subject],
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.black54,
              ),
            )
          : null,
      last: Row(
        children: [
          if (change.type != SubstitutionPlanChangeTypes.freeLesson ||
              Static.timetable.data.days[change.date.weekday - 1]
                      .lessons[change.unit].subjects
                      .where((s) =>
                          Static.subjects.data.subjects[s.subject] ==
                          Static.subjects.data.subjects[change.subject])
                      .length >
                  1)
            Container(
              width: 24,
              margin: EdgeInsets.only(right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    change.changed.teacher != null
                        ? change.changed.teacher.toUpperCase()
                        : change.teacher != null
                            ? change.teacher.toUpperCase()
                            : '',
                    style: GoogleFonts.ubuntuMono(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    change.teacher != null &&
                            change.changed.teacher != null &&
                            change.teacher != change.changed.teacher
                        ? change.teacher.toUpperCase()
                        : '',
                    style: GoogleFonts.ubuntuMono(
                      fontSize: 16,
                      textStyle: TextStyle(
                        color: Colors.black54,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (change.type != SubstitutionPlanChangeTypes.freeLesson ||
              Static.timetable.data.days[change.date.weekday - 1]
                      .lessons[change.unit].subjects
                      .where((s) =>
                          Static.subjects.data.subjects[s.subject] ==
                          Static.subjects.data.subjects[change.subject])
                      .length >
                  1)
            Container(
              width: 24,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    change.changed.room != null
                        ? change.changed.room.toUpperCase()
                        : change.room != null ? change.room.toUpperCase() : '',
                    style: GoogleFonts.ubuntuMono(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    change.room != null &&
                            change.changed.room != null &&
                            change.room != change.changed.room
                        ? change.room.toUpperCase()
                        : '',
                    style: GoogleFonts.ubuntuMono(
                      fontSize: 16,
                      textStyle: TextStyle(
                        color: Colors.black54,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
