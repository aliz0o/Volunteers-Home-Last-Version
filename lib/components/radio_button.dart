import 'package:flutter/material.dart';

class RadioButton extends StatefulWidget {
  final String selected;
  final Color colour;
  final String screen;
  RadioButton({this.selected, this.colour, this.screen});
  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: (widget.screen == 'events')
            ? EdgeInsets.symmetric(horizontal: 1, vertical: 2)
            : EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Center(
          child: Text(
            widget.selected,
            style: TextStyle(
                fontFamily: 'Aclonica',
                fontSize: (widget.screen == 'events') ? 13 : 17,
                color: Colors.white),
          ),
        ),
        height: (widget.screen == 'events') ? 30 : 50,
        width: (widget.screen == 'events') ? 500 : 154,
        decoration: BoxDecoration(
          borderRadius: (widget.screen == 'events')
              ? BorderRadius.circular(3)
              : BorderRadius.circular(10),
          color: widget.colour,
          border: Border.all(
            color: (widget.screen == 'events')
                ? Colors.white.withOpacity(0.15)
                : Colors.white.withOpacity(0.25),
          ),
        ),
      ),
    );
  }
}
