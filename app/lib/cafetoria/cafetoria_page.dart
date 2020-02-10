import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ginko/cafetoria/cafetoria_row.dart';
import 'package:ginko/utils/list_group_header.dart';
import 'package:ginko/utils/size_limit.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/theme.dart';
import 'package:models/models.dart';

// ignore: public_member_api_docs
class CafetoriaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final days =
        (Static.cafetoria.data.days..sort((a, b) => a.date.compareTo(b.date)));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cafétoria',
          style: TextStyle(
            color: textColor(context),
          ),
        ),
        elevation: 2,
      ),
      body: Scrollbar(
        child: ListView(
          shrinkWrap: true,
          children: days
              .map((day) => SizeLimit(
                    child: ListGroupHeader(
                      title:
                          // ignore: lines_longer_than_80_chars
                          '${weekdays[day.date.weekday - 1]} ${shortOutputDateFormat.format(day.date)}',
                      children: day.menus
                          .map(
                            (menu) => Container(
                              margin: EdgeInsets.all(10),
                              child: CafetoriaRow(
                                day: day,
                                menu: menu,
                              ),
                            ),
                          )
                          .toList()
                          .cast<Widget>(),
                    ),
                  ))
              .toList()
              .cast<Widget>(),
        ),
      ),
    );
  }
}
