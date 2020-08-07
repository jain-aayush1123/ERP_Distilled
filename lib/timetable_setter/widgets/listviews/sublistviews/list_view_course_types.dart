import 'package:erp_distilled/utils/colors.dart';
import 'package:flutter/material.dart';

class ListViewCourseType extends StatefulWidget {
  final List courseTypes;
  final String courseCode;
  final ValueChanged<String> parentAction;

  ListViewCourseType(this.courseCode, this.courseTypes, this.parentAction);
  @override
  _ListViewCourseTypeState createState() => _ListViewCourseTypeState();
}

class _ListViewCourseTypeState extends State<ListViewCourseType> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.courseCode,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.courseTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: InkWell(
                        onTap: () {
                          widget.parentAction(
                              widget.courseTypes.elementAt(index));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            widget.courseTypes.elementAt(index),
                            style: TextStyle(),
                          ),
                        ),
                      ),
                    );
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
                widget.parentAction("Back");
              },
              // foregroundColor: Colors.red,
              foregroundColor: MColors.accentColor,
            ),
          ),
        ),
      ],
    );
  }
}
