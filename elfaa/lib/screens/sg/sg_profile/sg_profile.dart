import 'package:elfaa/constants.dart';
import 'package:elfaa/screens/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:elfaa/alert_dialog.dart';
import 'package:elfaa/screens/profile/changpass_page.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SGProfile extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<SGProfile> {
  bool tappedYes = false;
  bool editable = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  String selectvalue = 'value 1';

  Widget _buildName() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: TextFormField(
            readOnly: true,
            //  enabled: editable,
            textAlign: TextAlign.right,
            controller: name,
            decoration: InputDecoration(
                labelText: 'الاسم الكامل', hintText: 'الاسم', helperText: ""),
            validator: (String? value) {
              // if (value!.isEmpty) {
              //   return 'الحقل مطلوب';
              // } else if (value.length == 1) {
              //   return " يجب أن يحتوي الاسم أكثر من حرف على الأقل";
              // } else if (!RegExp(
              //         r"^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+(?:\s[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+)?$")
              //     .hasMatch(value)) {
              //   return 'أدخل اسم يحتوي على أحرف فقط';
              // }
              // return null;
            },
            onSaved: (String? value) {},
          ),
        ));
  }

  Widget _buildEmail() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: TextFormField(
            readOnly: true,
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.right,
            controller: email,
            decoration: InputDecoration(
                labelText: "البريد الإلكتروني",
                hintText: "البريد الإلكتروني",
                helperText: ""),
            validator: (String? value) {
              // if (value!.isEmpty) {
              //   return 'الحقل مطلوب';
              // }
              // if (!RegExp(
              //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              //     .hasMatch(value)) {
              //   return 'أدخل بريد إلكتروني صالح';
              // }
              // return null;
            },
            onSaved: (String? value) {},
          ),
        ));
  }

  Widget _buildPhoneNumber() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: TextFormField(
            readOnly: true,
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
              // if (value!.isEmpty) {
              //   return 'الحقل مطلوب';
              // } else if (value.length != 10) {
              //   return "الرقم ليس مكوّن من 10 خانات";
              // } else if (!value.startsWith('05', 0)) {
              //   return "ادخل رقم جوال يبدأ ب05";
              // }
              // return null;
            },
            onSaved: (String? value) {},
          ),
        ));
  }

  @override
  void initState() {
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

    return Scaffold(
      backgroundColor: Color(0xFFfafafa),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 90,
        title: Text(
          'حسابي الشخصي',
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenWidth * 0.02),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        // suffixIcon: Icon(Icons.escalator_warning,
                        //     color: Color(0xFFFD8601)),
                        labelText: "منطقة العمل",
                      ),
                      onChanged: (val) {
                        setState(() {
                          selectvalue = val.toString();
                        });
                      },
                      value: selectvalue,
                      items: const [
                        DropdownMenuItem(
                          child: Text("البوليفارد"),
                          value: "value 1",
                        ),
                        DropdownMenuItem(
                          child: Text("ونتر وندرلاند"),
                          value: "value 2",
                        )
                      ],
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: ScreenHeight * 0.05),
                ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF429EB2)),
                    ),
                    child: const Text('تغيير كلمة المرور')),
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
