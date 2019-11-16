import 'package:flutter/material.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/views/cafetoria/row.dart';
import 'package:ginko/views/size_limit.dart';
import 'package:translations/translations_app.dart';

/// CafetoriaPage class
/// describes the Cafetoria widget
class CafetoriaPage extends StatefulWidget {
  // ignore: public_member_api_docs
  const CafetoriaPage({
    Key key,
  }) : super(key: key);

  @override
  _CafetoriaPageState createState() => _CafetoriaPageState();
}

class _CafetoriaPageState extends State<CafetoriaPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  Future _update() async {
    await Static.cafetoria.forceLoadOnline();
    setState(() {});
  }

  @override
  void initState() {
    Static.refreshCafetoria = (shouldRender) async {
      if (shouldRender) {
        await _refreshIndicatorKey.currentState.show();
      } else {
        await _update();
      }
    };
    super.initState();
  }

  @override
  void dispose() {
    Static.refreshCafetoria = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _update,
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            children: [
              if (Static.cafetoria.data.days.isEmpty)
                Center(
                  child: Text(
                    AppTranslations.of(context).cafetoriaNoMenus,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ...(Static.cafetoria.data.days
                    ..sort((a, b) => a.date.compareTo(b.date)))
                  .map((day) => CafetoriaRow(
                        day: day,
                        showDate: true,
                        device: Static.device.data,
                      ))
                  .toList()
                  .cast<Widget>()
            ]
                .map((widget) => SizeLimit(
                      child: widget,
                    ))
                .toList()
                .cast<Widget>(),
          ),
        ),
      );
}
