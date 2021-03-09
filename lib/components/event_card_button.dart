import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';

class EventCardButton extends StatefulWidget {
  final eventClass;
  EventCardButton({this.eventClass});
  @override
  _EventCardButtonState createState() => _EventCardButtonState();
}

class _EventCardButtonState extends State<EventCardButton> {
  @override
  Widget build(BuildContext context) {
    return widget.eventClass == 'All'
        ? PopupMenuButton(
            icon: Icon(Icons.adaptive.more, color: Colors.white),
            elevation: 10,
            color: Colors.black87,
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    child: Text(
                      'Volunteer',
                      style: kEventCardButtonTextStyle,
                    ),
                  ),
                  const PopupMenuItem(
                    child: Text(
                      'Attend',
                      style: kEventCardButtonTextStyle,
                    ),
                  ),
                ])
        : widget.eventClass == 'Volunteering'
            ? PopupMenuButton(
                icon: Icon(Icons.adaptive.more, color: Colors.white),
                elevation: 10,
                color: Colors.black87,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      const PopupMenuItem(
                        child: Text(
                          'Volunteer',
                          style: kEventCardButtonTextStyle,
                        ),
                      ),
                    ])
            : PopupMenuButton(
                icon: Icon(Icons.adaptive.more, color: Colors.white),
                elevation: 10,
                color: Colors.black87,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      const PopupMenuItem(
                        child: Text(
                          'Attend',
                          style: kEventCardButtonTextStyle,
                        ),
                      ),
                    ]);
  }
}
