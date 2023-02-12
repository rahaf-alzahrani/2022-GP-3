import 'package:elfaa/constants.dart';
import 'package:flutter/material.dart';
import 'package:elfaa/custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:elfaa/screens/Homepage/navPage.dart';

class AddSecurityGuard extends StatefulWidget {
  const AddSecurityGuard({super.key});

  @override
  State<AddSecurityGuard> createState() => _AddSecurityGuardState();
}

class _AddSecurityGuardState extends State<AddSecurityGuard> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController name = TextEditingController();
  String userID = "";
  final _formKey = GlobalKey<FormState>();
  bool obscured = true;
  Icon icon = Icon(Icons.visibility, color: Colors.grey);
  FocusNode focus = FocusNode();

  @override
  void dispose() {
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double ScreenHeight = MediaQuery.of(context).size.height;
    final double ScreenWidth = MediaQuery.of(context).size.width;
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
        title: const Text(
          "إضافة حارس أمن جديد",
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
                SizedBox(
                  height: 0.04 * ScreenHeight,
                ),
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      textAlign: TextAlign.right,
                      controller: name,
                      decoration: const InputDecoration(
                        suffixIcon:
                            Icon(Icons.person, color: Color(0xFFFD8601)),
                        labelText: "الاسم الثلاثي",
                        hintText: "مثال: احمد خالد الصالح",
                      ),
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      validator: (value) {
                        if (value!.isEmpty || name.text.trim() == "") {
                          return "الحقل مطلوب";
                        } else if (value.length == 1) {
                          return " يجب أن يحتوي الاسم أكثر من حرف على الأقل";
                        } else if (RegExp(r"/^[a-zA-Z\s]*$/").hasMatch(value)) {
                          return 'أدخل اسم يحتوي على أحرف فقط';
                        } else if (name.text.split(' ').length < 3) {
                          return 'يجب ادخال الاسم الثلاثي';
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
                  child: Row(
                    children: [
                      buildButtonWidget(),
                      SizedBox(
                        width: ScreenWidth * 0.68,
                        child: TextFormField(
                            obscureText: true,
                            readOnly: true,
                            onTap: () {
                              FocusScope.of(context).requestFocus(focus);
                            },
                            controller: pass,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 181, 181, 181),
                                  ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(22),
                                      bottomLeft: Radius.circular(22)),
                                ),
                                suffixIcon: Icon(Icons.lock,
                            color: Color(0xFFFD8601)),
                                labelText: "كلمة المرور",
                                hintText: "أنشئ كلمة مرور عشوائية"),
                            validator: (value) {
                              if (value!.isEmpty || pass.text.trim() == "") {
                                return "الحقل مطلوب";
                              }
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenHeight * 0.025),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        //if all fields are valid , create user
                        var res = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email.text, password: pass.text);
                        setState(() {
                          userID = res.user!.uid;
                        });
                        print("User ID  ::: $userID");
                        //add user details
                        addUserDetails(name.text.trim(), email.text.trim(),
                            phoneNo.text.trim(), userID);
                        sendEmail(email.text.trim(), pass.text.toString());
                        Fluttertoast.showToast(
                            msg: "تم إضافة حارس الأمن بنجاح",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.lightGreen,
                            fontSize: 16.0,
                            textColor: Colors.black);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavPage(
                              code: 1,
                            ),
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
    );
  }

  Future addUserDetails(
    String firstname,
    String email,
    String phoneno,
    String userID,
  ) async {
    await FirebaseFirestore.instance.collection('users').doc(userID).set(({
          'name': firstname,
          'email': email,
          'phoneNo': phoneno,
          'userID': userID,
          'password': pass.text.toString(),
          'type': 'security'
        }));
  }

  Widget buildButtonWidget() {
    return SizedBox(
      width: 85,
      height: 50,
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(18),
                          bottomRight: Radius.circular(18))))),
          onPressed: () {
             final password = generatePassword();
             pass.text = password;
          },
          child: Text("إنشاء",
              style: TextStyle(color: Colors.white, fontSize: 15))),
    );
  }

  sendEmail(String sendEmailTo, String pass) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("passMail").add(
      {
        'from': 'best.graduation.project@gmail.com',
        'to': "$sendEmailTo",
        'message': {
          'subject': "Elfaa Security Password",
          'text': "Your Password is: $pass",
// 'html': "This is the <code>HTML</code> section of the email body.",
        },
      },
    ).then(
      (value) {
        print("Queued email for delivery!");
      },
    );
    print('Email done');
  }
}
