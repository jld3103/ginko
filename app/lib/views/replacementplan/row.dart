import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// ReplacementPlanRow class
/// renders a change
class ReplacementPlanRow extends StatelessWidget {
  // ignore: public_member_api_docs
  const ReplacementPlanRow({
    @required this.change,
    this.showUnit = true,
    this.addPadding = true,
  });

  // ignore: public_member_api_docs
  final Change change;

  // ignore: public_member_api_docs
  final bool showUnit;

  // ignore: public_member_api_docs
  final bool addPadding;

  @override
  Widget build(BuildContext context) => Card(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: addPadding ? 15 : null,
                child: showUnit ? Text('${change.unit + 1}') : null,
              ),
              Container(
                margin: EdgeInsets.only(right: 3),
                alignment: Alignment.center,
                height: 32,
                width: 2,
                color: change.type == ChangeTypes.freeLesson
                    ? Theme.of(context).primaryColor
                    : (change.type == ChangeTypes.exam ||
                            change.type == ChangeTypes.rewriteExam
                        ? Colors.red
                        : Colors.orange),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 70,
                          child: Text(
                            AppTranslations.of(context)
                                    .subjects[change.subject] ??
                                '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(change.changed.room ?? ''),
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(change.room ?? ''),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 70,
                          child: Text(
                            (AppTranslations.of(context)
                                        .subjects[change.changed.subject] ??
                                    '') +
                                (change.changed.info != null &&
                                        change.changed.subject != null
                                    ? ': '
                                    : '') +
                                ((change.type == ChangeTypes.freeLesson
                                        ? AppTranslations.of(context)
                                            .replacementPlanFreeLesson
                                        : change.type == ChangeTypes.replaced
                                            ? AppTranslations.of(context)
                                                .replacementPlanReplaced
                                            : change.type ==
                                                    ChangeTypes.roomChanged
                                                ? AppTranslations.of(context)
                                                    .replacementPlanRoomChanged
                                                : change.type ==
                                                        ChangeTypes.withTasks
                                                    ? AppTranslations
                                                            .of(context)
                                                        // ignore: lines_longer_than_80_chars
                                                        .replacementPlanWithTasks
                                                    : '') +
                                    (change.changed.info != null &&
                                            change.type != ChangeTypes.unknown
                                        ? ' '
                                        : '') +
                                    (change.changed.info ?? '')),
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(change.changed.teacher ?? ''),
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(change.teacher ?? ''),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
