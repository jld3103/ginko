import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ginko/home/home_page.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:ginko/plugins/pwa/pwa.dart';
import 'package:ginko/substitution_plan/substitution_plan_page.dart';
import 'package:ginko/timetable/timetable_page.dart';
import 'package:ginko/utils/notifications.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/static.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:models/models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

// ignore: public_member_api_docs
class AppPage extends StatefulWidget {
  // ignore: public_member_api_docs
  const AppPage({
    this.page = 1,
    this.loading = true,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final int page;

  // ignore: public_member_api_docs
  final bool loading;

  @override
  State<StatefulWidget> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage>
    with SingleTickerProviderStateMixin, AfterLayoutMixin<AppPage> {
  bool _loading;
  TabController _tabController;
  int _currentTab = 1;
  bool _permissionsGranted = true;
  bool _permissionsChecking = false;
  bool _canInstall = false;
  bool _installing = false;
  PWA _pwa;

  Future _fetchData() async {
    setState(() {
      _loading = true;
    });
    try {
      final credentialsCorrect = await Static.user.forceLoadOnline();
      if (credentialsCorrect) {
        final storedUpdates = Static.updates.data;
        await Static.updates.forceLoadOnline();
        final fetchedUpdates = Static.updates.data;
        Static.updates.object = storedUpdates;
        for (final key in fetchedUpdates.keys) {
          if (storedUpdates == null ||
              fetchedUpdates[key] != storedUpdates[key]) {
            print('Updating $key');
            switch (key) {
              case Keys.substitutionPlan:
                await Static.substitutionPlan.loadOnline();
                break;
              case Keys.timetable:
                await Static.timetable.loadOnline();
                break;
              case Keys.calendar:
                await Static.calendar.loadOnline();
                break;
              case Keys.aiXformation:
                await Static.aiXformation.loadOnline();
                break;
              case Keys.cafetoria:
                await Static.cafetoria.loadOnline();
                break;
              case Keys.releases:
                await Static.releases.loadOnline();
                break;
              case Keys.subjects:
                await Static.subjects.loadOnline();
                break;
              default:
                print('unknown loader $key');
                break;
            }
            Static.updates.data[key] = fetchedUpdates[key];
          }
        }
        await Static.selection.forceLoadOnline();
        await Static.settings.forceLoadOnline();
        if (Static.device.data != null && Static.device.data.token != '') {
          await Static.device.forceLoadOnline();
        }
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      } else {
        await _launchLogin();
      }
    } on DioError {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future _launchLogin() async {
    if (getScreenSize(MediaQuery.of(context).size.width) == ScreenSize.big &&
        Platform().isWeb) {
      await Navigator.of(context).pushReplacementNamed('/${Keys.choose}');
    } else {
      await Navigator.of(context).pushReplacementNamed('/${Keys.login}');
    }
  }

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _currentTab = widget.page,
    );
    _loading = widget.loading;
    if (_loading) {
      Static.user.loadOffline();
      Static.device.loadOffline();
      Static.selection.loadOffline();
      if (Static.selection.data == null) {
        Static.selection.object = Selection([]);
      }
      Static.updates.loadOffline();
      if (Static.updates.data == null) {
        Static.updates.object = {};
      }
      Static.settings.loadOffline();
      if (Static.settings.data == null) {
        Static.settings.object = Settings([]);
      }
      Static.substitutionPlan.loadOffline();
      Static.timetable.loadOffline();
      Static.calendar.loadOffline();
      Static.aiXformation.loadOffline();
      Static.cafetoria.loadOffline();
      Static.releases.loadOffline();
      Static.subjects.loadOffline();
    }
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Future afterFirstLayout(BuildContext context) async {
    if (!Static.user.hasStoredData) {
      await _launchLogin();
      return;
    }
    _pwa = PWA();
    if (Platform().isWeb) {
      _permissionsGranted =
          await Static.firebaseMessaging.hasNotificationPermissions();
      _canInstall = _pwa.canInstall();
      setState(() {});
    }
    if (Static.releases.data != null &&
        Platform().isDesktop &&
        Version.parse(Static.releases.data.version) >
            Version.parse(await Static.releases.getCurrentAppVersion())) {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 30),
        content: Text('Eine neue App-Version ist verfügbar'),
        action: SnackBarAction(
          label: 'Aktualisieren',
          onPressed: () {
            launch(Static.releases.data.url);
          },
        ),
      ));
    }
    if (_loading) {
      await _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final webActions = [
      if (_permissionsChecking)
        FlatButton(
          onPressed: () {},
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
            strokeWidth: 2,
          ),
        ),
      if (!_permissionsGranted && !_permissionsChecking)
        FlatButton(
          onPressed: () async {
            setState(() {
              _permissionsChecking = true;
            });
            _permissionsGranted =
                await Static.firebaseMessaging.requestNotificationPermissions();
            await updateTokens(context);
            setState(() {
              _permissionsChecking = false;
            });
          },
          child: Icon(
            Icons.notifications_off,
            size: 28,
          ),
        ),
      if (_installing)
        FlatButton(
          onPressed: () {},
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
            strokeWidth: 2,
          ),
        ),
      if (_canInstall && !_installing)
        FlatButton(
          onPressed: () async {
            setState(() {
              _installing = true;
            });
            await _pwa.install();
            _canInstall = _pwa.canInstall();
            setState(() {
              _installing = false;
            });
          },
          child: Icon(
            MdiIcons.cellphoneArrowDown,
            size: 28,
          ),
        ),
    ];
    final pages = [
      InlinePage(
        'Vertretungsplan',
        [
          ...webActions,
          if (Static.user.hasLoadedData)
            InkWell(
              onTap: () {},
              child: Container(
                width: 48,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(7.5),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFC8C8C8),
                          spreadRadius: 0.5,
                          blurRadius: 1,
                        ),
                      ],
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      border: Border.all(
                        color: Colors.black,
                        width:
                            getScreenSize(MediaQuery.of(context).size.width) ==
                                    ScreenSize.small
                                ? 0.5
                                : 1.25,
                      ),
                    ),
                    child: Text(
                      isSeniorGrade(Static.user.data.grade)
                          ? Static.user.data.grade.toUpperCase()
                          : Static.user.data.grade,
                      style: GoogleFonts.ubuntuMono(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
        SubstitutionPlanPage(),
        Icons.list,
      ),
      InlinePage(
        'Startseite',
        [
          ...webActions,
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/${Keys.settings}');
            },
            icon: Icon(
              Icons.settings,
              size: 28,
            ),
          ),
        ],
        HomePage(),
        Icons.home,
      ),
      InlinePage(
        'Stundenplan',
        [
          ...webActions,
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/${Keys.calendar}');
            },
            icon: Icon(
              MdiIcons.calendarMonth,
              size: 28,
            ),
          ),
        ],
        TimetablePage(),
        MdiIcons.timetable,
      ),
    ];
    final tabBar = Column(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: getScreenSize(MediaQuery.of(context).size.width) ==
                    ScreenSize.small
                ? [
                    BoxShadow(
                      color: Color(0xFFC8C8C8),
                      spreadRadius: 1.25,
                      blurRadius: 1,
                    ),
                  ]
                : null,
            color: Theme.of(context).primaryColor,
          ),
          child: TabBar(
            controller: _tabController,
            onTap: (index) {
              setState(() {
                _currentTab = _tabController.index = index;
              });
            },
            indicatorColor: getScreenSize(MediaQuery.of(context).size.width) ==
                    ScreenSize.small
                ? Colors.transparent
                : null,
            tabs: pages
                .map((page) => Tab(
                      icon: Icon(
                        page.iconData,
                        color: _currentTab == pages.indexOf(page) &&
                                getScreenSize(
                                        MediaQuery.of(context).size.width) ==
                                    ScreenSize.small
                            ? Theme.of(context).accentColor
                            : Colors.black54,
                      ),
                    ))
                .toList()
                .cast<Widget>(),
          ),
        ),
        if (getScreenSize(MediaQuery.of(context).size.width) !=
            ScreenSize.small)
          Container(
            height: 1,
            margin: EdgeInsets.only(top: 1),
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFC8C8C8),
                  spreadRadius: 1.25,
                  blurRadius: 1,
                ),
              ],
              color: Theme.of(context).primaryColor,
            ),
          ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(pages[_currentTab].title),
        automaticallyImplyLeading: false,
        actions: pages[_currentTab].actions,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 3,
            child: _loading
                ? LinearProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  )
                : Container(),
          ),
          if (getScreenSize(MediaQuery.of(context).size.width) !=
              ScreenSize.small)
            tabBar,
          Expanded(
            child: Scaffold(
              body: Stack(
                children: [
                  IndexedStack(
                    index: _currentTab,
                    children: pages
                        .map((page) => page.content)
                        .toList()
                        .cast<Widget>(),
                  ),
                  NotificationsWidget(
                    fetchData: _fetchData,
                  ),
                ],
              ),
            ),
          ),
          if (getScreenSize(MediaQuery.of(context).size.width) ==
              ScreenSize.small)
            tabBar,
        ],
      ),
    );
  }
}

// ignore: public_member_api_docs
class InlinePage {
  // ignore: public_member_api_docs
  InlinePage(
    this.title,
    this.actions,
    this.content,
    this.iconData,
  );

  // ignore: public_member_api_docs
  final String title;

  // ignore: public_member_api_docs
  final List<Widget> actions;

  // ignore: public_member_api_docs
  final Widget content;

  // ignore: public_member_api_docs
  final IconData iconData;
}
