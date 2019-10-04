import 'package:flutter/material.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/views/replacementplan/row.dart';
import 'package:ginko/views/unitplan/row.dart';
import 'package:models/models.dart';

/// UnitPlanAllRow class
/// renders a lesson/subject with all it's changes
class UnitPlanAllRow extends StatefulWidget {
  // ignore: public_member_api_docs
  const UnitPlanAllRow({
    @required this.subject,
    @required this.unitPlanDay,
    @required this.replacementPlan,
    @required this.start,
    this.current,
  });

  // ignore: public_member_api_docs
  final Subject subject;

  // ignore: public_member_api_docs
  final UnitPlanDay unitPlanDay;

  // ignore: public_member_api_docs
  final ReplacementPlanForGrade replacementPlan;

  // ignore: public_member_api_docs
  final DateTime start;

  // ignore: public_member_api_docs
  final DateTime current;

  @override
  _UnitPlanAllRowState createState() => _UnitPlanAllRowState();
}

class _UnitPlanAllRowState extends State<UnitPlanAllRow> {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(
          left: 5,
          right: 5,
          top: 0,
          bottom: widget.unitPlanDay.lessons.indexOf(
                          widget.unitPlanDay.lessons[widget.subject.unit]) ==
                      widget.unitPlanDay.lessons.length - 1 &&
                  getScreenSize(MediaQuery.of(context).size.width) ==
                      ScreenSize.small
              ? 25
              : 0,
        ),
        child: Center(
          child: Column(
            children: [
              UnitPlanRow(subject: widget.subject),
              ...widget.replacementPlan.changes
                  .where((change) =>
                      change.date ==
                          monday(widget.current ?? DateTime.now()).add(
                              Duration(days: widget.unitPlanDay.weekday)) &&
                      change.unit ==
                          widget
                              .unitPlanDay.lessons[widget.subject.unit].unit &&
                      change
                          .getMatchingSubjectsByLesson(
                              widget.unitPlanDay.lessons[widget.subject.unit])
                          .isNotEmpty)
                  .map((change) => ReplacementPlanRow(
                        change: change,
                        showUnit: false,
                        addPadding: false,
                      ))
                  .toList()
                  .cast<Widget>(),
            ],
          ),
        ),
      );
}
