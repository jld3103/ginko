import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ginko/cafetoria/cafetoria_row.dart';
import 'package:ginko/utils/static.dart';
import 'package:models/models.dart';

// ignore: public_member_api_docs
class CafetoriaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final days =
        (Static.cafetoria.data.days..sort((a, b) => a.date.compareTo(b.date)));
    return Scaffold(
      appBar: AppBar(
        title: Text('Cafétoria'),
      ),
      body: Scrollbar(
        child: ListView(
          shrinkWrap: true,
          children: days
              .map((day) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: days.indexOf(day) == 0 ? 5 : 15,
                          left: 5,
                          right: 5,
                          bottom: 5,
                        ),
                        child: Text(
                          // ignore: lines_longer_than_80_chars
                          '${weekdays[day.date.weekday - 1]} ${shortOutputDateFormat.format(day.date)}',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ...day.menus
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
                    ],
                  ))
              .toList()
              .cast<Widget>(),
        ),
      ),
    );
  }
}
