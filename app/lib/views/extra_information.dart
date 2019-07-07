import 'package:app/utils/data.dart';
import 'package:app/utils/localizations.dart';
import 'package:app/views/cafetoria/row.dart';
import 'package:app/views/calendar/row.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
    final start = widget.date;
    final end = start.add(Duration(days: 1)).subtract(Duration(seconds: 1));
    final events = Data.calendar.events.where((event) {
      if (event.start == start && event.end == end) {
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
            if (widget.panelController.isPanelOpen != null) {
              if (widget.panelController.isPanelOpen()) {
                widget.panelController.close();
              } else {
                widget.panelController.open();
              }
            }
          },
          child: Container(
            padding: EdgeInsets.only(
              top: 10,
              bottom: 5,
              left: 15,
              right: 15,
            ),
            color: Colors.transparent,
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  AppLocalization.of(context).weekday(widget.date.weekday - 1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(' - ${dateFormat.format(widget.date)}'),
              ],
            ),
          ),
        ),
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
        ListView(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
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
      ],
    );
  }
}
