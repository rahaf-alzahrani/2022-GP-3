import 'package:elfaa/screens/Homepage/Home_page.dart';
import 'package:elfaa/screens/Reportpage/ReportPage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:elfaa/screens/admin/admin_home/admin_home_page.dart';
import 'package:elfaa/screens/admin/admin_alert/admin_alert_page.dart';
import 'package:elfaa/screens/admin/admin_notification/admin_notification_page.dart';
import 'package:elfaa/screens/admin/admin_profile/admin_profile.dart';
import 'package:elfaa/screens/notificationPage/Notepage.dart';
import 'package:elfaa/screens/sg/SG_alert/sg_alert.dart';
import 'package:elfaa/screens/sg/sg_home/sg_home.dart';
import 'package:elfaa/screens/sg/sg_notification/sg_notification.dart';
import 'package:elfaa/screens/sg/sg_profile/sg_profile.dart';
import 'package:flutter/material.dart';
import 'package:elfaa/screens/profile/profile_page.dart';
import 'package:elfaa/constants.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key, this.code = 1});

  final int? code;
  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  final screens = [EditProfilePage(), ReportPage(), Notepage(), HomePage()];

  final screensForSG = [
    SGProfile(),
    SGAlert(),
    SGNotification(),
    SGHomePage(),
  ];

  final screensForAdmin = [
    AdminProfile(),
    AdminAlertPage(),
    AdminNotificationPage(),
    AdminHomePage(),
  ];
  int index = 3;
  void initState() {
    // get current user

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(
        Icons.person,
        color: kOrangeColor,
        size: 30,
      ),
      Icon(
        Icons.campaign,
        color: kOrangeColor,
        size: 30,
      ),
      Icon(
        Icons.notifications,
        color: kOrangeColor,
        size: 30,
      ),
      Icon(
        Icons.home,
        color: kOrangeColor,
        size: 30,
      ),
    ];
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xFFEBEAEA),
      body: widget.code == 0
          ? screens[index]
          : widget.code == 1
              ? screensForAdmin[index]
              : screensForSG[index],
      bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(color: Colors.orange),
          ),
          child: CurvedNavigationBar(
            color: Colors.white,
            buttonBackgroundColor: Colors.white,
            animationDuration: Duration(milliseconds: 300),
            backgroundColor: Color(0xFFfafafa),
            height: 60,
            index: index,
            items: items,
            onTap: (index) => setState(() => this.index = index),
          )),
    );
  }
}
