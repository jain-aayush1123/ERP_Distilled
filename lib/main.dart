import 'package:erp_distilled/authentication/main_login.dart';
import 'package:erp_distilled/timetable_setter/widgets/main_app.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(new MySplashScreen());

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new SplashScreen(
        onClick: () {
          print("AWSM");
          _launchMyPage();
        },
        seconds: 3,
        navigateAfterSeconds: LoginMain(),
        title: new Text(
          'ERP Distilled',
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32.0,
            color: Colors.white,
          ),
        ),
        loadingText: Text(
          "Aayush Jain Production",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
        gradientBackground: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: [0.1, 0.9],
          colors: [
            Color(0xff17ead9),
            Color(0xff6078ea),
          ],
        ),
      ),
    );
  }

  _launchMyPage() async {
    const url = 'https://www.facebook.com/AWSMnesss';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
