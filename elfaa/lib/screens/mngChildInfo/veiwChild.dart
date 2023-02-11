import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:elfaa/screens/Homepage/HomelistBox.dart';
import '../profile/profile_page.dart' as profile;
import '../../notification.dart';
import '../../range_alert.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:elfaa/screens/Homepage/Home_page.dart';
import 'package:elfaa/screens/Homepage/navPage.dart';
import 'package:elfaa/screens/mngChildInfo/report_child.dart';
import 'package:elfaa/zones.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:elfaa/constants.dart';
import 'package:elfaa/screens/mngChildInfo/editChild.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:point_in_polygon/point_in_polygon.dart';

import '../../alert_dialog.dart';

class viewChild extends StatefulWidget {
  const viewChild(
      {super.key,
      required this.childID,
      required this.childImage,
      required this.childname,
      required this.childbirthday,
      required this.childHeight,
      required this.childGender});
  final String childID;
  final String childImage;
  final String childname;
  final String childbirthday;
  final int childHeight;
  final String childGender;

  @override
  State<viewChild> createState() => _viewChildState();
}

class _viewChildState extends State<viewChild> {
  bool tappedYes = false;
  bool loading = false;
  var theZoneName = "";
  late final notification not;
  GoogleMapController? mapController;
  Uint8List? markerimage;
  Completer<GoogleMapController> _mapcontroller = Completer();
  static Position? position;
  DatabaseReference ref = FirebaseDatabase.instance.ref("devices");
  Circle? childCircle;
  Marker? marker;
  static Circle? circle;
  late zones zoneList;
  Future<void> addZones() async {
    zoneList = zones();
    zoneList.LoadData();
  }

