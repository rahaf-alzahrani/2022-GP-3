import       'package:cloud_firestore/cloud_firestore.dart';
import 'package:elfaa/constants.dart';
import 'package:elfaa/report.dart';
import 'package:elfaa/screens/admin/admin_alert/admin_alert_page.dart';
import 'package:elfaa/screens/admin/admin_home/add_SG_page.dart';
import 'package:elfaa/screens/sg/sg_home/report_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SGHomePage extends StatefulWidget {
  const SGHomePage({super.key});

  @override
  State<SGHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<SGHomePage> {
  final Color color1 = kPrimaryColor;
  final Color color2 = kPrimaryColor;
  final Color color3 = kPrimaryColor;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    AdminAlertPage.newTimestamp = "";
    AdminAlertPage.lastTimestamp = "";

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0),
            child: Column(
              children: [

                SizedBox(height: height * 0.01),

                StreamBuilder<List<Report>>(
                    stream: reportStream(),
                    builder: (context, snapshot) {

                      final reports = snapshot.data ?? [];

                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: reports.length,
                          itemBuilder: (context, index) {
                            final report = reports[index];

                            bool showTimestamp = false;

                            AdminAlertPage.newTimestamp = DateFormat("DD/MM/yyyy").format(report.time);

                            if(AdminAlertPage.lastTimestamp != AdminAlertPage.newTimestamp) {
                              showTimestamp = true;
                            }

                            AdminAlertPage.lastTimestamp = AdminAlertPage.newTimestamp;

                            return Column(
                              children: [

                                if(showTimestamp)
                                  SizedBox(
                                      height: height * 0.05,
                                      child: Center(
                                        child: Text(
                                          DateFormat("DD/MM/yyyy").format(report.time),
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                        ),
                                      )
                                  ),

                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) {
                                              return ReporteDetail(
                                                childReport: reports[index],
                                                isSecurityGuard: true,
                                              );
                                            }
                                        )
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(blurRadius: 10, color: Colors.black12)
                                          ]

                                      ),
                                      margin: EdgeInsets.symmetric(vertical: 4),
                                      padding: EdgeInsets.symmetric(
                                        vertical: height * 0.02,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(Icons.arrow_back_ios_new),

                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "بلاغ #${DateFormat("yyyyMMDDhhmmss").format(report.time)}",
                                                      style:
                                                      Theme.of(context).textTheme.subtitle1,
                                                    ),

                                                    SizedBox(
                                                      height: height * 0.01,
                                                    ),

                                                    Text(
                                                      DateFormat("dd-MM-yyyy hh:mm aa").format(report.time),
                                                      style: Theme.of(context).textTheme.caption,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: width * 0.02,
                                                ),
                                                CircleAvatar(
                                                  backgroundColor: kOrangeColor,
                                                  child: Icon(
                                                    Icons.campaign,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          }
                      );
                    }
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  Stream<List<Report>> reportStream() {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    User? _user = _auth.currentUser;

    return FirebaseFirestore.instance.collection("report")
        .where('finderID', isEqualTo: _user!.uid)
        .orderBy('time', descending: true)
        .snapshots().map((querySnapshot) {

      List<Report> reports = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        reports.add(Report.fromMap(documentSnapshot));
      }

      return reports;
    });
  }

  Widget addButton(double height) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Container(
          height: height * 0.06,
          decoration: BoxDecoration(
              color: kOrangeColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: kOrangeColor.withOpacity(.3),
                    offset: Offset(0, 4),
                    blurRadius: 8)
              ]),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddSecurityGuard()),
              );
            },
            icon: Icon(Icons.add),
            color: Colors.white,
          )),
    );
  }

  Container _buildHeader() {
    final GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey<ScaffoldState>();
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.22,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            top: height * -0.24,
            right: width * -0.2,
            child: Container(
              width: width * 0.8,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [color1, color2]),
                  boxShadow: [
                    BoxShadow(
                        color: color2,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 10.0)
                  ]),
            ),
          ),
          Positioned(
            top: height * 0.06,
            right: width * 0.08,
            bottom: 0,
            child: Text(
              "! مرحبًا" " ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Positioned(
            top: height * 0.1,
            right: width * 0.09,
            child: Text(
              "حارس الأمن",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
