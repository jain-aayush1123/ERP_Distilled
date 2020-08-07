import 'package:flutter/material.dart';

class ColumnHeader extends StatelessWidget {
  final String title;
  ColumnHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Color(0xff6078ea),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title.toUpperCase().trim(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
