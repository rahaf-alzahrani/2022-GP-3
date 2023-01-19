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
import 'package:firebase_auth/firebase_auth.dart';

class addChild extends StatefulWidget {
  const addChild({super.key});

  @override
  State<addChild> createState() => _addChildState();
}

class _addChildState extends State<addChild> {
  late TextEditingController controllerDEVICE;

  String gpsID = '';

//profile image variables
  XFile? _img;
  final ImagePicker _picker = ImagePicker();
  String imgURL = '';
//information form controllers
  final controllerName = TextEditingController();
  final controllerBirthday = TextEditingController();
  final controllerHeight = TextEditingController();
  String selectedGender = 'أنثى';

//globalKey
  final _formKey = GlobalKey<FormState>();

//Parent info
  String pID = '';
  Future<void> getCurrentP() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = await _auth.currentUser;
    final uid = user!.uid;
    setState(() {
      pID = uid;
    });
  }

  //Loading for uploading
  bool isLoading = false;
  bool isProcessing = false;

  //is DeviceID unique
  bool isDeviceVerify = false;

  @override
  void initState() {
    controllerBirthday.text = ""; //set the initial value of text field
    getCurrentP();
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
          "إضافة طفل ",
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
                childImg(),
                SizedBox(height: ScreenHeight * 0.04),
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      textAlign: TextAlign.right,
                      controller: controllerName,
                      decoration: const InputDecoration(
                        suffixIcon:
                            Icon(Icons.child_care, color: Color(0xFFFD8601)),
                        labelText: "اسم الطفل",
                        hintText: "مثال: أسماء",
                      ),
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      validator: (value) {
                        if (value!.isEmpty ||
                            controllerName.text.trim() == "") {
                          return "الحقل مطلوب";
                        }
                        return null;
                      },
                    )),
                SizedBox(height: ScreenHeight * 0.025),
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      textAlign: TextAlign.right,
                      controller: controllerHeight,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.accessibility_new,
                            color: Color(0xFFFD8601)),
                        labelText: "الطول",
                        hintText: "بالسنتيمترات",
                      ),
                      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      validator: (value) {
                        if (value!.isEmpty ||
                            controllerHeight.text.trim() == "") {
                          return "الحقل مطلوب";
                        } else if (int.parse(controllerHeight.text.trim()) >
                                160 ||
                            int.parse(controllerHeight.text.trim()) < 30) {
                          return "يرجى إدخال طول صحيح";
                        }
                        return null;
                      },
                    )),
                SizedBox(height: ScreenHeight * 0.025),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.escalator_warning,
                          color: Color(0xFFFD8601)),
                      labelText: "الجنس",
                    ),
                    onChanged: (val) {
                      setState(() {
                        selectedGender = val.toString();
                      });
                    },
                    value: selectedGender,
                    items: const [
                      DropdownMenuItem(
                        child: Text("ذكر"),
                        value: 'ذكر',
                      ),
                      DropdownMenuItem(
                        child: Text("أنثى"),
                        value: "أنثى",
                      )
                    ],
                    validator: (value) {
                      if (value!.isEmpty ||
                          controllerHeight.text.trim() == "") {
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
                        textAlign: TextAlign.right,
                        controller: controllerBirthday,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.calendar_today,
                              color: Color(0xFFFD8601)),
                          labelText: "تاريخ الميلاد",
                          hintText: "اختر من التقويم",
                        ),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        validator: (value) {
                          if (value!.isEmpty ||
                              controllerBirthday.text.trim() == "") {
                            return "الحقل مطلوب";
                          }
                          return null;
                        },
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime((DateTime.now().year) - 12),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: const Color(0xFF429EB2),
                                  colorScheme: const ColorScheme.light(
                                      primary: Color(0xFF429EB2)),
                                  buttonTheme: const ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              controllerBirthday.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          }
                        })),
                SizedBox(height: ScreenHeight * 0.025),
                SizedBox(
                  width: ScreenWidth,
                  child: ElevatedButton(
                      onPressed: () async {
                        final gpsID = await openDialog();
                        if (gpsID == null || gpsID.isEmpty) return;

                        setState(() => this.gpsID = gpsID);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF429EB2),
                          textStyle: const TextStyle(
                            fontSize: 22,
                            color: Color.fromARGB(255, 255, 255, 255),
                          )),
                      child: const Text('ربط جهاز التتبع')),
                ),
                SizedBox(height: ScreenHeight * 0.025),
                ElevatedButton(
                    onPressed: isProcessing
                        ? null
                        : () async {
                            if (imgURL.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "يرجى اختيار صورة",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 7,
                                  backgroundColor:
                                      Color.fromARGB(255, 195, 74, 74),
                                  fontSize: 16.0,
                                  textColor: Colors.white);

                              return;
                            }
                            if (!isDeviceVerify) {
                              Fluttertoast.showToast(
                                  msg: 'لم يتم التحقق من الجهاز');
                              return;
                            }
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                                isProcessing = true;
                              });

                              final child = Child(
                                  image: imgURL,
                                  name: controllerName.text,
                                  gender: selectedGender,
                                  height: int.parse(controllerHeight.text),
                                  birthday:
                                      DateTime.parse(controllerBirthday.text));
                              await addChild(child);
                              Fluttertoast.showToast(
                                  msg: "تمت إضافة الطفل بنجاح",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.lightGreen,
                                  textColor: Colors.black,
                                  fontSize: 16.0);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NavPage()),
                              );
                              setState(() {
                                isLoading = false;
                                isProcessing = false;
                              });
                            }
                          },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF429EB2)),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('إضافة')),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //-----------------Rero's Helping Methods--------------------------------//

  //Add track device
  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('أدخل الرقم التسلسلي لجهاز التتبع'),
          content: TextField(
              autofocus: true,
              controller: controllerDEVICE,
              decoration: InputDecoration(hintText: 'gpsxxxidxx')),
          actions: [
            TextButton(
              child: Text('تحقق'),
              onPressed: () async {
                if (controllerDEVICE.text.isEmpty) {
                  Fluttertoast.showToast(msg: "الرجاء إدخال معرّف الجهاز");
                  return;
                }
                QuerySnapshot<Map<String, dynamic>> child =
                    await FirebaseFirestore.instance
                        .collection("devices")
                        .where("deviceID", isEqualTo: controllerDEVICE.text)
                        .get();
                if (child.docs.length == 0) {
                  isDeviceVerify = true;
                  Navigator.pop(context, controllerDEVICE.text);
                  //  Fluttertoast.showToast(msg: "تم التحقق من الجهاز");
                  Fluttertoast.showToast(
                      msg: "تم التحقق من الجهاز",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.lightGreen,
                      fontSize: 16.0,
                      textColor: Colors.black);
                } else {
                  //  Fluttertoast.showToast(msg: "الجهاز مستخدم بالفعل");
                  Fluttertoast.showToast(
                      msg: "الجهاز مستخدم بالفعل",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red,
                      fontSize: 16.0,
                      textColor: Colors.black);
                  isDeviceVerify = false;
                }
              },
            )
          ],
        ),
      );

  //Adding child's profile picture
  childImg() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
              radius: 80,
              backgroundImage: _img == null
                  ? const AssetImage("assets/images/empty.png")
                  : FileImage(File(_img!.path)) as ImageProvider),
          Positioned(
              bottom: 15,
              right: 15,
              child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomImgPicker()));
                  },
                  child: const Icon(Icons.camera_alt,
                      color: kPrimaryColor, size: 28)))
        ],
      ),
    );
  }

