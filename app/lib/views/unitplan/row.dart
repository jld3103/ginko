import 'package:app/utils/localizations.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// UnitPlanRow class
/// renders a lesson/subject
class UnitPlanRow extends StatelessWidget {
  // ignore: public_member_api_docs
  const UnitPlanRow({
    @required this.subject,
    this.showUnit = true,
    this.addPadding = true,
  });

  // ignore: public_member_api_docs
  final Subject subject;

  // ignore: public_member_api_docs
  final bool showUnit;

  // ignore: public_member_api_docs
  final bool addPadding;

  @override
  Widget build(BuildContext context) {
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
        child: Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: addPadding ? 20 : null,
              child: showUnit ? Text('${subject.unit + 1}') : null,
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 85,
                        child: Text(
                          AppLocalization.of(context)
                                  .subject(subject.subject) ??
                              '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 15,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(subject.room ?? ''),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 85,
                        child: Text(
                          timeStr,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 15,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(subject.teacher ?? ''),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
