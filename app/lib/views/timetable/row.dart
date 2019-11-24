import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// TimetableRow class
/// renders a lesson/subject
class TimetableRow extends StatelessWidget {
  // ignore: public_member_api_docs
  const TimetableRow({
    @required this.subject,
  });

  // ignore: public_member_api_docs
  final Subject subject;

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
      padding: EdgeInsets.only(top: 5, right: 9, bottom: 5, left: 6),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 2.5, right: 2.5),
            width: 20,
            child: Text(
              '${subject.unit + 1}',
              style: TextStyle(
                color: Color(0xff444444),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
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
                  children: [
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
