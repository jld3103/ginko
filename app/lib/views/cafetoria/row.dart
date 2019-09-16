import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// CafetoriaRow class
/// renders a day
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

class _CafetoriaRowState extends State<CafetoriaRow> {
  DateFormat _timeFormat;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((a) {
      final languageCode = AppTranslations.of(context).locale.languageCode;
      initializeDateFormatting(languageCode, null).then((_) {
        setState(() {
          _timeFormat = DateFormat.Hm(languageCode);
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeFormat == null) {
      return Container();
    }
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.restaurant,
          color: Theme.of(context).primaryColor,
        ),
        title: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showDate)
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text(
                    // ignore: lines_longer_than_80_chars
                    '${AppTranslations.of(context).weekdays[widget.day.date.weekday - 1]} ${outputDateFormat.format(widget.day.date)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ...widget.day.menus
                  .map(
                    (menu) => Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // ignore: lines_longer_than_80_chars
                            '${menu.name}${menu.price != 0 ? ' (${menu.price}€)' : ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (menu.times.isNotEmpty)
                            Text(
                              menu.times
                                  .map((time) =>
                                      _timeFormat.format(DateTime(0).add(time)))
                                  .toList()
                                  .join(' - '),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
