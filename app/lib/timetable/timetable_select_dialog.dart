import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ginko/timetable/timetable_row.dart';
import 'package:ginko/utils/dialog_content_wrapper.dart';
import 'package:models/models.dart';

// ignore: public_member_api_docs
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
            '${weekdays[weekday]} ${lesson.unit + 1}.'),
        children: [
          DialogContentWrapper(
            children: lesson.subjects
                .map((subject) => InkWell(
                      onTap: () {
                        Navigator.of(context).pop(subject);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        child: TimetableRow(
                          showUnit: false,
                          showSplit: false,
                          subject: subject,
                        ),
                      ),
                    ))
                .toList()
                .cast<Widget>(),
          ),
        ],
      );
}
