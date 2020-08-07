import 'package:erp_distilled/timetable_setter/data/timetable_repo.dart';
import 'package:erp_distilled/timetable_setter/widgets/timetable_view/timetable_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'listviews/sublistviews/list_view_classes.dart';
import 'listviews/sublistviews/list_view_course_types.dart';
import 'listviews/sublistviews/sub_code_list_view.dart';

var repo = new TimetableRepo();
int length = 10;
List courseCodeList;
List distinctCourseCodeList;
List completeTimetableList = [];
List revievedEntries = new List();
List timetableEntries = new List();
Future getDistinctCourseCodeList() async {
  completeTimetableList = await repo.convertCSVtoList();
  courseCodeList = new List();
  distinctCourseCodeList = new List();

  completeTimetableList.forEach((f) {
    courseCodeList.add(f.courseCode);
  });
  distinctCourseCodeList = [
    ...{...courseCodeList}
  ];

  return distinctCourseCodeList;
}

Future getAllCourseTypes(String courseCode) async {
  completeTimetableList = await repo.convertCSVtoList();
  List courseTypes = new List();
  List distinctCourseType = new List();

  completeTimetableList.forEach((f) {
    if (f.courseCode == courseCode) {
      courseTypes.add(f.courseType);
    }
  });

  distinctCourseType = [
    ...{...courseTypes}
  ];
  return distinctCourseType;
}

Future getClassesOfCourseType(String courseCode, String courseType) async {
  completeTimetableList = await repo.convertCSVtoList();
  List classes = new List();
  // List distinctCourseType = new List();

  completeTimetableList.forEach((f) {
    if (f.courseCode == courseCode && f.courseType == courseType) {
      classes.add(f);
    }
  });

  // distinctCourseType = [
  //   ...{...courseTypes}
  // ];
  return classes;
}

class TimetableSetter extends StatefulWidget {
  @override
  _TimetableSetterState createState() => _TimetableSetterState();
}

class _TimetableSetterState extends State<TimetableSetter> {
  String recievedCourseCode = "";
  String recievedCourseType = "";
  var recievedClass = "";
  bool setClassesBack = false;

  bool flag = false;

  _getCourseCode(String text) {
    setState(() {
      recievedCourseCode = text;
      flag = true;
    });
  }

  _getClasses(String recieved) {
    setState(() {
      if (recieved == "Cancel") {
        //do something
      }
      recievedCourseType = recieved;
    });
  }

  _setClasses(var recievedTappedList) {
    setState(() {
      //i have a list here recievedTappedList this will be passed to timtable main and processed there
      revievedEntries = recievedTappedList;
    });
  }

  _setClassesAfterDelete(var entries) {
    setState(() {
      timetableEntries = entries;
      revievedEntries = new List();
    });
  }

  _setClassesBackHandle(String bool) {
    setState(() {
      setClassesBack = true;
    });
  }

  _setTimetableEntries(var entries) {
    setState(() {
      timetableEntries = entries;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ERP Distilled',
      home: Scaffold(
        body: SafeArea(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: [0.1, 0.9],
                      colors: [
                        Color(0x4f17ead9),
                        Color(0x4f6078ea),
                      ],
                    ),
                  ),
                  child: flag == false || recievedCourseType == "Back"
                      ? listViewCourseCodes(context)
                      : recievedCourseType == "" || setClassesBack == true
                          ? listViewCourseType(context, recievedCourseCode)
                          : listViewClasses(
                              context, recievedCourseCode, recievedCourseType),
                ),
                // : Text("awsm"),
              ),
              Expanded(
                flex: 3,
                child: TimetableMain(
                  revievedEntries,
                  timetableEntries,
                  _setTimetableEntries,
                  _setClassesAfterDelete,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listViewCourseCodes(BuildContext context) {
    setState(() {
      recievedCourseType = "";
    });
    return FutureBuilder(
      future: getDistinctCourseCodeList(),
      initialData: completeTimetableList = new List(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Please wait its loading...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return SubListView(
              snapshot.data,
              _getCourseCode,
            );
          // snapshot.data  :- get your object which is pass from future function
        }
      },
    );
  }

  Widget listViewCourseType(BuildContext context, String courseCode) {
    setClassesBack = false;
    return FutureBuilder(
      future: getAllCourseTypes(courseCode),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Please wait its loading...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return ListViewCourseType(courseCode, snapshot.data, _getClasses);
          // snapshot.data  :- get your object which is pass from future function
        }
      },
    );
  }

  Widget listViewClasses(
    BuildContext context,
    String courseCode,
    String courseType,
  ) {
    return FutureBuilder(
      future: getClassesOfCourseType(courseCode, courseType),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Please wait its loading...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return ListViewClasses(
                courseCode, snapshot.data, _setClasses, _setClassesBackHandle);
          // snapshot.data  :- get your object which is pass from future function
        }
      },
    );
  }
}
