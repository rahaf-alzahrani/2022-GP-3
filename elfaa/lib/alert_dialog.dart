import 'package:flutter/material.dart';
import 'package:elfaa/constants.dart';

enum DialogsAction { yes, cancel }

class AlertDialogs {
  static Future<DialogsAction> yesCancelDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Center(child: Text(title)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text(
                    body,
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pop(DialogsAction.cancel),
                        child: Text(
                          'لا',
                          style: TextStyle(
                              color: Color(0xFF9C0000),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pop(DialogsAction.yes),
                        child: Text(
                          'نعم',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ])
              ],
            ),
          );
        });
    return (action != null) ? action : DialogsAction.cancel;
  }
}
