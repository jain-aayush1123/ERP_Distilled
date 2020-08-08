import 'package:flutter/material.dart';

class ListViewClasses extends StatefulWidget {
  final List classes;
  final String courseCode;
  final ValueChanged<List> parentAction;
  final ValueChanged<String> parentActionBack;

  ListViewClasses(
    this.courseCode,
    this.classes,
    this.parentAction,
    this.parentActionBack,
  );

  @override
  _ListViewClassesState createState() => _ListViewClassesState();
}

class _ListViewClassesState extends State<ListViewClasses> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: Text(
                  widget.courseCode,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    widget.classes.elementAt(0).courseName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.classes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _classCard(context, index);
                  },
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              mini: true,
              onPressed: () {
                widget.parentActionBack("true");
              },
              // backgroundColor: MColors.accentColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _subtitleText(BuildContext context, String text) {
    return Text(
      text.trim(),
      style: TextStyle(
        fontWeight: FontWeight.w300,
        color: Colors.grey,
      ),
    );
  }

  Widget _classCard(BuildContext context, int index) {
    List hoursList = widget.classes.elementAt(index).hours;
    List daysList = widget.classes.elementAt(index).days;
    final concatHours = StringBuffer();
    final concatDays = StringBuffer();

    hoursList.forEach((hour) {
      concatHours.write(hour + " ");
    });

    daysList.forEach((day) {
      concatDays.write(day + " ");
    });
    return Card(
      child: InkWell(
        onTap: () {
          //*get all the elements with same section number
          List tappedEntries = new List();
          widget.classes.forEach((f) {
            if (f.section == widget.classes.elementAt(index).section) {
              // print(f.instructor);
              tappedEntries.add(f);
            }
          });
          widget.parentAction(tappedEntries);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(widget.classes.elementAt(index).instructor),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _subtitleText(context, concatDays.toString()),
                  _subtitleText(context, concatHours.toString()),
                  _subtitleText(
                      context, widget.classes.elementAt(index).section),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
