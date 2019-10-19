import 'package:flutter/material.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/views/cafetoria/row.dart';
import 'package:ginko/views/calendar/row.dart';
import 'package:models/models.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:translations/translations_app.dart';

/// ExtraInformation class
/// shows a list of extra information
class ExtraInformation extends StatefulWidget {
  // ignore: public_member_api_docs
  const ExtraInformation({
    @required this.date,
    @required this.calendar,
    @required this.cafetoria,
    @required this.user,
    this.panelController,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final DateTime date;

  // ignore: public_member_api_docs
  final Calendar calendar;

  // ignore: public_member_api_docs
  final Cafetoria cafetoria;

  // ignore: public_member_api_docs
  final User user;

  // ignore: public_member_api_docs
  final PanelController panelController;

  @override
  State<StatefulWidget> createState() => _ExtraInformationState();
}

class _ExtraInformationState extends State<ExtraInformation> {
  @override
  Widget build(BuildContext context) {
    final start = widget.date;
    final end = start.add(Duration(days: 1)).subtract(Duration(seconds: 1));
    final events = widget.calendar.getEventsForTimeSpan(start, end);
    final cafetoriaDays = widget.cafetoria != null
        ? widget.cafetoria.days.where((day) => day.date == start).toList()
        : [];
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.panelController != null) {
              if (widget.panelController.isPanelOpen()) {
                widget.panelController.close();
              } else {
                widget.panelController.open();
              }
            }
          },
          child: Column(
            children: [
              if (getScreenSize(MediaQuery.of(context).size.width) ==
                  ScreenSize.small)
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.transparent,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 7, bottom: 7),
                      child: SizedBox(
                        height: 6,
                        width: MediaQuery.of(context).size.width / 3,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (getScreenSize(MediaQuery.of(context).size.width) !=
                  ScreenSize.small)
                Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: getScreenSize(MediaQuery.of(context).size.width) !=
                            ScreenSize.small
                        ? 15
                        : 0,
                  ),
                  color: getScreenSize(MediaQuery.of(context).size.width) !=
                          ScreenSize.small
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  width: double.infinity,
                  height: null,
                  alignment: getScreenSize(MediaQuery.of(context).size.width) !=
                          ScreenSize.small
                      ? Alignment.bottomLeft
                      : null,
                  child: Container(
                    height: getScreenSize(MediaQuery.of(context).size.width) !=
                            ScreenSize.small
                        ? 41
                        : 34,
                    alignment: Alignment.center,
                    child: getHeaderText,
                  ),
                ),
              if (getScreenSize(MediaQuery.of(context).size.width) ==
                  ScreenSize.small)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 1,
                      child: Center(
                        child: Container(
                          margin: EdgeInsetsDirectional.only(
                            start: 1,
                            end: 1,
                          ),
                          height: 1,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getHeaderText,
                          Row(
                            children: [
                              Text(
                                events.length.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: 1.5,
                                height: 1,
                                color: Colors.transparent,
                              ),
                              Icon(
                                Icons.calendar_today,
                                color: Theme.of(context).primaryColor,
                                size: 16,
                              ),
                              Container(
                                width: 10,
                                height: 1,
                                color: Colors.transparent,
                              ),
                              Text(
                                (cafetoriaDays.isNotEmpty
                                        ? cafetoriaDays[0].menus.length
                                        : 0)
                                    .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: 1.5,
                                height: 1,
                                color: Colors.transparent,
                              ),
                              Icon(
                                Icons.restaurant,
                                color: Theme.of(context).primaryColor,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Container(
          height: getScreenSize(MediaQuery.of(context).size.width) !=
                  ScreenSize.small
              ? MediaQuery.of(context).size.height - 97
              : null,
          decoration: getScreenSize(MediaQuery.of(context).size.width) !=
                  ScreenSize.small
              ? BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                )
              : null,
          child: ListView(
            padding: EdgeInsets.all(
                getScreenSize(MediaQuery.of(context).size.width) !=
                        ScreenSize.small
                    ? 5
                    : 10),
            shrinkWrap: true,
            children: [
              ...events
                  .map((event) => CalendarRow(
                        event: event,
                      ))
                  .toList(),
              if (cafetoriaDays.isNotEmpty)
                CafetoriaRow(
                  day: cafetoriaDays[0],
                  user: widget.user,
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget get getHeaderText => Row(
        children: [
          Text(
            AppTranslations.of(context).weekdays[widget.date.weekday - 1],
            style: TextStyle(
              fontWeight: getScreenSize(MediaQuery.of(context).size.width) ==
                      ScreenSize.small
                  ? FontWeight.bold
                  : null,
              color: getScreenSize(MediaQuery.of(context).size.width) !=
                      ScreenSize.small
                  ? Colors.white
                  : null,
              fontSize: getScreenSize(MediaQuery.of(context).size.width) !=
                      ScreenSize.small
                  ? 18
                  : null,
            ),
          ),
          Text(
            // ignore: lines_longer_than_80_chars
            ' - ${outputDateFormat(widget.user.language.value).format(widget.date)}',
            style: TextStyle(
              color: getScreenSize(MediaQuery.of(context).size.width) !=
                      ScreenSize.small
                  ? Colors.white
                  : null,
              fontSize: getScreenSize(MediaQuery.of(context).size.width) !=
                      ScreenSize.small
                  ? 18
                  : null,
            ),
          ),
        ],
      );
}
