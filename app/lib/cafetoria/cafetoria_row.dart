import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';

// ignore: public_member_api_docs
class CafetoriaRow extends StatefulWidget {
  // ignore: public_member_api_docs
  const CafetoriaRow({
    @required this.day,
    this.showDate = false,
  });

  // ignore: public_member_api_docs
  final CafetoriaDay day;

  // ignore: public_member_api_docs
  final bool showDate;

  @override
  State<StatefulWidget> createState() => _CafetoriaRowState();
}

class _CafetoriaRowState extends State<CafetoriaRow>
    with AfterLayoutMixin<CafetoriaRow> {
  DateFormat _timeFormat;

  @override
  Future afterFirstLayout(BuildContext context) async {
    await initializeDateFormatting('de', null);
    setState(() {
      _timeFormat = DateFormat.Hm('de');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_timeFormat == null) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: Icon(
              Icons.restaurant,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showDate)
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      // ignore: lines_longer_than_80_chars
                      '${weekdays[widget.day.date.weekday - 1]} ${outputDateFormat.format(widget.day.date)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ...widget.day.menus
                    .map(
                      (menu) => Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // ignore: lines_longer_than_80_chars
                              '${menu.name}${menu.price != 0 ? ' (${menu.price}€)' : ''}',
                            ),
                            if (menu.times.isNotEmpty)
                              Text(
                                menu.times
                                    .map((time) => _timeFormat
                                        .format(DateTime(0).add(time)))
                                    .toList()
                                    .join(' - '),
                              ),
                          ],
                        ),
                      ),
                    )
                    .toList()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
