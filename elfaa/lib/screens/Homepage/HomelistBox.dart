import 'package:elfaa/screens/Homepage/childrenList.dart';
import 'package:elfaa/screens/mngChildInfo/veiwChild.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:point_in_polygon/point_in_polygon.dart';

import '../../zones.dart';

class HomelistBox extends StatelessWidget {
  HomelistBox(
      this._childlist, this.markersMap, this.childsLocations, this.zoneList);
  childrenList _childlist;
  Map<String, Map> childsLocations;
  Map<String, Marker> markersMap;
  zones zoneList;

  String updateZone() {
    zoneList.add();
    zoneList.addZonesName();
    var theZoneName = "";
    if (childsLocations[_childlist.childID]!['lat'] != 0) {
      Point point = Point(
          x: childsLocations[_childlist.childID]!['lat'],
          y: childsLocations[_childlist.childID]!['long']);

      for (int i = 0; i < zoneList.zoneName.length; i++) {
        if (Poly.isPointInPolygon(point, zoneList.zoneNames[i]!['points'])) {
          theZoneName = zoneList.zoneNames[i]!['name'];
        }
      }
    }
    return theZoneName;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey<ScaffoldState>();
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 18, right: 18, top: 1),
        child: InkWell(
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Color(0xff484848).withOpacity(.3),
                  offset: Offset(0, 4),
                  blurRadius: 8)
            ], color: Colors.white, borderRadius: BorderRadius.circular(12)),
            height: height * 0.12,
            // width: width * 0.00001,
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    //padding: EdgeInsets.only(left: 10),
                    child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => viewChild(
                              childID: "${_childlist.childID}",
                              childImage: "${_childlist.childImagePath}",
                              childname: "${_childlist.childName}",
                              childbirthday: "${_childlist.childbirthday}",
                              childHeight: _childlist.childHeight!,
                              childGender: "${_childlist.childGender}")),
                    );
                  },
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.black,
                )),
                Row(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                // Container(
                                //     height: 10,
                                //     width: 10,
                                //     decoration: BoxDecoration(
                                //         shape: BoxShape.circle,
                                //         color: _childlist.status == true
                                //             ? Colors.red
                                //             : Colors.green)),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      right: width * 0.05,
                                      // left: 0.1,
                                      top: 0.1,
                                      bottom: 0.1),
                                  child: Text(
                                    "${_childlist.childName}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 41, 41, 32)),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                right: width * 0.05,
                                //left: 0.1,
                                //top: 0.01,
                                //bottom: 0.1
                              ),
                              child: Text("${updateZone()}",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey)),
                            ),
                            markersMap.containsKey(_childlist.childID)
                                ? SizedBox()
                                : Padding(
                                    padding: EdgeInsets.only(
                                        right: width * 0.05,
                                        //left: 0.1,
                                        //top: 0.1,
                                        bottom: 0.1),
                                    child: Text(
                                      "الجهاز غير متصل",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.red),
                                    ),
                                  ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(1),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: networkImg(
                                "${_childlist.childImagePath}", width, height),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => viewChild(
                      childID: "${_childlist.childID}",
                      childImage: "${_childlist.childImagePath}",
                      childname: "${_childlist.childName}",
                      childbirthday: "${_childlist.childbirthday}",
                      childHeight: _childlist.childHeight!,
                      childGender: "${_childlist.childGender}")),
            );
          },
        ));
  }
}

networkImg(String childImage, double ScreenWidth, double ScreenHeight) {
  try {
    return Image.network(
      childImage,
      width: ScreenWidth * 0.15,
      height: ScreenHeight * 0.33,
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

//const childrenList({
  //  Key? key,
    //required this.childImagePath,
   // required this.childName,
   // required this.zoneName,
 // }) : super(key: key);