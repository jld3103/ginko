import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ginko/aixformation/aixformation_row.dart';
import 'package:ginko/app/app_page.dart';
import 'package:ginko/cafetoria/cafetoria_row.dart';
import 'package:ginko/calendar/calendar_row.dart';
import 'package:ginko/substitution_plan/substitution_plan_row.dart';
import 'package:ginko/timetable/timetable_row.dart';
import 'package:ginko/utils/list_group_header.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/size_limit.dart';
import 'package:ginko/utils/static.dart';
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
    final day = monday(DateTime.now()).add(Duration(days: weekday));
    final subjects = Static.timetable.hasLoadedData
        ? Static.timetable.data.days[weekday].lessons
            .map((lesson) {
              final subjects = (lesson.subjects.length > 1
                      ? lesson.subjects
                          .where((subject) =>
                              Static.selection.data
                                  .getSelection(lesson.block) ==
                              subject.identifier)
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
    final timetableView = Column(
      children: [
        if (Static.timetable.hasLoadedData && Static.selection.hasLoadedData)
          ListGroupHeader(
            title: 'Nächste Stunden - ${weekdays[weekday]}',
            counter: subjects.length > 3 ? subjects.length - 3 : 0,
            onTap: () {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    AppPage(
                  page: 2,
                  loading: false,
                ),
              ));
            },
          ),
        SizeLimit(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subjects.isEmpty &&
                    (!Static.timetable.hasLoadedData ||
                        !Static.selection.hasLoadedData))
                  Container(
                    height: 60,
                    color: Colors.transparent,
                  )
                else
                  ...(subjects.length > 3 ? subjects.sublist(0, 3) : subjects)
                      .map((subject) => Container(
                            margin: EdgeInsets.only(
                              top: 10,
                              right: 20,
                              bottom: 10,
                              left: 20,
                            ),
                            child: Column(
                              children: [
                                TimetableRow(
                                  subject: subject,
                                ),
                                ...changes
                                    .where(
                                        (change) => change.unit == subject.unit)
                                    .map((change) => SubstitutionPlanRow(
                                          change: change
                                              .completedBySubject(subject),
                                          showUnit: false,
                                        ))
                                    .toList()
                                    .cast<Widget>(),
                              ],
                            ),
                          )),
              ],
            ),
          ),
        ),
      ],
    );
    final substitutionPlanView = Column(
      children: [
        if (Static.timetable.hasLoadedData && Static.selection.hasLoadedData)
          ListGroupHeader(
            title:
                // ignore: lines_longer_than_80_chars
                'Nächste Vertretungen - ${weekdays[Static.timetable.data.initialDay(Static.selection.data, DateTime.now()).weekday - 1]}',
            counter: changes.length > 3 ? changes.length - 3 : 0,
            onTap: () {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    AppPage(
                  page: 0,
                  loading: false,
                ),
              ));
            },
          ),
        if (changes.isEmpty)
          Container(
            height: 60,
            color: Colors.transparent,
          )
        else
          SizeLimit(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Static.substitutionPlan.hasLoadedData)
                    ...(changes.length > 3 ? changes.sublist(0, 3) : changes)
                        .map((change) => Container(
                              margin: EdgeInsets.only(
                                top: 10,
                                right: 20,
                                bottom: 10,
                                left: 20,
                              ),
                              child: SubstitutionPlanRow(
                                change: change,
                              ),
                            ))
                        .toList()
                        .cast<Widget>()
                ],
              ),
            ),
          ),
      ],
    );
    final aiXformationView = Column(
      children: [
        if (Static.aiXformation.hasLoadedData)
          ListGroupHeader(
            title: 'AiXformation',
            counter: Static.aiXformation.data.posts.length -
                (size == ScreenSize.small ? 2 : 3),
            onTap: () {
              Navigator.of(context).pushNamed('/${Keys.aiXformation}');
            },
          ),
        if (Static.aiXformation.hasLoadedData)
          ...Static.aiXformation.data.posts
              .sublist(0, size == ScreenSize.small ? 2 : 3)
              .map((post) => AiXformationRow(
                    post: post,
                  ))
              .toList()
              .cast<Widget>(),
      ],
    );
    final days = Static.cafetoria.hasLoadedData
        ? (Static.cafetoria.data.days
                .where((d) => d.date.isAfter(day.subtract(Duration(days: 1))))
                .toList()
                  ..sort((a, b) => a.date.compareTo(b.date)))
            .toList()
        : [];
    final cafetoriaView = Column(
      children: [
        if (Static.cafetoria.hasLoadedData)
          ListGroupHeader(
            title: 'Cafétoria',
            counter: days.length - 2,
            onTap: () {
              Navigator.of(context).pushNamed('/${Keys.cafetoria}');
            },
          ),
        if (!Static.cafetoria.hasLoadedData || days.isEmpty)
          Container(
            height: 60,
            color: Colors.transparent,
          )
        else
          ...(days.length > 2 ? days.sublist(0, 2) : days)
              .map((day) => SizeLimit(
                    child: CafetoriaRow(
                      day: day,
                      showDate: true,
                    ),
                  ))
              .toList()
              .cast<Widget>(),
      ],
    );
    final events = Static.calendar.hasLoadedData
        ? (Static.calendar.data
                .getEventsForTimeSpan(day, day.add(Duration(days: 730)))
                  ..sort((a, b) => a.start.compareTo(b.start)))
            .toList()
        : [];
    final calendarView = Column(
      children: [
        if (Static.calendar.hasLoadedData)
          ListGroupHeader(
            title: 'Kalender',
            counter: events.length - 3,
            onTap: () {
              Navigator.of(context).pushNamed('/${Keys.calendar}');
            },
          ),
        if (!Static.calendar.hasLoadedData || events.isEmpty)
          Container(
            height: 60,
            color: Colors.transparent,
          )
        else
          ...(events.length > 3 ? events.sublist(0, 3) : events)
              .map((event) => SizeLimit(
                    child: CalendarRow(
                      event: event,
                    ),
                  ))
              .toList()
              .cast<Widget>(),
      ],
    );
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          if (size == ScreenSize.small)
            Column(
              children: [
                timetableView,
                substitutionPlanView,
                calendarView,
                cafetoriaView,
                aiXformationView,
              ],
            ),
          if (size == ScreenSize.middle)
            Column(
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
                            child: x,
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
                            child: x,
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
                            child: x,
                          ))
                      .toList()
                      .cast<Widget>(),
                ),
              ],
            ),
          if (size == ScreenSize.big)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                substitutionPlanView,
                timetableView,
                calendarView,
                cafetoriaView,
                aiXformationView,
              ]
                  .map((x) => Expanded(
                        flex: 1,
                        child: x,
                      ))
                  .toList()
                  .cast<Widget>(),
            ),
        ],
      ),
    );
  }
}
