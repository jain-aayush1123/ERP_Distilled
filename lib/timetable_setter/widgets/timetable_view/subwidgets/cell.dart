import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  final List dayList;
  final int index;
  Cell(this.dayList, this.index);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  dayList.elementAt(index).courseCode.split(' ')[0] + " ",
                ),
                Text(
                  dayList.elementAt(index).courseCode.split(' ')[1],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                (index + 1).toString() + " ",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.lightBlue[100],
                ),
              ),
              Text(
                dayList.elementAt(index).courseType[0] +
                    dayList.elementAt(index).section,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              Text(
                (index + 1).toString() + " ",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.transparent,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
