import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elfaa/constants.dart';
import 'package:elfaa/screens/admin/admin_alert/admin_alert_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../admin/admin_notification/notification.dart';

class Notepage extends StatefulWidget {
  const Notepage({super.key});

  @override
  State<Notepage> createState() => _Notepage();
}

class _Notepage extends State<Notepage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    AdminAlertPage.lastTimestamp = "";
    AdminAlertPage.newTimestamp = "";

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
            StreamBuilder<List<UserNotification>>(
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

                        AdminAlertPage.newTimestamp =
                            DateFormat("DD/MM/yyyy").format(notification.time);

                        if (AdminAlertPage.lastTimestamp !=
                            AdminAlertPage.newTimestamp) {
                          showTimestamp = true;
                        }

                        AdminAlertPage.lastTimestamp =
                            AdminAlertPage.newTimestamp;

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
                                          backgroundColor:
                                              _getColor(notification.newStatus),
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

  Stream<List<UserNotification>> notificationStream() {
    return FirebaseFirestore.instance
        .collection("notification")
        .orderBy('time', descending: true)
        .snapshots()
        .map((querySnapshot) {
      List<UserNotification> notifications = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        notifications.add(UserNotification.fromMap(documentSnapshot));
      }
      return notifications;
    });
  }
}
