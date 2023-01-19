import 'package:elfaa/screens/Homepage/HomelistBox.dart';
import 'package:elfaa/screens/Homepage/childrenList.dart';
import 'package:elfaa/screens/notificationPage/NotlistBox.dart';
import 'package:elfaa/screens/notificationPage/noteList.dart';
import 'package:flutter/material.dart';
import 'package:elfaa/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final DateTime now = DateTime.now();
final DateFormat formatter = DateFormat('yyyy-MM-dd');
final String formatted = formatter.format(now);
List<Object> _childrenList = [];
List<Object> _notList = [];

class NotePage extends StatefulWidget {
  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String userid = "";

  void dispose() {
    super.dispose();
  }

  int index = 1;

  //const NotePage({super.key});
  final Color color1 = Color(0xFF429EB2);

  final Color color2 = Color(0xFF429EB2);

  final Color color3 = Color(0xFF429EB2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 90,
        title: Text(
          "التنبيهات",
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
      body: SizedBox(
          child: _childrenList.length == 0
              ? Padding(
                  padding: const EdgeInsets.all(25),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/noNotifications.png"),
                      ),
                    ),
                  ),
                )
              : list()),
    );
  }

  Widget list() {
    return ListView.builder(
        itemCount: _childrenList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          //if (index == 0)
          //return Null;
          // else
          return NotlistBox(_childrenList[index] as childrenList, _notList);
        });
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    getChildrenList();
    getChildrenList2();
  }

  void initState() {
    super.initState();
  }

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
    if (!mounted) return;

    setState(() {
      if (!mounted) return;

      _childrenList =
          List.from(data.docs.map((doc) => childrenList.fromSnapshot(doc)));
    });
  }

  Future<void> getChildrenList2() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = await _auth.currentUser;
    if (!mounted) return;
    final userid = user!.uid;

    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .collection('notificationForChild')
        .get();

    if (!mounted) return;
    setState(() {
      if (!mounted) return;
      // if (data.docs.length != 0) {
      _notList = List.from(data.docs.map((doc) => noteList.fromSnapshot(doc)));
      // }
    });
  }
}
