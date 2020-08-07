import 'package:erp_distilled/dashboard/widgets/home_page.dart';
import 'package:erp_distilled/timetable_setter/widgets/main_app.dart';
import 'package:flutter/material.dart';

class MenuDash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: _menuOption(context, "Dashboard"),
          ),
          InkWell(
            onTap: () {
              _pushTimetableSetter(context);
            },
            child: _menuOption(context, "Set Timetable"),
          ),
          _menuOption(context, "App Credits"),
          _menuOption(context, "Settings"),
        ],
      ),
    );
  }

  Widget _menuOption(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
    );
  }

  void _pushTimetableSetter(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return TimetableSetter();
        },
      ),
    );
  }
}

//menu
// Padding(
//           padding: const EdgeInsets.only(left: 16.0),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text("Dashboard",
//                     style: TextStyle(color: Colors.white, fontSize: 22)),
//                 SizedBox(height: 10),
//                 Text("Messages",
//                     style: TextStyle(color: Colors.white, fontSize: 22)),
//                 SizedBox(height: 10),
//                 Text("Utility Bills",
//                     style: TextStyle(color: Colors.white, fontSize: 22)),
//                 SizedBox(height: 10),
//                 Text("Funds Transfer",
//                     style: TextStyle(color: Colors.white, fontSize: 22)),
//                 SizedBox(height: 10),
//                 Text("Branches",
//                     style: TextStyle(color: Colors.white, fontSize: 22)),
//               ],
//             ),
//           ),
//         ),
