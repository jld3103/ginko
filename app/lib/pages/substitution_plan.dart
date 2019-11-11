import 'package:flutter/material.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/views/size_limit.dart';
import 'package:ginko/views/substitution_plan/row.dart';
import 'package:ginko/views/tab_proxy.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// CafetoriaPage class
/// describes the replacement plan widget
class SubstitutionPlanPage extends StatefulWidget {
  // ignore: public_member_api_docs
  const SubstitutionPlanPage({
    @required this.substitutionPlan,
    @required this.device,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final SubstitutionPlanForGrade substitutionPlan;

  // ignore: public_member_api_docs
  final Device device;

  @override
  _SubstitutionPlanPageState createState() => _SubstitutionPlanPageState();
}

class _SubstitutionPlanPageState extends State<SubstitutionPlanPage>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        length: widget.substitutionPlan.substitutionPlanDays.length,
        vsync: this);
    Static.rebuildSubstitutionPlan = () => setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    Static.rebuildSubstitutionPlan = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TabProxy(
        tabNames: widget.substitutionPlan.substitutionPlanDays
            .map((day) =>
                AppTranslations.of(context).weekdays[day.date.weekday - 1] +
                (getScreenSize(MediaQuery.of(context).size.width) !=
                        ScreenSize.small
                    // ignore: lines_longer_than_80_chars
                    ? ' ${outputDateFormat(widget.device.language).format(day.date)}'
                    : ''))
            .toList(),
        controller: _tabController,
        tabs: List.generate(widget.substitutionPlan.substitutionPlanDays.length,
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
                          Text(AppTranslations.of(context).substitutionPlanFor),
                          Text(
                            outputDateFormat(widget.device.language).format(
                                widget.substitutionPlan
                                    .substitutionPlanDays[day].date),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 5,
                            width: 1,
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                    Text(AppTranslations.of(context).substitutionPlanUpdated),
                    Text(
                      outputDateTimeFormat(widget.device.language).format(widget
                          .substitutionPlan.substitutionPlanDays[day].updated),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ...widget.substitutionPlan.changes
                  .where((change) =>
                      change.date ==
                      widget.substitutionPlan.substitutionPlanDays[day].date)
                  .map((change) {
                    final showUnit = change.unit != previousUnit;
                    previousUnit = change.unit;
                    return SizeLimit(
                      child: SubstitutionPlanRow(
                        change: change,
                        showUnit: showUnit,
                        showCard: false,
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
