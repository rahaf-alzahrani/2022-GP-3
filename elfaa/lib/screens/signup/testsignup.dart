import 'package:elfaa/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_auth/email_auth.dart';

class testSignup extends StatefulWidget {
  const testSignup({super.key});

  @override
  State<testSignup> createState() => _testSignupState();
}

class _testSignupState extends State<testSignup> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController name = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obscured = true;
  Icon icon = Icon(Icons.visibility, color: Colors.grey);
  FocusNode focus = FocusNode();
  int currentStep = 0;

  List<Step> getSteps() => [
        Step(
            isActive: currentStep >= 0,
            title: Text('الخطوة 1'),
            content: Container(
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                20,
                                MediaQuery.of(context).size.height * 0.01,
                                20,
                                0),
                            child: Column(
                              children: <Widget>[
                                logoWidget("assets/images/logo1.png"),
                                Text("!مرحبًا بك في تطبيق إلفاء",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 25)),
                                Text(
                                    " الرجاء إدخال بريدك الإلكتروني الصحيح حتى تتمكن من إكمال اجراءات تسجيل الدخول ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 129, 129, 129),
                                        fontSize: 17)),
                                const SizedBox(height: 50),
                                Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      controller: email,
                                      decoration: const InputDecoration(
                                        suffixIcon: Icon(Icons.email_outlined,
                                            color: Color(0xFFFD8601)),
                                        labelText: "البريد الإلكتروني",
                                        hintText: "أدخل بريدك الإلكتروني",
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            email.text.trim() == "") {
                                          return "الحقل مطلوب";
                                        } else if (!RegExp(
                                                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                            .hasMatch(value)) {
                                          return 'أدخل بريد إلكتروني صالح';
                                        }
                                      },
                                    )),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      sendOTP();
                                    }
                                  },
                                  child: Text(" إرسال رمز التحقق",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            )))))),
        Step(
          isActive: currentStep >= 1,
          title: Text("الخطوة 2"),
          content: Container(),
        ),
        Step(
          isActive: currentStep >= 2,
          title: Text(" الخطوة 3 "),
          content: Container(),
        ),
      ];

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
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor),
          ),
          centerTitle: true,
        ),
        body: Stepper(
          type: StepperType.horizontal,
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: () {
            final isLastStep = currentStep == getSteps().length - 1;
            if (isLastStep) {
              print("Completed");
            }
            setState(() => currentStep += 1);
          },
          onStepCancel:
              currentStep == 0 ? null : () => setState(() => currentStep -= 1),
        ));
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

  void sendOTP() async {
    var emailauth = EmailAuth(sessionName: "إلفاء");
    if (await emailauth.sendOtp(recipientMail: email.text, otpLength: 3)) {
      Fluttertoast.showToast(
          msg: "تم إرسال رمز التحقق",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 7,
          backgroundColor: Colors.lightGreen,
          fontSize: 16.0,
          textColor: Colors.white);
    } else {
      Fluttertoast.showToast(
          msg: "حدث خطأ ما",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 7,
          backgroundColor: Colors.red,
          fontSize: 16.0,
          textColor: Colors.white);
    }
  }

  Future addUserDetails(
      String firstname, String email, String phoneno, String id) async {
    await FirebaseFirestore.instance.collection('users').doc(id).set(({
          'name': firstname,
          'email': email,
          'phoneNo': phoneno,
          'userID': id,
        }));
  }
}
