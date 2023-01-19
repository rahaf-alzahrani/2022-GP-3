import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:elfaa/screens/Homepage/navPage.dart';

class AuthProvider extends ChangeNotifier {
 
   final FirebaseAuth auth = FirebaseAuth.instance;
   bool isLoading = false;
   final FirebaseFirestore db = FirebaseFirestore.instance;
  Future<User?> handleSignInEmail(context, email, password, String type) async {
    try {
      isLoading = true;
      notifyListeners();
      UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User user = result.user!;

      Map<String, dynamic> userData =
          await doesNameAlreadyExist(user.uid, "users");
          
      if (userData["type"] == type) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('type', type);
        await prefs.setString('user', email);
        if (type == "parent") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => NavPage(
                  code: 0,
                ),
              ),
              (Route<dynamic> route) => false);
        } else if (type == "admin") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => NavPage(
                  code: 1,
                ),
              ),
              (Route<dynamic> route) => false);
        }else if (type == "security") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => NavPage(
                  code: 2,
                ),
              ),
              (Route<dynamic> route) => false);
        }
      } else {
        Fluttertoast.showToast(
            msg: "نوع المستخدم غير صحيح",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Color.fromARGB(255, 249, 100, 89),
            fontSize: 16.0,
            textColor: Colors.black);
      }

      isLoading = false;
      notifyListeners();
      return user;
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      if (e.code == "user-not-found") {
        Fluttertoast.showToast(
            msg: "البريد الإلكتروني أو كلمة المرور غير صحيحة",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Color.fromARGB(255, 249, 100, 89),
            fontSize: 16.0,
            textColor: Colors.black);
      } else {
        Fluttertoast.showToast(
            msg: "البريد الإلكتروني أو كلمة المرور غير صحيحة",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Color.fromARGB(255, 249, 100, 89),
            fontSize: 16.0,
            textColor: Colors.black);
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<Map<String, dynamic>> doesNameAlreadyExist(
      String userId, collection) async {
    final QuerySnapshot result = await db
        .collection(collection)
        .where('userID', isEqualTo: userId)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    Map<String, dynamic> data;
    if (documents.isNotEmpty) {
      data = documents[0].data() as Map<String, dynamic>;
    } else {
      data = {'type': ''};
    }
    return data;
  }
}
