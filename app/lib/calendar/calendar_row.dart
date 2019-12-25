import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:models/models.dart';

// ignore: public_member_api_docs
class CalendarRow extends StatefulWidget {
  // ignore: public_member_api_docs
  const CalendarRow({
    @required this.event,
    this.showDate = false,
  });

  // ignore: public_member_api_docs
  final CalendarEvent event;

  // ignore: public_member_api_docs
  final bool showDate;

  @override
  _CalendarRowState createState() => _CalendarRowState();
}

class _CalendarRowState extends State<CalendarRow>
    with AfterLayoutMixin<CalendarRow> {
  bool _initialized = false;

  @override
  Future afterFirstLayout(BuildContext context) async {
    await initializeDateFormatting('de', null);
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) => !_initialized
      ? Container()
      : Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.all(5),
                alignment: Alignment.center,
                child: Icon(
                  Icons.calendar_today,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.event.dateString),
                  ],
                ),
              ),
              if (Platform().isMobile)
                IconButton(
                  onPressed: () {
                    final startDate = widget.event.start.subtract(Duration(
                      hours: widget.event.start.hour,
                      minutes: widget.event.start.minute,
                      seconds: widget.event.start.second,
                    ));
                    final endDate = widget.event.end.subtract(Duration(
                      hours: widget.event.end.hour,
                      minutes: widget.event.end.minute,
                      seconds: widget.event.end.second,
                    ));
                    Add2Calendar.addEvent2Cal(Event(
                      title: widget.event.name,
                      description: widget.event.info,
                      startDate: widget.event.start,
                      endDate: widget.event.end,
                      allDay: startDate != endDate,
                    ));
                  },
                  icon: Icon(Icons.add),
                ),
            ],
          ),
        );
}
