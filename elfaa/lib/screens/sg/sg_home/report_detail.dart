import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elfaa/constants.dart';
import 'package:elfaa/report.dart';
import 'package:elfaa/screens/Reportpage/progress_report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../Homepage/HomelistBox.dart';

class ReporteDetail extends StatefulWidget {
  final Report childReport;
  final bool isSecurityGuard;

  const ReporteDetail({
    Key? key,
    required this.childReport,
    this.isSecurityGuard = false,
  });

  @override
  State<ReporteDetail> createState() => _ReporteDetailState();
}

class _ReporteDetailState extends State<ReporteDetail> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(24.770171, 46.643851);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final color = _getColor(widget.childReport.status ?? "");

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 90,
        title: Text(
          "تفاصيل البلاغ",
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 0.3 * height,
            width: 90 * width,
            color: kPrimaryColor,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.024,
                width: width * 0.05,
              ),
              Expanded(
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: childStream(widget.childReport),
                      builder: (context, snapshot) {
                        final child = snapshot.data;

                        final Timestamp birthday =
                            child?['birthday'] ?? Timestamp.now();

                        final age = ((DateTime.now()
                                    .difference(birthday.toDate())
                                    .inDays) /
                                365)
                            .floor();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  widget.childReport.childName!,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 41, 41, 32),
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "اسم الطفل :",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 41, 41, 32),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  child?['gender'] ?? "",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 41, 41, 32),
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "الجنس: ",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 41, 41, 32),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  child?['height'].toString() ?? "",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 41, 41, 32),
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "الطول: ",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 41, 41, 32),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "$age ${age == 1 ? 'سنة' : 'سنوات'}",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 41, 41, 32),
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "العمر: ",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 41, 41, 32),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  DateFormat("dd/MM/yyyy hh:mm aa")
                                      .format(widget.childReport.time),
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 41, 41, 32),
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "وقت البلاغ:",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 41, 41, 32),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                )),
              ),
              SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 80,
                  width: 68,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child:
                        networkImg(widget.childReport.imageUrl!, width, height),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ),
          SizedBox(
            width: width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'حالة البلاغ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  width: height * 0.01,
                ),
                Container(
                  height: height * 0.04,
                  width: height * 0.15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.childReport.status ?? "",
                        style: TextStyle(
                            color: color,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: color)),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: height * 0.02,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text("رقم التواصل مع الوالد",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 20,
                              ),
                              StreamBuilder<String>(
                                  stream: phoneNumberStream(widget.childReport),
                                  builder: (context, snapshot) {
                                    final String? phoneNumber = snapshot.data;
                                    return Text(phoneNumber ?? "رقم التواصل",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold));
                                  }),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: height * 0.07,
                  width: width * 0.425,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      Text(
                        'اتصل بالوالد',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 20),
                      Icon(
                        Icons.phone,
                        size: 16,
                        color: kPrimaryColor,
                      )
                    ],
                  )),
                  decoration: BoxDecoration(
                      color: klightBlueColor,
                      borderRadius: BorderRadius.circular(32)),
                ),
              ),
              SizedBox(
                width: width * 0.05,
              ),
              InkWell(
                onTap: () async {
                  if (widget.childReport.status != "ضائع") return;

                  setState(() {
                    isLoading = true;
                  });

                  await FirebaseFirestore.instance
                      .collection('report')
                      .doc(widget.childReport.id)
                      .update({"status": "تم العثور عليه"});

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.childReport.parentID)
                      .collection('children')
                      .doc(widget.childReport.childrenId)
                      .update({"status": true});

                  User? _user = _auth.currentUser;

                  final user = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(_user!.uid)
                      .get();

                  await FirebaseFirestore.instance
                      .collection('report')
                      .doc(widget.childReport.id)
                      .collection('progress')
                      .add({
                    "action": "${widget.isSecurityGuard ? "حارس الأمن" : "المشرف"}"
                        " (name: ${user['name']}, رقم جواله: ${user['phoneNo']}) غيّر حالة البلاغ إلى تم العثور على الطفل",
                    "time": Timestamp.now()
                  });

                  await FirebaseFirestore.instance
                      .collection('notification')
                      .add({
                    "message":
                        "البلاغ #${DateFormat("yyyyMMDDhhmmss").format(widget.childReport.time)} تم تحديث حالته إلى تم العثور عليه",
                    "newStatus": "تم العثور عليه",
                    "time": Timestamp.now()
                  });

                  Navigator.pop(context);
                },
                child: Container(
                  height: height * 0.07,
                  width: width * 0.425,
                  child: Center(
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'تم العثور عليه',
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )),
                  decoration: BoxDecoration(
                      color: Color(0xFF429EB2),
                      borderRadius: BorderRadius.circular(32)),
                ),
              ),
            ],
          ),
          if (!widget.isSecurityGuard)
            SizedBox(
              height: height * 0.03,
            ),
          if (!widget.isSecurityGuard)
            InkWell(
              onTap: () async {
                if (widget.childReport.status != "ضائع") return;

                setState(() {
                  isLoading = true;
                });

                User? _user = _auth.currentUser;

                await FirebaseFirestore.instance
                    .collection('report')
                    .doc(widget.childReport.id)
                    .update({"status": "مغلق", "finderID": _user!.uid});

                final user = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(_user.uid)
                    .get();

                await FirebaseFirestore.instance
                    .collection('report')
                    .doc(widget.childReport.id)
                    .collection('progress')
                    .add({
                  "action":
                      "المشرف (${user['name']}, رقم جواله: ${user['phoneNo']}) أغلق البلاغ",
                  "time": Timestamp.now()
                });

                await FirebaseFirestore.instance
                    .collection('notification')
                    .add({
                  "message":
                      "البلاغ #${DateFormat("yyyyMMDDhhmmss").format(widget.childReport.time)} تم تحديث حالته إلى مغلق عن طريق المشرف",
                  "newStatus": "مغلق",
                  "time": Timestamp.now()
                });

                Navigator.pop(context);
              },
              child: Container(
                height: height * 0.07,
                width: width * 0.425,
                child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "إغلاق البلاغ",
                            style: TextStyle(
                                color: Color(0xFF9C0000),
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          )),
                decoration: BoxDecoration(
                    color: Color(0xFFFFEEEE),
                    borderRadius: BorderRadius.circular(32)),
              ),
            ),
          SizedBox(height: 10),
          SizedBox(
            height: height * 0.03,
          ),
        ],
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

  Stream<String> phoneNumberStream(Report report) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('userID', isEqualTo: report.parentID)
        .snapshots()
        .map((querySnapshot) {
      String phoneNumber = "No Contact Info";

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        phoneNumber = documentSnapshot['phoneNo'];
      }

      return phoneNumber;
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> childStream(Report report) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(report.parentID)
        .collection('children')
        .doc(report.childrenId!)
        .snapshots()
        .map((documentSnapshot) {
      return documentSnapshot;
    });
  }
}
