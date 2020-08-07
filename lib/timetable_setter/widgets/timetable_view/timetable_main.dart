import 'package:erp_distilled/dashboard/widgets/home_page.dart';
import 'package:erp_distilled/local_storage/data/db.dart';
import 'package:erp_distilled/local_storage/data/db_timetable_entry.dart';
import 'package:erp_distilled/timetable_setter/data/timetable_entry.dart';
import 'package:erp_distilled/timetable_setter/widgets/timetable_view/subwidgets/cell.dart';
import 'package:erp_distilled/timetable_setter/widgets/timetable_view/subwidgets/column_header.dart';
import 'package:erp_distilled/timetable_setter/widgets/timetable_view/timetable.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';

class TimetableMain extends StatefulWidget {
  final List receivedEntries;
  final List timetableEntries;
  final ValueChanged<List> parentAction;
  final ValueChanged<List> parentDeleteAction;

  TimetableMain(
    this.receivedEntries,
    this.timetableEntries,
    this.parentAction,
    this.parentDeleteAction,
  );
  @override
  _TimetableMainState createState() => _TimetableMainState();
}

class _TimetableMainState extends State<TimetableMain> {
  String err = "";
  bool visible = false;
  List listOfAllDays = new List();

  @override
  Widget build(BuildContext context) {
    listOfAllDays = new List();

    TimetableTools tools = new TimetableTools();
    if (widget.timetableEntries.length == 0) {
      //*if the list that we got was null, generate a blank timetable and fill it with recieved entries
      listOfAllDays = tools.generateBlankTimetable();
      setState(() {
        listOfAllDays =
            tools.addToTimetable(listOfAllDays, widget.receivedEntries);
      });
    } else {
      listOfAllDays = widget.timetableEntries;

      bool noClashes =
          tools.checkClashes(listOfAllDays, widget.receivedEntries);
      bool sameCourseCodeTypeClassAbsent = tools.checkSameCourseCodeTypeClass(
          listOfAllDays, widget.receivedEntries);

      if (noClashes && sameCourseCodeTypeClassAbsent) {
        setState(() {
          listOfAllDays =
              tools.addToTimetable(listOfAllDays, widget.receivedEntries);
        });
      } else {
        //show error
      }
    }

    return FabCircularMenu(
      child: Container(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ColumnHeader("Mon"),
                    ColumnHeader("Tue"),
                    ColumnHeader("Wed"),
                    ColumnHeader("Thu"),
                    ColumnHeader("Fri"),
                    ColumnHeader("Sat"),
                  ],
                ),
                Container(
                  color: Colors.white,
                  height: 1,
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      timetableColumn(
                          context, listOfAllDays.elementAt(0), listOfAllDays),
                      timetableColumn(
                          context, listOfAllDays.elementAt(1), listOfAllDays),
                      timetableColumn(
                          context, listOfAllDays.elementAt(2), listOfAllDays),
                      timetableColumn(
                          context, listOfAllDays.elementAt(3), listOfAllDays),
                      timetableColumn(
                          context, listOfAllDays.elementAt(4), listOfAllDays),
                      timetableColumn(
                          context, listOfAllDays.elementAt(5), listOfAllDays),
                    ],
                  ),
                ),
              ],
            ),
            // widget.receivedEntries.length != 0
            //     ? _fabSave(context)
            //     : new Container(),
          ],
        ),
      ),
      ringColor: Colors.indigoAccent[100],
      ringDiameter: MediaQuery.of(context).size.width,
      ringWidth: MediaQuery.of(context).size.width / 4,
      fabColor: Colors.indigoAccent,
      options: <Widget>[
        IconButton(
            icon: Icon(Icons.save),
            splashColor: Colors.indigoAccent[400],
            tooltip: "Save to Local storage",
            onPressed: () {
              widget.parentAction(listOfAllDays);
              _saveToLocalDatabase();
            },
            iconSize: 40.0,
            color: Colors.white),
        IconButton(
            icon: Icon(Icons.sd_card),
            splashColor: Colors.indigoAccent[400],
            tooltip: "Read from Local storage",
            onPressed: () {
              // _saveToLocalDatabase();
              _printLocal();
            },
            iconSize: 40.0,
            color: Colors.white),
        IconButton(
            icon: Icon(Icons.cloud_upload),
            splashColor: Colors.indigoAccent[400],
            tooltip: "Upload to Cloud",
            onPressed: () {},
            iconSize: 40.0,
            color: Colors.white),
        IconButton(
            icon: Icon(Icons.cloud_download),
            splashColor: Colors.indigoAccent[400],
            tooltip: "Download from Cloud",
            onPressed: () {},
            iconSize: 40.0,
            color: Colors.white),
        IconButton(
            icon: Icon(Icons.delete),
            splashColor: Colors.indigoAccent[400],
            tooltip: "Delete All",
            onPressed: () {
              _deleteAll();
            },
            iconSize: 40.0,
            color: Colors.white),
        IconButton(
            icon: Icon(Icons.exit_to_app),
            splashColor: Colors.indigoAccent[400],
            tooltip: "Exit",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return HomePage();
                  },
                ),
              );
            },
            iconSize: 40.0,
            color: Colors.white),
      ],
    );
  }

  Widget timetableColumn(
      BuildContext context, List dayList, List listOfAllDays) {
    return Expanded(
      child: ListView.builder(
        itemCount: dayList.length,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            splashColor: Colors.blue[100],
            onTap: () {
              if (dayList.elementAt(index).courseCode != " ") {
                // widget.parentAction(listOfAllDays);

                _asyncConfirmDialog(
                  context: context,
                  entry: dayList.elementAt(index),
                  listOfAllDays: listOfAllDays,
                );
              }
            },
            child: Cell(dayList, index),
          );
        },
      ),
    );
  }

  Widget _fabSave(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          // mini: true,
          backgroundColor: Colors.purple,
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
          onPressed: () {
            widget.parentAction(listOfAllDays);
          },
        ),
      ),
    );
  }

  Future _asyncConfirmDialog({
    BuildContext context,
    TimetableEntry entry,
    List listOfAllDays,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              entry.courseCode + " - " + entry.courseType[0] + entry.section),
          content: Text(
            "Course Name:" +
                "\t" +
                entry.courseName +
                "\n" +
                "Instructor:" +
                "\t" +
                entry.instructor +
                "\n" +
                "Room:" +
                "\t" +
                entry.room +
                "\n",
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('DELETE'),
              textColor: Colors.red,
              onPressed: () {
                Navigator.of(context).pop(0);
                _deleteClasses(entry);
              },
            ),
            FlatButton(
              child: const Text('DISMISS'),
              onPressed: () {
                Navigator.of(context).pop(1);
              },
            )
          ],
        );
      },
    );
  }

  _saveToLocalDatabase() async {
    DBProvider.db.saveLocal(listOfAllDays);
  }

  _printLocal() async {
    TimetableTools tools = new TimetableTools();
    List readList = await DBProvider.db.readTimetableEntryListFromLocal();
    listOfAllDays = new List();
    listOfAllDays = tools.generateBlankTimetable();

    setState(() {
      listOfAllDays = tools.addToTimetable(listOfAllDays, readList);
      widget.parentAction(listOfAllDays);
    });
  }

  _deleteClasses(TimetableEntry entry) {
    TimetableTools tools = new TimetableTools();
    setState(() {
      listOfAllDays = tools.deleteClassesFromTimetable(listOfAllDays, entry);
      widget.parentAction(listOfAllDays);
      widget.parentDeleteAction(listOfAllDays);
    });

    //FIXME staggered classes - only same time classes get deletd ot the off ones
    //from entry get hours and days and then set the to zero
  }

  _deleteAll() {
    TimetableTools tools = new TimetableTools();

    setState(() {
      listOfAllDays = tools.generateBlankTimetable();
      widget.parentDeleteAction(listOfAllDays);
    });
  }
}
