import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedInUser;

class EventCardButton extends StatefulWidget {
  final eventClass;
  final String eventID;
  final int volunteersCounter;
  final int attendanceCounter;
  final int noOfVolunteers;
  final int noOfAttendance;
  EventCardButton({
    @required this.eventClass,
    @required this.eventID,
    @required this.volunteersCounter,
    @required this.attendanceCounter,
    @required this.noOfVolunteers,
    @required this.noOfAttendance,
  });
  @override
  _EventCardButtonState createState() => _EventCardButtonState();
}

class _EventCardButtonState extends State<EventCardButton> {
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.eventClass == 'All'
        ? PopupMenuButton(
            onSelected: (value) {
              if (value == 'Volunteer' &&
                  widget.volunteersCounter <= widget.noOfVolunteers) {
                _fireStore.collection('events').doc(widget.eventID).update({
                  'volunteers': FieldValue.arrayUnion([loggedInUser.email]),
                  'volunteersCounter': widget.volunteersCounter + 1,
                  'noOfVolunteers': widget.noOfVolunteers - 1,
                });
              } else if (value == 'Attend' &&
                  widget.attendanceCounter <= widget.noOfAttendance) {
                _fireStore.collection('events').doc(widget.eventID).update({
                  'attendance': FieldValue.arrayUnion([loggedInUser.email]),
                  'attendanceCounter': widget.attendanceCounter + 1,
                  'noOfAttendees': widget.noOfAttendance - 1,
                });
              }
            },
            icon: Icon(Icons.adaptive.more, color: Colors.white),
            elevation: 10,
            color: Colors.black87,
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: 'Volunteer',
                    child: Text(
                      'Volunteer',
                      style: kEventCardButtonTextStyle,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'Attend',
                    child: Text(
                      'Attend',
                      style: kEventCardButtonTextStyle,
                    ),
                  ),
                ])
        : widget.eventClass == 'Volunteering'
            ? PopupMenuButton(
                onSelected: (value) {
                  if (value == 'Volunteer' &&
                      widget.volunteersCounter <= widget.noOfVolunteers) {
                    _fireStore.collection('events').doc(widget.eventID).update({
                      'volunteers': FieldValue.arrayUnion([loggedInUser.email]),
                      'volunteersCounter': widget.volunteersCounter + 1,
                      'noOfVolunteers': widget.noOfVolunteers - 1,
                    });
                  }
                },
                icon: Icon(Icons.adaptive.more, color: Colors.white),
                elevation: 10,
                color: Colors.black87,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      const PopupMenuItem(
                        value: 'Volunteer',
                        child: Text(
                          'Volunteer',
                          style: kEventCardButtonTextStyle,
                        ),
                      ),
                    ])
            : PopupMenuButton(
                onSelected: (value) {
                  if (value == 'Attend' &&
                      widget.attendanceCounter <= widget.noOfAttendance) {
                    _fireStore.collection('events').doc(widget.eventID).update({
                      'attendance': FieldValue.arrayUnion([loggedInUser.email]),
                      'attendanceCounter': widget.attendanceCounter + 1,
                      'noOfAttendees': widget.noOfAttendance - 1,
                    });
                  }
                },
                icon: Icon(Icons.adaptive.more, color: Colors.white),
                elevation: 10,
                color: Colors.black87,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      const PopupMenuItem(
                        value: 'Attend',
                        child: Text(
                          'Attend',
                          style: kEventCardButtonTextStyle,
                        ),
                      ),
                    ]);
  }
}
