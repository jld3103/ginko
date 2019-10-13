import 'package:flutter/material.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/views/replacementplan/row.dart';
import 'package:ginko/views/size_limit.dart';
import 'package:ginko/views/tab_proxy.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// CafetoriaPage class
/// describes the replacement plan widget
class ReplacementPlanPage extends StatefulWidget {
  // ignore: public_member_api_docs
  const ReplacementPlanPage({
    @required this.replacementPlan,
    @required this.user,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final ReplacementPlanForGrade replacementPlan;

  // ignore: public_member_api_docs
  final User user;

  @override
  _ReplacementPlanPageState createState() => _ReplacementPlanPageState();
}

class _ReplacementPlanPageState extends State<ReplacementPlanPage>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        length: widget.replacementPlan.replacementPlanDays.length, vsync: this);
    Static.rebuildReplacementPlan = () => setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    Static.rebuildReplacementPlan = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TabProxy(
        tabNames: widget.replacementPlan.replacementPlanDays
            .map((day) =>
                AppTranslations.of(context).weekdays[day.date.weekday - 1] +
                (getScreenSize(MediaQuery.of(context).size.width) !=
                        ScreenSize.small
                    // ignore: lines_longer_than_80_chars
                    ? ' ${outputDateFormat(widget.user.language.value).format(day.date)}'
                    : ''))
            .toList(),
        controller: _tabController,
        tabs: List.generate(widget.replacementPlan.replacementPlanDays.length,
            (day) {
          int previousUnit;
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            children: [
              SizeLimit(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (getScreenSize(MediaQuery.of(context).size.width) ==
                        ScreenSize.small)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppTranslations.of(context).replacementPlanFor),
                          Text(
                            outputDateFormat(widget.user.language.value).format(
                                widget.replacementPlan.replacementPlanDays[day]
                                    .date),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 16,
                            width: 1,
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                    Text(AppTranslations.of(context).replacementPlanUpdated),
                    Text(
                      outputDateTimeFormat(widget.user.language.value).format(
                          widget.replacementPlan.replacementPlanDays[day]
                              .updated),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ...widget.replacementPlan.changes
                  .map((change) {
                    final showUnit = change.unit != previousUnit;
                    previousUnit = change.unit;
                    return SizeLimit(
                      child: ReplacementPlanRow(
                        change: change,
                        showUnit: showUnit,
                      ),
                    );
                  })
                  .toList()
                  .cast<Widget>(),
            ],
          );
        }).toList().cast<Widget>(),
      );
}
