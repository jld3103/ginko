import 'package:app/utils/data.dart';
import 'package:app/utils/localizations.dart';
import 'package:app/views/cafetoria/row.dart';
import 'package:app/views/calendar/row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform/flutter_platform.dart';
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
  bool _showBig;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((a) {
      setState(() {
        _showBig =
            !Platform().isMobile && MediaQuery.of(context).size.width >= 600;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_showBig == null) {
      return Container();
    }
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
            color:
                _showBig ? Theme.of(context).primaryColor : Colors.transparent,
            width: double.infinity,
            height: _showBig ? 104 : null,
            alignment: _showBig ? Alignment.bottomLeft : null,
            child: Container(
              height: 46,
              alignment: Alignment.center,
              child: Row(
                children: [
                  Text(
                    AppLocalization.of(context)
                        .weekday(widget.date.weekday - 1),
                    style: TextStyle(
                      fontWeight: !_showBig ? FontWeight.bold : null,
                      color: _showBig ? Colors.white : null,
                      fontSize: _showBig ? 18 : null,
                    ),
                  ),
                  Text(
                    ' - ${dateFormat.format(widget.date)}',
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
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ],
          ),
          child: ListView(
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
        ),
      ],
    );
  }
}
