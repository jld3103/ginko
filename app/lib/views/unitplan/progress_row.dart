import 'dart:async';

import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/views/replacementplan/row.dart';
import 'package:ginko/views/unitplan/progress_overlay.dart';
import 'package:ginko/views/unitplan/row.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// UnitPlanProgressRow class
/// renders a lesson/subject with progress
class UnitPlanProgressRow extends StatefulWidget {
  // ignore: public_member_api_docs
  const UnitPlanProgressRow({
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
  _UnitPlanProgressRowState createState() => _UnitPlanProgressRowState();
}

class _UnitPlanProgressRowState extends State<UnitPlanProgressRow> {
  double _progress = 1;

  Timer _timer;

  void _updateProgress() {
    setState(() {
      if ((widget.current ?? DateTime.now()).isAfter(
          widget.start.add(Times.getUnitTimes(widget.subject.unit)[1]))) {
        _progress = 1;
      } else if ((widget.current ?? DateTime.now()).isBefore(
          widget.start.add(Times.getUnitTimes(widget.subject.unit)[0]))) {
        _progress = 0;
      } else {
        _progress = (widget.current ?? DateTime.now())
                .subtract(Times.getUnitTimes(widget.subject.unit)[0])
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
      _timer = Timer.periodic(Duration(minutes: 1), (a) => _updateProgress());
      _updateProgress();
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
  Widget build(BuildContext context) => Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 5,
              right: 5,
              top: 0,
              bottom: widget.unitPlanDay.lessons.indexOf(widget
                              .unitPlanDay.lessons[widget.subject.unit]) ==
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
                              widget.unitPlanDay.lessons[widget.subject.unit]
                                  .unit &&
                          change
                              .getMatchingSubjectsByLesson(widget
                                  .unitPlanDay.lessons[widget.subject.unit])
                              .where((s) =>
                                  s.identifier == widget.subject.identifier)
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
          ),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) => UnitPlanProgressRowOverlay(
                height: constraints.biggest.height,
                progress: _progress,
              ),
            ),
          ),
        ],
      );
}
