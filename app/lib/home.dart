import 'dart:async';

import 'package:app/utils/data.dart';
import 'package:app/utils/selection.dart';
import 'package:app/utils/static.dart';
import 'package:app/views/extra_information.dart';
import 'package:app/views/unitplan/progress_row.dart';
import 'package:app/views/unitplan/select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform/flutter_platform.dart';
import 'package:models/models.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:translations/translations_app.dart';

/// Home class
/// describes the home widget
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

/// HomeState class
/// describes the state of the home widget
class HomeState extends State<Home> with TickerProviderStateMixin {
  PanelController _panelController;
  TabController _tabController;
  int _weekday;
  static final _channel = MethodChannel('de.ginko.app');

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
    WidgetsBinding.instance.addPostFrameCallback((a) {
      if (!Data.online) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(AppTranslations.of(context).homeOffline),
        ));
      }
      if (Platform().isAndroid) {
        Data.firebaseMessaging
          ..requestNotificationPermissions()
          ..configure(
            onLaunch: (message) async {
              print('onLaunch: $message');
            },
            onResume: (message) async {
              print('onResume: $message');
            },
          );
        _channel.setMethodCallHandler(_handleNotification);
      }
    });
    super.initState();
  }

  Future _handleNotification(MethodCall call) async {
    print(call);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(AppTranslations.of(context).homeNewReplacementPlan),
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MediaQuery.of(context).size.width < 600
      ? getHeaderView(
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 100,
                child: getUnitPlanView,
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
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
                panelSnapping: true,
                backdropEnabled: true,
                backdropTapClosesPanel: true,
                panel: ExtraInformation(
                  date: Data.unitPlan.initialDay(Data.user, DateTime.now()),
                  calendar: Data.calendar,
                  cafetoria: Data.cafetoria,
                  panelController: _panelController,
                ),
              ),
            ],
          ),
        )
      : Row(
          children: [
            Container(
              height: double.infinity,
              width: MediaQuery.of(context).size.width - 300,
              child: getHeaderView(getUnitPlanView),
            ),
            Container(
              height: double.infinity,
              width: 300,
              child: ExtraInformation(
                date: Data.unitPlan.initialDay(Data.user, DateTime.now()),
                calendar: Data.calendar,
                cafetoria: Data.cafetoria,
              ),
            ),
          ],
        );

  /// Get the view of the unit plan
  Widget get getUnitPlanView => TabBarView(
        controller: _tabController,
        children: List.generate(
          5,
          (weekday) {
            final start = Data.unitPlan
                .initialDay(Data.user, DateTime.now())
                .add(Duration(days: weekday));
            return ListView(
              shrinkWrap: true,
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
                      child: UnitPlanProgressRow(
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

  /// Get the app bar and tab bar header view
  Widget getHeaderView(Widget body) => DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppTranslations.of(context).appName),
            bottom: TabBar(
                controller: _tabController,
                tabs: AppTranslations.of(context)
                    .weekdays
                    .sublist(0, 5)
                    .map(
                      (weekday) => Tab(
                        child: Text(weekday
                            .substring(
                                0,
                                AppTranslations.of(context)
                                            .locale
                                            .languageCode ==
                                        'de'
                                    ? 2
                                    : 3)
                            .toUpperCase()),
                      ),
                    )
                    .toList()),
          ),
          body: body,
        ),
      );
}
