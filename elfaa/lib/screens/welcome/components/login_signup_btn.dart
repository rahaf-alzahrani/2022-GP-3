import 'package:flutter/material.dart';
import '../../../screens/Login/login_screen.dart';
import '../../../screens/signup/signup_screen.dart';
import '../../../../constants.dart';
// ignore: must_be_immutable
class LoginAndSignupBtn extends StatelessWidget {
  LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  final tutorEmail = TextEditingController();
  final tutorPassword = TextEditingController();
  String tutorErrorTextEmail = '';
  bool tutorEmailValid = false;
  String tutorErrorTextPassword = '';
  bool tutorPasswordValid = false;
  bool tutorAllFieldsValid = false;

  final studentEmail = TextEditingController();
  final studentPassword = TextEditingController();
  String studentErrorTextEmail = '';
  bool studentEmailValid = false;
  String studentErrorTextPassword = '';
  bool studentPasswordValid = false;
  bool studentAllFieldsValid = false;

  final adminEmail = TextEditingController();
  final adminPassword = TextEditingController();
  String adminErrorTextEmail = '';
  bool adminEmailValid = false;
  String adminErrorTextPassword = '';
  bool adminPasswordValid = false;
  bool adminAllFieldsValid = false;

  bool tutorSelected = true;
  bool studentSelected = false;
  bool adminSelected = false;
  bool showTutorPassword = false;
  bool showStudentPassword = false;
  bool showAdminPassword = false;

  void dispose() {
    tutorEmail.dispose();
    tutorPassword.dispose();
    studentEmail.dispose();
    studentPassword.dispose();
    adminEmail.dispose();
    adminPassword.dispose();
    //super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: "login_btn",
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignInScreen(type: "parent");
                  },
                ),
              );
            },
            child: Text(
              "تسجيل الدخول",
              style: TextStyle(fontSize: 22),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SignupPage(type: "parent");
                },
              ),
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: kLightColor, elevation: 1),
          child: Text(
            "إنشاء حساب للوالدين",
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}