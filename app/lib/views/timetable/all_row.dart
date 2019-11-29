import 'package:flutter/material.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/views/substitution_plan/row.dart';
import 'package:ginko/views/timetable/row.dart';
import 'package:models/models.dart';

/// TimetableAllRow class
/// renders a lesson/subject with all it's changes
class TimetableAllRow extends StatefulWidget {
  // ignore: public_member_api_docs
  const TimetableAllRow({
    @required this.subject,
    @required this.timetableDay,
    @required this.substitutionPlan,
    @required this.start,
    this.current,
  });

  // ignore: public_member_api_docs
  final TimetableSubject subject;

  // ignore: public_member_api_docs
  final TimetableDay timetableDay;

  // ignore: public_member_api_docs
  final SubstitutionPlanForGrade substitutionPlan;

  // ignore: public_member_api_docs
  final DateTime start;

  // ignore: public_member_api_docs
  final DateTime current;

  @override
  _TimetableAllRowState createState() => _TimetableAllRowState();
}

class _TimetableAllRowState extends State<TimetableAllRow> {
  @override
  Widget build(BuildContext context) {
    final changes = widget.substitutionPlan.changes.where((change) =>
        change.date ==
            monday(widget.current ?? DateTime.now())
                .add(Duration(days: widget.timetableDay.weekday)) &&
        change.unit == widget.timetableDay.lessons[widget.subject.unit].unit &&
        change
            .getMatchingSubjectsByLesson(
                widget.timetableDay.lessons[widget.subject.unit])
            .contains(widget.subject));
    final showOriginal = (changes.isEmpty ||
            changes
                .where((change) => change.type == ChangeTypes.exam)
                .isNotEmpty) &&
        changes.where((change) => change.type != ChangeTypes.exam).length != 1;
    return Container(
      padding: EdgeInsets.only(
        left: 5,
        right: 5,
        top: 10,
        bottom: widget.timetableDay.lessons.indexOf(
                        widget.timetableDay.lessons[widget.subject.unit]) ==
                    widget.timetableDay.lessons.length - 1 &&
                getScreenSize(MediaQuery.of(context).size.width) ==
                    ScreenSize.small
            ? 35
            : 0,
      ),
      child: Center(
        child: Column(
          children: [
            if (showOriginal) TimetableRow(subject: widget.subject),
            ...changes
                .map((change) => SubstitutionPlanRow(
                      change: change.completed(
                          widget.timetableDay.lessons[widget.subject.unit]),
                      showUnit: !showOriginal &&
                          (changes.toList().indexOf(change) == 0),
                    ))
                .toList()
                .cast<Widget>(),
          ],
        ),
      ),
    );
  }
}
