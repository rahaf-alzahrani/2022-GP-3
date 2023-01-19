import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elfaa/screens/Homepage/childrenList.dart';
import 'package:elfaa/screens/notificationPage/noteList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

List<Object> _childNot = [];
List notification = [];

class NotlistBox extends StatefulWidget {
  final childrenList _childrenList;
  List _Note;
  NotlistBox(this._childrenList, this._Note);

  @override
  State<NotlistBox> createState() => _NotlistBoxState();
}

class _NotlistBoxState extends State<NotlistBox> {
  @override
  Widget build(BuildContext context) {
    //cast to notelist
    List<noteList>? _notifications =
        (widget._Note).map((dynamic item) => item as noteList).toList();

    DateTime now = DateTime.now();
    String formattedTime = DateFormat.jm().format(now);
    final DateTime now2 = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now2);
    final GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey<ScaffoldState>();
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 25, right: 25, top: 7),
      child: Container(
        height: height * 0.1,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Color(0xff484848).withOpacity(.3),
              offset: Offset(0, 4),
              blurRadius: 8)
        ], color: Colors.white, borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Column(children: [
                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 15),
                    child: Text(
                        " مر " +
                            "${widget._childrenList.childName}" +
                            " من "
                                "بوابة 1 ",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9C0000),
                        )),
                  ),
                ),
                Row(
                  children: [
                    Text(DateFormat.jm().format(now),
                        style: TextStyle(
                          color: Color(0xff919296),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.left),
                    Text(" | " + formatted,
                        style: TextStyle(
                          color: Color(0xff919296),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.left),
                  ],
                ),
              ]),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          right: 1, left: 0.1, top: width * 0.05, bottom: 0.1),
                      child: Text(
                        "${widget._childrenList.childName} ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 41, 41, 32)),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: networkImg("${widget._childrenList.childImagePath}",
                        width, height),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  // Future<void> getChildnot() async {
  //   if (!mounted) return;
  //   var data = await FirebaseFirestore.instance
  //       .collection('notificationForChild')
  //       .doc(widget._childrenList.notID)
  //       .collection('notifications')
  //       .get();

  //   if (!mounted) return;

  //   setState(() {
  //     if (!mounted) return;

  //     _childNot =
  //         List.from(data.docs.map((doc) => noteList.fromSnapshot(doc)));

  //   });
  // }
}

networkImg(String childImage, double ScreenWidth, double ScreenHeight) {
  try {
    return Image.network(
      childImage,
      width: ScreenWidth * 0.15,
      height: ScreenHeight * 0.33,
      fit: BoxFit.cover,
      frameBuilder:
          (BuildContext context, Widget child, int? frame, bool isAsyncLoaded) {
        return Container(
          child: child,
        );
      },
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: Text(
            "جاري التحميل",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? st) {
        return Container(
          width: ScreenWidth * 0.15,
          height: ScreenHeight * 0.33,
          child: Center(
            child: Text(
              "! حدث خطأ",
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 41, 41, 32),
              ),
            ),
          ),
        );
      },
    );
  } catch (error) {}
}
