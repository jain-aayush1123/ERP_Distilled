import 'package:erp_distilled/dashboard/widgets/dashboard.dart';
import 'package:erp_distilled/dashboard/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final Color backgroundColor = Color(0xFF4A4A58);

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  List list = new List();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
    list.add("aayush");
    list.add("awsm");
    list.add("blah");
    list.add("value");
    list.add("aayush");
    list.add("awsm");
    list.add("blah");
    list.add("value");
    list.add("aayush");
    list.add("awsm");
    list.add("blah");
    list.add("value");
    list.add("aayush");
    list.add("awsm");
    list.add("blah");
    list.add("value");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.portraitUp,
    // ]);
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return SafeArea(
      child: Container(
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              menu(context),
              dashboard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: MenuDash(),
      ),
    );
  }

  Widget dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.50 * screenWidth,
      right: isCollapsed ? 0 : -0.5 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.white,
          animationDuration: duration,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  InkWell(
                    splashColor: Colors.blue[100],
                    onTap: () {
                      setState(() {
                        if (isCollapsed)
                          _controller.forward();
                        else
                          _controller.reverse();

                        setCollapsedState();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.menu,
                        ),
                        Text(
                          "Timetable",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Dashboard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  setCollapsedState() {
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }
}
