import 'package:elfaa/screens/admin/AdminHomeListBox.dart';
import 'package:elfaa/screens/admin/admin_home/add_SG_page.dart';
import 'package:elfaa/screens/admin/SecurityList.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elfaa/constants.dart';

int index = 2;
final Color color1 = kPrimaryColor;
final Color color2 = kPrimaryColor;
final Color color3 = kPrimaryColor;
String username = "";
List<Object> _secList = [];

class AdminHomePage extends StatefulWidget {
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  //const HomePage({super.key});
  final uid ="ZwXgzHC5u9e8iHDYoKOU19Iaag62";

  Future<void> getCurrentUserr() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (!mounted) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      username = snapshot['name'];

    });
    if (!mounted) return;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getCurrentUserr();
     getSecList();
    super.initState();
  }

  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: <
            Widget>[
          _buildHeader(),

          // _secList.length == 0
          //     ? Padding(
          //         padding:
          //             const EdgeInsets.only(left: 25.0, right: 25, bottom: 10),
          //         child: Container(
          //           height: height * 0.2,
          //           decoration: BoxDecoration(
          //               boxShadow: [
          //                 BoxShadow(
          //                     color: Color(0xff484848).withOpacity(.3),
          //                     offset: Offset(0, 4),
          //                     blurRadius: 8)
          //               ],
          //               borderRadius: BorderRadius.circular(30),
          //               image: DecorationImage(
          //                   image: AssetImage("assets/images/empty.jpeg"),
          //                   fit: BoxFit.cover)),
          //         ),
          //       )
          //     : _secList.length == 1
          //         ? Padding(
          //             padding: const EdgeInsets.only(
          //                 left: 25.0, right: 25, bottom: 10),
          //             child: Container(
          //               height: height * 0.2,
          //               width: MediaQuery.of(context).size.width,
          //               decoration: BoxDecoration(
          //                   boxShadow: [
          //                     BoxShadow(
          //                         color: Color(0xff484848).withOpacity(.3),
          //                         offset: Offset(0, 4),
          //                         blurRadius: 8)
          //                   ],
          //                   borderRadius: BorderRadius.circular(30),
          //                   image: DecorationImage(
          //                       image: AssetImage("assets/images/oneChild.jpg"),
          //                       fit: BoxFit.cover)),
          //             ),
          //           )
          //         : Padding(
          //             padding: const EdgeInsets.only(
          //                 left: 25.0, right: 25, bottom: 10),
          //             child: Container(
          //               height: height * 0.2,
          //               width: MediaQuery.of(context).size.width,
          //               decoration: BoxDecoration(
          //                   boxShadow: [
          //                     BoxShadow(
          //                         color: Color(0xff484848).withOpacity(.3),
          //                         offset: Offset(0, 4),
          //                         blurRadius: 8)
          //                   ],
          //                   borderRadius: BorderRadius.circular(30),
          //                   image: DecorationImage(
          //                       image: AssetImage("assets/images/MainMap.jpg"),
          //                       fit: BoxFit.cover)),
          //             ),
          //           ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Container(
                    height: height * 0.06,
                    decoration: BoxDecoration(
                        color: kOrangeColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: kOrangeColor.withOpacity(.2),
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
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25.0, top: 5),
                child: Text(
                  "حراس الأمن",
                  style: TextStyle(
                      color: kdarkColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          _secList.length == 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 30),
                  child: Container(
                    height: height * 0.35,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/noChildren.png"),
                            fit: BoxFit.cover)),
                  ),
                )
              : RefreshIndicator(onRefresh: refresh, child: _buildList()),
        ]),
      ),
    );
  }

  Future refresh() async {
    setState(() {
      _buildList();
    });
  }

  Container _buildList() {
    final GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey<ScaffoldState>();
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.7,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 0.1),
            child: SizedBox(child: list()),
          )
        ],
      ),
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
              "المشرف " + username,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          //margin: const EdgeInsets.only(top: 40, left: 250),
        ],
      ),
    );
  }

  Widget list() => ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _secList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return AdminHomeListBox(_secList[index] as SecurityList);
      });
  //void initState() {
  // getCurrentUser();

  // final user = FirebaseAuth.instance.currentUser!.uid;
  // final userRef = FirebaseFirestore.instance
  //   .collection('parent')
  //   .doc(user)
  //   .collection('children')
  //  .doc();
  // _buildHeader();
  //   super.initState();
  // }

  Future<void> getSecList() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = await _auth.currentUser;
    if (!mounted) return;
    final userid = user!.uid;

    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('type', isEqualTo: 'security')
        .get();
    if (!mounted) return;
    setState(() {
      if (!mounted) return;
      _secList =
          List.from(data.docs.map((doc) => SecurityList.fromSnapshot(doc)));
    });
  }

  void dispose() {
    super.dispose();
  }
}


//class ListPageState extends State<ListPage> {}