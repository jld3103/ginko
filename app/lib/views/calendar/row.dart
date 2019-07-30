import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// CalendarRow class
/// renders an event
class CalendarRow extends StatefulWidget {
  // ignore: public_member_api_docs
  const CalendarRow({
    @required this.event,
  });

  // ignore: public_member_api_docs
  final CalendarEvent event;

  @override
  State<StatefulWidget> createState() => CalendarRowState();
}

/// CalendarRowState class
/// state of an event widget
class CalendarRowState extends State<CalendarRow> {
  DateFormat _dateFormat;
  DateFormat _dateTimeFormat;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((a) {
      final languageCode = AppTranslations.of(context).locale.languageCode;
      initializeDateFormatting(languageCode, null).then((_) {
        setState(() {
          _dateFormat = DateFormat.yMMMMd(languageCode);
          _dateTimeFormat = DateFormat.yMMMMd(languageCode).add_Hm();
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_dateFormat == null) {
      return Container();
    }
    var dateStr = '';
    if (widget.event.start
            .add(Duration(days: 1))
            .subtract(Duration(seconds: 1)) ==
        widget.event.end) {
      if (widget.event.start.hour != 0 || widget.event.start.minute != 0) {
        dateStr = _dateTimeFormat.format(widget.event.start);
      } else {
        dateStr = _dateFormat.format(widget.event.start);
      }
    } else {
      if (widget.event.start.hour != 0 || widget.event.start.minute != 0) {
        dateStr = _dateTimeFormat.format(widget.event.start);
      } else {
        dateStr = _dateFormat.format(widget.event.start);
      }
      dateStr += ' - ';
      if (widget.event.end.hour != 0 || widget.event.end.minute != 0) {
        dateStr += _dateTimeFormat.format(widget.event.end);
      } else {
        dateStr += _dateFormat.format(widget.event.end);
      }
    }
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: ListTile(
          leading: Icon(
            Icons.calendar_today,
            color: Theme.of(context).primaryColor,
          ),
          title: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(dateStr),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
