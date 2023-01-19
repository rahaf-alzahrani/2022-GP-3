import 'package:elfaa/screens/admin/SecurityList.dart';
import 'package:elfaa/screens/admin/viewSec.dart';
import 'package:flutter/material.dart';
import 'package:elfaa/constants.dart';

class AdminHomeListBox extends StatelessWidget {
  final SecurityList _secList;

  AdminHomeListBox(this._secList);

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
            height: height * 0.1,
            // width: width * 0.00001,
            padding: EdgeInsets.all(7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => viewSec(
                            password: "${_secList.password}",
                            secID: "${_secList.secID}",
                            phoneNo: "${_secList.phoneNo}",
                            secName: "${_secList.secName}",
                            email: "${_secList.email}",
                          )),
                );
                  },
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.black,
                ),
                Container(
                  width: 150,

                  child: Text(
                    "${_secList.secName}",
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromARGB(255, 41, 41, 32)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: width * 0.03),
                  child: CircleAvatar(
                      backgroundColor: kOrangeColor,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ),
          onTap: () {
            print(_secList.secID);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => viewSec(
                        password: "${_secList.password}",
                        secID: "${_secList.secID}",
                        phoneNo: "${_secList.phoneNo}",
                        secName: "${_secList.secName}",
                        email: "${_secList.email}",
                      )),
            );
          },
        ));
  }
}