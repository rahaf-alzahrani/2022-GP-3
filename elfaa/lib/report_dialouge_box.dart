import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elfaa/screens/Homepage/childrenList.dart';
import 'package:elfaa/screens/Homepage/navPage.dart';
import 'package:elfaa/screens/mngChildInfo/report_child.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'alert_dialog.dart';

class ChildrenDialog extends StatefulWidget {
  final title;
  const ChildrenDialog({super.key, this.title});

  @override
  State<ChildrenDialog> createState() => _ChildrenDialogState();
}

class _ChildrenDialogState extends State<ChildrenDialog> {
  List<childrenList> _childrenList = [];
  List<childrenList> selectedChildren = [];
  bool tappedYes = false;

  Future<void> getChildrenList() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = await _auth.currentUser;
    if (!mounted) return;
    final userid = user!.uid;

    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .collection('children')
        .orderBy('birthday', descending: true)
        .get();
    

    final list = [];

    for(QueryDocumentSnapshot snapshot in data.docs){
      final condition = await doesChildHaveOpenReport(snapshot.id);
      if(!condition) {
        list.add(childrenList.fromSnapshot(snapshot));
      }
    }

    if (!mounted) return;
    setState(() {
      if (!mounted) return;
      _childrenList =
          List.from(list);
    });
  }

  Future<bool> doesChildHaveOpenReport(String childID) async {
    final doesChildHaveOpenReport = await FirebaseFirestore.instance
        .collection('report')
        .where('childrenId', isEqualTo: childID)
        .where('status', isEqualTo: "Lost")
        .get();

    return doesChildHaveOpenReport.docs.isNotEmpty;
  }
  
  @override
  void initState() {
    getChildrenList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: _childrenList.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: 400,
              width: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "اختر طفلًا للإبلاغ عن ضياعه",
                      style: TextStyle(
                        color: Color.fromARGB(255, 41, 41, 32),
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 250,
                        child: ListView.builder(
                            itemCount: _childrenList.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    value: selectedChildren
                                            .contains(_childrenList[index])
                                        ? true
                                        : false,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (selectedChildren
                                            .contains(_childrenList[index])) {
                                          selectedChildren
                                              .remove(_childrenList[index]);
                                        } else {
                                          selectedChildren
                                              .add(_childrenList[index]);
                                        }
                                      });
                                    },
                                  ),
                                  Spacer(),
                                  Text(
                                    _childrenList[index].childName!,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 41, 41, 32),
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                          icon: Icon(
                            Icons.campaign,
                            color: selectedChildren.isEmpty ? Colors.grey.shade700 : Color(0xFF9C0000),
                          ),
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 22),
                            shadowColor: Color.fromARGB(255, 0, 0, 0),
                            elevation: 0,
                            backgroundColor: selectedChildren.isEmpty ? Colors.grey.shade200 : Color(0xFFFFEEEE),
                            shape: const StadiumBorder(),
                            maximumSize: const Size(180, 48),
                            minimumSize: const Size(180, 48),
                          ),
                          label: Text(
                            ' إنشاء بلاغ   ',
                            style: TextStyle(
                                color: selectedChildren.isEmpty
                                    ? Colors.grey.shade700 : Color(0xFF9C0000),
                                fontSize: 20),
                          ),
                          onPressed: () async {
                            if(selectedChildren.isNotEmpty) {
                              final action = await AlertDialogs.yesCancelDialog(
                                  context,
                                  'إنشاء البلاغ',
                                  'هل أنت متأكد من إنشاء البلاغ؟');
                              if (!mounted) return;
                              if (action == DialogsAction.yes) {
                                if (!mounted) return;
                                for (var i = 0;
                                i < selectedChildren.length;
                                i++) {
                                  createReportToFirebase(
                                      selectedChildren[i].childID!,
                                      selectedChildren[i].childImagePath!,
                                      selectedChildren[i].childName!);
                                }
                                Fluttertoast.showToast(
                                    msg: "تم الإبلاغ بنجاح",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                    Color.fromARGB(255, 48, 109, 50),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            NavPage(
                                              code: 0,
                                            ))));
                                Navigator.pop(context);
                              } else {
                                Navigator.pop(context);
                              }
                            }
                          }),
                    ),



                  ],
                ),
              ),
            ),
    );
  }
}
