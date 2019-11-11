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
    @required this.device,
    @required this.timetable,
    @required this.calendar,
    @required this.cafetoria,
    @required this.substitutionPlan,
    @required this.selection,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final Device device;

  // ignore: public_member_api_docs
  final TimetableForGrade timetable;

  // ignore: public_member_api_docs
  final Calendar calendar;

  // ignore: public_member_api_docs
  final Cafetoria cafetoria;

  // ignore: public_member_api_docs
  final SubstitutionPlanForGrade substitutionPlan;

  // ignore: public_member_api_docs
  final Selection selection;

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
      ..index = _weekday = widget.timetable
              .initialDay(widget.selection, DateTime.now())
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
                    calendar: widget.calendar,
                    cafetoria: widget.cafetoria,
                    device: widget.device,
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
              children: widget.timetable.days[weekday].lessons
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
                          timetableDay: widget.timetable.days[weekday],
                          substitutionPlan: widget.substitutionPlan,
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
                      calendar: widget.calendar,
                      cafetoria: widget.cafetoria,
                      panelController: _panelController,
                      device: widget.device,
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
