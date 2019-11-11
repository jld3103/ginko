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
    this.addPadding = true,
    this.showCard = true,
  });

  // ignore: public_member_api_docs
  final Change change;

  // ignore: public_member_api_docs
  final bool showUnit;

  // ignore: public_member_api_docs
  final bool addPadding;

  // ignore: public_member_api_docs
  final bool showCard;

  @override
  Widget build(BuildContext context) {
    var infoText = '';
    if (change.changed.subject != null) {
      infoText += AppTranslations.of(context).subjects[change.changed.subject];
    }
    if (change.changed.subject != null &&
        (change.type != ChangeTypes.replaced || change.changed.info != null)) {
      infoText += ': ';
    }
    switch (change.type) {
      case ChangeTypes.unknown:
        infoText += AppTranslations.of(context).substitutionPlanUnknown;
        break;
      case ChangeTypes.exam:
        infoText += AppTranslations.of(context).substitutionPlanExam;
        break;
      case ChangeTypes.freeLesson:
        infoText += AppTranslations.of(context).substitutionPlanFreeLesson;
        break;
      case ChangeTypes.replaced:
        break;
    }
    if (change.changed.info != null &&
        (change.type != ChangeTypes.replaced ||
            (change.changed.subject != null &&
                change.type != ChangeTypes.replaced))) {
      infoText += ' ';
    }
    if (change.changed.info != null) {
      infoText += change.changed.info;
    }
    final content = Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: showCard ? 5 : 2.5,
        right: 5,
        bottom: showCard ? 5 : 2.5,
        left: 7.5,
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: showUnit ? 20 : null,
            child: showUnit
                ? Text(
                    '${change.unit + 1}',
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  )
                : null,
          ),
          Container(
            margin: EdgeInsets.only(right: 12.5),
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
                        child: Text(change.changed.room ?? ''),
                      ),
                    ),
                    Expanded(
                      flex: 15,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          change.room ?? '',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 70,
                      child: Text(
                        infoText,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
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
                        child: Text(
                          change.teacher ?? '',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
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
      return Container(
        padding: EdgeInsets.only(left: !showUnit && addPadding ? 20 : 0),
        child: Card(
          margin: EdgeInsets.only(
            top: 0,
            right: 2.5,
            bottom: 0,
            left: 2.5,
          ),
          child: content,
        ),
      );
    }
    return Container(
      padding: EdgeInsets.only(left: !showUnit && addPadding ? 20 : 0),
      child: content,
    );
  }
}
