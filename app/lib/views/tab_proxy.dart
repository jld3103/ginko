import 'package:flutter/material.dart';
import 'package:ginko/utils/screen_sizes.dart';

/// TabProxy class
/// decides how to display tabs
/// Either as tabs or as columns
class TabProxy extends StatelessWidget {
  // ignore: public_member_api_docs
  const TabProxy({
    @required this.tabs,
    @required this.tabNames,
    @required this.controller,
  }) : super();

  // ignore: public_member_api_docs
  final List<Widget> tabs;

  // ignore: public_member_api_docs
  final List<String> tabNames;

  // ignore: public_member_api_docs
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    var tabFontSize = 15.0;
    final width = MediaQuery.of(context).size.width;
    if (width <= 320) {
      tabFontSize = 12.0;
    } else if (width <= 330) {
      tabFontSize = 13.0;
    }
    if (getScreenSize(MediaQuery.of(context).size.width) == ScreenSize.big) {
      return Row(
        children: tabs
            .map((tab) => Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        height: 41,
                        padding: EdgeInsets.only(top: 10),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          tabNames[tabs.indexOf(tab)],
                          style: TextStyle(
                            fontSize: tabFontSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 39),
                        alignment: Alignment.topCenter,
                        child: tab,
                      ),
                    ],
                  ),
                ))
            .toList(),
      );
    } else {
      return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: TabBar(
            controller: controller,
            indicatorColor: Theme.of(context).accentColor,
            indicatorWeight: 2.5,
            tabs: tabNames
                .map((day) => Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: tabFontSize,
                          color: Colors.white,
                        ),
                      ),
                    ))
                .toList(),
          ),
          body: TabBarView(
            controller: controller,
            children: tabs
                .map((tab) => Container(
                      height: double.infinity,
                      color: Colors.white,
                      child: tab,
                    ))
                .toList(),
          ),
        ),
      );
    }
  }
}
