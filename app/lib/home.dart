import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ginko/utils/data.dart';
import 'package:ginko/utils/platform/platform.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/selection.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/views/extra_information.dart';
import 'package:ginko/views/tab_proxy.dart';
import 'package:ginko/views/unitplan/all_row.dart';
import 'package:ginko/views/unitplan/select_dialog.dart';
import 'package:models/models.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

/// HomePage class
/// describes the home widget
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

/// HomePageState class
/// describes the state of the home widget
class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  PanelController _panelController;
  TabController _tabController;
  int _weekday;

  @override
  void initState() {
    _panelController = PanelController();
    _tabController = TabController(length: 5, vsync: this);
    _tabController
      ..index = _weekday =
          Data.unitPlan.initialDay(Data.user, DateTime.now()).weekday - 1
      ..addListener(() {
        if (_weekday != _tabController.index) {
          setState(() {
            _weekday = _tabController.index;
          });
        }
      });
    Static.rebuildUnitPlan = () => setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      getScreenSize(MediaQuery.of(context).size.width) == ScreenSize.small
          ? Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height -
                      (Platform().isWeb &&
                              getScreenSize(
                                      MediaQuery.of(context).size.width) ==
                                  ScreenSize.small
                          ? 5
                          : 0),
                  child: getContent,
                ),
                SlidingUpPanel(
                  controller: _panelController,
                  parallaxEnabled: true,
                  parallaxOffset: .1,
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                  minHeight: 30,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                  panelSnapping: true,
                  backdropEnabled: true,
                  backdropTapClosesPanel: true,
                  panel: ExtraInformation(
                    date: monday(DateTime.now()).add(Duration(days: _weekday)),
                    calendar: Data.calendar,
                    cafetoria: Data.cafetoria,
                    panelController: _panelController,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  height: double.infinity,
                  width: MediaQuery.of(context).size.width - 300,
                  child: getContent,
                ),
                Container(
                  height: double.infinity,
                  width: 300,
                  child: ExtraInformation(
                    date: monday(DateTime.now()).add(Duration(days: _weekday)),
                    calendar: Data.calendar,
                    cafetoria: Data.cafetoria,
                  ),
                ),
              ],
            );

  /// Get the content of the tabs
  Widget get getContent => TabProxy(
        controller: _tabController,
        tabs: List.generate(
          5,
          (weekday) {
            final start = monday(DateTime.now()).add(Duration(days: weekday));
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              children: Data.unitPlan.days[weekday].lessons
                  .map((lesson) {
                    final subjects = lesson.subjects
                        .where((subject) =>
                            Selection.get(lesson.block, isWeekA(start)) ==
                            subject.identifier)
                        .toList();
                    return GestureDetector(
                      onTap: () async {
                        if (lesson.subjects.length > 1) {
                          // ignore: omit_local_variable_types
                          final List<Subject> selections = await showDialog(
                            context: context,
                            builder: (context) => UnitPlanSelectDialog(
                              weekday: weekday,
                              lesson: lesson,
                            ),
                          );
                          if (selections == null) {
                            return;
                          }
                          if (selections.length == 1) {
                            selections.add(selections[0]);
                          }
                          Selection.set(
                              lesson.block, true, selections[0].identifier);
                          Selection.set(
                              lesson.block, false, selections[1].identifier);
                          // ignore: unawaited_futures
                          Data.updateUser();
                          Static.rebuildUnitPlan();
                        }
                      },
                      child: UnitPlanAllRow(
                        subject: subjects.isNotEmpty
                            ? subjects[0]
                            : Subject(
                                subject: Keys.none,
                                teacher: null,
                                weeks: null,
                                room: null,
                                unit: lesson.unit,
                              ),
                        unitPlanDay: Data.unitPlan.days[weekday],
                        replacementPlan: Data.replacementPlan,
                        start: start,
                      ),
                    );
                  })
                  .toList()
                  .cast<Widget>(),
            );
          },
        ).toList().cast<Widget>(),
      );
}
