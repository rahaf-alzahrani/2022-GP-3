import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elfaa/constants.dart';
import 'package:elfaa/report.dart';
import 'package:elfaa/screens/Reportpage/ReportPage.dart';
import 'package:elfaa/screens/sg/sg_home/report_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminAlertPage extends StatefulWidget {
  const AdminAlertPage({super.key});

  @override
  State<AdminAlertPage> createState() => _AdminAlertPageState();
}

class _AdminAlertPageState extends State<AdminAlertPage> {
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
          'البلاغات',
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

            StreamBuilder<List<Report>>(
              stream: reportStream(),
              builder: (context, snapshot) {

                final reports = snapshot.data ?? [];

                return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: reports.length,
                    itemBuilder: ((context, index) {
                      final report = reports[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) {
                                      return ReporteDetail(childReport: reports[index]);
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
                      );
                    }));
              }
            )
          ],
        ),
      ),
    );
  }

  Stream<List<Report>> reportStream() {
    return FirebaseFirestore.instance.collection("report")
        .orderBy('time', descending: true)
        .snapshots().map((querySnapshot) {

      List<Report> reports = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        reports.add(Report.fromMap(documentSnapshot));
      }

      return reports;
    });
  }
}
