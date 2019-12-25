import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ginko/utils/static.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:models/models.dart';

// ignore: public_member_api_docs
class SubstitutionPlanRow extends StatelessWidget {
  // ignore: public_member_api_docs
  const SubstitutionPlanRow({
    @required this.change,
    this.showUnit = true,
    this.keepPadding = true,
    Key key,
  })  : assert(change != null, 'change must not be null'),
        super(key: key);

  // ignore: public_member_api_docs
  final SubstitutionPlanChange change;

  // ignore: public_member_api_docs
  final bool showUnit;

  // ignore: public_member_api_docs
  final bool keepPadding;

  @override
  Widget build(BuildContext context) {
    final infoText = [];
    if (change.changed.subject != null &&
        (change.subject != null && change.subject != change.changed.subject)) {
      infoText.add(Static.subjects.data.subjects[change.subject]);
    }
    switch (change.type) {
      case SubstitutionPlanChangeTypes.exam:
        infoText.add(Static.subjects.data.subjects['kl']);
        break;
      case SubstitutionPlanChangeTypes.freeLesson:
        infoText.add(Static.subjects.data.subjects['fr']);
        break;
      case SubstitutionPlanChangeTypes.changed:
        break;
    }
    if (change.changed.info != null) {
      infoText.add(change.changed.info);
    }
    return Container(
      height: 40,
      child: Row(
        children: [
          if (keepPadding)
            Container(
              width: 10,
              color: Colors.transparent,
              child: showUnit
                  ? Center(
                      child: Text(
                        (change.unit + 1).toString(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )
                  : null,
            ),
          Container(
            height: 40,
            width: 2.5,
            margin: EdgeInsets.only(
              top: 1,
              right: 5,
              bottom: 1,
              left: 5,
            ),
            color: change.type == SubstitutionPlanChangeTypes.freeLesson
                ? Theme.of(context).accentColor
                : (change.type == SubstitutionPlanChangeTypes.exam
                    ? Colors.red
                    : Colors.orange),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Static.subjects.hasLoadedData)
                  Text(
                    infoText.join(' '),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                if (Static.subjects.hasLoadedData &&
                    infoText.join(' ') !=
                        Static.subjects.data.subjects[change.subject])
                  Text(
                    Static.subjects.data.subjects[change.subject],
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.black54,
                    ),
                  )
                else
                  Text(''),
              ],
            ),
          ),
          Container(
            width: 24,
            margin: EdgeInsets.only(right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  change.changed.teacher != null
                      ? change.changed.teacher.toUpperCase()
                      : '',
                  style: GoogleFonts.ubuntuMono(
                    fontSize: 16,
                  ),
                ),
                if (change.teacher != change.changed.teacher)
                  Text(
                    change.teacher != null ? change.teacher.toUpperCase() : '',
                    style: GoogleFonts.ubuntuMono(
                      fontSize: 16,
                      textStyle: TextStyle(
                        color: Colors.black54,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            width: 24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  change.changed.room != null
                      ? change.changed.room.toUpperCase()
                      : '',
                  style: GoogleFonts.ubuntuMono(
                    fontSize: 16,
                  ),
                ),
                if (change.room != change.changed.room)
                  Text(
                    change.room != null ? change.room.toUpperCase() : '',
                    style: GoogleFonts.ubuntuMono(
                      fontSize: 16,
                      textStyle: TextStyle(
                        color: Colors.black54,
                        decoration: TextDecoration.lineThrough,
                      ),
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
