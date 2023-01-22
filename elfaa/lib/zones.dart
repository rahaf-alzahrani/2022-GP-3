import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:elfaa/screens/Homepage/Home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:point_in_polygon/point_in_polygon.dart';

class zones {
  //zones
  List<String> images = [
    //winter wender land
    "assets/images/parking.png",
    "assets/images/gate.png",
    "assets/images/carnival.png",
    "assets/images/way.png",
    "assets/images/snow.png",
    "assets/images/winter.png",
    "assets/images/gate.png",
    "assets/images/parking.png",
    //winter wender land
    //bolivard
    "assets/images/parking.png",
    //  "assets/images/parking.png",
    "assets/images/gate.png",
    "assets/images/china.png",
    "assets/images/italy.png",
    "assets/images/usa.png", "assets/images/mexico.png",
    "assets/images/india.png",
    "assets/images/spanish.png",
    "assets/images/morocco.png",
    "assets/images/greece.png",
    "assets/images/japan.png",
    "assets/images/gate.png",

    //bolivard
  ];
  List<String> zoneName = [
    //winter wender land
    " مواقف السيارات رقم ١",
    "البوابة الرئيسية رقم ١",
    "دريم لاند كرنفال",
    "طريق العجائب",
    "غابة الثلج",
    "المهرجان الشتوي",
    "بوابة رقم ٢",
    " مواقف السيارات رقم ٢",
    //winter wender land
    //bolivard
    " مواقف السيارات رقم ١",
    //" مواقف السيارات رقم ٢",
    "البوابة الرئيسية رقم ١",
    "دولة الصين ",
    "دولة إيطاليا",
    "دولة الولايات المتحدة",
    "دولة المكسيك", "دولة الهند",
    "دولة أسبانيا",
    "دولة المغرب",
    "دولة اليونان",
    "دولة اليابان",
    "بوابة رقم ٢",
    //bolivard
  ];
  List<LatLng> latLang = [
    //winter wender land
    LatLng(24.773958, 46.642998),
    LatLng(24.772762, 46.643398),
    LatLng(24.771166, 46.645050),
    LatLng(24.770475, 46.644526),
    LatLng(24.770757, 46.643163),
    LatLng(24.767258, 46.646161),
    LatLng(24.765549, 46.646914),
    LatLng(24.764556, 46.647982),
    //winter wender land
    //bolivard
    LatLng(24.772252, 46.599206),
    //LatLng(24.779747, 46.599871),
    LatLng(24.773285, 46.599454),
    LatLng(24.773674, 46.600876),
    LatLng(24.774501, 46.600598),
    LatLng(24.774516, 46.599139),
    LatLng(24.775380, 46.598871),
    LatLng(24.776597, 46.599186),
    LatLng(24.776248, 46.600179),
    LatLng(24.775178, 46.602127),
    LatLng(24.776699, 46.602688),
    LatLng(24.777608, 46.601742),
    LatLng(24.777857, 46.600048),
    //bolivard
  ];
  List<Marker> markers = [];
  //winter wender land
  List<LatLng> c_parking1_W = [
    LatLng(24.773336, 46.644482),
    LatLng(24.772433, 46.642303),
    LatLng(24.774246, 46.641876),
    LatLng(24.775300, 46.642225),
    LatLng(24.775553, 46.642887),
    LatLng(24.775256, 46.643531),
  ];
  List<LatLng> c_mainGate_W = [
    LatLng(24.773166, 46.644561),
    LatLng(24.773336, 46.644482),
    LatLng(24.772433, 46.642303),
    LatLng(24.772227, 46.642378),
  ];
  List<LatLng> carnival_W = [
    LatLng(24.773150, 46.644561),
    LatLng(24.772799, 46.643816),
    LatLng(24.769366, 46.645674),
    LatLng(24.769634, 46.646348),
  ];
  List<LatLng> way_W = [
    LatLng(24.772790, 46.643810),
    LatLng(24.769366, 46.645674),
    LatLng(24.768992, 46.644895),
    LatLng(24.772530, 46.643214),
  ];
  List<Point> way_WW = [
    Point(x: 24.772790, y: 46.643810),
    Point(x: 24.769366, y: 46.645674),
    Point(x: 24.768992, y: 46.644895),
    Point(x: 24.772530, y: 46.643214),
  ];
  List<LatLng> snow_w = [
    LatLng(24.768992, 46.644860),
    LatLng(24.772530, 46.643200),
    LatLng(24.772227, 46.642378),
    LatLng(24.771149, 46.642754),
    LatLng(24.770798, 46.642689),
    LatLng(24.770252, 46.643043),
    LatLng(24.768556, 46.643893),
  ];
  List<LatLng> winter_w = [
    LatLng(24.769600, 46.646340),
    LatLng(24.768520, 46.643890),
    LatLng(24.765217, 46.645624),
    LatLng(24.766252, 46.648034),
  ];
  List<LatLng> c_gate2_w = [
    LatLng(24.765217, 46.645624),
    LatLng(24.766252, 46.648034),
    LatLng(24.765978, 46.648184),
    LatLng(24.765014, 46.645796),
  ];
  List<LatLng> c_parking2_w = [
    LatLng(24.765970, 46.648180),
    LatLng(24.765010, 46.645790),
    LatLng(24.764587, 46.646367),
    LatLng(24.764213, 46.646838),
    LatLng(24.764045, 46.647233),
    LatLng(24.763907, 46.648705),
    LatLng(24.764037, 46.648999),
    LatLng(24.764228, 46.649075),
  ];
  //winter wender land
  //bolivard
  List<LatLng> c_parking1_b = [
    LatLng(24.776649, 46.597483),
    LatLng(24.776507, 46.596910),
    LatLng(24.771279, 46.598833),
    LatLng(24.773749, 46.604866),
    LatLng(24.775397, 46.604203),
    LatLng(24.774433, 46.601921),
    LatLng(24.773992, 46.602074),
    LatLng(24.773149, 46.599744),
    LatLng(24.773199, 46.599453),
    LatLng(24.773363, 46.599161),
  ];
  List<Point> c_parking1_bb = [
    Point(x: 24.776649, y: 46.597483),
    Point(x: 24.776507, y: 46.596910),
    Point(x: 24.771279, y: 46.598833),
    Point(x: 24.773749, y: 46.604866),
    Point(x: 24.775397, y: 46.604203),
    Point(x: 24.774433, y: 46.601921),
    Point(x: 24.773992, y: 46.602074),
    Point(x: 24.773149, y: 46.599744),
    Point(x: 24.773199, y: 46.599453),
    Point(x: 24.773363, y: 46.599161),
  ];
  List<LatLng> c_parking2_b = [
    LatLng(24.781752, 46.602491),
    LatLng(24.779268, 46.596659),
    LatLng(24.777812, 46.597502),
    LatLng(24.780235, 46.603357),
  ];
  List<LatLng> c_gate1_b = [
    LatLng(24.773407, 46.600164),
    LatLng(24.773213, 46.599713),
    LatLng(24.773234, 46.599432),
    LatLng(24.773397, 46.599218),
    LatLng(24.773786, 46.599060),
    LatLng(24.773888, 46.599814),
  ];
  List<LatLng> chaina_b = [
    LatLng(24.773890, 46.599849),
    LatLng(24.773320, 46.600260),
    LatLng(24.773986, 46.602041),
    LatLng(24.774632, 46.601717),
  ];
  List<LatLng> italy_b = [
    LatLng(24.773888, 46.599814),
    LatLng(24.774632, 46.601717),
    LatLng(24.775222, 46.601360),
    LatLng(24.774741, 46.599598),
  ];
  List<LatLng> usa_b = [
    LatLng(24.773888, 46.599814),
    LatLng(24.774741, 46.599598),
    LatLng(24.775568, 46.598109),
    LatLng(24.773786, 46.599060),
  ];
  List<LatLng> mec_b = [
    LatLng(24.775568, 46.598109),
    LatLng(24.774741, 46.599598),
    LatLng(24.775933, 46.599272),
  ];
  List<LatLng> india_b = [
    LatLng(24.776649, 46.597483),
    LatLng(24.775568, 46.598109),
    LatLng(24.775933, 46.599272),
    LatLng(24.777732, 46.600083),
  ];
  List<LatLng> spain_b = [
    LatLng(24.775933, 46.599272),
    LatLng(24.777732, 46.600083),
    LatLng(24.775250, 46.601360),
    LatLng(24.774741, 46.599598),
  ];
  List<LatLng> maroco_b = [
    LatLng(24.774465, 46.601910),
    LatLng(24.775447, 46.604178),
    LatLng(24.775818, 46.601061),
  ];
  List<LatLng> greece_b = [
    LatLng(24.777754, 46.603048),
    LatLng(24.775447, 46.604178),
    LatLng(24.775818, 46.601061),
  ];
  List<LatLng> japan_b = [
    LatLng(24.777754, 46.603048),
    LatLng(24.778860, 46.602487),
    LatLng(24.777732, 46.600083),
    LatLng(24.775818, 46.601061),
  ];
  List<Point> japan_bb = [
    Point(y: 24.777754, x: 46.603048),
    Point(y: 24.778860, x: 46.602487),
    Point(y: 24.777732, x: 46.600083),
    Point(y: 24.775818, x: 46.601061),
  ];
  List<LatLng> c_gate2_b = [
    LatLng(24.777677, 46.599828),
    LatLng(24.777892, 46.599715),
    LatLng(24.778110, 46.599907),
    LatLng(24.778086, 46.600160),
    LatLng(24.777905, 46.600284),
  ];
  //bolivard
  Set<Polygon> polygons = HashSet<Polygon>();
  add() async {
    //winter wender land
    polygons.add(
      Polygon(
        polygonId: PolygonId("1"),
        points: c_parking1_W,
        fillColor: Colors.orange.withOpacity(0.2),
        strokeColor: Colors.orange,
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("2"),
        points: c_mainGate_W,
        fillColor: Colors.red.withOpacity(0.2),
        strokeColor: Colors.red,
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("3"),
        points: carnival_W,
        fillColor: ui.Color.fromARGB(255, 240, 33, 243).withOpacity(0.2),
        strokeColor: ui.Color.fromARGB(255, 240, 33, 243),
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("4"),
        points: way_W,
        fillColor: ui.Color.fromARGB(255, 149, 33, 243).withOpacity(0.2),
        strokeColor: ui.Color.fromARGB(255, 149, 33, 243),
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("5"),
        points: snow_w,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("6"),
        points: winter_w,
        fillColor: ui.Color.fromARGB(255, 33, 243, 44).withOpacity(0.2),
        strokeColor: ui.Color.fromARGB(255, 33, 243, 44),
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("7"),
        points: c_gate2_w,
        fillColor: Colors.red.withOpacity(0.2),
        strokeColor: Colors.red,
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("8"),
        points: c_parking2_w,
        fillColor: Colors.orange.withOpacity(0.2),
        strokeColor: Colors.orange,
        strokeWidth: 2,
      ),
    );
    //winter wender land
    //bolivard
    polygons.add(
      Polygon(
        polygonId: PolygonId("9"),
        points: c_parking1_b,
        fillColor: Colors.orange.withOpacity(0.2),
        strokeColor: Colors.orange,
        strokeWidth: 2,
      ),
    );
    // polygons.add(
    //   Polygon(
    //     polygonId: PolygonId("10"),
    //     points: parking2_b,
    //     fillColor: Colors.orange.withOpacity(0.2),
    //     strokeColor: Colors.orange,
    //     strokeWidth: 2,
    //   ),
    // );
    polygons.add(
      Polygon(
        polygonId: PolygonId("11"),
        points: c_gate1_b,
        fillColor: Colors.red.withOpacity(0.2),
        strokeColor: Colors.red,
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("12"),
        points: chaina_b,
        fillColor: Colors.yellow.withOpacity(0.2),
        strokeColor: Colors.yellow,
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("13"),
        points: italy_b,
        fillColor: Colors.green.withOpacity(0.2),
        strokeColor: Colors.green,
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("14"),
        points: usa_b,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("15"),
        points: mec_b,
        fillColor: ui.Color.fromARGB(255, 117, 243, 33).withOpacity(0.2),
        strokeColor: ui.Color.fromARGB(255, 117, 243, 33),
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("16"),
        points: india_b,
        fillColor: ui.Color.fromARGB(255, 255, 128, 0).withOpacity(0.2),
        strokeColor: ui.Color.fromARGB(255, 255, 128, 0),
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("17"),
        points: spain_b,
        fillColor: ui.Color.fromARGB(255, 255, 0, 0).withOpacity(0.2),
        strokeColor: ui.Color.fromARGB(255, 255, 0, 0),
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("18"),
        points: maroco_b,
        fillColor: ui.Color.fromARGB(255, 255, 0, 0).withOpacity(0.2),
        strokeColor: ui.Color.fromARGB(255, 255, 0, 0),
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("19"),
        points: greece_b,
        fillColor: color1.withOpacity(0.2),
        strokeColor: color1,
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("20"),
        points: japan_b,
        fillColor: ui.Color.fromARGB(255, 255, 114, 217).withOpacity(0.2),
        strokeColor: ui.Color.fromARGB(255, 255, 114, 217),
        strokeWidth: 2,
      ),
    );
    polygons.add(
      Polygon(
        polygonId: PolygonId("21"),
        points: c_gate2_b,
        fillColor: ui.Color.fromARGB(255, 255, 0, 0).withOpacity(0.2),
        strokeColor: ui.Color.fromARGB(255, 255, 0, 0),
        strokeWidth: 2,
      ),
    );
    //bolivard
  }

  LoadData() async {
    for (int i = 0; i < images.length; i++) {
      final Uint8List markerIcon = await getBytesFromAssets(images[i], 50);
      markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: latLang[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(
            title: zoneName[i],
          )));
    }
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
//zones

}
