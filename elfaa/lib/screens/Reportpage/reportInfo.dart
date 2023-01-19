// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elfaa/report.dart';
import 'package:elfaa/screens/Homepage/navPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:elfaa/constants.dart';
import '../../Location_helper.dart';
import 'progress_report.dart';

class reportInfo extends StatefulWidget {
  final Report childReport;

  reportInfo({
    Key? key,
    required this.childReport,
  });

  @override
  State<reportInfo> createState() => _reportInfoState();
}

class _reportInfoState extends State<reportInfo> {
  bool tappedYes = false;
  bool isLoading = false;
  bool editable = false;
  final List<Marker> _marker = <Marker>[
    Marker(markerId: MarkerId("12"), position: LatLng(24.770171, 46.643851))
  ];
  final List<LatLng> _latlng = <LatLng>[
    LatLng(24.770171, 46.643851),
  ];
  int zoneName = 0;
  // GoogleMapController? mapController; //contrller for Google map
  // Set<Marker> markers = Set(); //markers for google map

  static Position? position;
  // LatLng showLocation = LatLng(27.7089427, 85.3086209);
  Completer<GoogleMapController> _mapcontroller = Completer();

  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
      bearing: 0.0,
      target: LatLng(24.770171, 46.643851),
      tilt: 0.0,
      zoom: 17);
  Future<void> getMyCurrentLocation() async {
    await Location_Helper.getCurrentLocation();
    position = await Geolocator.getLastKnownPosition().whenComplete(() {
      setState(() {});
    });
  }

  void initState() {
    super.initState();
    getMyCurrentLocation();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> getCurrentUser() async {
    final User? user = await _auth.currentUser;
    if (!mounted) return;
    final uid = user!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {});
    if (!mounted) return;
  }

  PickedFile? _imgFile;

  final ImagePicker _picker = ImagePicker();

//information form controllers
  final now = DateTime.now();
  final df = new DateFormat('dd-MM-yyyy hh:mm a');
  int myvalue = 1558432747;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey<ScaffoldState>();
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final color = _getColor(widget.childReport.status ?? "");

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        elevation: 0,
        toolbarHeight: 90,
        title: Text(
          "تفاصيل البلاغ",
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
      body: Column(
        children: [
          Container(
            height: height / 2.3,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: position != null
                ? buildMap()
                : Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 150.0),
                          child: Container(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: Text(
                              "من فضلك فعّل الموقع لكي تظهر الخريطة",
                              style: TextStyle(
                                  color: kOrangeColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
          Expanded(
            child: BlurryContainer(
              height: double.infinity,
              width: width,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.024,
                              width: width * 0.05,
                            ),

                            Container(
                              // color: Colors.green,
                                height: height * 0.13,
                                width: width * 0.45,
                                // padding: EdgeInsets.only(
                                //     right: width * 0.03,
                                //     left: 0.1,
                                //     top: width * 0.06,
                                //     bottom: 0.01),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            widget.childReport.childName!,
                                            style: TextStyle(
                                              color:
                                              Color.fromARGB(255, 41, 41, 32),
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            ":اسم الطفل",
                                            style: TextStyle(
                                              color:
                                              Color.fromARGB(255, 41, 41, 32),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            DateFormat("hh:mm aa").format(widget.childReport.time),
                                            style: TextStyle(
                                              color:
                                              Color.fromARGB(255, 41, 41, 32),
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            ":وقت البلاغ",
                                            style: TextStyle(
                                              color:
                                              Color.fromARGB(255, 41, 41, 32),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            widget.childReport.date!,
                                            style: TextStyle(
                                              color:
                                              Color.fromARGB(255, 41, 41, 32),
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            ":تاريخ البلاغ",
                                            style: TextStyle(
                                              color:
                                              Color.fromARGB(255, 41, 41, 32),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),

                            SizedBox(
                              width: 10,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                height: 80,
                                width: 68,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: networkImg(widget.childReport.imageUrl!,
                                      width, height),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: height * 0.03,
                        ),

                        SizedBox(
                          width: width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              Text(
                                'حالة البلاغ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),

                              SizedBox(
                                width: height * 0.01,
                              ),

                              Container(
                                height: height * 0.04,
                                width: height * 0.10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.childReport.status ?? "",
                                      style: TextStyle(
                                          color: color,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color
                                        )
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: height * 0.03,
                        ),

                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const Text('رقم التواصل مع مشرف حرّاس الأمن',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                                '0501941104',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: height * 0.07,
                                width: width * 0.425,
                                  child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          SizedBox(width: 20),

                                          Text(
                                            'اتصل بالأمن',
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),

                                          SizedBox(width: 20),

                                          Icon(
                                            Icons.phone,
                                            size: 16,
                                            color: kPrimaryColor,
                                          )
                                        ],
                                      )),
                                  decoration: BoxDecoration(
                                    color: klightBlueColor,
                                    borderRadius: BorderRadius.circular(32)),
                              ),
                            ),

                            SizedBox(
                              width: width * 0.05,
                            ),

                            InkWell(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });

                                final User user = await _auth.currentUser!;
                                print(widget.childReport.id);
                                await FirebaseFirestore.instance
                                    .collection('report')
                                    .doc(widget.childReport.id)
                                    .update({"status": "مغلق"});
                                final parentChild = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('children')
                                    .doc(widget.childReport.childrenId);
                                parentChild.update({"status": false});

                                await FirebaseFirestore.instance
                                    .collection('notification')
                                    .add({
                                  "message": "البلاغ رقم #${DateFormat("yyyyMMDDhhmmss")
                                      .format(widget.childReport.time)} تم إغلاقه عن طريق الوالد",
                                  "newStatus": "مغلق",
                                  "time": Timestamp.now()
                                });

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NavPage(code: 0)));
                              },
                              child: Container(
                                height: height * 0.07,
                                width: width * 0.425,
                                child: Center(
                                    child: isLoading
                                        ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                        : Text(
                                      'إغلاق البلاغ',
                                      style: TextStyle(
                                          color: kdarkRed,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                                decoration: BoxDecoration(
                                    color: Color(0xFFFFEEEE),
                                    borderRadius: BorderRadius.circular(32)),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),

                        // TextButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => ProgressReport(
                        //               reportID: widget.childReport.id!
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //     child: Text(
                        //         'View report progress',
                        //         style: TextStyle(
                        //             color: Colors.blue,
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.normal
                        //         )
                        //     ),
                        // )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      markers: Set<Marker>.of(_marker),
      myLocationButtonEnabled: true,
      initialCameraPosition: _myCurrentLocationCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _mapcontroller.complete(controller);
      },
    );
  }

  _getColor(String status) {
    if(status == "Lost") {
      return Colors.red;
    } else if(status == "Found"){
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }
}

networkImg(String childImage, double ScreenWidth, double ScreenHeight) {
  try {
    return Image.network(
      childImage,
      width: ScreenWidth * 0.2,
      height: ScreenHeight * 0.09,
      fit: BoxFit.cover,
      frameBuilder:
          (BuildContext context, Widget child, int? frame, bool isAsyncLoaded) {
        return Container(
          child: child,
        );
      },
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: Text(
            "جاري التحميل",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? st) {
        return Container(
          width: ScreenWidth * 0.15,
          height: ScreenHeight * 0.33,
          child: Center(
            child: Text(
              "! حدث خطأ",
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 41, 41, 32),
              ),
            ),
          ),
        );
      },
    );
  } catch (error) {}
}
