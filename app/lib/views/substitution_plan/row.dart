import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// SubstitutionPlanRow class
/// renders a change
class SubstitutionPlanRow extends StatelessWidget {
  // ignore: public_member_api_docs
  const SubstitutionPlanRow({
    @required this.change,
    this.showUnit = true,
    this.showCard = true,
  });

  // ignore: public_member_api_docs
  final Change change;

  // ignore: public_member_api_docs
  final bool showUnit;

  // ignore: public_member_api_docs
  final bool showCard;

  @override
  Widget build(BuildContext context) {
    final infoText = [];
    if (change.changed.subject != null &&
        (change.subject != null && change.subject != change.changed.subject)) {
      infoText
          .add(AppTranslations.of(context).subjects[change.changed.subject]);
    }
    switch (change.type) {
      case ChangeTypes.exam:
        infoText.add(AppTranslations.of(context).substitutionPlanExam);
        break;
      case ChangeTypes.freeLesson:
        infoText.add(AppTranslations.of(context).substitutionPlanFreeLesson);
        break;
      case ChangeTypes.changed:
        break;
    }
    if (change.changed.info != null) {
      infoText.add(change.changed.info);
    }
    final content = Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 2.5,
        right: 6.5,
        bottom: 2.5,
        left: 6.5,
      ),
      child: Row(
        children: [
          Container(
            width: 15,
            child: Text(
              showUnit ? '${change.unit + 1}' : '',
              style: TextStyle(
                color: Color(0xff444444),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 5),
            alignment: Alignment.center,
            height: 32,
            width: 2,
            color: change.type == ChangeTypes.freeLesson
                ? Theme.of(context).primaryColor
                : (change.type == ChangeTypes.exam
                    ? Colors.red
                    : Colors.orange),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 70,
                      child: Text(
                        AppTranslations.of(context).subjects[change.subject] ??
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
                        child: Text(
                          change.changed.room ?? '',
                          style: change.changed.room != null
                              ? TextStyle(
                                  color: Theme.of(context).primaryColor,
                                )
                              : null,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 15,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          change.room ?? '',
                          style: change.changed.room == null
                              ? TextStyle(
                                  color: Theme.of(context).primaryColor,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 70,
                      child: Text(
                        infoText.join(' '),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 15,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          change.changed.teacher ?? '',
                          style: change.changed.teacher != null
                              ? TextStyle(
                                  color: Theme.of(context).primaryColor,
                                )
                              : null,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 15,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          change.teacher ?? '',
                          style: change.changed.teacher == null
                              ? TextStyle(
                                  color: Theme.of(context).primaryColor,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (showCard) {
      return Card(
        margin: EdgeInsets.all(2.5),
        child: content,
      );
    }
    return content;
  }
}
