import 'package:flutter/material.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/selection.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/views/section.dart';
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
    Key key,
  }) : super(key: key);

  @override
  _SubstitutionPlanPageState createState() => _SubstitutionPlanPageState();
}

class _SubstitutionPlanPageState extends State<SubstitutionPlanPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  void _setController() {
    if (_tabController != null && _tabController.length > 0) {
      setState(() {
        _tabController.index = 0;
      });
    }
    _tabController = TabController(
      length: Static.substitutionPlan.data.substitutionPlanDays.length,
      vsync: this,
    );
  }

  Future _update() async {
    await Static.substitutionPlan.forceLoadOnline();
    _setController();
    setState(() {});
  }

  @override
  void initState() {
    _setController();
    Static.refreshSubstitutionPlan = (shouldRender) async {
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
    Static.refreshSubstitutionPlan = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _update,
      child: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 56,
            color: Colors.white,
            child: Static.substitutionPlan.data.substitutionPlanDays.isEmpty
                ? null
                : TabProxy(
                    onReload: () async {
                      await Static.refreshSubstitutionPlan(false);
                    },
                    tabNames: Static.substitutionPlan.data.substitutionPlanDays
                        .map((day) =>
                            AppTranslations.of(context)
                                .weekdays[day.date.weekday - 1] +
                            (getScreenSize(MediaQuery.of(context).size.width) !=
                                    ScreenSize.small
                                // ignore: lines_longer_than_80_chars
                                ? ' ${outputDateFormat(Static.device.data.language).format(day.date)}'
                                : ''))
                        .toList(),
                    controller: _tabController,
                    tabs: List.generate(
                        Static.substitutionPlan.data.substitutionPlanDays
                            .length, (day) {
                      int matchingChangesPreviousUnit;
                      int notMatchingChangesPreviousUnit;
                      final matchingChanges = [];
                      final notMatchingChanges = [];
                      for (final change in Static.substitutionPlan.data.changes
                          .where((change) =>
                              change.date ==
                              Static.substitutionPlan.data
                                  .substitutionPlanDays[day].date)) {
                        final lesson = Static.timetable.data
                            .days[change.date.weekday - 1].lessons[change.unit];
                        final subjects = change.getMatchingSubjectsByTimetable(
                            Static.timetable.data);
                        if (subjects
                            .where((subject) =>
                                subject.identifier ==
                                TimetableSelection.get(
                                    lesson.block, true)) // FIXME
                            .isNotEmpty) {
                          matchingChanges.add(change);
                        } else {
                          notMatchingChanges.add(change);
                        }
                      }
                      return ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(5),
                        children: [
                          SizeLimit(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (getScreenSize(
                                        MediaQuery.of(context).size.width) ==
                                    ScreenSize.small)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(AppTranslations.of(context)
                                          .substitutionPlanFor),
                                      Text(
                                        outputDateFormat(
                                                Static.device.data.language)
                                            .format(Static
                                                .substitutionPlan
                                                .data
                                                .substitutionPlanDays[day]
                                                .date),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        height: 5,
                                        width: 1,
                                        color: Colors.transparent,
                                      ),
                                    ],
                                  ),
                                Text(AppTranslations.of(context)
                                    .substitutionPlanUpdated),
                                Text(
                                  outputDateTimeFormat(
                                          Static.device.data.language)
                                      .format(Static.substitutionPlan.data
                                          .substitutionPlanDays[day].updated),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (matchingChanges.isEmpty &&
                              notMatchingChanges.isEmpty)
                            Container(
                              color: Colors.transparent,
                              margin: EdgeInsets.only(
                                top: 20,
                              ),
                              child: Center(
                                child: Text(
                                  AppTranslations.of(context)
                                      .substitutionPlanNoChanges,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (matchingChanges.isNotEmpty)
                            Section(
                              title:
                                  // ignore: lines_longer_than_80_chars
                                  '${AppTranslations.of(context).substitutionPlanMatchingChanges}:',
                              children: [
                                ...matchingChanges
                                    .map((change) {
                                      final showUnit = change.unit !=
                                          matchingChangesPreviousUnit;
                                      matchingChangesPreviousUnit = change.unit;
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
                            ),
                          if (notMatchingChanges.isNotEmpty)
                            Section(
                              title:
                                  // ignore: lines_longer_than_80_chars
                                  '${AppTranslations.of(context).substitutionPlanNotMatchingChanges}:',
                              children: [
                                ...notMatchingChanges
                                    .map((change) {
                                      final showUnit = change.unit !=
                                          notMatchingChangesPreviousUnit;
                                      notMatchingChangesPreviousUnit =
                                          change.unit;
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
                            ),
                        ],
                      );
                    }).toList().cast<Widget>(),
                  ),
          ),
        ],
      ));
}
