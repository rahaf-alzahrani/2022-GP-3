import 'package:flutter/material.dart';
import 'package:elfaa/screens/welcome/welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    new Future.delayed(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomeScreen()),
            ));
  }

  @override
  Widget build(BuildContext context) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                  margin: const EdgeInsets.only(top: 350, bottom: 0, left: 0),
                  child: Image.asset("assets/images/elfaa.gif",
                      gaplessPlayback: true, fit: BoxFit.fill)));
        
  }
}