//bottom container of image source options
  bottomImgPicker() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "أضف صورة",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  icon: const Icon(Icons.camera),
                  style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
                  onPressed: () async {
                    await takePhoto(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  label: const Text("الكاميرا")),
              TextButton.icon(
                  icon: const Icon(Icons.image),
                  style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
                  onPressed: () async {
                    await takePhoto(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  label: const Text("ألبوم الصور"))
            ],
          )
        ],
      ),
    );
  }

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

  //adding child doc to a parent doc in the firestore database
  Future addChild(Child child) async {
    //Reference to document

    final docChild = FirebaseFirestore.instance
        .collection('users')
        .doc(pID)
        .collection('children')
        .doc();

    // Add Device into Device Collection
    final docDevice = FirebaseFirestore.instance.collection('devices').doc();
    //Create doc and write data
    await docDevice.set({
      'deviceID': controllerDEVICE.text,
      'childID': docChild.id,
      'parentID': pID,
    });

    final json = child.toJson();
    //Create doc and write data
    await docChild.set(json);
    print(docChild.id);
    // Add Device to Realtime Database
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('devices/${docChild.id}');
    ref.set({
      'deviceID': controllerDEVICE.text,
      'long': 0.0,
      'lat': 0.0,
      'timestamp': 0.0
    });
  }
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