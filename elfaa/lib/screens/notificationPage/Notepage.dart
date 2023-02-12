import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elfaa/constants.dart';
import 'package:elfaa/screens/Homepage/Home_page.dart';
import 'package:elfaa/screens/admin/admin_alert/admin_alert_page.dart';
import 'package:elfaa/screens/notificationPage/notification_Parent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String lastTimestamp = "";
String newTimestamp = "";

class Notepage extends StatefulWidget {
  const Notepage({super.key});

  @override
  State<Notepage> createState() => _Notepage();
}

class _Notepage extends State<Notepage> {
  String pID = '';
  Future<void> getCurrentP() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = await _auth.currentUser;
    final uid = user!.uid;
    setState(() {
      pID = uid;
    });
  }

  @override
  void initState() {
    getCurrentP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 90,
        title: Text(
          'التنبيهات',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        flexibleSpace: Container(
            decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28)),
          color: kPrimaryColor,
        )),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: height * 0.01),
            StreamBuilder<List<UserNotification2>>(
                stream: notificationStream(),
                builder: (context, snapshot) {
                  final notifications = snapshot.data ?? [];

                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: notifications.length,
                      itemBuilder: ((context, index) {
                        final notification = notifications[index];

                        bool showTimestamp = false;

                        newTimestamp =
                            DateFormat("DD/MM/yyyy").format(notification.time);

                        if (lastTimestamp != newTimestamp) {
                          showTimestamp = true;
                        }

                        lastTimestamp = newTimestamp;

                        return Column(
                          children: [
                            if (showTimestamp)
                              SizedBox(
                                  height: height * 0.08,
                                  child: Center(
                                    child: Text(
                                      DateFormat("DD/MM/yyyy")
                                          .format(notification.time),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10, color: Colors.black12)
                                    ]),
                                margin: EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.symmetric(
                                  vertical: height * 0.02,
                                ),
                                child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                notification.message,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1,
                                              ),
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              Text(
                                                DateFormat(
                                                        "dd-MM-yyyy hh:mm aa")
                                                    .format(notification.time),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: color1
                                          //    _getColor(notification.newStatus)
                                          ,
                                          child: Icon(
                                            Icons.notifications_active,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        );
                      }));
                })
          ],
        ),
      ),
    );
  }

  _getColor(String status) {
    if (status == "ضائع") {
      return Colors.red;
    } else if (status == "تم العثور عليه") {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  Stream<List<UserNotification2>> notificationStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(pID)
        .collection('notification')
        .orderBy('time', descending: true)
        .snapshots()
        .map((querySnapshot) {
      List<UserNotification2> notifications = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        notifications.add(UserNotification2.fromMap(documentSnapshot));
      }
      return notifications;
    });
  }
}
