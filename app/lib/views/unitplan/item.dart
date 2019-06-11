import 'package:app/utils/localizations.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:models/times.dart';

/// UnitPlanItem class
/// renders a lesson/subject
class UnitPlanItem {
  // ignore: public_member_api_docs
  UnitPlanItem(this.subject);

  // ignore: public_member_api_docs
  Subject subject;

  /// renders a lesson/subject
  Widget render(BuildContext context) {
    final unit = subject.unit;

    final times = Times.getUnitTimes(unit, false);
    final startHour = (times[0].inHours.toString().length == 1 ? '0' : '') +
        times[0].inHours.toString();
    final startMinute =
        ((times[0].inMinutes % 60).toString().length == 1 ? '0' : '') +
            (times[0].inMinutes % 60).toString();
    final endHour = (times[1].inHours.toString().length == 1 ? '0' : '') +
        times[1].inHours.toString();
    final endMinute =
        ((times[1].inMinutes % 60).toString().length == 1 ? '0' : '') +
            (times[1].inMinutes % 60).toString();
    final timeStr = '$startHour:$startMinute - $endHour:$endMinute';

    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 50,
                  child: Text(
                      AppLocalization.of(context).subject(subject.subject) ??
                          ''),
                ),
                Expanded(
                  flex: 50,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(subject.room ?? ''),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 50,
                  child: Text(timeStr),
                ),
                Expanded(
                  flex: 50,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(subject.teacher ?? ''),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
