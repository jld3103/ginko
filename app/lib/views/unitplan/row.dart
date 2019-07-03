import 'package:app/utils/selection.dart';
import 'package:app/utils/static.dart';
import 'package:app/views/unitplan/item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// UnitPlanRow class
/// wrapper for unit plan item
class UnitPlanRow extends StatefulWidget {
  // ignore: public_member_api_docs
  const UnitPlanRow({
    @required this.start,
    @required this.lesson,
  });

  // ignore: public_member_api_docs
  final DateTime start;

  // ignore: public_member_api_docs
  final Lesson lesson;

  @override
  State<StatefulWidget> createState() => UnitPlanRowState();
}

/// UnitPlanRowState class
/// wrapper state for a unit plan item
class UnitPlanRowState extends State<UnitPlanRow> {
  @override
  Widget build(BuildContext context) {
    final weekA = weekNumber(widget.start) % 2 == 0;

    final subjects = widget.lesson.subjects
        .where((subject) =>
            Selection.get(widget.lesson.block, weekA) == subject.identifier)
        .toList();
    final subject = subjects.isNotEmpty
        ? subjects[0]
        : Subject(
            subject: Keys.none,
            teacher: null,
            weeks: null,
            room: null,
            course: null,
            changes: <Change>[],
            unit: widget.lesson.unit,
          );
    return GestureDetector(
      onTap: () {
        if (widget.lesson.subjects.length > 1) {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              contentPadding: EdgeInsets.all(10),
              children: widget.lesson.subjects
                  .map((subject) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Selection.set(
                              widget.lesson.block, weekA, subject.identifier);
                          Static.rebuildUnitPlan();
                        },
                        child: UnitPlanItem(subject),
                      ))
                  .toList(),
            ),
          );
        }
      },
      child: UnitPlanItem(subject),
    );
  }
}
