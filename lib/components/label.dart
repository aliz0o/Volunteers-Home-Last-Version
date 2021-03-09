import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String label;
  Label({this.label});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 54, bottom: 8),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Aclonica',
          ),
        ),
      ),
    );
  }
}