  LocationData? currentLocation2;
  void check_zone() {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    //GoogleMapController googleMapController = await _mapcontroller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;

        // googleMapController.animateCamera(
        //   CameraUpdate.newCameraPosition(
        //     CameraPosition(
        //       zoom: 17,
        //       target: LatLng(
        //         newLoc.latitude!,
        //         newLoc.longitude!,
        //       ),
        //     ),
        //   ),
        // );
        setState(() {});
      },
    );
  }

  void check_range() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
        updateMarkerAndcircle(location);
      },
    );
    GoogleMapController googleMapController = await _mapcontroller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        //LatLng myChildLocation = LatLng(24.769788, 46.644595); //allowed
        LatLng myChildLocation = LatLng(24.769642, 46.644723); //not allowed
        LatLng myLocation = LatLng(newLoc.latitude!, newLoc.longitude!);
        double dist = Geolocator.distanceBetween(
            myChildLocation.latitude,
            myChildLocation.longitude,
            myLocation.latitude,
            myLocation.longitude);
        int allowedDis = dist.toInt() - 15;

        if (profile.isSwitched) {
          if (15 < dist && !isHeWithme) {
            isHeWithme = true;
            range_alert.oklDialog(
              context,
              "تحذير  ",
              "انتبه طفلك" +
                  " ${widget.childname} " +
                  " تجاوز المسافة المسموحة بـ " +
                  "$allowedDis" +
                  " متر",
            );

            not.showNotification(
                id: 0,
                title: "تحذير",
                body: "انتبه طفلك تجاوز المسافة المسموحة بـ " +
                    "$allowedDis" +
                    " متر");
          } else if (15 >= dist && isHeWithme) {
            isHeWithme = false;
          }
        }

        // googleMapController.animateCamera(
        //   CameraUpdate.newCameraPosition(
        //     CameraPosition(
        //       zoom: 17,
        //       target: LatLng(
        //         newLoc.latitude!,
        //         newLoc.longitude!,
        //       ),
        //     ),
        //   ),
        // );
        // setState(() {});
        updateMarkerAndcircle(newLoc);
      },
    );
  }

  @override
  void initState() {
    getCurrentLocation();
    getMyCurrentLocation();
    getCurrentLocation2();
    addZones();
    check_range();
    getChildLocation();
    ref.onValue.listen((event) {
      DataSnapshot temp = event.snapshot;
      Map data = temp.value as Map;
      if (data["lat"].toInt() == 0 && data["long"].toInt() == 0) {
        setState(() {
          marker = null;
          childCircle = null;
        });

        return;
      }
      setState(() {
        zoneList.addZonesName();
        marker = Marker(
          markerId: MarkerId('${widget.childID}'),
          position: LatLng(data['lat'], data['long']),
        );
        childCircle = Circle(
          circleId: CircleId('${widget.childID}'),
          center: LatLng(data['lat'], data['long']),
          radius: 15,
          fillColor: Colors.blue.shade100.withOpacity(0.5),
          strokeColor: Colors.blue.shade100.withOpacity(0.1),
        );

        final Point point = Point(x: data['lat'], y: data['long']);
        for (int i = 0; i < zoneList.zoneName.length; i++) {
          if (Poly.isPointInPolygon(point, zoneList.zoneNames[i]['points'])) {
            theZoneName = zoneList.zoneNames[i]['name'];

            if (zoneList.zoneNames[i]['criticalZones']) {
              notification().showNotification(
                  title: "تحذير",
                  body: "انتبه طفلك" +
                      ' ${widget.childname} ' +
                      "دخل منطقة محظورة "
                          "\n\"${zoneList.zoneNames[i]['name']}\"",
                  payload: '${widget.childImage}');
              range_alert.oklDialog(
                context,
                "تحذير  ",
                "دخل منطقة محظورة " +
                    ' ${widget.childname} ' +
                    "انتبه طفلك" +
                    "\n\"${zoneList.zoneNames[i]['name']}\"",
              );
            }
          }
        }
      });
    });
    super.initState();
  }

  getChildLocation() async {
    ref = ref.child("${widget.childID}");
    DataSnapshot temp = await ref.get();
    Map data = temp.value as Map;
    if (data["lat"].toInt() == 0 && data["long"].toInt() == 0) {
      return;
    }
    marker = Marker(
      markerId: MarkerId('${widget.childID}'),
      position: LatLng(data['lat'].toDouble(), data['long'].toDouble()),
    );
    childCircle = Circle(
      circleId: CircleId('${widget.childID}'),
      center: LatLng(data['lat'].toDouble(), data['long'].toDouble()),
      radius: 15,
      fillColor: Colors.blue.shade100.withOpacity(0.5),
      strokeColor: Colors.blue.shade100.withOpacity(0.1),
    );
    GoogleMapController googleMapController = await _mapcontroller.future;
    setState(() {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 17,
            target: LatLng(
              data["lat"].toDouble(),
              data["long"].toDouble(),
            ),
          ),
        ),
      );
    });
  }

  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    target: LatLng(24.769924, 46.646101),
    zoom: 12,
  );

  static Future<Position> getCurrentLocation() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high);
  }

  Future<void> getMyCurrentLocation() async {
    await getCurrentLocation();
    position = await Geolocator.getLastKnownPosition().whenComplete(() {
      setState(() {});
    });
    if (!mounted) return;
  }

  LocationData? currentLocation;
  void getCurrentLocation2() async {
    Location location = Location();
    GoogleMapController googleMapController = await _mapcontroller.future;
    location.getLocation().then(
      (location) {
        updateMarkerAndcircle(location);
        currentLocation = location;

        // googleMapController.animateCamera(
        //   CameraUpdate.newCameraPosition(
        //     CameraPosition(
        //       zoom: 17,
        //       target: LatLng(
        //         currentLocation!.latitude!,
        //         currentLocation!.longitude!,
        //       ),
        //     ),
        //   ),
        // );
      },
    ); //then
    location.onLocationChanged.listen((newLoc) {
      //  updateMarkerAndcircle(newLoc);
    });
  }

  @override
  Widget build(BuildContext context) {
    //Child Info
    final String childName = widget.childname;
    int childHeight = widget.childHeight;
    String childImage = widget.childImage;
    String childGender = widget.childGender;
    String zoneName = theZoneName;

    //Responsiviness variables
    final double ScreenHeight = MediaQuery.of(context).size.height;
    final double ScreenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: (() {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => editChild(
                        childID: widget.childID,
                        childImage: childImage,
                        childname: childName,
                        childbirthday: widget.childbirthday,
                        childHeight: childHeight,
                        childGender: childGender)),
              );
            })),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 90,
        // title: Text(
        //   childName,
        //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        // ),
        centerTitle: true,
        flexibleSpace: Container(
            decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28)),
          color: kPrimaryColor,
        )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: ScreenHeight * 0.45,
            width: MediaQuery.of(context).size.width,
            child: position != null
                ? buildMap()
                : Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 150.0),
                          child: Container(
                            child: CircularProgressIndicator(
                              color: color1,
                            ),
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28), topRight: Radius.circular(28)),
              color: kPrimaryColor.withOpacity(0.9),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 5,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 9,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: ScreenWidth * 0.35,
                            height: ScreenHeight * 0.1,
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xff484848).withOpacity(.3),
                                      offset: Offset(0, 4),
                                      blurRadius: 8)
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                childName,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              alignment: Alignment.center,
                              width: ScreenWidth * 0.5,
                              height: ScreenHeight * 0.05,
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color(0xff484848).withOpacity(.3),
                                        offset: Offset(0, 4),
                                        blurRadius: 8)
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: theZoneName == ""
                                  ? Text(
                                      "المنطقة غير محددة",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      " في منطقة " + "$theZoneName",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    )),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 22,
                                offset: Offset(5, 5),
                              )
                            ]),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: networkImg("${widget.childImage}",
                                    ScreenWidth * 0.9, ScreenHeight * 0.8)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenHeight * 0.013),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: ScreenWidth * 0.28,
                        height: ScreenHeight * 0.1,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            boxShadow: [
                              BoxShadow(
                                  color: kPrimaryColor.withOpacity(1),
                                  blurRadius: 10)
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Icon(
                                        FontAwesomeIcons.calendar,
                                        color: kPrimaryColor,
                                        size: 15,
                                      ),
                                    )),
                              ),
                              getAgeText()
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: ScreenWidth * 0.28,
                        height: ScreenHeight * 0.1,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            boxShadow: [
                              BoxShadow(
                                  color: kPrimaryColor.withOpacity(1),
                                  blurRadius: 10)
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Icon(
                                        FontAwesomeIcons.male,
                                        color: kPrimaryColor,
                                        size: 15,
                                      ),
                                    )),
                              ),
                              Text(
                                "$childGender",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: ScreenWidth * 0.28,
                        height: ScreenHeight * 0.1,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            boxShadow: [
                              BoxShadow(
                                  color: kPrimaryColor.withOpacity(1),
                                  blurRadius: 10)
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Icon(
                                        FontAwesomeIcons.h,
                                        color: kPrimaryColor,
                                        size: 15,
                                      ),
                                    )),
                              ),
                              Text(
                                "$childHeight سم",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenHeight * 0.03),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.campaign,
                        color: Color(0xFF9C0000),
                      ),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 22),
                        shadowColor: Color.fromARGB(255, 0, 0, 0),
                        elevation: 0,
                        backgroundColor: Color(0xFFFFEEEE),
                        shape: const StadiumBorder(),
                        maximumSize: const Size(180, 48),
                        minimumSize: const Size(180, 48),
                      ),
                      label: Text(
                        ' إنشاء بلاغ   ',
                        style:
                            TextStyle(color: Color(0xFF9C0000), fontSize: 20),
                      ),
                      onPressed: () async {
                        final action = await AlertDialogs.yesCancelDialog(
                            context,
                            'إنشاء البلاغ',
                            'هل أنت متأكد من إنشاء البلاغ؟');
                        if (!mounted) return;
                        if (action == DialogsAction.yes) {
                          setState(() => tappedYes = true);
                          if (!mounted) return;
                          createReportToFirebase(widget.childID,
                                  widget.childImage, widget.childname)
                              .then((value) {
                            setState(() {
                              loading = false;
                            });

                            Fluttertoast.showToast(
                                msg: "تم الإبلاغ بنجاح",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    Color.fromARGB(255, 48, 109, 50),
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => NavPage(
                                          code: 0,
                                        ))));
                          });
                          Navigator.pop(context);
                        } else {
                          setState(() => tappedYes = false);
                          if (!mounted) return;
                        }
                        // print("hello");
                        setState(() {
                          loading = true;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  getAgeText() {
    //Convert timestamp type of data to DateTime
    DateTime childBirthday = DateTime.parse((widget.childbirthday).toString());
    //Calculate Age As years: 0, Months: 0, Days: 0
    DateDuration calcAge = AgeCalculator.age(childBirthday);

    int childAgeYears = calcAge.years;
    int childAgeMonths = calcAge.months;
    String str = '';
    try {
      if (childAgeYears > 10 || childAgeYears == 1 || childAgeYears == 2) {
        str = "$childAgeYears سنة";
      } else if (childAgeYears > 2 && childAgeYears < 11) {
        str = "$childAgeYears سنوات";
      } else if (childAgeYears < 1) {
        if (childAgeMonths == 1 ||
            childAgeMonths == 11 ||
            childAgeMonths == 12 ||
            childAgeMonths == 0) {
          str = "$childAgeMonths شهر";
        } else {
          str = "$childAgeMonths شهور";
        }
      }
    } catch (error) {
      Text("error");
    }
    return Text(str,
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold));
  }

  void updateMarkerAndcircle(LocationData newLocaldata) {
    LatLng latIng = LatLng(newLocaldata.latitude!, newLocaldata.longitude!);
    this.setState(() {
      circle = Circle(
        circleId: CircleId("car"),
        center: latIng,
        radius: 15,
        zIndex: 1,
        fillColor: Color.fromARGB(255, 255, 126, 12).withOpacity(0.5),
        strokeColor: Color.fromARGB(255, 255, 126, 12).withOpacity(0.1),
      );
    });
  }

  Widget buildMap() {
    zoneList.add();
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      markers: marker != null
          ? Set<Marker>.of(zoneList.markers + [marker!])
          : Set<Marker>.of(zoneList.markers),
      myLocationButtonEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(24.63333, 46.71667),
        zoom: 10,
      ),
      onCameraMove: (CameraPosition position) {
        // print(position.target);
      },
      onMapCreated: (GoogleMapController controller) {
        setState(() {
          _mapcontroller.complete(controller);
        });
      },
      circles: Set.of((circle != null && childCircle != null)
          ? [circle!, childCircle!]
          : (circle != null)
              ? [circle!]
              : (childCircle != null)
                  ? [childCircle!]
                  : []),
      polygons: zoneList.polygons,
    );
  }
}

networkImg(String childImage, double ScreenWidth, double ScreenHeight) {
  try {
    return Image.network(
      childImage,
      width: ScreenWidth * 0.33,
      height: ScreenHeight * 0.15,
      fit: BoxFit.cover,
      frameBuilder:
          (BuildContext context, Widget child, int? frame, bool isAsyncLoaded) {
        return Padding(
          padding: EdgeInsets.all(1),
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
          width: ScreenWidth * 0.33,
          height: ScreenHeight * 0.15,
          child: Center(
            child: Text(
              "حدث خطأ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  } catch (error) {}
}
