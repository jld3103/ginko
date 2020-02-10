import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ginko/cafetoria/cafetoria_row.dart';
import 'package:ginko/calendar/calendar_row.dart';
import 'package:ginko/substitution_plan/substitution_plan_row.dart';
import 'package:ginko/timetable/timetable_row.dart';
import 'package:ginko/timetable/timetable_select_dialog.dart';
import 'package:ginko/utils/custom_grid.dart';
import 'package:ginko/utils/empty_row.dart';
import 'package:ginko/utils/list_group_header.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/size_limit.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/theme.dart';
import 'package:models/models.dart';

// ignore: public_member_api_docs
class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  @override
  Widget build(BuildContext context) => Static.timetable.hasLoadedData &&
          Static.substitutionPlan.hasLoadedData &&
          Static.cafetoria.hasLoadedData &&
          Static.calendar.hasLoadedData &&
          Static.selection.hasLoadedData
      ? CustomGrid(
          initialHorizontalIndex: Static.timetable.data
                  .initialDay(Static.selection.data, DateTime.now())
                  .weekday -
              1,
          type:
              getScreenSize(MediaQuery.of(context).size.width) == ScreenSize.big
                  ? CustomGridType.grid
                  : CustomGridType.tabs,
          columnPrepend: weekdays.values
              .toList()
              .sublist(0, 5)
              .map((weekday) =>
                  getScreenSize(MediaQuery.of(context).size.width) ==
                          ScreenSize.small
                      ? weekday.substring(0, 2).toUpperCase()
                      : weekday)
              .toList(),
          childrenRowPrepend: List.generate(
            8,
            (index) => Container(
              height: 60,
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor(context),
                  ),
                ),
              ),
            ),
          ),
          appendRowPrepend: [
            Container(
              height: 60,
              child: Center(
                child: Text(
                  'Termine',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor(context),
                  ),
                ),
              ),
            ),
            Container(
              height: 60,
              child: Center(
                child: Text(
                  'Cafétoria',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor(context),
                  ),
                ),
              ),
            ),
          ],
          append: List.generate(5, (weekday) {
            final events = Static.calendar.hasLoadedData
                ? (Static.calendar.data.getEventsForTimeSpan(
                        monday(DateTime.now()).add(Duration(days: weekday)),
                        monday(DateTime.now())
                            .add(Duration(days: weekday + 1))
                            .subtract(Duration(seconds: 1)))
                      ..sort((a, b) => a.start.compareTo(b.start)))
                    .toList()
                : [];
            final days = Static.cafetoria.hasLoadedData
                ? (Static.cafetoria.data.days
                        .where((d) =>
                            d.date ==
                            monday(DateTime.now()).add(Duration(days: weekday)))
                        .toList()
                          ..sort((a, b) => a.date.compareTo(b.date)))
                    .toList()
                : [];
            final calendarWidget = events.isEmpty
                ? EmptyRow()
                : SizeLimit(
                    child: Column(
                      children: [
                        ...events
                            .map((event) => Container(
                                  margin: EdgeInsets.all(10),
                                  child: CalendarRow(
                                    event: event,
                                  ),
                                ))
                            .toList()
                            .cast<Widget>(),
                      ],
                    ),
                  );
            final cafetoriaWidget = days.isEmpty
                ? EmptyRow()
                : SizeLimit(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...days
                            .map((day) => Column(
                                  children: day.menus
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
                                ))
                            .toList()
                            .cast<Widget>(),
                      ],
                    ),
                  );
            return [
              if (getScreenSize(MediaQuery.of(context).size.width) ==
                  ScreenSize.big) ...[
                calendarWidget,
                cafetoriaWidget,
              ] else
                ...[
                  ListGroupHeader(
                    title: 'Termine',
                    onTap: () {
                      Navigator.of(context).pushNamed('/${Keys.calendar}');
                    },
                    children: [
                      calendarWidget,
                    ],
                  ),
                  ListGroupHeader(
                    title: 'Cafétoria',
                    onTap: () {
                      Navigator.of(context).pushNamed('/${Keys.cafetoria}');
                    },
                    children: [
                      cafetoriaWidget,
                    ],
                  ),
                ].map((x) => SizeLimit(child: x)).toList().cast<Widget>(),
            ];
          }),
          tabsChildrenWrap: (child) => Container(
            margin: EdgeInsets.only(
              bottom: 10,
              left: 5,
              right: 5,
              top: 5,
            ),
            child: Card(
              elevation: 3,
              child: child,
            ),
          ),
          children: List.generate(
            5,
            (weekday) =>
                Static.timetable.data.days[weekday].lessons.map((lesson) {
              final subjects = lesson.subjects.length > 1
                  ? lesson.subjects
                      .where((subject) => Static.selection.data
                          .doIdentifiersMatch(
                              Static.selection.data.getSelection(lesson.block),
                              subject.identifier))
                      .toList()
                  : lesson.subjects;
              // ignore: omit_local_variable_types
              final List<SubstitutionPlanChange> changes = subjects.isNotEmpty
                  ? Static.substitutionPlan.data.changes
                      .where((change) =>
                          change.date ==
                              monday(DateTime.now())
                                  .add(Duration(days: weekday)) &&
                          change.unit == subjects[0].unit &&
                          change.subjectMatches(subjects[0]))
                      .toList()
                  : [];
              return SizeLimit(
                child: InkWell(
                  onTap: () async {
                    if (lesson.subjects.length > 1) {
                      // ignore: omit_local_variable_types
                      final TimetableSubject selection = await showDialog(
                        context: context,
                        builder: (context) => TimetableSelectDialog(
                          weekday: weekday,
                          lesson: lesson,
                        ),
                      );
                      if (selection == null) {
                        return;
                      }
                      Static.selection.data.setSelection(
                        lesson.block,
                        selection.identifier,
                      );
                      Static.selection.save();
                      setState(() {});
                      try {
                        await Static.selection.forceLoadOnline();
                        // ignore: empty_catches
                      } on DioError {}
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TimetableRow(
                          subject: subjects.isNotEmpty
                              ? subjects[0]
                              : TimetableSubject(
                                  unit: lesson.unit,
                                  subject: 'none',
                                  teachers: null,
                                  room: null,
                                ),
                          showUnit: getScreenSize(
                                  MediaQuery.of(context).size.width) !=
                              ScreenSize.big,
                        ),
                        ...changes
                            .map((change) => SubstitutionPlanRow(
                                  change: change.completedByLesson(lesson),
                                  showUnit: false,
                                  keepPadding: getScreenSize(
                                          MediaQuery.of(context).size.width) !=
                                      ScreenSize.big,
                                ))
                            .toList()
                            .cast<Widget>(),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        )
      : Container();
}
