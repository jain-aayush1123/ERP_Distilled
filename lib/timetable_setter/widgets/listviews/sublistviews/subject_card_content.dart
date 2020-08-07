import 'package:flutter/material.dart';

class SubjectCardContent extends StatelessWidget {
  final String coursecode;
  SubjectCardContent({this.coursecode});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(coursecode),
    );
  }
}
