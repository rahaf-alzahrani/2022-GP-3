import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:elfaa/constants.dart';
import 'package:intl/intl.dart';

class ProgressReport extends StatelessWidget {
  final String reportID;
  const ProgressReport({Key? key, required this.reportID}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        elevation: 0,
        toolbarHeight: 90,
        title: Text(
          "تفاصيل تغيّرات حالة البلاغ",
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

            StreamBuilder<List<Map<String, dynamic>>>(
                stream: reportProgressStream(),
                builder: (context, snapshot) {

                  final progresses = snapshot.data ?? [];

                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: progresses.length,
                      itemBuilder: ((context, index) {
                        final progress = progresses[index];

                        final Timestamp timestamp = progress['time'] ?? Timestamp.now();

                        return Padding(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    progress['action'] ?? "",
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),

                                  SizedBox(
                                    height: height * 0.01,
                                  ),

                                  Text(
                                    DateFormat("dd-MM-yyyy hh:mm aa").format(timestamp.toDate()),
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                ],
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

  Stream<List<Map<String, dynamic>>> reportProgressStream() {
    return FirebaseFirestore.instance.collection("report")
        .doc(reportID).collection("progress")
        .orderBy('time', descending: true)
        .snapshots().map((querySnapshot) {

      List<Map<String, dynamic>> progresses = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final Map<String, dynamic> progress = {};

        progress['action'] = documentSnapshot['action'];
        progress['time'] = documentSnapshot['time'];
        progresses.add(progress);
      }

      return progresses;
    });
  }
}
