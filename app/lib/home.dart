import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/selection.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/views/extra_information.dart';
import 'package:ginko/views/size_limit.dart';
import 'package:ginko/views/tab_proxy.dart';
import 'package:ginko/views/unitplan/all_row.dart';
import 'package:ginko/views/unitplan/select_dialog.dart';
import 'package:models/models.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:translations/translations_app.dart';

/// HomePage class
/// describes the home widget
class HomePage extends StatefulWidget {
  // ignore: public_member_api_docs
  const HomePage({
    @required this.user,
    @required this.unitPlan,
    @required this.calendar,
    @required this.cafetoria,
    @required this.replacementPlan,
    @required this.updateUser,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final User user;

  // ignore: public_member_api_docs
  final UnitPlanForGrade unitPlan;

  // ignore: public_member_api_docs
  final Calendar calendar;

  // ignore: public_member_api_docs
  final Cafetoria cafetoria;

  // ignore: public_member_api_docs
  final ReplacementPlanForGrade replacementPlan;

  // ignore: public_member_api_docs
  final VoidCallback updateUser;

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
          widget.unitPlan.initialDay(widget.user, DateTime.now()).weekday - 1
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
                  height: MediaQuery.of(context).size.height,
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
                    calendar: widget.calendar,
                    cafetoria: widget.cafetoria,
                    panelController: _panelController,
                    user: widget.user,
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
                    calendar: widget.calendar,
                    cafetoria: widget.cafetoria,
                    user: widget.user,
                  ),
                ),
              ],
            );

  /// Get the content of the tabs
  Widget get getContent => TabProxy(
        controller: _tabController,
        tabNames: AppTranslations.of(context)
            .weekdays
            .sublist(0, 5)
            .map((weekday) => weekday
                .substring(
                    0,
                    AppTranslations.of(context).locale.languageCode == 'de'
                        ? 2
                        : 3)
                .toUpperCase())
            .toList(),
        tabs: List.generate(
          5,
          (weekday) {
            final start = monday(DateTime.now()).add(Duration(days: weekday));
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              children: widget.unitPlan.days[weekday].lessons
                  .map((lesson) {
                    final subjects = lesson.subjects
                        .where((subject) =>
                            Selection.get(lesson.block, isWeekA(start)) ==
                            subject.identifier)
                        .toList();
                    return SizeLimit(
                      child: GestureDetector(
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
                            widget.updateUser();
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
                          unitPlanDay: widget.unitPlan.days[weekday],
                          replacementPlan: widget.replacementPlan,
                          start: start,
                        ),
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
