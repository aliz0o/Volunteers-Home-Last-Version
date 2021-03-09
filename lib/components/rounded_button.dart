import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function function;
  final Color color;
  RoundedButton({this.text, this.function, this.color});
  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(7.0),
        child: MaterialButton(
          onPressed: function,
          minWidth: scrWidth * 0.83,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: 21, fontFamily: 'Aclonica'),
          ),
        ),
      ),
    );
  }
}
