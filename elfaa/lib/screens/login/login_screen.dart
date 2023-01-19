import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:elfaa/screens/signup/signup_screen.dart';
import 'package:elfaa/constants.dart';
import 'package:elfaa/screens/login/ForgotPasswordPage.dart';
import 'package:elfaa/auth_provider.dart';
import 'package:provider/provider.dart';
//import 'package:elfaa/screens/login/ForgotPasswordPage.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.type});
  final String type;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool SecuritySelected = false;
  bool ParentSelected = true;
  String type = "parent";
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool obscured = true;
  Icon icon = Icon(Icons.visibility, color: Colors.grey);
  FocusNode focus = FocusNode();
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
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
          "تسجيل الدخول",
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
                  20, MediaQuery.of(context).size.height * 0.05, 20, 0),
              child: Column(
                children: <Widget>[
                  logoWidget("assets/images/logo1.png"),
                  SizedBox(height: ScreenHeight * 0.03),
                  Container(
                      height: screenWidth * 0.1,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: screenWidth * 0.01),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(screenWidth),
                      ),
                      child: Row(children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            setState(() {
                              ParentSelected = false;
                              SecuritySelected = true;
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(screenWidth),
                                    bottomLeft: Radius.circular(screenWidth)),
                                color: SecuritySelected
                                    ? kPrimaryColor
                                    : Colors.white,
                              ),
                              child: Text('الأمن',
                                  style: TextStyle(
                                      color: SecuritySelected
                                          ? Colors.white
                                          : kdarkColor))),
                        )),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            setState(() {
                              ParentSelected = true;
                              SecuritySelected = false;
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(screenWidth),
                                    bottomRight: Radius.circular(screenWidth)),
                                color: ParentSelected
                                    ? kPrimaryColor
                                    : Colors.white,
                              ),
                              child: Text('الوالدين',
                                  style: TextStyle(
                                      color: ParentSelected
                                          ? Colors.white
                                          : kdarkColor))),
                        )),
                      ])),
                  SizedBox(height: ScreenHeight * 0.070),
                  ParentSelected
                      ? ParentLogin(
                          email: email,
                          ScreenHeight: ScreenHeight,
                          focus: focus,
                          pass: pass,
                          obscured: obscured,
                          icon: icon,
                          formKey: _formKey,
                          authProvider: authProvider)
                      : SecurityLogin(
                          email: email,
                          ScreenHeight: ScreenHeight,
                          focus: focus,
                          pass: pass,
                          obscured: obscured,
                          icon: icon,
                          formKey: _formKey,
                          authProvider: authProvider)
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
}

class ParentLogin extends StatelessWidget {
  const ParentLogin({
    Key? key,
    required this.email,
    required this.ScreenHeight,
    required this.focus,
    required this.pass,
    required this.obscured,
    required this.icon,
    required GlobalKey<FormState> formKey,
    required this.authProvider,
  })  : _formKey = formKey,
        super(key: key);

