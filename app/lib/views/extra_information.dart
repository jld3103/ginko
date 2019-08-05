import 'package:app/utils/data.dart';
import 'package:app/views/cafetoria/row.dart';
import 'package:app/views/calendar/row.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:translations/translations_app.dart';

/// ExtraInformation class
/// shows a list of extra information
class ExtraInformation extends StatefulWidget {
  // ignore: public_member_api_docs
  const ExtraInformation({
    @required this.date,
    @required this.panelController,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final DateTime date;

  // ignore: public_member_api_docs
  final PanelController panelController;

  @override
  State<StatefulWidget> createState() => ExtraInformationState();
}

/// ExtraInformationState class
/// describes the state of the list of extra information
class ExtraInformationState extends State<ExtraInformation> {
  @override
  Widget build(BuildContext context) {
    final _showBig = MediaQuery.of(context).size.width >= 600;

    final start = widget.date;
    final end = start.add(Duration(days: 1)).subtract(Duration(seconds: 1));
    final events = Data.calendar.events.where((event) {
      if (event.start == start &&
          (event.end == end ||
              event.end.isAfter(end) ||
              event.end.isBefore(end))) {
        return true;
      }
      if (event.end == end &&
          (event.start == start ||
              event.start.isAfter(start) ||
              event.start.isBefore(start))) {
        return true;
      }
      if (event.start.isBefore(start) && event.end.isAfter(end)) {
        return true;
      }
      if (event.start.isAfter(start) && event.end.isBefore(end)) {
        return true;
      }
      if (event.start.isAfter(start) && event.start.isBefore(end)) {
        return true;
      }
      if (event.end.isAfter(start) && event.end.isBefore(end)) {
        return true;
      }
      return false;
    }).toList();
    final cafetoriaDays =
        Data.cafetoria.days.where((day) => day.date == start).toList();
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            try {
              if (widget.panelController.isPanelOpen()) {
                widget.panelController.close();
              } else {
                widget.panelController.open();
              }
              // ignore: empty_catches, avoid_catching_errors
            } on NoSuchMethodError {}
          },
          child: Container(
            padding: EdgeInsets.only(
              top: _showBig ? 10 : 0,
              bottom: _showBig ? 5 : 0,
              left: 15,
              right: _showBig ? 15 : 0,
            ),
            color:
                _showBig ? Theme.of(context).primaryColor : Colors.transparent,
            width: double.infinity,
            height: _showBig ? 104 : null,
            alignment: _showBig ? Alignment.bottomLeft : null,
            child: Container(
              height: _showBig ? 46 : 34,
              alignment: Alignment.center,
              child: Row(
                children: [
                  Text(
                    AppTranslations.of(context)
                        .weekdays[widget.date.weekday - 1],
                    style: TextStyle(
                      fontWeight: !_showBig ? FontWeight.bold : null,
                      color: _showBig ? Colors.white : null,
                      fontSize: _showBig ? 18 : null,
                    ),
                  ),
                  Text(
                    ' - ${outputDateFormat.format(widget.date)}',
                    style: TextStyle(
                      color: _showBig ? Colors.white : null,
                      fontSize: _showBig ? 18 : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!_showBig)
          SizedBox(
            height: 1,
            child: Center(
              child: Container(
                margin: EdgeInsetsDirectional.only(start: 1, end: 1),
                height: 1,
                color: Colors.grey,
              ),
            ),
          ),
        Container(
          height: _showBig ? MediaQuery.of(context).size.height - 104 : null,
          decoration: _showBig
              ? BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                )
              : null,
          child: ListView(
            padding: EdgeInsets.all(_showBig ? 5 : 10),
            shrinkWrap: true,
            children: [
              ...events
                  .map((event) => CalendarRow(
                        event: event,
                      ))
                  .toList(),
              if (cafetoriaDays.isNotEmpty)
                CafetoriaRow(
                  day: cafetoriaDays[0],
                )
            ],
          ),
        ),
      ],
    );
  }
}
