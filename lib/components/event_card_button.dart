import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedInUser;
List volunteersList = [];
List attendanceList = [];

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
    getArrayData();
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

  void getArrayData() async {
    DocumentReference document =
        _fireStore.collection('events').doc(widget.eventID);
    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        Map<String, dynamic> data = snapshot.data();
        volunteersList = data['volunteers'];
        attendanceList = data['attendance'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    return widget.eventClass == 'All'
        ? PopupMenuButton(
            onSelected: (value) {
              getArrayData();
              if (value == 'Volunteer' &&
                  widget.volunteersCounter <= widget.noOfVolunteers) {
                _fireStore.collection('events').doc(widget.eventID).update({
                  'volunteers': FieldValue.arrayUnion([loggedInUser.email]),
                  'volunteersCounter': widget.volunteersCounter + 1,
                  'noOfVolunteers': widget.noOfVolunteers - 1,
                });
              } else if (value == 'volunteerCanceled') {
                _fireStore.collection('events').doc(widget.eventID).update({
                  'volunteers': FieldValue.arrayRemove([loggedInUser.email]),
                  'volunteersCounter': widget.volunteersCounter - 1,
                  'noOfVolunteers': widget.noOfVolunteers + 1,
                });
              } else if (value == 'Attend' &&
                  widget.attendanceCounter <= widget.noOfAttendance) {
                _fireStore.collection('events').doc(widget.eventID).update({
                  'attendance': FieldValue.arrayUnion([loggedInUser.email]),
                  'attendanceCounter': widget.attendanceCounter + 1,
                  'noOfAttendees': widget.noOfAttendance - 1,
                });
              } else if (value == 'attendCanceled') {
                _fireStore.collection('events').doc(widget.eventID).update({
                  'attendance': FieldValue.arrayRemove([loggedInUser.email]),
                  'attendanceCounter': widget.attendanceCounter - 1,
                  'noOfAttendees': widget.noOfAttendance + 1,
                });
              }
            },
            icon: Icon(Icons.adaptive.more, color: Colors.white),
            elevation: 5,
            color: Colors.black87,
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                      value:
                          volunteersList.contains(loggedInUser.email) == false
                              ? 'Volunteer'
                              : 'volunteerCanceled',
                      child: volunteersList.contains(loggedInUser.email) ==
                              false
                          ? Text(
                              'Volunteer',
                              style: kEventCardButtonTextStyle,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Volunteer',
                                  style: kEventCardButtonTextStyle,
                                ),
                                Icon(Icons.check, color: Colors.greenAccent)
                              ],
                            )),
                  PopupMenuItem(
                      value:
                          attendanceList.contains(loggedInUser.email) == false
                              ? 'Attend'
                              : 'attendCanceled',
                      child: attendanceList.contains(loggedInUser.email) ==
                              false
                          ? Text(
                              'Attend',
                              style: kEventCardButtonTextStyle,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Attend',
                                  style: kEventCardButtonTextStyle,
                                ),
                                Icon(Icons.check, color: Colors.greenAccent)
                              ],
                            )),
                ])
        : widget.eventClass == 'Volunteering'
            ? PopupMenuButton(
                onSelected: (value) {
                  getArrayData();
                  if (value == 'Volunteer' &&
                      widget.volunteersCounter <= widget.noOfVolunteers) {
                    _fireStore.collection('events').doc(widget.eventID).update({
                      'volunteers': FieldValue.arrayUnion([loggedInUser.email]),
                      'volunteersCounter': widget.volunteersCounter + 1,
                      'noOfVolunteers': widget.noOfVolunteers - 1,
                    });
                  } else if (value == 'volunteerCanceled') {
                    _fireStore.collection('events').doc(widget.eventID).update({
                      'volunteers':
                          FieldValue.arrayRemove([loggedInUser.email]),
                      'volunteersCounter': widget.volunteersCounter - 1,
                      'noOfVolunteers': widget.noOfVolunteers + 1,
                    });
                  }
                },
                icon: Icon(Icons.adaptive.more, color: Colors.white),
                elevation: 5,
                color: Colors.black87,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                          value: volunteersList.contains(loggedInUser.email) ==
                                  false
                              ? 'Volunteer'
                              : 'volunteerCanceled',
                          child: volunteersList.contains(loggedInUser.email) ==
                                  false
                              ? Text(
                                  'Volunteer',
                                  style: kEventCardButtonTextStyle,
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Volunteer',
                                      style: kEventCardButtonTextStyle,
                                    ),
                                    Icon(Icons.check, color: Colors.greenAccent)
                                  ],
                                )),
                    ])
            : PopupMenuButton(
                onSelected: (value) {
                  getArrayData();
                  if (value == 'Attend' &&
                      widget.attendanceCounter <= widget.noOfAttendance) {
                    _fireStore.collection('events').doc(widget.eventID).update({
                      'attendance': FieldValue.arrayUnion([loggedInUser.email]),
                      'attendanceCounter': widget.attendanceCounter + 1,
                      'noOfAttendees': widget.noOfAttendance - 1,
                    });
                  } else if (value == 'attendCanceled') {
                    _fireStore.collection('events').doc(widget.eventID).update({
                      'attendance':
                          FieldValue.arrayRemove([loggedInUser.email]),
                      'attendanceCounter': widget.attendanceCounter - 1,
                      'noOfAttendees': widget.noOfAttendance + 1,
                    });
                  }
                },
                icon: Icon(Icons.adaptive.more, color: Colors.white),
                elevation: 5,
                color: Colors.black87,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                          value: attendanceList.contains(loggedInUser.email) ==
                                  false
                              ? 'Attend'
                              : 'attendCanceled',
                          child: attendanceList.contains(loggedInUser.email) ==
                                  false
                              ? Text(
                                  'Attend',
                                  style: kEventCardButtonTextStyle,
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Attend',
                                      style: kEventCardButtonTextStyle,
                                    ),
                                    Icon(Icons.check, color: Colors.greenAccent)
                                  ],
                                )),
                    ]);
  }
}