  final TextEditingController email;
  final double ScreenHeight;
  final FocusNode focus;
  final TextEditingController pass;
  final bool obscured;
  final Icon icon;
  final GlobalKey<FormState> _formKey;
  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.right,
                controller: email,
                decoration: const InputDecoration(
                  suffixIcon:
                      Icon(Icons.email_outlined, color: Color(0xFFFD8601)),
                  labelText: "البريد الإلكتروني",
                  hintText: "أدخل بريدك الإلكتروني",
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
                focusNode: focus,
                onTap: () {
                  FocusScope.of(context).requestFocus(focus);
                },
                controller: pass,
                obscureText: obscured,
                decoration: InputDecoration(
                  suffixIcon: focus.hasFocus
                      ? IconButton(
                          icon: icon,
                          onPressed: () {
                            // setState(() {
                            //   obscured = !obscured;
                            //   if (obscured == true) {
                            //     icon = Icon(Icons.visibility,
                            //         color: Colors.grey);
                            //   } else {
                            //     icon = Icon(Icons.visibility_off,
                            //         color: Colors.grey);
                            //   }
                            // });
                          },
                        )
                      : Icon(Icons.lock_outline, color: Color(0xFFFD8601)),
                  labelText: "كلمة المرور",
                  hintText: "أدخل كلمة المرور",
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                validator: (value) {
                  if (value!.isEmpty || pass.text.trim() == "") {
                    return "الحقل مطلوب";
                  }
                  return null;
                },
              )),
          SizedBox(height: ScreenHeight * 0.025),
          Align(
            alignment: Alignment(-0.9, 0),
            child: Container(
              child: GestureDetector(
                child: Text('نسيت كلمة المرور؟',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF818181),
                    )),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ForgotPasswordPage(),
                )),
              ),
            ),
          ),
          SizedBox(height: ScreenHeight * 0.025),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await authProvider.handleSignInEmail(
                    context, email.text, pass.text, "parent");
              }
            },
            child: Text("تسجيل الدخول", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: ScreenHeight * 0.025),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignupPage(type: "parent")));
                },
                child: Text(
                  "تسجيل جديد ",
                  style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF818181),
                      fontWeight: FontWeight.w800),
                ),
              ),
              Text("ليس لديك حساب؟",
                  style: TextStyle(fontSize: 17, color: Color(0xFF818181))),
            ],
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SecurityLogin extends StatelessWidget {
  SecurityLogin({
    Key? key,
    required this.email,
    required this.ScreenHeight,
    required this.focus,
    required this.pass,
    required this.obscured,
    required this.icon,
    required GlobalKey<FormState> formKey,
    required this.authProvider,
  })  : _formKey = formKey,
        super(key: key);

  final TextEditingController email;
  final double ScreenHeight;
  final FocusNode focus;
  final TextEditingController pass;
  final bool obscured;
  final Icon icon;
  final GlobalKey<FormState> _formKey;
  final AuthProvider authProvider;
  String type = "security";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.badge, color: Color(0xFFFD8601)),
                labelText: "نوع المستخدم",
              ),
              onChanged: (val) {
                type = val.toString();
              },
              value: type,
              items: const [
                DropdownMenuItem(
                  child: Text("حارس أمن"),
                  value: 'security',
                ),
                DropdownMenuItem(
                  child: Text("مشرف"),
                  value: "admin",
                )
              ],
              validator: (value) {
                if (value!.isEmpty || type.trim() == "") {
                  return "الحقل مطلوب";
                }
                return null;
              },
            ),
          ),
          SizedBox(height: ScreenHeight * 0.025),
          Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.right,
                controller: email,
                decoration: const InputDecoration(
                  suffixIcon:
                      Icon(Icons.email_outlined, color: Color(0xFFFD8601)),
                  labelText: "البريد الإلكتروني",
                  hintText: "أدخل بريدك الإلكتروني",
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
                focusNode: focus,
                onTap: () {
                  FocusScope.of(context).requestFocus(focus);
                },
                controller: pass,
                obscureText: obscured,
                decoration: InputDecoration(
                  suffixIcon: focus.hasFocus
                      ? IconButton(
                          icon: icon,
                          onPressed: () {
                            // setState(() {
                            //   obscured = !obscured;
                            //   if (obscured == true) {
                            //     icon = Icon(Icons.visibility,
                            //         color: Colors.grey);
                            //   } else {
                            //     icon = Icon(Icons.visibility_off,
                            //         color: Colors.grey);
                            //   }
                            // });
                          },
                        )
                      : Icon(Icons.lock_outline, color: Color(0xFFFD8601)),
                  labelText: "كلمة المرور",
                  hintText: "أدخل كلمة المرور",
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                validator: (value) {
                  if (value!.isEmpty || pass.text.trim() == "") {
                    return "الحقل مطلوب";
                  }
                  return null;
                },
              )),
          SizedBox(height: ScreenHeight * 0.025),
          Align(
            alignment: Alignment(-0.9, 0),
            child: Container(
              child: GestureDetector(
                child: Text('نسيت كلمة المرور؟',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF818181),
                    )),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ForgotPasswordPage(),
                )),
              ),
            ),
          ),
          SizedBox(height: ScreenHeight * 0.025),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await authProvider.handleSignInEmail(
                    context, email.text, pass.text, type);
              }
            },
            child: Text("تسجيل الدخول", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}