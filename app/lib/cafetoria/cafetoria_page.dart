import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ginko/cafetoria/cafetoria_row.dart';
import 'package:ginko/utils/size_limit.dart';
import 'package:ginko/utils/static.dart';

// ignore: public_member_api_docs
class CafetoriaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Cafétoria'),
        ),
        body: Scrollbar(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            children: Static.cafetoria.data.days
                .map((day) => Center(
                      child: SizeLimit(
                        child: CafetoriaRow(
                          day: day,
                          showDate: true,
                        ),
                      ),
                    ))
                .toList()
                .cast<Widget>(),
          ),
        ),
      );
}
