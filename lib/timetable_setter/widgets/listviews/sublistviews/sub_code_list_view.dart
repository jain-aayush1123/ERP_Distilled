import 'package:flutter/material.dart';
import './subject_card_content.dart';

class SubListView extends StatefulWidget {
  final List completeList;
  final ValueChanged<String> parentAction;
  SubListView(this.completeList, this.parentAction);

  @override
  _SubListViewState createState() => _SubListViewState();
}

class _SubListViewState extends State<SubListView> {
  TextEditingController controller = new TextEditingController();
  String filter;

  @override
  SubListView get widget => super.widget;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.lightBlue[50],
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
            child: TextField(
              decoration: new InputDecoration(
                labelText: "Course Code: ",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: TextStyle(color: Colors.white),
              controller: controller,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.completeList.length,
              itemBuilder: (BuildContext context, int index) {
                return filter == null || filter == ""
                    ? cardView(context, index)
                    : widget.completeList
                            .elementAt(index)
                            .toLowerCase()
                            .contains(filter.toLowerCase())
                        ? cardView(context, index)
                        : Container(
                            child: Center(
                              child: Container(),
                            ),
                          );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget cardView(BuildContext context, int index) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue[300],
        onTap: () {
          //destroy widget here
          widget.parentAction("${widget.completeList.elementAt(index)}");
        },
        child: SubjectCardContent(
          coursecode: widget.completeList.elementAt(index),
        ),
      ),
    );
  }
}
