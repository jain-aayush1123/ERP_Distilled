import 'package:erp_distilled/authentication/login_page.dart';
import 'package:erp_distilled/dashboard/widgets/home_page.dart';
import 'package:erp_distilled/timetable_setter/widgets/main_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginMain extends StatefulWidget {
  @override
  _LoginMainState createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  var userName, userEmail, userUID, userPhotoURL;

  @override
  void initState() {
    super.initState();
    getStringValueSharedPref('userEmail').then((result) {
      setState(() {
        userEmail = result;
      });
    });
    getStringValueSharedPref('userUID').then((result) {
      setState(() {
        userUID = result;
      });
    });
    getStringValueSharedPref('userPhotoURL').then((result) {
      setState(() {
        userPhotoURL = result;
      });
    });
    getStringValueSharedPref('userName').then((result) {
      setState(() {
        userName = result;
      });
    });
    UserData currentUserData =
        UserData(userName, userEmail, userUID, userPhotoURL);
  }

  @override
  Widget build(BuildContext context) {
    print(userName);
    //TODO fix is no auth found
    return Scaffold(
      // body: userName == null ? LoginPage() : HomePage(),
      body: userName == null ? LoginPage() : TimetableSetter(),
    );
  }
}

getStringValueSharedPref(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String stringValue = prefs.getString(key);
  return stringValue;
}

class UserData {
  final String userName;
  final String userEmail;
  final String userUID;
  final String userPhotoURL;

  UserData(this.userName, this.userEmail, this.userUID, this.userPhotoURL);
}
