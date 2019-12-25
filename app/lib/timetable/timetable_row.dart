import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ginko/utils/static.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:models/models.dart';

// ignore: public_member_api_docs
class TimetableRow extends StatelessWidget {
  // ignore: public_member_api_docs
  const TimetableRow({
    @required this.subject,
    this.showUnit = true,
    this.keepPadding = true,
    this.keepIndicator = true,
    Key key,
  })  : assert(subject != null, 'subject must not be null'),
        super(key: key);

  // ignore: public_member_api_docs
  final TimetableSubject subject;

  // ignore: public_member_api_docs
  final bool showUnit;

  // ignore: public_member_api_docs
  final bool keepPadding;

  // ignore: public_member_api_docs
  final bool keepIndicator;

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
      height: 40,
      child: Row(
        children: [
          if (keepPadding)
            Container(
              width: 10,
              color: Colors.transparent,
              child: showUnit && unit != 5
                  ? Center(
                      child: Text(
                        (unit + 1).toString(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )
                  : null,
            ),
          if (keepIndicator)
            Container(
              height: 40,
              width: 2.5,
              margin: EdgeInsets.only(
                top: 1,
                right: 5,
                bottom: 1,
                left: 5,
              ),
              color: Colors.transparent,
            ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  subject.subject == 'mit' || subject.subject == 'none'
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
              children: [
                if (Static.subjects.hasLoadedData)
                  Text(
                    Static.subjects.data.subjects[subject.subject],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          subject.subject == 'mit' || subject.subject == 'none'
                              ? null
                              : FontWeight.bold,
                      color:
                          subject.subject == 'mit' || subject.subject == 'none'
                              ? Colors.black
                              : Theme.of(context).accentColor,
                    ),
                  ),
                if (subject.subject != 'mit' && subject.subject != 'none')
                  Text(
                    timeStr,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
          if (subject.subject != 'mit' && subject.subject != 'none')
            Container(
              width: 24,
              margin: EdgeInsets.only(right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (subject.teachers != null)
                    Text(
                      '${subject.teachers[0].toUpperCase()}\n',
                      style: GoogleFonts.ubuntuMono(
                        fontSize: 16,
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
