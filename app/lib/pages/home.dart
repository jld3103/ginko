import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/selection.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/views/extra_information.dart';
import 'package:ginko/views/size_limit.dart';
import 'package:ginko/views/tab_proxy.dart';
import 'package:ginko/views/timetable/all_row.dart';
import 'package:ginko/views/timetable/select_dialog.dart';
import 'package:models/models.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:translations/translations_app.dart';

/// HomePage class
/// describes the home widget
class HomePage extends StatefulWidget {
  // ignore: public_member_api_docs
  const HomePage({
    Key key,
  }) : super(key: key);

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
      ..index = _weekday = Static.timetable.data
              .initialDay(Static.selection.data, DateTime.now())
              .weekday -
          1
      ..addListener(() {
        if (_weekday != _tabController.index) {
          setState(() {
            _weekday = _tabController.index;
          });
        }
      });
    Static.rebuildTimetable = () => setState(() {});
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
          ? getContent
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
                    calendar: Static.calendar.data,
                    cafetoria: Static.cafetoria.data,
                    device: Static.device.data,
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
            final list = ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                top: 5,
                bottom: getScreenSize(MediaQuery.of(context).size.width) ==
                        ScreenSize.small
                    ? 23
                    : 5,
              ),
              children: Static.timetable.data.days[weekday].lessons
                  .map((lesson) {
                    final subjects = lesson.subjects
                        .where((subject) =>
                            TimetableSelection.get(
                                lesson.block, isWeekA(start)) ==
                            subject.identifier)
                        .toList();
                    return SizeLimit(
                      child: GestureDetector(
                        onTap: () async {
                          if (lesson.subjects.length > 1) {
                            // ignore: omit_local_variable_types
                            final List<Subject> selections = await showDialog(
                              context: context,
                              builder: (context) => TimetableSelectDialog(
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
                            TimetableSelection.set(
                                lesson.block, true, selections[0].identifier);
                            TimetableSelection.set(
                                lesson.block, false, selections[1].identifier);
                            Static.selection.save();
                            Static.rebuildTimetable();
                            try {
                              await Static.selection.forceLoadOnline();
                              // ignore: empty_catches
                            } on DioError {}
                          }
                        },
                        child: TimetableAllRow(
                          subject: subjects.isNotEmpty
                              ? subjects[0]
                              : Subject(
                                  subject: Keys.none,
                                  teacher: null,
                                  weeks: null,
                                  room: null,
                                  unit: lesson.unit,
                                ),
                          timetableDay: Static.timetable.data.days[weekday],
                          substitutionPlan: Static.substitutionPlan.data,
                          start: start,
                        ),
                      ),
                    );
                  })
                  .toList()
                  .cast<Widget>(),
            );
            if (getScreenSize(MediaQuery.of(context).size.width) ==
                ScreenSize.small) {
              return Stack(
                children: [
                  list,
                  SlidingUpPanel(
                    controller: _panelController,
                    minHeight: 48,
                    backdropEnabled: true,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                      )
                    ],
                    panel: ExtraInformation(
                      date: monday(DateTime.now()).add(Duration(days: weekday)),
                      calendar: Static.calendar.data,
                      cafetoria: Static.cafetoria.data,
                      panelController: _panelController,
                      device: Static.device.data,
                    ),
                  ),
                ],
              );
            }
            return list;
          },
        ).toList().cast<Widget>(),
      );
}
