import 'package:elfaa/constants.dart';
import 'package:elfaa/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.type});
  final String type;
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController name = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obscured = true;
  Icon icon = Icon(Icons.visibility, color: Colors.grey);
  FocusNode focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    final double ScreenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFfafafa),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: kPrimaryColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        title: const Text(
          "تسجيل جديد",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: kPrimaryColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.04, 20, 0),
              child: Column(
                children: <Widget>[
                  logoWidget("assets/images/logo1.png"),
                  SizedBox(height: ScreenHeight * 0.060),
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        textAlign: TextAlign.right,
                        controller: name,
                        decoration: const InputDecoration(
                          suffixIcon:
                              Icon(Icons.person, color: Color(0xFFFD8601)),
                          labelText: "الاسم",
                          hintText: "مثال: نورة محمد",
                        ),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        validator: (value) {
                          if (value!.isEmpty || name.text.trim() == "") {
                            return "الحقل مطلوب";
                          } else if (value.length == 1) {
                            return " يجب أن يحتوي الاسم أكثر من حرف على الأقل";
                          } else if (!RegExp(
                                  r"^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+(?:\s[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+)?$")
                              .hasMatch(value)) {
                            return 'أدخل اسم يحتوي على أحرف فقط';
                          }
                          return null;
                        },
                      )),
                  SizedBox(height: ScreenHeight * 0.025),
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.right,
                        controller: email,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.email_outlined,
                                color: Color(0xFFFD8601)),
                            labelText: "البريد الإلكتروني",
                            hintText: "example@example.com"),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        validator: (value) {
                          if (value!.isEmpty || email.text.trim() == "") {
                            return "الحقل مطلوب";
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'أدخل بريد إلكتروني صالح';
                          }
                          return null;
                        },
                      )),
                  SizedBox(height: ScreenHeight * 0.025),
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        textAlign: TextAlign.right,
                        controller: phoneNo,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.phone_callback,
                              color: Color(0xFFFD8601)),
                          labelText: "رقم الجوال",
                          hintText: "05xxxxxxxx",
                        ),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        validator: (value) {
                          if (value!.isEmpty || phoneNo.text.trim() == "") {
                            return "الحقل مطلوب";
                          } else if (value.length != 10) {
                            return "الرقم ليس مكوّن من 10 خانات";
                          } else if (!value.startsWith('05', 0)) {
                            return "ادخل رقم جوال يبدأ ب05";
                          }
                          return null;
                        },
                      )),
                  SizedBox(height: ScreenHeight * 0.025),
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        focusNode: focus,
                        onTap: () {
                          FocusScope.of(context).requestFocus(focus);
                        },
                        obscureText: false,
                        controller: pass,
                        decoration: InputDecoration(
                            suffixIcon: focus.hasFocus
                                ? IconButton(
                                    icon: icon,
                                    onPressed: () {
                                      setState(() {
                                        obscured = !obscured;
                                        if (obscured == true) {
                                          icon = Icon(Icons.visibility,
                                              color: Colors.grey);
                                        } else {
                                          icon = Icon(Icons.visibility_off,
                                              color: Colors.grey);
                                        }
                                      });
                                    },
                                  )
                                : Icon(Icons.lock_outline,
                                    color: Color(0xFFFD8601)),
                            labelText: "كلمة المرور",
                            hintText: "أدخل كلمة المرور"),
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).unfocus(),
                        validator: (value) {
                          RegExp regex = RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])'); //Min 1 uppercase, 1 lowercase and 1 numeric number
                          if (value!.isEmpty || pass.text.trim() == "") {
                            return "الحقل مطلوب";
                          } else if (!regex.hasMatch(value)) {
                            return " أدخل كلمة مرور صالحة ضمن الشروط";
                          } else if (value.length < 8) {
                            return " أدخل كلمة مرور صالحة ضمن الشروط";
                          }
                          return null;
                        },
                      )),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        textDirection: TextDirection.rtl,
                        " كلمة المرور يجب أن تحتوي على الأقل:"
                        "\n"
                        "* 8 خانات"
                        "\n"
                        "* حرف كبير باللغة الإنجليزية"
                        "\n"
                        "* حرف صغير باللغة الإنجليزية"
                        "\n"
                        "* رقم ",
                        style: TextStyle(
                          color: Color(0xFF818181),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenHeight * 0.025),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          //if all fields are valid , create user
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email.text, password: pass.text);

                          final user = FirebaseAuth.instance.currentUser!.uid;
                          //add user details
                          addUserDetails(name.text.trim(), email.text.trim(),
                              phoneNo.text.trim(), user);
                          Fluttertoast.showToast(
                              msg: "تم تسجيل حسابك بنجاح",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.lightGreen,
                              fontSize: 16.0,
                              textColor: Colors.black);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SignInScreen(type: "parent");
                              },
                            ),
                          );
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: "البريد الإلكتروني مستخدم بالفعل",
                              toastLength: Toast.LENGTH_SHORT,
                              backgroundColor: Colors.red,
                              fontSize: 16.0,
                              textColor: Colors.black);
                        }
                      }
                    },
                    child: Text("تسجيل",
                        style: TextStyle(color: Colors.white, fontSize: 22)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget logoWidget(String imageName) {
    return Center(
        child: Image.asset(
      imageName,
      fit: BoxFit.fill,
      width: 150,
      height: 150,
    ));
  }

  Future addUserDetails(
      String firstname, String email, String phoneno, String id) async {
    await FirebaseFirestore.instance.collection('users').doc(id).set(({
          'name': firstname,
          'email': email,
          'phoneNo': phoneno,
          'type': 'parent',
          'userID': id,
          'type': "parent"
        }));
  }
}
