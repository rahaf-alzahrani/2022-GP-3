// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:elfaa/alert_dialog.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:elfaa/constants.dart';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
class DummyTesting extends StatefulWidget {
  String childImagePath = "";
  String childName = "";

  DummyTesting({
    required this.childName,
    required this.childImagePath,
  });

  @override
  State<DummyTesting> createState() => _DummyTestingState();
}

class _DummyTestingState extends State<DummyTesting> {
  bool tappedYes = false;

  bool editable = false;

  int zoneName = 0;

  Future<void> getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = await _auth.currentUser;
    if (!mounted) return;
    final uid = user!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {});
    if (!mounted) return;
  }

  PickedFile? _imgFile;

  final ImagePicker _picker = ImagePicker();

//information form controllers
  final now = DateTime.now();

  final df = new DateFormat('dd-MM-yyyy hh:mm a');

  int myvalue = 1558432747;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey<ScaffoldState>();
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: height * 0.54,
                  width: width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                          image: AssetImage("assets/images/oneChild.jpg"),
                          fit: BoxFit.cover)),
                ),
                Positioned(
                  top: height * 0.402,
                  child: BlurryContainer(
                    padding: EdgeInsets.all(20),
                    // color: Colors.black,
                    height: height * 2,
                    width: width,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(25)),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Container(
                                height: height * 0.05,
                                width: height * 0.17,
                                child: Center(
                                    child: Text(
                                  "..." "جاري البحث",
                                  style: TextStyle(
                                      color: Color(0xff919296),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        right: width * 0.03,
                                        left: 0.1,
                                        top: width * 0.06,
                                        bottom: 0.01),
                                    child: Text(
                                      widget.childName,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 41, 41, 32),
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.black,
                                    padding: EdgeInsets.all(5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: networkImg(
                                          widget.childImagePath, width, height),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ":" "وقت وتاريخ البلاغ",
                    style: TextStyle(
                      color: Color(0xff292929),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    df.format(new DateTime.fromMillisecondsSinceEpoch(
                        myvalue * 1000)),
                    style: TextStyle(
                      color: Color(0xff919296),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    ":" "رقم التواصل مع مسؤول حارس الأمن",
                    style: TextStyle(
                      color: Color(0xff292929),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "0584736352",
                    style: TextStyle(
                      color: Color(0xff919296),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color(0xFFFFEEEE), // background
                            // foreground
                          ),
                          child: Text(
                            'إلغاء البلاغ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF9C0000),
                            ),
                          ),
                          onPressed: () async {
                            final action = await AlertDialogs.yesCancelDialog(
                                context,
                                'إلغاء البلاغ',
                                'هل أنت متأكد من إلغاء البلاغ؟');
                            if (!mounted) return;
                            if (action == DialogsAction.yes) {
                              setState(() => tappedYes = true);
                              if (!mounted) return;

                              Navigator.pop(context);
                            } else {
                              setState(() => tappedYes = false);
                              if (!mounted) return;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

networkImg(String childImage, double ScreenWidth, double ScreenHeight) {
  try {
    return Image.network(
      childImage,
      width: ScreenWidth * 0.2,
      height: ScreenHeight * 0.09,
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
