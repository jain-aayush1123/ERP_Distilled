import 'package:erp_distilled/dashboard/widgets/home_page.dart';
import 'package:erp_distilled/timetable_setter/widgets/main_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;
  print(user.displayName);
  print(user.email);
  print(user.uid);
  print(user.photoUrl);

  addStringToSharedPref('userName', user.displayName);
  addStringToSharedPref('userEmail', user.email);
  addStringToSharedPref('userUID', user.uid);
  addStringToSharedPref('userPhotoURL', user.photoUrl);

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  // return 'signInWithGoogle succeeded: $user';
  if (user != null) {
    return user.email;
  }
  return null;
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}

// getStringValueSharedPref(String key) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String stringValue = prefs.getString(key);
//   return stringValue;
// }

addStringToSharedPref(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        //TODO add background here
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.1, 0.9],
              colors: [
                Color(0xff17ead9),
                Color(0xff6078ea),
              ],
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Welcome",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Text(
                //   "To A Timetable App",
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 38 / 1.6,
                //       fontWeight: FontWeight.w700),
                // ),
                //        SizedBox(
                //        height: 300,
                //    ),
                InkWell(
                  onTap: () async {
                    // signInWithGoogle().whenComplete(() {
                    //   Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //       builder: (context) {
                    //         return HomePage();
                    //       },
                    //     ),
                    //   );
                    // });
                    String blah = await signInWithGoogle();
                    if (blah != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            //TODO redirect to home page to display dashboard
                            // return HomePage();
                            return TimetableSetter();
                          },
                        ),
                      );
                    } else {}
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Let's Begin",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38 / 1.6,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }

  Widget _signOutButton() {
    return RaisedButton(
      onPressed: () {
        signOutGoogle();
      },
      child: Text("awsm"),
    );
  }
}
