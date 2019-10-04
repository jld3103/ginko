import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 5, right: 9, bottom: 5, left: 6.5),
      child: Row(
        children: [
          Container(
            width: addPadding ? 17.5 : null,
            child: showUnit
                ? Text(
                    '${subject.unit + 1}',
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  )
                : null,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 85,
                      child: Text(
                        AppTranslations.of(context).subjects[subject.subject] ??
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
                        child: Text(
                          subject.room ?? '',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
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
                        child: Text(
                          subject.teacher ?? '',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
