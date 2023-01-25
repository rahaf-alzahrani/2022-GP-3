import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../alert_dialog.dart';
import '../../../constants.dart';
import '../../Homepage/navPage.dart';

class EditSecurityGuard extends StatefulWidget {
  final String secName;
  final String phoneNo;
  final String secID;
  final String email;
  final String password;

  EditSecurityGuard(
      {required this.secName,
      required this.phoneNo,
      required this.password,
      required this.secID,
      required this.email});

  @override
  State<EditSecurityGuard> createState() => _EditSecurityGuardState();
}

class _EditSecurityGuardState extends State<EditSecurityGuard> {
  clear() {
    _secName.clear();
    _email.clear();
    _phoneNo.clear();
  }

  bool? changeStatus;

  final _formKey = GlobalKey<FormState>();
  bool tappedYes = false;

  TextEditingController _secName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phoneNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextEditingController _secName =
        TextEditingController.fromValue(TextEditingValue(text: widget.secName));
    TextEditingController _email =
        TextEditingController.fromValue(TextEditingValue(text: widget.email));
    TextEditingController _phoneNo =
        TextEditingController.fromValue(TextEditingValue(text: widget.phoneNo));
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
          widget.secName,
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
            child: Column(children: [
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
              const SizedBox(
                height: 20,
              ),
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
              const SizedBox(
                height: 20,
              ),
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
              const SizedBox(
                height: 50,
              ),
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
                    //
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    final action2 = await AlertDialogs.yesCancelDialog(
                        context,
                        'تعديل معلومات حارس الأمن ',
                        'هل أنت متأكد من حفظ التعديل؟');
                    if (!mounted) return;
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (action2 == DialogsAction.yes) {
                      setState(() => tappedYes = true);
                      try {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.secID)
                            .update({
                          'name': _secName.text,
                          'phoneNo': _phoneNo.text,
                          'email': _email.text
                        }).then((value) {
                          resetEmail(_email.text.toString()).then((value) {

                            Navigator.push(context, MaterialPageRoute(builder: (context){

                              return NavPage(code:1);
                            }));
                          });
                        });
                        if (!mounted) return;
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
            ]),
          ),
        ),
      ),
    );
    // drawer: const BusinessDrawer(),
  }
}
