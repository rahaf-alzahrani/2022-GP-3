import 'dart:async';

import 'package:elfaa/screens/admin/widget/edit_security.dart';
import 'package:flutter/material.dart';
import 'package:elfaa/constants.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elfaa/alert_dialog.dart';
import 'package:elfaa/screens/Homepage/navPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../zones.dart';
import 'admin_home/admin_home_page.dart';

class viewSec extends StatefulWidget {
  const viewSec(
      {super.key,
      required this.secName,
      required this.phoneNo,
      required this.password,
      required this.secID,
      required this.email});

  final String secName;
  final String phoneNo;
  final String secID;
  final String email;
  final String password;

  @override
  State<viewSec> createState() => _viewSecState();
}

class _viewSecState extends State<viewSec> {
  late zones zoneList;

  Future<void> addZones() async {
    zoneList = zones();
    zoneList.LoadData();
  }

  @override
  void initState() {
    // _secName.text = widget.secName;
    // _email.text = widget.email;
    // _phoneNo.text = widget.phoneNo;
    // _secID.text = widget.secID;
    super.initState();
  }

//Loading for uploading
  bool isLoading = false;
  bool isProcessing = false;

//globalKey
  final _formKey = GlobalKey<FormState>();

  //alert dialuge
  bool tappedYes = false;

  //get parent  ID
  String uid = '';

  Future<void> getParent() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = await _auth.currentUser;

    setState(() {
      uid = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {


    TextEditingController _secName =
    TextEditingController.fromValue(
        TextEditingValue(text: widget.secName));
    TextEditingController _email = TextEditingController.fromValue(
        TextEditingValue(text: widget.email));
    TextEditingController _phoneNo =
    TextEditingController.fromValue(
        TextEditingValue(text: widget.phoneNo));
    final String secName = widget.secName;
    //Responsiviness variables
    final double ScreenHeight = MediaQuery.of(context).size.height;

    //Resetting email
    Future resetEmail(String newEmail) async {
      var firebaseUser = await FirebaseAuth.instance.currentUser;
      var newUSer = FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.email, password: widget.password);
      var message;

      if (firebaseUser != newUSer) {
        firebaseUser!
            .updateEmail(newEmail)
            .then(
              (value) => message = 'Success',
        )
            .catchError((onError) => message = 'error');
        return message;
      }
    }

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
          secName,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        flexibleSpace: Container(
            decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28)),
          color: kPrimaryColor,
        )),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.04, 20, 0),
            child: Column(
              children: <Widget>[
                SizedBox(height: ScreenHeight * 0.030),

                ////Namee
              Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: TextFormField(
                       enabled: true,
                      textAlign: TextAlign.right,
                      controller: _secName,
                      decoration: InputDecoration(
                          labelText: 'الاسم', hintText: 'أدخل الاسم', helperText: ""),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'الحقل مطلوب';
                        } else if (value.length == 1) {
                          return " يجب أن يحتوي الاسم أكثر من حرف على الأقل";
                        } else if (RegExp(r"/^[a-zA-Z\s]*$/").hasMatch(value)) {
                          return 'أدخل اسم يحتوي على أحرف فقط';
                        } else if (_secName.text.split(' ').length < 3) {
                          return 'يجب ادخال الاسم الثلاثي';
                        }
                        return null;
                      },
                      // onSaved: (String? value) {
                      //   _name = value;
                      // },
                    ),
                  )),
                // /eemail
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: TextFormField(
                        enabled: true,
                        textAlign: TextAlign.right,
                        controller: _phoneNo,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            labelText: 'رقم الجوال', hintText: '05xxxxxxxx', helperText: ""),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'الحقل مطلوب';
                          } else if (value.length != 10) {
                            return "الرقم ليس مكوّن من 10 خانات";
                          } else if (!value.startsWith('05', 0)) {
                            return "ادخل رقم جوال يبدأ ب05";
                          }
                          return null;
                        },
                        // onSaved: (String? value) {
                        //   _phoneNumber = value!;
                        // },
                      ),
                    )),
                // phone lumberrr.

              Directionality(
                  textDirection: TextDirection.rtl,

                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: TextFormField(
                      enabled: true,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.right,
                      controller: _email,
                      decoration: InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          hintText: 'أدخل بريدك الإلكتروني',
                          helperText: ""),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'الحقل مطلوب';
                        }
                        if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'أدخل بريد إلكتروني صالح';
                        }
                        return null;
                      },
                      // onSaved: (String? value) {
                      //   _email = value!;
                      // },
                    ),
                  )),




                Directionality(
                  textDirection: TextDirection.rtl,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.edit,
                      color: kPrimaryColor,
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Color(0xFFf5f5f5)),
                      maximumSize: MaterialStateProperty.all(Size(180, 56)),
                      minimumSize: MaterialStateProperty.all(Size(180, 56)),
                      side: MaterialStateProperty.all(
                        BorderSide.lerp(
                            BorderSide(
                              style: BorderStyle.solid,
                              color: kPrimaryColor,
                              width: 1.0,
                            ),
                            BorderSide(
                              style: BorderStyle.solid,
                              color: kPrimaryColor,
                              width: 1.0,
                            ),
                            1.0),
                      ),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered))
                            return Color(0xFFBED7DC);
                          return Color(0xFFBED7DC);
                        },
                      ),
                    ),
                    label: Text(
                      ' حفظ التعديلات   ',
                      style: TextStyle(color: kPrimaryColor, fontSize: 17),
                    ),
                    onPressed: () async {

                      Navigator.push(context, MaterialPageRoute(builder: (context){
                         return  EditSecurityGuard(


                           password: "${widget.password}",
                           secID: "${widget.secID}",
                           phoneNo: "${widget.phoneNo}",
                           secName: "${widget.secName}",
                           email: "${widget.email}",
                         );
                      }));
                    },
                  ),
                ),
                SizedBox(height: ScreenHeight * 0.02),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.delete,
                      color: Color(0xFF9C0000),
                    ),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 22),
                      shadowColor: Color.fromARGB(255, 0, 0, 0),
                      elevation: 0,
                      backgroundColor: Color(0xFFFFEEEE),
                      shape: const StadiumBorder(),
                      maximumSize: const Size(180, 56),
                      minimumSize: const Size(180, 56),
                    ),
                    label: Text(
                      '  حذف حارس الأمن  ',
                      style: TextStyle(color: Color(0xFF9C0000), fontSize: 17),
                    ),
                    onPressed: () async {
                      final action = await AlertDialogs.yesCancelDialog(context,
                          'حذف حارس الأمن', 'هل أنت متأكد من حذف حارس الأمن؟');
                      if (!mounted) return;
                      if (action == DialogsAction.yes) {
                        setState(() => tappedYes = true);
                        if (!mounted) return;
                        //delete child here

 /// PAste here admin uid if you create newOne,
                        var adminId = "kO6Sz0aT2JWvBxMGRivDxUSofFR2";

                        FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: widget.email, password: widget.password);
                        var clientId = FirebaseAuth.instance.currentUser;
                        if (adminId != clientId?.uid) {
                      clientId
                              ?.delete()
                              .then((value) {
                        FirebaseFirestore.instance
                            .collection('users').doc(widget.secID.toString()).delete().then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NavPage(code:1)));
                            });
                          });
                        }

                        Fluttertoast.showToast(
                            msg: "تم حذف حارس الأمن ",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.black,
                            fontSize: 11.0);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminHomePage()),
                        );
                      } else {
                        setState(() => tappedYes = false);
                        if (!mounted) return;
                      }
                    },
                  ),
                ),
                SizedBox(height: ScreenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

