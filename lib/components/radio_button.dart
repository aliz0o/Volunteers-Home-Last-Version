import 'package:flutter/material.dart';

class RadioButton extends StatefulWidget {
  final String selected;
  final Color colour;
  RadioButton({this.selected, this.colour});
  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Center(
        child: Text(
          widget.selected,
          style: TextStyle(
              fontFamily: 'Aclonica', fontSize: 17, color: Colors.white),
        ),
      ),
      height: 50,
      width: 154,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.colour,
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
        ),
      ),
    );
  }
}
