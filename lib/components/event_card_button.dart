import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteering/screens/coming_list.dart';
import 'package:volunteering/services/events_stream_builder.dart';
import 'package:volunteering/components/radio_button.dart';

final _fireStore = FirebaseFirestore.instance;

const inactiveColor = Colors.white;
const activeColor = Color(0xff0962ff);

class EventCardButton extends StatefulWidget {
  final eventClass;
  final String eventID;
  final int volunteersCounter;
  final int attendanceCounter;
  final int noOfVolunteers;
  final int noOfAttendance;
  final List volunteersList;
  final List attendanceList;
  final List comingVolunteerID;
  final List comingAttendanceID;
  final String screen;
  final userEmail;
  EventCardButton({
    @required this.eventClass,
    @required this.eventID,
    @required this.volunteersCounter,
    @required this.attendanceCounter,
    @required this.noOfVolunteers,
    @required this.noOfAttendance,
    @required this.volunteersList,
    @required this.attendanceList,
    @required this.comingVolunteerID,
    @required this.comingAttendanceID,
    @required this.screen,
    @required this.userEmail,
  });
  @override
  _EventCardButtonState createState() => _EventCardButtonState();
}

class _EventCardButtonState extends State<EventCardButton> {
  void addRemoveEvent(value) {
    if (value == 'Volunteer' &&
        widget.volunteersCounter <= widget.noOfVolunteers) {
      _fireStore.collection('events').doc(widget.eventID).update({
        'volunteers': FieldValue.arrayUnion([loggedInUser.email]),
        'comingVolunteerID': FieldValue.arrayUnion([loggedInUser.uid]),
        'all': FieldValue.arrayUnion([loggedInUser.email]),
        'volunteersCounter': widget.volunteersCounter + 1,
        'noOfVolunteers': widget.noOfVolunteers - 1,
      });
    } else if (value == 'volunteerCanceled') {
      _fireStore.collection('events').doc(widget.eventID).update({
        'volunteers': FieldValue.arrayRemove([loggedInUser.email]),
        'comingVolunteerID': FieldValue.arrayRemove([loggedInUser.uid]),
        'all': FieldValue.arrayRemove([loggedInUser.email]),
        'volunteersCounter': widget.volunteersCounter - 1,
        'noOfVolunteers': widget.noOfVolunteers + 1,
      });
    } else if (value == 'Attend' &&
        widget.attendanceCounter <= widget.noOfAttendance) {
      _fireStore.collection('events').doc(widget.eventID).update({
        'attendance': FieldValue.arrayUnion([loggedInUser.email]),
        'comingAttendanceID': FieldValue.arrayUnion([loggedInUser.uid]),
        'all': FieldValue.arrayUnion([loggedInUser.email]),
        'attendanceCounter': widget.attendanceCounter + 1,
        'noOfAttendees': widget.noOfAttendance - 1,
      });
    } else if (value == 'attendCanceled') {
      _fireStore.collection('events').doc(widget.eventID).update({
        'attendance': FieldValue.arrayRemove([loggedInUser.email]),
        'comingAttendanceID': FieldValue.arrayRemove([loggedInUser.uid]),
        'all': FieldValue.arrayRemove([loggedInUser.email]),
        'attendanceCounter': widget.attendanceCounter - 1,
        'noOfAttendees': widget.noOfAttendance + 1,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (widget.screen == 'events' && widget.userEmail != loggedInUser.email)
        ? widget.eventClass == 'All'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () => {
                              widget.volunteersList.contains(loggedInUser.email)
                                  ? addRemoveEvent('volunteerCanceled')
                                  : addRemoveEvent('Volunteer'),
                            },
                        child: RadioButton(
                          selected: 'Volunteer',
                          screen: 'events',
                          colour:
                              widget.volunteersList.contains(loggedInUser.email)
                                  ? activeColor.withOpacity(0.17)
                                  : inactiveColor.withOpacity(0.06),
                        )),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => {
                        widget.attendanceList.contains(loggedInUser.email)
                            ? addRemoveEvent('attendCanceled')
                            : addRemoveEvent('Attend'),
                      },
                      child: RadioButton(
                        selected: 'Attend',
                        screen: 'events',
                        colour:
                            widget.attendanceList.contains(loggedInUser.email)
                                ? activeColor.withOpacity(0.17)
                                : inactiveColor.withOpacity(0.06),
                      ),
                    ),
                  ),
                ],
              )
            : widget.eventClass == 'Volunteering'
                ? GestureDetector(
                    onTap: () => {
                          widget.volunteersList.contains(loggedInUser.email)
                              ? addRemoveEvent('volunteerCanceled')
                              : addRemoveEvent('Volunteer'),
                        },
                    child: RadioButton(
                      selected: 'Volunteer',
                      screen: 'events',
                      colour: widget.volunteersList.contains(loggedInUser.email)
                          ? activeColor.withOpacity(0.17)
                          : inactiveColor.withOpacity(0.06),
                    ))
                : GestureDetector(
                    onTap: () => {
                      widget.attendanceList.contains(loggedInUser.email)
                          ? addRemoveEvent('attendCanceled')
                          : addRemoveEvent('Attend'),
                    },
                    child: RadioButton(
                      selected: 'Attend',
                      screen: 'events',
                      colour: widget.attendanceList.contains(loggedInUser.email)
                          ? activeColor.withOpacity(0.17)
                          : inactiveColor.withOpacity(0.06),
                    ),
                  )
        : GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ComingList(
                          volunteersList: widget.comingVolunteerID,
                          attendanceList: widget.comingAttendanceID,
                        )),
              ),
            },
            child: RadioButton(
              selected: 'Coming List',
              screen: 'events',
              colour: inactiveColor.withOpacity(0.06),
            ),
          );
  }
}
