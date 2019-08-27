import 'package:flutter/material.dart';
import 'package:ginko/utils/data.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/views/cafetoria/row.dart';
import 'package:ginko/views/calendar/row.dart';
import 'package:models/models.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:translations/translations_app.dart';

/// ExtraInformation class
/// shows a list of extra information
class ExtraInformation extends StatefulWidget {
  // ignore: public_member_api_docs
  const ExtraInformation({
    @required this.date,
    @required this.calendar,
    @required this.cafetoria,
    this.panelController,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final DateTime date;

  // ignore: public_member_api_docs
  final Calendar calendar;

  // ignore: public_member_api_docs
  final Cafetoria cafetoria;

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
    final _showBig =
        getScreenSize(MediaQuery.of(context).size.width) != ScreenSize.small;

    final start = widget.date;
    final end = start.add(Duration(days: 1)).subtract(Duration(seconds: 1));
    final events = widget.calendar.getEventsForTimeSpan(start, end);
    final cafetoriaDays = widget.cafetoria != null
        ? widget.cafetoria.days.where((day) => day.date == start).toList()
        : [];
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.panelController != null) {
              if (widget.panelController.isPanelOpen()) {
                widget.panelController.close();
              } else {
                widget.panelController.open();
              }
            }
          },
          child: Container(
            padding: EdgeInsets.only(
              left: 15,
              right: _showBig ? 15 : 0,
            ),
            color:
                _showBig ? Theme.of(context).primaryColor : Colors.transparent,
            width: double.infinity,
            height: null,
            alignment: _showBig ? Alignment.bottomLeft : null,
            child: Container(
              height: _showBig ? 41 : 34,
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
          height: _showBig ? MediaQuery.of(context).size.height - 97 : null,
          decoration: _showBig
              ? BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 1),
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
                        user: Data.user,
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
