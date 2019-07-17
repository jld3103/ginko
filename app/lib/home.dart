import 'package:app/utils/data.dart';
import 'package:app/utils/localizations.dart';
import 'package:app/utils/selection.dart';
import 'package:app/utils/static.dart';
import 'package:app/views/extra_information.dart';
import 'package:app/views/replacementplan/row.dart';
import 'package:app/views/unitplan/row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform/flutter_platform.dart';
import 'package:models/models.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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

  /// Get the date of the current selected tab
  DateTime get getDate => getMonday.add(Duration(days: _weekday));

  /// Get the Monday of the week
  /// Skips a week of weekend
  DateTime get getMonday {
    final now = DateTime.now();
    return now
        .subtract(Duration(
          days: now.weekday - 1,
          hours: now.hour,
          minutes: now.minute,
          seconds: now.second,
          milliseconds: now.millisecond,
          microseconds: now.microsecond,
        ))
        .add(Duration(days: now.weekday > 5 ? 0 : 0));
  }

  @override
  void initState() {
    _panelController = PanelController();
    _tabController = TabController(length: 5, vsync: this);
    _weekday = 0;
    _tabController.addListener(() {
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
          content: Text(AppLocalization.of(context).homeOffline),
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
      content: Text(AppLocalization.of(context).homeNewReplacementPlan),
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Platform().isMobile || MediaQuery.of(context).size.width < 600
          ? getHeaderView(
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
                panelSnapping: true,
                backdropEnabled: true,
                backdropTapClosesPanel: true,
                panel: ExtraInformation(
                  date: getDate,
                  panelController: _panelController,
                ),
                body: getUnitPlanView,
              ),
            )
          : Row(
              children: [
                AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.bounceInOut,
                  child: Container(
                    height: double.infinity,
                    width: MediaQuery.of(context).size.width - 300,
                    child: getHeaderView(getUnitPlanView),
                  ),
                ),
                AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.bounceInOut,
                  child: Container(
                    height: double.infinity,
                    width: 300,
                    child: ExtraInformation(
                      date: getDate,
                      panelController: _panelController,
                    ),
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
            final start = getMonday.add(Duration(days: weekday));
            final weekA = isWeekA(start);
            return ListView(
              padding: EdgeInsets.all(5),
              shrinkWrap: true,
              children: Data.unitPlan.days[weekday].lessons
                  .map(
                    (lesson) {
                      final subjects = lesson.subjects
                          .where((subject) =>
                              Selection.get(lesson.block, weekA) ==
                              subject.identifier)
                          .toList();
                      final subject = subjects.isNotEmpty
                          ? subjects[0]
                          : Subject(
                              subject: Keys.none,
                              teacher: null,
                              weeks: null,
                              room: null,
                              unit: lesson.unit,
                            );
                      return GestureDetector(
                        onTap: () {
                          if (lesson.subjects.length > 1) {
                            showDialog(
                              context: context,
                              builder: (context) => SimpleDialog(
                                title: Text(AppLocalization.of(context)
                                    .weekday(weekday)),
                                contentPadding: EdgeInsets.all(10),
                                children: lesson.subjects
                                    .map((subject) => GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            Selection.set(lesson.block, weekA,
                                                subject.identifier);
                                            Static.rebuildUnitPlan();
                                          },
                                          child: UnitPlanRow(
                                            subject: subject,
                                            showUnit: false,
                                            addPadding: false,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            UnitPlanRow(subject: subject),
                            ...Data.replacementPlan.changes
                                .where((change) =>
                                    change.date ==
                                        getMonday
                                            .add(Duration(days: weekday)) &&
                                    change.unit ==
                                        Data.unitPlan.days[weekday].lessons
                                            .indexOf(lesson) &&
                                    change
                                            .getMatchingClasses(Data.unitPlan)
                                            .identifier ==
                                        subject.identifier)
                                .map((change) => Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: ReplacementPlanRow(
                                        change: change,
                                        showUnit: false,
                                        addPadding: false,
                                      ),
                                    ))
                                .toList()
                                .cast<Widget>(),
                          ],
                        ),
                      );
                    },
                  )
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
            title: Text(AppLocalization.of(context).appName),
            bottom: TabBar(
                controller: _tabController,
                tabs: AppLocalization.of(context)
                    .weekdays
                    .sublist(0, 5)
                    .map(
                      (weekday) => Tab(
                        child: Text(weekday.substring(0, 2).toUpperCase()),
                      ),
                    )
                    .toList()),
          ),
          body: body,
        ),
      );
}
