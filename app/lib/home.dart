import 'package:app/utils/data.dart';
import 'package:app/utils/localizations.dart';
import 'package:app/utils/static.dart';
import 'package:app/views/extra_information.dart';
import 'package:app/views/unitplan/row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

/// Home class
/// describes the home widget
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

/// HomeState class
/// describes the state of the home widget
class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  PanelController _panelController;
  TabController _tabController;
  int _weekday;

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
        .add(Duration(days: now.weekday > 5 ? 7 : 0));
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
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
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
          body: SlidingUpPanel(
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
            body: TabBarView(
              controller: _tabController,
              children: List.generate(
                5,
                (weekday) => ListView(
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  children: Data.unitPlan.days[weekday].lessons
                      .map(
                        (lesson) => UnitPlanRow(
                          lesson: lesson,
                          start: getMonday.add(Duration(days: weekday)),
                        ),
                      )
                      .toList()
                      .cast<Widget>(),
                ),
              ).toList().cast<Widget>(),
            ),
          ),
        ),
      );
}
