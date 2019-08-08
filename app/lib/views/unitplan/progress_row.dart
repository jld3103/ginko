import 'dart:async';

import 'package:app/utils/data.dart';
import 'package:app/utils/selection.dart';
import 'package:app/views/replacementplan/row.dart';
import 'package:app/views/unitplan/row.dart';
import 'package:app/views/unitplan/select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// UnitPlanProgressRow class
/// renders a lesson/subject with progress
class UnitPlanProgressRow extends StatefulWidget {
  // ignore: public_member_api_docs
  const UnitPlanProgressRow({
    @required this.lesson,
    @required this.start,
    @required this.weekday,
  });

  // ignore: public_member_api_docs
  final Lesson lesson;

  // ignore: public_member_api_docs
  final DateTime start;

  // ignore: public_member_api_docs
  final int weekday;

  @override
  _UnitPlanProgressRowState createState() => _UnitPlanProgressRowState();
}

class _UnitPlanProgressRowState extends State<UnitPlanProgressRow> {
  double _progress = 1;

  Timer _timer;
  Subject _subject;

  void _updateProgress() {
    print('${widget.weekday} ${widget.lesson.unit}');
    setState(() {
      if (DateTime.now()
          .isAfter(widget.start.add(Times.getUnitTimes(_subject.unit)[1]))) {
        _progress = 1;
      } else if (DateTime.now()
          .isBefore(widget.start.add(Times.getUnitTimes(_subject.unit)[0]))) {
        _progress = 0;
      } else {
        _progress = DateTime.now()
                .subtract(Times.getUnitTimes(_subject.unit)[0])
                .minute /
            60;
      }
      if (_progress == 1 && _timer != null) {
        _timer.cancel();
        _timer = null;
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((a) {
      _updateProgress();
      if (_progress != 1) {
        _timer = Timer.periodic(Duration(minutes: 1), (a) => _updateProgress());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subjects = widget.lesson.subjects
        .where((subject) =>
            Selection.get(widget.lesson.block, isWeekA(widget.start)) ==
            subject.identifier)
        .toList();
    _subject = subjects.isNotEmpty
        ? subjects[0]
        : Subject(
            subject: Keys.none,
            teacher: null,
            weeks: null,
            room: null,
            unit: widget.lesson.unit,
          );
    return GestureDetector(
      onTap: () {
        if (widget.lesson.subjects.length > 1) {
          showDialog(
            context: context,
            builder: (context) => UnitPlanSelectDialog(
              weekday: widget.weekday,
              lesson: widget.lesson,
            ),
          );
        }
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 5,
              right: 5,
              top: 0,
              bottom: Data.unitPlan.days[widget.weekday].lessons
                              .indexOf(widget.lesson) ==
                          Data.unitPlan.days[widget.weekday].lessons.length -
                              1 &&
                      MediaQuery.of(context).size.width < 600
                  ? 25
                  : 0,
            ),
            child: Column(
              children: [
                UnitPlanRow(subject: _subject),
                ...Data.replacementPlan.changes
                    .where((change) =>
                        change.date ==
                            monday(DateTime.now())
                                .add(Duration(days: widget.weekday)) &&
                        change.unit == widget.lesson.unit &&
                        change
                            .getMatchingSubjectsByLesson(widget.lesson)
                            .where((s) => s.identifier == _subject.identifier)
                            .isNotEmpty)
                    .map((change) => Container(
                          margin: EdgeInsets.only(left: 15),
                          child: ReplacementPlanRow(
                            change: change,
                            showUnit: false,
                            addPadding: false,
                          ),
                        ))
                    .toList()
                    .cast<Widget>(),
              ],
            ),
          ),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) => Padding(
                padding: EdgeInsets.only(
                    bottom: constraints.biggest.height * (1 - _progress)),
                child: Container(
                  color: Colors.black.withOpacity(0.15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
