import 'package:flutter/material.dart';

class SubText extends StatefulWidget {
  SubText({this.first, this.last});
  final String first;
  final String last;
  @override
  _SubTextState createState() => _SubTextState();
}

class _SubTextState extends State<SubText> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: widget.first,
          style: TextStyle(
            color: Colors.white.withOpacity(0.60),
            fontFamily: 'Product Sans',
          ),
        ),
        TextSpan(
          text: widget.last,
          style: TextStyle(
            //fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Aclonica',
          ),
        ),
      ]),
    );
  }
}
