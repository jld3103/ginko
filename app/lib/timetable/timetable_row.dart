import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ginko/utils/custom_row.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:models/models.dart';

// ignore: public_member_api_docs
class TimetableRow extends StatelessWidget {
  // ignore: public_member_api_docs
  const TimetableRow({
    @required this.subject,
    this.showUnit = true,
    this.showSplit = true,
    Key key,
  })  : assert(subject != null, 'subject must not be null'),
        super(key: key);

  // ignore: public_member_api_docs
  final TimetableSubject subject;

  // ignore: public_member_api_docs
  final bool showUnit;

  // ignore: public_member_api_docs
  final bool showSplit;

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
    return CustomRow(
      showSplit:
          !(subject.subject == 'mit' || subject.subject == 'none') && showSplit,
      leading: showUnit && unit != 5
          ? Center(
              child: Text(
                (unit + 1).toString(),
                style: TextStyle(
                  fontSize: 18,
                  color: textColor(context),
                ),
              ),
            )
          : null,
      titleAlignment: subject.subject == 'mit' || subject.subject == 'none'
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      title: Static.subjects.hasLoadedData
          ? Static.subjects.data.subjects[subject.subject]
          : null,
      titleFontWeight: subject.subject == 'mit' || subject.subject == 'none'
          ? FontWeight.normal
          : null,
      titleColor: subject.subject == 'mit' || subject.subject == 'none'
          ? textColor(context)
          : Theme.of(context).accentColor,
      subtitle: subject.subject != 'mit' && subject.subject != 'none'
          ? Text(
              timeStr,
              style: TextStyle(
                color: textColor(context),
              ),
            )
          : null,
      last: Row(
        children: [
          if (subject.subject != 'mit' && subject.subject != 'none')
            Container(
              width: 24,
              margin: EdgeInsets.only(right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (subject.teachers != null)
                    Text(
                      // ignore: lines_longer_than_80_chars
                      '${(subject.teachers.map((t) => t.toUpperCase()).toList()..addAll([
                          if (subject.teachers.length == 1) ''
                        ])).join('\n')}',
                      style: GoogleFonts.ubuntuMono(
                        fontSize: 16,
                        color: textColor(context),
                      ),
                    ),
                ],
              ),
            ),
          if (subject.subject != 'mit' && subject.subject != 'none')
            Container(
              width: 24,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (subject.room != null)
                    Text(
                      '${subject.room.toUpperCase()}\n',
                      style: GoogleFonts.ubuntuMono(
                        fontSize: 16,
                        color: textColor(context),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
