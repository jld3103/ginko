import 'package:flutter/material.dart';
import 'package:ginko/substitution_plan/substitution_plan_row.dart';
import 'package:ginko/utils/custom_grid.dart';
import 'package:ginko/utils/empty_row.dart';
import 'package:ginko/utils/icons_texts.dart';
import 'package:ginko/utils/list_group_header.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/size_limit.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/theme.dart';
import 'package:models/models.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: public_member_api_docs
class SubstitutionPlanPage extends StatefulWidget {
  @override
  _SubstitutionPlanPageState createState() => _SubstitutionPlanPageState();
}

class _SubstitutionPlanPageState extends State<SubstitutionPlanPage> {
  @override
  Widget build(BuildContext context) => Static.timetable.hasLoadedData &&
          Static.substitutionPlan.hasLoadedData
      ? CustomGrid(
          type: getScreenSize(MediaQuery.of(context).size.width) ==
                  ScreenSize.small
              ? CustomGridType.tabs
              : CustomGridType.grid,
          columnPrepend: Static.substitutionPlan.data.substitutionPlanDays
              .map((day) => weekdays[day.date.weekday - 1])
              .toList(),
          childrenRowPrepend: [
            Container(
              height: 60,
              color: Colors.transparent,
            ),
            Container(
              height: 60,
              child: Center(
                child: Text(
                  'Meine Vertretungen',
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
                  'Weitere Vertretungen',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor(context),
                  ),
                ),
              ),
            ),
          ],
          children: List.generate(
            2,
            (index) {
              final weekday = Static.substitutionPlan.hasLoadedData
                  ? (Static.substitutionPlan.data.substitutionPlanDays
                            ..sort((a, b) => a.date.compareTo(b.date)))[index]
                          .date
                          .weekday -
                      1
                  : 0;
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
                          subject.subject != 'mit')
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
              final myChangesWidget = myChanges.isEmpty
                  ? EmptyRow()
                  : Column(
                      children: [
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
                      ],
                    );
              final notMyChangesWidget = notMyChanges.isEmpty
                  ? EmptyRow()
                  : Column(
                      children: [
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
                      ],
                    );
              final items = [
                if (getScreenSize(MediaQuery.of(context).size.width) !=
                    ScreenSize.small)
                  myChangesWidget
                else
                  ListGroupHeader(
                    title: 'Meine Vertretungen',
                    children: [
                      myChangesWidget,
                    ],
                  ),
                if (getScreenSize(MediaQuery.of(context).size.width) !=
                    ScreenSize.small)
                  notMyChangesWidget
                else
                  ListGroupHeader(
                    title: 'Weitere Vertretungen',
                    children: [
                      notMyChangesWidget,
                    ],
                  ),
              ];
              return [
                Center(
                  child: SizeLimit(
                    child: Card(
                      elevation: 3,
                      margin: EdgeInsets.all(10),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: IconsTexts(
                          icons: [
                            Icons.event,
                            Icons.timer,
                          ],
                          texts: [
                            outputDateFormat.format(Static.substitutionPlan.data
                                .substitutionPlanDays[index].date),
                            timeago.format(
                              Static.substitutionPlan.data
                                  .substitutionPlanDays[index].updated,
                              locale: 'de',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ...items,
              ];
            },
          ),
        )
      : Container();
}
