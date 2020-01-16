import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ginko/substitution_plan/substitution_plan_row.dart';
import 'package:ginko/utils/icons_texts.dart';
import 'package:ginko/utils/list_group_header.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/size_limit.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/tab_proxy.dart';
import 'package:models/models.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: public_member_api_docs
class SubstitutionPlanPage extends StatefulWidget {
  @override
  _SubstitutionPlanPageState createState() => _SubstitutionPlanPageState();
}

class _SubstitutionPlanPageState extends State<SubstitutionPlanPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => TabProxy(
        controller: _tabController,
        weekdays: [
          if (Static.substitutionPlan.hasLoadedData) ...[
            ...Static.substitutionPlan.data.substitutionPlanDays
                .map((day) => weekdays[day.date.weekday - 1])
                .toList()
          ] else ...[
            '',
            ''
          ],
        ]
            .cast<String>()
            .map((weekday) =>
                getScreenSize(MediaQuery.of(context).size.width) ==
                            ScreenSize.small &&
                        weekday.isNotEmpty
                    ? weekday.substring(0, 2).toUpperCase()
                    : weekday)
            .toList(),
        tabs: List.generate(
          2,
          (index) {
            final weekday = Static.substitutionPlan.hasLoadedData
                ? (Static.substitutionPlan.data.substitutionPlanDays
                          ..sort((a, b) => a.date.compareTo(b.date)))[index]
                        .date
                        .weekday -
                    1
                : 0;
            final day = monday(DateTime.now()).add(Duration(days: weekday));
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
                        DateTime.now().isBefore(
                            day.add(Times.getUnitTimes(subject.unit)[1])))
                    .toList()
                : [];
            final myChanges = [];
            var notMyChanges = [];
            if (Static.substitutionPlan.hasLoadedData &&
                Static.timetable.hasLoadedData) {
              for (final change in Static.substitutionPlan.data.changes
                  .where((change) => change.date.weekday - 1 == weekday)
                  .toList()) {
                for (final subject in subjects) {
                  if (change.subjectMatches(subject)) {
                    myChanges.add(change);
                    break;
                  }
                }
                if (!myChanges.contains(change)) {
                  notMyChanges.add(change);
                }
              }
            }
            notMyChanges = notMyChanges.toSet().toList();
            final items = [
              ListGroupHeader(
                title: 'Meine Vertretungen',
              ),
              if (myChanges.isEmpty)
                Container(
                  height: 60,
                  color: Colors.transparent,
                )
              else
                ...myChanges
                    .map((change) => SizeLimit(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: SubstitutionPlanRow(
                              change: change,
                            ),
                          ),
                        ))
                    .toList()
                    .cast<Widget>(),
              ListGroupHeader(
                title: 'Weitere Vertretungen',
              ),
              ...notMyChanges
                  .map((change) => SizeLimit(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: SubstitutionPlanRow(
                            change: change,
                          ),
                        ),
                      ))
                  .toList()
                  .cast<Widget>(),
            ];
            return Scrollbar(
              child: ListView(
                shrinkWrap: true,
                children: [
                  if (Static.substitutionPlan.hasLoadedData)
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: IconsTexts(
                            icons: [
                              Icons.timer,
                              Icons.event,
                            ],
                            texts: [
                              timeago.format(
                                Static.substitutionPlan.data
                                    .substitutionPlanDays[index].updated,
                                locale: 'de',
                              ),
                              outputDateFormat.format(Static.substitutionPlan
                                  .data.substitutionPlanDays[index].date),
                            ],
                          ),
                        ),
                        ...items,
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      );
}
