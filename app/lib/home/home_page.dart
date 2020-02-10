import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ginko/aixformation/aixformation_row.dart';
import 'package:ginko/app/app_page.dart';
import 'package:ginko/cafetoria/cafetoria_row.dart';
import 'package:ginko/calendar/calendar_row.dart';
import 'package:ginko/substitution_plan/substitution_plan_row.dart';
import 'package:ginko/timetable/timetable_row.dart';
import 'package:ginko/utils/empty_row.dart';
import 'package:ginko/utils/list_group_header.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/size_limit.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/theme.dart';
import 'package:models/models.dart';

// ignore: public_member_api_docs
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = getScreenSize(MediaQuery.of(context).size.width);
    final weekday = Static.timetable.hasLoadedData
        ? Static.timetable.data
                .initialDay(Static.selection.data, DateTime.now())
                .weekday -
            1
        : 0;
    final day = Static.selection.hasLoadedData && Static.timetable.hasLoadedData
        ? Static.timetable.data
            .initialDay(Static.selection.data, DateTime.now())
        : monday(DateTime.now()).add(Duration(days: weekday));
    final subjects = Static.timetable.hasLoadedData
        ? Static.timetable.data.days[weekday].lessons
            .map((lesson) {
              final subjects = (lesson.subjects.length > 1
                      ? lesson.subjects
                          .where((subject) => Static.selection.data
                              .doIdentifiersMatch(
                                  Static.selection.data
                                      .getSelection(lesson.block),
                                  subject.identifier))
                          .toList()
                      : lesson.subjects)
                  .toList();
              if (subjects.isNotEmpty) {
                return subjects.first;
              }
              return null;
            })
            .where((subject) =>
                subject != null &&
                subject.subject != 'fr' &&
                subject.subject != 'mit' &&
                DateTime.now()
                    .isBefore(day.add(Times.getUnitTimes(subject.unit)[1])))
            .toList()
        : [];
    final changes = [];
    if (Static.substitutionPlan.hasLoadedData &&
        Static.timetable.hasLoadedData) {
      for (final change in Static.substitutionPlan.data.changes
          .where((change) => change.date == day)
          .toList()) {
        for (final subject in subjects) {
          if (change.subjectMatches(subject)) {
            changes.add(change);
            break;
          }
        }
      }
    }
    final timetableCut = size == ScreenSize.small
        ? 3
        : _calculateCut(context, size == ScreenSize.middle ? 3 : 2);
    final timetableView = Static.timetable.hasLoadedData &&
            Static.selection.hasLoadedData
        ? ListGroupHeader(
            title: 'Nächste Stunden - ${weekdays[weekday]}',
            counter: subjects.length > timetableCut
                ? subjects.length - timetableCut
                : 0,
            onTap: () {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    AppPage(
                  page: 2,
                  loading: false,
                ),
              ));
            },
            children: [
              SizeLimit(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (subjects.isEmpty ||
                        !Static.timetable.hasLoadedData ||
                        !Static.selection.hasLoadedData)
                      EmptyRow()
                    else
                      ...(subjects.length > timetableCut
                              ? subjects.sublist(0, timetableCut)
                              : subjects)
                          .map((subject) => Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    TimetableRow(
                                      subject: subject,
                                    ),
                                    ...changes
                                        .where((change) =>
                                            change.unit == subject.unit)
                                        .map((change) => SubstitutionPlanRow(
                                              change: change
                                                  .completedBySubject(subject),
                                              showUnit: false,
                                              keepPadding: true,
                                            ))
                                        .toList()
                                        .cast<Widget>(),
                                  ],
                                ),
                              )),
                  ],
                ),
              ),
            ],
          )
        : Container();
    final substitutionPlanCut = size == ScreenSize.small
        ? 3
        : _calculateCut(context, size == ScreenSize.middle ? 3 : 2);
    final substitutionPlanView =
        Static.timetable.hasLoadedData && Static.selection.hasLoadedData
            ? ListGroupHeader(
                title:
                    // ignore: lines_longer_than_80_chars
                    'Nächste Vertretungen - ${weekdays[Static.timetable.data.initialDay(Static.selection.data, DateTime.now()).weekday - 1]}',
                counter: changes.length > substitutionPlanCut
                    ? changes.length - substitutionPlanCut
                    : 0,
                onTap: () {
                  Navigator.of(context).pushReplacement(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        AppPage(
                      page: 0,
                      loading: false,
                    ),
                  ));
                },
                children: [
                  if (changes.isEmpty)
                    EmptyRow()
                  else
                    SizeLimit(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (Static.substitutionPlan.hasLoadedData)
                            ...(changes.length > substitutionPlanCut
                                    ? changes.sublist(0, substitutionPlanCut)
                                    : changes)
                                .map((change) => Container(
                                      margin: EdgeInsets.all(10),
                                      child: SubstitutionPlanRow(
                                        change: change,
                                      ),
                                    ))
                                .toList()
                                .cast<Widget>()
                        ],
                      ),
                    ),
                ],
              )
            : Container();
    final aiXformationCut = size == ScreenSize.small
        ? 3
        : _calculateCut(context, size == ScreenSize.middle ? 3 : 1);
    final aiXformationView = Static.aiXformation.hasLoadedData
        ? ListGroupHeader(
            title: 'AiXformation',
            counter: Static.aiXformation.data.posts.length - aiXformationCut,
            onTap: () {
              Navigator.of(context).pushNamed('/${Keys.aiXformation}');
            },
            children: [
              if (!Static.aiXformation.hasLoadedData)
                EmptyRow()
              else
                ...(Static.aiXformation.data.posts.length > aiXformationCut
                        ? Static.aiXformation.data.posts
                            .sublist(0, aiXformationCut)
                        : Static.aiXformation.data.posts)
                    .map((post) => Container(
                          margin: EdgeInsets.all(10),
                          child: AiXformationRow(
                            post: post,
                          ),
                        ))
                    .toList()
                    .cast<Widget>(),
            ],
          )
        : Container();
    final allDays = Static.cafetoria.hasLoadedData
        ? (Static.cafetoria.data.days.toList()
              ..sort((a, b) => a.date.compareTo(b.date)))
            .toList()
        : [];
    final afterDays = allDays
        .where((d) => d.date.isAfter(day.subtract(Duration(seconds: 1))))
        .toList();
    final cafetoriaCut = size == ScreenSize.small
        ? 3
        : _calculateCut(context, size == ScreenSize.middle ? 3 : 2);
    final cafetoriaView = Static.cafetoria.hasLoadedData
        ? ListGroupHeader(
            title: 'Cafétoria - ${weekdays[weekday]}',
            counter: allDays.length - 1,
            onTap: () {
              Navigator.of(context).pushNamed('/${Keys.cafetoria}');
            },
            children: [
              if (!Static.cafetoria.hasLoadedData || afterDays.isEmpty)
                EmptyRow()
              else
                SizeLimit(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (afterDays.first.menus.length > cafetoriaCut
                            ? afterDays.first.menus.sublist(0, cafetoriaCut)
                            : afterDays.first.menus)
                        .map(
                          (menu) => Container(
                            margin: EdgeInsets.all(10),
                            child: CafetoriaRow(
                              day: allDays.first,
                              menu: menu,
                            ),
                          ),
                        )
                        .toList()
                        .cast<Widget>(),
                  ),
                ),
            ],
          )
        : Container();
    final events = Static.calendar.hasLoadedData
        ? (Static.calendar.data
                .getEventsForTimeSpan(day, day.add(Duration(days: 730)))
                  ..sort((a, b) => a.start.compareTo(b.start)))
            .toList()
        : [];
    final calendarCut = size == ScreenSize.small
        ? 3
        : _calculateCut(context, size == ScreenSize.middle ? 3 : 2);
    final calendarView = Static.calendar.hasLoadedData
        ? ListGroupHeader(
            title: 'Kalender',
            counter: events.length - calendarCut,
            onTap: () {
              Navigator.of(context).pushNamed('/${Keys.calendar}');
            },
            children: [
              if (!Static.calendar.hasLoadedData || events.isEmpty)
                EmptyRow()
              else
                SizeLimit(
                  child: Column(
                    children: [
                      ...(events.length > calendarCut
                              ? events.sublist(0, calendarCut)
                              : events)
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
                ),
            ],
          )
        : Container();
    if (size == ScreenSize.small) {
      return Container(
        color: backgroundColor(context),
        child: Scrollbar(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(0),
            children: [
              timetableView,
              substitutionPlanView,
              calendarView,
              cafetoriaView,
              aiXformationView,
            ],
          ),
        ),
      );
    }
    if (size == ScreenSize.middle) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              substitutionPlanView,
              timetableView,
            ]
                .map((x) => Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: (MediaQuery.of(context).size.height -
                                _screenPadding) /
                            3,
                        child: x,
                      ),
                    ))
                .toList()
                .cast<Widget>(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              calendarView,
              cafetoriaView,
            ]
                .map((x) => Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: (MediaQuery.of(context).size.height -
                                _screenPadding) /
                            3,
                        child: x,
                      ),
                    ))
                .toList()
                .cast<Widget>(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              aiXformationView,
            ]
                .map((x) => Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: (MediaQuery.of(context).size.height -
                                _screenPadding) /
                            3,
                        child: x,
                      ),
                    ))
                .toList()
                .cast<Widget>(),
          ),
        ],
      );
    }
    if (size == ScreenSize.big) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              substitutionPlanView,
              cafetoriaView,
            ]
                .map((x) => SizedBox(
                      height: (MediaQuery.of(context).size.height -
                              _screenPadding) /
                          2,
                      child: x,
                    ))
                .toList()
                .cast<Widget>(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              timetableView,
              calendarView,
            ]
                .map((x) => SizedBox(
                      height: (MediaQuery.of(context).size.height -
                              _screenPadding) /
                          2,
                      child: x,
                    ))
                .toList()
                .cast<Widget>(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - _screenPadding,
            child: aiXformationView,
          ),
        ]
            .map((x) => Expanded(
                  flex: 1,
                  child: x,
                ))
            .toList()
            .cast<Widget>(),
      );
    }
    return Container();
  }

  int _calculateCut(BuildContext context, int parts) =>
      _calculateHeight(context, parts) ~/ 60;

  double _calculateHeight(BuildContext context, int parts) {
    final viewHeight = MediaQuery.of(context).size.height;
    final tabBarHeight = TabBar(
      tabs: const [],
    ).preferredSize.height;
    const padding = 30;
    return (viewHeight - _screenPadding) / parts - tabBarHeight - padding;
  }

  final _screenPadding = 110;
}
