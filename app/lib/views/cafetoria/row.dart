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
  });

  // ignore: public_member_api_docs
  final CafetoriaDay day;

  @override
  State<StatefulWidget> createState() => CafetoriaRowState();
}

/// CafetoriaRowState class
/// state of a day widget
class CafetoriaRowState extends State<CafetoriaRow> {
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
            children: widget.day.menus
                .map(
                  (menu) => Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                menu.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (menu.price != 0)
                              Text(' (${menu.price}€)')
                            // TODO(jld3103): Add times
                          ],
                        )
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
