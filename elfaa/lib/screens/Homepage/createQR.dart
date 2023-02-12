// ignore_for_file: file_names, camel_case_types
import 'dart:io';
import 'package:elfaa/screens/Homepage/navPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:elfaa/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class createQR extends StatefulWidget {
  const createQR({super.key,
  required this.phoneNo,});

  final String phoneNo;
  @override
  State<createQR> createState() => _createQRState();
}

class _createQRState extends State<createQR> {
  late TextEditingController controllerDEVICE;

  String gpsID = '';

//profile image variables
  XFile? _img;
  final ImagePicker _picker = ImagePicker();
  String imgURL = '';
//information form controllers
  // TextEditingController name = TextEditingController();
  // TextEditingController email = TextEditingController();
  // TextEditingController phoneNo = TextEditingController();
//globalKey
  final _formKey = GlobalKey<FormState>();

//Parent info
  // Future<void> getCurrentP() async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   final User? user = await _auth.currentUser;
  //   if (!mounted) return;
  //   final uid = user!.uid;
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid)
  //       .get()
  //       .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
  //     if (!mounted) return;
  //     name.text = snapshot['name'];
  //     email.text = snapshot['email'];
  //     phoneNo.text = snapshot['phoneNo'].toString();
  //   });
  // }

  //Loading for uploading
  bool isLoading = false;
  bool isProcessing = false;

  //is DeviceID unique
  bool isDeviceVerify = false;

  @override
  void initState() {
    //set the initial value of text field
    // getCurrentP();
    super.initState();

    controllerDEVICE = TextEditingController();
  }

  void dispose() {
    controllerDEVICE.dispose();

    super.dispose;
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
          "إنشاء باركود ",
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
                Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "هذا الباركود يمكن الآخرين من الوصول لمعلومات والدي الطفل ",
                      style: TextStyle(
                          fontSize: 20,
                          color: kdarkColor,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: QrImage(
                    data: ("${widget.phoneNo}"),
                    errorCorrectionLevel: 2,
                    size: 300,
                    foregroundColor: kPrimaryColor,
                    backgroundColor: kLightColor,
                    embeddedImage: AssetImage('assets/images/logo1.png'),
                    embeddedImageStyle:
                        QrEmbeddedImageStyle(size: Size(80, 80)),
                  ),
                ),
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        border: Border(
                          left: BorderSide(
                            color: kPrimaryColor,
                            width: 5.0,
                          ),
                          right: BorderSide(
                            color: kPrimaryColor,
                            width: 5.0,
                          ),
                          bottom: BorderSide(
                            color: kPrimaryColor,
                            width: 5.0,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      height: 43,
                      width: 290,
                      child: Text("أتصل على عائلتي",
                          style: TextStyle(
                              fontSize: 25,
                              color: kLightColor,
                              fontWeight: FontWeight.bold)),
                    )),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.print,
                        color: kPrimaryColor,
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Color(0xFFf5f5f5)),
                        maximumSize: MaterialStateProperty.all(Size(150, 56)),
                        minimumSize: MaterialStateProperty.all(Size(150, 56)),
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
                        'طباعة',
                        style: TextStyle(color: kPrimaryColor, fontSize: 20),
                      ),
                      onPressed: () {
                        print("Print");
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //-----------------Rero's Helping Methods--------------------------------//

  //Add track device
  // Future<String?> openDialog() => showDialog<String>(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text('أدخل الرقم التسلسلي لجهاز التتبع'),
  //         content: TextField(
  //             autofocus: true,
  //             controller: controllerDEVICE,
  //             decoration: InputDecoration(hintText: 'gpsxxxidxx')),
  //         actions: [
  //           TextButton(
  //             child: Text('تحقق'),
  //             onPressed: () async {
  //               if (controllerDEVICE.text.isEmpty) {
  //                 Fluttertoast.showToast(msg: "الرجاء إدخال معرّف الجهاز");
  //                 return;
  //               }
  //               QuerySnapshot<Map<String, dynamic>> child =
  //                   await FirebaseFirestore.instance
  //                       .collection("devices")
  //                       .where("deviceID", isEqualTo: controllerDEVICE.text)
  //                       .get();
  //               if (child.docs.length == 0) {
  //                 isDeviceVerify = true;
  //                 Navigator.pop(context, controllerDEVICE.text);
  //                 //  Fluttertoast.showToast(msg: "تم التحقق من الجهاز");
  //                 Fluttertoast.showToast(
  //                     msg: "تم التحقق من الجهاز",
  //                     toastLength: Toast.LENGTH_SHORT,
  //                     gravity: ToastGravity.BOTTOM,
  //                     timeInSecForIosWeb: 3,
  //                     backgroundColor: Colors.lightGreen,
  //                     fontSize: 16.0,
  //                     textColor: Colors.black);
  //               } else {
  //                 //  Fluttertoast.showToast(msg: "الجهاز مستخدم بالفعل");
  //                 Fluttertoast.showToast(
  //                     msg: "الجهاز مستخدم بالفعل",
  //                     toastLength: Toast.LENGTH_SHORT,
  //                     gravity: ToastGravity.BOTTOM,
  //                     timeInSecForIosWeb: 3,
  //                     backgroundColor: Colors.red,
  //                     fontSize: 16.0,
  //                     textColor: Colors.black);
  //                 isDeviceVerify = false;
  //               }
  //             },
  //           )
  //         ],
  //       ),
  //     );

  //Adding child's profile picture
  // childImg() {
  //   return Center(
  //     child: Stack(
  //       children: <Widget>[
  //         CircleAvatar(
  //             radius: 80,
  //             backgroundImage: _img == null
  //                 ? const AssetImage("assets/images/empty.png")
  //                 : FileImage(File(_img!.path)) as ImageProvider),
  //         Positioned(
  //             bottom: 15,
  //             right: 15,
  //             child: InkWell(
  //                 onTap: () {
  //                   showModalBottomSheet(
  //                       context: context,
  //                       builder: ((builder) => bottomImgPicker()));
  //                 },
  //                 child: const Icon(Icons.camera_alt,
  //                     color: kPrimaryColor, size: 28)))
  //       ],
  //     ),
  //   );
  // }

// //bottom container of image source options
//   bottomImgPicker() {
//     return Container(
//       height: 100,
//       width: MediaQuery.of(context).size.width,
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: Column(
//         children: <Widget>[
//           const Text(
//             "أضف صورة",
//             style: TextStyle(fontSize: 20),
//           ),
//           const SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextButton.icon(
//                   icon: const Icon(Icons.camera),
//                   style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
//                   onPressed: () async {
//                     await takePhoto(ImageSource.camera);
//                     Navigator.pop(context);
//                   },
//                   label: const Text("الكاميرا")),
//               TextButton.icon(
//                   icon: const Icon(Icons.image),
//                   style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
//                   onPressed: () async {
//                     await takePhoto(ImageSource.gallery);
//                     Navigator.pop(context);
//                   },
//                   label: const Text("ألبوم الصور"))
//             ],
//           )
//         ],
//       ),
//     );
//   }

//Getting the picture from the mobile camera
  Future<void> takePhoto(ImageSource source) async {
    final image = await _picker.pickImage(source: source, imageQuality: 20);
    if (image == null) return;
    String uniqueFileName = DateTime.now().toString();

    setState(() {
      _img = image;
    });

    Reference refRoot = FirebaseStorage.instance.ref();
    Reference refDir = refRoot.child('children-images');

    Reference refImg = refDir.child(uniqueFileName);
    try {
      //store the file
      await refImg.putFile(File(_img!.path));
      //succedss: get the url
      imgURL = await refImg.getDownloadURL();
    } catch (e) {
      //error report
    }
  }

  InputDecoration decoration(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());
}

//child class
class Child {
  final String image;
  final String name;
  final DateTime birthday;
  final String gender;
  final int height;

  Child(
      {required this.image,
      required this.name,
      required this.gender,
      required this.height,
      required this.birthday});

  Map<String, dynamic> toJson() => {
        'image': image,
        'name': name,
        'height': height,
        'gender': gender,
        'birthday': birthday,
      };
}
