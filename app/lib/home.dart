import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:ginko/utils/data.dart';
import 'package:ginko/utils/platform/platform.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/selection.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/views/extra_information.dart';
import 'package:ginko/views/tab_proxy.dart';
import 'package:ginko/views/unitplan/progress_row.dart';
import 'package:ginko/views/unitplan/scan.dart';
import 'package:ginko/views/unitplan/select_dialog.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((a) async {
      if (!Data.online) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(AppTranslations.of(context).homeOffline),
        ));
      }
      if (Platform().isAndroid || Platform().isWeb) {
        final gotNullToken = await Data.firebaseMessaging.getToken() == 'null';
        final hasPermissions =
            await Data.firebaseMessaging.requestNotificationPermissions();
        Data.firebaseMessaging.configure(
          onLaunch: (data) async => _handleNotification(data),
          onResume: (data) async => _handleNotification(data),
          onMessage: (data) async => _handleNotification(data),
        );
        _channel.setMethodCallHandler((call) async {
          _handleNotification(json.decode(json.encode(call.arguments)));
        });

        if (gotNullToken) {
          print('Got a token after requesting permissions');
          print('Updating tokens on server');
          await Data.updateUser();
        }

        // Ask for scan
        if (isSeniorGrade(Data.user.grade.value) &&
            Platform().isAndroid &&
            !(Static.storage.getBool(Keys.askedForScan) ?? false)) {
          Static.storage.setBool(Keys.askedForScan, true);
          var allDetected = true;
          for (final day in Data.unitPlan.days) {
            if (!allDetected) {
              break;
            }
            for (final lesson in day.lessons) {
              if (!allDetected) {
                break;
              }
              for (final weekA in [true, false]) {
                if (Selection.get(lesson.block, weekA) == null) {
                  allDetected = false;
                  break;
                }
              }
            }
          }
          if (!allDetected) {
            await showDialog(
              context: context,
              builder: (context) => ScanDialog(),
            );
          }
        }
      }
    });
    super.initState();
  }

  void _handleNotification(Map<String, dynamic> data) {
    print(data);
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
  Widget build(BuildContext context) => Scaffold(
        appBar: Platform().isWeb &&
                getScreenSize(MediaQuery.of(context).size.width) ==
                    ScreenSize.small
            ? null
            : AppBar(
                title: Text(AppTranslations.of(context).appName),
                elevation: 0,
              ),
        body: getScreenSize(MediaQuery.of(context).size.width) ==
                ScreenSize.small
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
                            : 100),
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
                      date: Data.unitPlan.initialDay(Data.user, DateTime.now()),
                      calendar: Data.calendar,
                      cafetoria: Data.cafetoria,
                    ),
                  ),
                ],
              ),
      );

  /// Get the content of the tabs
  Widget get getContent => TabProxy(
        controller: _tabController,
        tabs: List.generate(
          5,
          (weekday) {
            final start = Data.unitPlan
                .initialDay(Data.user, DateTime.now())
                .add(Duration(days: weekday - 1));
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
}
