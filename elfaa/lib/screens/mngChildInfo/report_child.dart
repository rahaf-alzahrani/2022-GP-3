import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../report.dart';

Future<String> createReportToFirebase(
    String childrenId, String childImage, String childName) async {
  try {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final docChild = FirebaseFirestore.instance.collection('report').doc();
    User? user = _auth.currentUser;
    final parentChild = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('children')
        .doc(childrenId);

    Report report = Report(time: DateTime.now());
    report.parentID = user.uid;
    report.id = docChild.id;
    report.status = "ضائع";
    report.childrenId = childrenId;
    report.imageUrl = childImage;
    report.childName = childName;
    DateTime now = DateTime.now();
    report.date = "${now.day}/${now.month}/${now.year}";
    report.time = DateTime.now();
    report.lat = "24.770171";
    report.long = "46.643851";
    report.finderID = "";

    await docChild.set(report.toMap());

    final parent = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    await docChild.collection('progress').add({
      "action":
          "الوالد (برقم الجوال ${parent['phoneNo']}) أنشأ بلاغًاعن ضياع طفله",
      "time": Timestamp.now()
    });

    await FirebaseFirestore.instance.collection('notification').add({
      "message":
          "البلاغ #${DateFormat("yyyyMMDDhhmmss").format(report.time)} تم إنشاءه للتوّ",
      "newStatus": "ضائع",
      "time": Timestamp.now()
    });

    await parentChild.update({"status": true});
    return "Succes";
  } catch (e) {
    throw e;
  }
}
