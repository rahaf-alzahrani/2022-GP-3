import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:elfaa/screens/Homepage/HomelistBox.dart';
import 'package:elfaa/screens/mngChildInfo/addChild.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elfaa/constants.dart';
import 'package:location/location.dart';
import 'package:point_in_polygon/point_in_polygon.dart';
import '../../zones.dart';
import 'dart:ui' as ui;
import 'childrenList.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_geocoder/geocoder.dart';
import 'package:elfaa/notification.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator/geolocator.dart';
import '../../range_alert.dart';
import '../profile/profile_page.dart' as profile;

int index = 2;
final Color color1 = kPrimaryColor;
final Color color2 = kPrimaryColor;
final Color color3 = kPrimaryColor;
String username = "";
List<childrenList> _childrenList = [];
List? zoneNames;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userid = "";
  bool isHeWithme = false;
  late final notification not;
  static Circle circle = Circle(
    circleId: CircleId('currentCircle'),
    center: LatLng(24.769924, 46.646101),
    radius: 15,
    fillColor: Colors.blue.shade100.withOpacity(0.5),
    strokeColor: Colors.blue.shade100.withOpacity(0.1),
  );
  Completer<GoogleMapController> _mapcontroller = Completer();
  static Position? position;
  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    target: LatLng(24.63333, 46.71667),
    zoom: 10,
  );

  late zones zoneList;
  Future<void> addZones() async {
    zoneList = zones();
    zoneList.LoadData();
  }

  Future<void> addZonesName() async {
    for (int i = 0; i < zoneList.zoneName.length; i++) {
      // zoneList.add( zoneList.zoneName[i]:zoneList.c_gate1_b);
    }
  }

  Future<void> getMyCurrentLocation() async {
    await Geolocator.requestPermission();
    position = await Geolocator.getLastKnownPosition().whenComplete(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  static Future<Position> getCurrentLocation() async {
    // bool isEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!isEnabled) {
    //   await Geolocator.requestPermission();
    // }
    await Geolocator.requestPermission();

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.low);
  }

  Future<void> getCurrentUserr() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = await _auth.currentUser;
    if (!mounted) return;
    final userid = user!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      username = snapshot['name'];
    });
    if (!mounted) return;
  }

  void dispose() {
    super.dispose();
  }

//critical zones
  LocationData? currentLocation2;
  void check_zone() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await _mapcontroller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        final Point point = Point(x: newLoc.latitude!, y: newLoc.longitude!);
        for (int i = 0; i < zoneList.zoneName.length; i++) {
          if (Poly.isPointInPolygon(point, zoneList.way_WW)) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Alert Dialog Box"),
                content: const Text("You have raised a Alert Dialog Box"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      color: Colors.green,
                      padding: const EdgeInsets.all(14),
                      child: const Text("okay"),
                    ),
                  ),
                ],
              ),
            );
          }
        }

        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 17,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }

//range
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
            range_alert.oklDialog(
              context,
              "تحذير  ",
              "انتبه طفلك تجاوز المسافة المسموحة بـ " + "$allowedDis" + " متر",
            );
            // not.showNotification(
            //     id: 0,
            //     title: "تحذير",
            //     body: "انتبه طفلك تجاوز المسافة المسموحة بـ "
            //     //+
            //     //     "$allowedDis" +
            //     //     " متر"
            //     );
            isHeWithme = true;
          } else if (15 >= dist && isHeWithme) {
            isHeWithme = true;
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

  LocationData? currentLocation;
  void getCurrentLocation2() async {
    Location location = Location();

    GoogleMapController googleMapController = await _mapcontroller.future;
    location.getLocation().then(
      (location) {
        currentLocation = location;

        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 17,
              target: LatLng(
                currentLocation!.latitude!,
                currentLocation!.longitude!,
              ),
            ),
          ),
        );
      },
    );
  }

  List<String> childDocsId = [];
  initState() {
    //check_zone();
    // not.initializePlatformSpecifics;
    getMyCurrentLocation();
    check_range();
    addZones();
    getCurrentLocation2();
    getCurrentUserr();
    topRef.onValue.listen((event) {
      for (final child in event.snapshot.children) {
        if (!(childDocsId.contains(child.key!))) {
          continue;
        }
        Map newData = child.value as Map;
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Alert Dialog Box"),
            content: Text("You have raised a Alert Dialog Box" + "$newData"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.all(14),
                  child: const Text("okay"),
                ),
              ),
            ],
          ),
        );
        if (newData["lat"].toInt() == 0 && newData["long"].toInt() == 0) {
          if (markersMap.containsKey(child.key!)) {
            setState(() {
              markersMap.remove(child.key!);
              circlesMap.remove(child.key!);
            });
          }

          return;
        }
        Marker marker = Marker(
          markerId: MarkerId(child.key!),
          position: LatLng(newData["lat"], newData["long"]),
          icon: markupIcons[child.key!]!,
        );
        Circle circle = Circle(
            circleId: CircleId(child.key!),
            center: LatLng(newData["lat"], newData["long"]),
            radius: 100,
            fillColor: Colors.blue.withOpacity(0.2),
            strokeWidth: 0);

        setState(() {
          markersMap[child.key!] = marker;
          circlesMap[child.key!] = circle;
        });
      }
    });
    getMyCurrentLocation();
    getCurrentUserr();
    getCurrentLocation2();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getChildrenList();
  }

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: <
            Widget>[
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.only(right: 25.0, top: 5),
            child: Text(
              "تتبع أطفالك ",
              style: TextStyle(
                  color: kOrangeColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 10),
            child: Container(
              height: height * 0.2,
              width: MediaQuery.of(context).size.width,
              child: position != null
                  ? buildMap()
                  : Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                            child: Container(
                              child: CircularProgressIndicator(
                                color: color1,
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                "من فضلك فعّل الموقع حتى تظهر الخريطة",
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //FloatingActionButton(onPressed:  (() =>  getCurrentLocation2();)),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Container(
                    height: height * 0.06,
                    decoration: BoxDecoration(
                        color: kOrangeColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: kOrangeColor.withOpacity(.3),
                              offset: Offset(0, 4),
                              blurRadius: 8)
                        ]),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => addChild()),
                        );
                      },
                      icon: Icon(Icons.add),
                      color: Colors.white,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Container(
                    height: height * 0.06,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff484848).withOpacity(.3),
                              offset: Offset(0, 4),
                              blurRadius: 8)
                        ]),
                    child: IconButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => QRPage()),
                        // );
                        notification().showNotification(
                            title: "Layan",
                            body: "mlzbdbdzfeht",
                            payload: "csadv");
                      },
                      icon: Icon(Icons.qr_code, size: 20),
                      color: Colors.white,
                    )),
              )
            ],
          ),
          _childrenList.length == 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 30),
                  child: Container(
                    height: height * 0.35,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(),
                  ),
                )
              : RefreshIndicator(onRefresh: refresh, child: _buildList()),
        ]),
      ),
    );
  }

  Future refresh() async {
    setState(() {
      _buildList();
    });
  }

  Container _buildList() {
    final GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey<ScaffoldState>();
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.4,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 0.1),
            child: SizedBox(child: list()),
          )
        ],
      ),
    );
  }

  Container _buildHeader() {
    // final GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey<ScaffoldState>();
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    // String stAddress = '';

    // stored the value of latitude in lat from textfield
    // String lat = "24.770561";
    // stored the value of longitude in lon from textfield
    // String lon = "46.644722";

    // converted the lat from string to double
    // double lat_data = double.parse(lat);
    // converted the lon from string to double
    // double lon_data = double.parse(lon);

    // final coordinates = new Coordinates(lat_data, lon_data);
    // var address = Geocoder.local.findAddressesFromCoordinates(coordinates);

    return Container(
      height: height * 0.22,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            top: height * -0.24,
            right: width * -0.2,
            child: Container(
              width: width * 0.8,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [color1, color2]),
                  boxShadow: [
                    BoxShadow(
                        color: color2,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 10.0)
                  ]),
            ),
          ),
          Positioned(
            top: height * 0.06,
            right: width * 0.08,
            bottom: 0,
            child: Text(
              "! مرحبًا" " ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Positioned(
            top: height * 0.1,
            right: width * 0.09,
            child: Text(
              username,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget list() => ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _childrenList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return HomelistBox(_childrenList[index] as childrenList, markersMap);
      });

  Map<String, Marker> markersMap = {};
  DatabaseReference topRef = FirebaseDatabase.instance.ref("devices");

  Map<String, Circle> circlesMap = {};
  Map<String, BitmapDescriptor> markupIcons = {};
  Future<void> getChildrenList() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = await _auth.currentUser;
    if (!mounted) return;
    final userid = user!.uid;

    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .collection('children')
        .orderBy('birthday', descending: true)
        .get();
    if (!mounted) return;

    if (!mounted) return;

    // _childrenList =
    //     List.from(data.docs.map((doc) => childrenList.fromSnapshot(doc)));
    _childrenList = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
      childDocsId.add(doc.id);
      _childrenList.add(childrenList.fromSnapshot(doc));
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("devices/${doc.id}");
      DataSnapshot temp = await ref.get();
      Map deviceData = temp.value as Map;
      if (deviceData["lat"].toInt() == 0 && deviceData["long"].toInt() == 0) {
        continue;
      }
      http.Response response =
          await http.get(Uri.parse(_childrenList.last.childImagePath!));
      final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
          response.bodyBytes.buffer.asUint8List(),
          targetHeight: 50,
          targetWidth: 50);
      int size = 60;
      final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);

      final Path clipPath = Path();
      clipPath.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
          Radius.circular(150)));
      clipPath.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(size / 2.toDouble(), size + 20.toDouble(), 10, 10),
          Radius.circular(150)));
      canvas.clipPath(clipPath);
      paintImage(
          canvas: canvas,
          rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
          image: frameInfo.image);

      //convert canvas as PNG bytes
      final _image = await pictureRecorder
          .endRecording()
          .toImage(size, (size * 1.1).toInt());
      final data = await _image.toByteData(format: ui.ImageByteFormat.png);
      final ByteData? byteData =
          await _image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List resizedImageMarker = byteData!.buffer.asUint8List();

      circlesMap[doc.id] = Circle(
          circleId: CircleId(doc.id),
          center: LatLng(
              deviceData["lat"].toDouble(), deviceData["long"].toDouble()),
          radius: 100,
          fillColor: Colors.blue.withOpacity(0.2),
          strokeWidth: 0);
      markupIcons[doc.id] = BitmapDescriptor.fromBytes(resizedImageMarker);
      markersMap[doc.id] = Marker(
        icon: BitmapDescriptor.fromBytes(resizedImageMarker),
        markerId: MarkerId(doc.id),
        position:
            LatLng(deviceData["lat"].toDouble(), deviceData["long"].toDouble()),
        // icon: BitmapDescriptor.fromBytes(response.bodyBytes),
      );
      // dbReferences[doc.id]!.onValue.listen((event) {
      //   print(event.snapshot.value);
      //   Map newData = event.snapshot.value as Map;
      //   markersMap[doc.id] = Marker(
      //     markerId: MarkerId(doc.id),
      //     position: LatLng(childrenLatLong[doc.id]!["lat"],
      //         childrenLatLong[doc.id]!["long"]),
      //     // icon: BitmapDescriptor.fromBytes(response.bodyBytes),
      //   );
      //   setState(() {
      //     markersSet = Set<Marker>.of(markersMap.values);
      //   });
      // });

    }
    setState(() {});
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
      markers: Set<Marker>.of(zoneList.markers + markersMap.values.toList()),
      myLocationButtonEnabled: true,
      initialCameraPosition: _myCurrentLocationCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        setState(() {
          _mapcontroller.complete(controller);
        });
      },
      circles: Set.of((circle != null)
          ? [circle] + circlesMap.values.toList()
          : circlesMap.values.toList()),
      polygons: zoneList.polygons,
    );
  }
}
