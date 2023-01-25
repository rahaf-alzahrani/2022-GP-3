import 'package:elfaa/constants.dart';
import 'package:elfaa/screens/Homepage/Home_page.dart';
import 'package:elfaa/screens/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:elfaa/alert_dialog.dart';
import 'package:elfaa/screens/profile/changpass_page.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

bool isSwitched = false;

class AdminProfile extends StatefulWidget {
  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  String? _name;
  String? _email;
  String? _phoneNumber;
  bool tappedYes = false;
  bool editable = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNo = TextEditingController();

  Future<void> getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (!mounted) return;


    /// PAste here admin uid if you create newOne,
    final uid = "kO6Sz0aT2JWvBxMGRivDxUSofFR2";

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (!mounted) return;
      name.text = snapshot['name'];
      email.text = snapshot['email'];
      phoneNo.text = snapshot['phoneNo'].toString();

    print(name);
    });
  }

  Widget _buildName() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: TextFormField(
            //  enabled: editable,
            textAlign: TextAlign.right,
            controller: name,
            decoration: InputDecoration(
                labelText: 'الاسم', hintText: 'أدخل الاسم', helperText: ""),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'الحقل مطلوب';
              } else if (value.length == 1) {
                return " يجب أن يحتوي الاسم أكثر من حرف على الأقل";
              } else if (!RegExp(
                      r"^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+(?:\s[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+)?$")
                  .hasMatch(value)) {
                return 'أدخل اسم يحتوي على أحرف فقط';
              }
              return null;
            },
            onSaved: (String? value) {
              _name = value;
            },
          ),
        ));
  }

  Widget _buildEmail() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.right,
            controller: email,
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
            onSaved: (String? value) {
              _email = value!;
            },
          ),
        ));
  }

  Widget _buildPhoneNumber() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: TextFormField(
            textAlign: TextAlign.right,
            controller: phoneNo,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
                labelText: 'رقم الجوال',
                hintText: '05xxxxxxxx',
                helperText: ""),
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
            onSaved: (String? value) {
              _phoneNumber = value!;
            },
          ),
        ));
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phoneNo.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final double ScreenHeight = MediaQuery.of(context).size.height;
    final double ScreenWidth = MediaQuery.of(context).size.width;
    //isSwitched = false;
    return Scaffold(
      backgroundColor: Color(0xFFfafafa),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 90,
        title: Text(
          "حسابي الشخصي",
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
        child: Container(
          margin: EdgeInsets.fromLTRB(24, 24, 24, 100),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: ScreenHeight * 0.030),
                _buildName(),
                _buildEmail(),
                _buildPhoneNumber(),
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
                      style: TextStyle(color: kPrimaryColor, fontSize: 20),
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      final action2 = await AlertDialogs.yesCancelDialog(
                          context,
                          'تعديل معلومات الحساب الشخصي',
                          'هل أنت متأكد من حفظ التعديل؟');
                      if (!mounted) return;
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (action2 == DialogsAction.yes) {
                        setState(() => tappedYes = true);
                        if (!mounted) return;
                        final FirebaseAuth _auth = await FirebaseAuth.instance;
                        if (!mounted) return;
                        final User? user = await _auth.currentUser;
                        if (!mounted) return;
                        final uid = user!.uid;
                        try {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .update({
                            'name': name.text,
                            'email': email.text,
                            'phoneNo': phoneNo.text,
                          });
                          if (!mounted) return;
                          await user.updateEmail(email.text);
                          if (!mounted) return;
                          Fluttertoast.showToast(
                              msg: "تم تعديل البيانات بنجاح",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.lightGreen,
                              textColor: Colors.black,
                              fontSize: 16.0);
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: "حدث خطأ ما",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.black,
                              fontSize: 16.0);
                        }
                        _formKey.currentState!.save();
                      }
                    },
                  ),
                ),
                SizedBox(height: ScreenHeight * 0.025),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.lock_reset,
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
                      'تغيير كلمة المرور',
                      style: TextStyle(color: kPrimaryColor, fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return changePasswordPage();
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: ScreenHeight * 0.09),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            print(isSwitched);
                          });
                        },
                        splashRadius: 50.0,
                        activeTrackColor: Color.fromARGB(255, 132, 198, 190),
                        activeColor: color1,
                      ),
                      Text(
                        "خاصية إشعار المسافة",
                        style: TextStyle(color: kPrimaryColor, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenHeight * 0.09),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.logout,
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
                      '  تسجيل الخروج    ',
                      style: TextStyle(color: Color(0xFF9C0000), fontSize: 20),
                    ),
                    onPressed: () async {
                      final action = await AlertDialogs.yesCancelDialog(context,
                          'تسجيل الخروج', 'هل أنت متأكد من تسجيل الخروج؟');
                      if (!mounted) return;
                      if (action == DialogsAction.yes) {
                        setState(() => tappedYes = true);
                        if (!mounted) return;
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomeScreen()));
                      } else {
                        setState(() => tappedYes = false);
                        if (!mounted) return;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
