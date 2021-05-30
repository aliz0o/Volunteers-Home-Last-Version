import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volunteering/screens/coming_list.dart';
import 'package:volunteering/components/radio_button.dart';
import 'package:volunteering/screens/events_screen.dart';
import 'package:volunteering/services/events_stream_builder.dart';

final _fireStore = FirebaseFirestore.instance;

final attendSnackBar = SnackBar(
  content: Text('You have already registered as an attendance..',
      style: TextStyle(fontSize: 10, fontFamily: 'Aclonica')),
  elevation: 5,
  backgroundColor: Color(0xff0962ff),
);


final volunteerSnackBar = SnackBar(
  content: Text('You have already registered as volunteer..',
      style: TextStyle(fontSize: 10, fontFamily: 'Aclonica')),
  elevation: 5,
  backgroundColor: Colors.black,
);
sendEmail(email ,subject,body) {
  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      });

  launch(_emailLaunchUri.toString());
}

final reachedVolunteersNumber = SnackBar(
  content: Text('This event has reached the required volunteers Number..',
      style: TextStyle(fontSize: 10, fontFamily: 'Aclonica')),
  elevation: 5,
  backgroundColor: Colors.black,
);
final reachedAttendanceNumber = SnackBar(
  content: Text('This event has reached the required attendance Number..',
      style: TextStyle(fontSize: 10, fontFamily: 'Aclonica')),
  elevation: 5,
  backgroundColor: Colors.black,
);

const inactiveColor = Colors.white;
const activeColor = Color(0xff0962ff);

class EventCardButton extends StatefulWidget {
  final String userEmail;
  final eventClass;
  final String eventID;
  final int volunteersCounter;
  final int attendanceCounter;
  final int noOfVolunteers;
  final int noOfAttendance;
  final List comingVolunteerID;
  final List comingAttendanceID;
  final String screen;
  final userID;
  EventCardButton({
    this.userEmail,
    this.eventClass,
    @required this.eventID,
    this.volunteersCounter,
    this.attendanceCounter,
    this.noOfVolunteers,
    this.noOfAttendance,
    this.comingVolunteerID,
    this.comingAttendanceID,
    this.screen,
    @required this.userID,
  });
  @override
  _EventCardButtonState createState() => _EventCardButtonState();
}

class _EventCardButtonState extends State<EventCardButton> {
  void addRemoveEvent(value) {
    if (value == 'Volunteer' &&
        widget.volunteersCounter < widget.noOfVolunteers) {
      _fireStore.collection('events').doc(widget.eventID).update({
        'comingVolunteerID': FieldValue.arrayUnion([loggedInUser.uid]),
        'all': FieldValue.arrayUnion([loggedInUser.uid]),
        'volunteersCounter': widget.volunteersCounter + 1,
        'noOfVolunteers': widget.noOfVolunteers - 1,
      });
    } else if (value == 'Volunteer' &&
        widget.volunteersCounter >= widget.noOfVolunteers) {
      ScaffoldMessenger.of(context).showSnackBar(reachedVolunteersNumber);
    } else if (value == 'volunteerCanceled') {
      _fireStore.collection('events').doc(widget.eventID).update({
        'comingVolunteerID': FieldValue.arrayRemove([loggedInUser.uid]),
        'all': FieldValue.arrayRemove([loggedInUser.uid]),
        'volunteersCounter': widget.volunteersCounter - 1,
        'noOfVolunteers': widget.noOfVolunteers + 1,
      });
    } else if (value == 'Attend' &&
        widget.attendanceCounter < widget.noOfAttendance) {
      _fireStore.collection('events').doc(widget.eventID).update({
        'comingAttendanceID': FieldValue.arrayUnion([loggedInUser.uid]),
        'all': FieldValue.arrayUnion([loggedInUser.uid]),
        'attendanceCounter': widget.attendanceCounter + 1,
        'noOfAttendees': widget.noOfAttendance - 1,
      });
    } else if (value == 'Attend' &&
        widget.attendanceCounter >= widget.noOfAttendance) {
      ScaffoldMessenger.of(context).showSnackBar(reachedVolunteersNumber);
    } else if (value == 'attendCanceled') {
      _fireStore.collection('events').doc(widget.eventID).update({
        'comingAttendanceID': FieldValue.arrayRemove([loggedInUser.uid]),
        'all': FieldValue.arrayRemove([loggedInUser.uid]),
        'attendanceCounter': widget.attendanceCounter - 1,
        'noOfAttendees': widget.noOfAttendance + 1,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ((widget.screen == 'events' ||
                widget.screen == 'committeeRequest') &&
            loggedInUserType == 'Admin')
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: widget.screen == 'events'
                      ? () => {
                            _fireStore
                                .collection('events')
                                .doc(widget.eventID)
                                .update({
                              'approved': true,
                            }),
                            _fireStore
                                .collection('users')
                                .doc(widget.userID)
                                .update({
                              'eventCount': FieldValue.increment(1),
                            }),

                                 sendEmail(widget.userEmail, "Volunteers Home", 'Thank you for trusting us. Your event has been approved you can check your account .\n All the best wishes for success \n We hope you enjoy using our app')
                          }
                      : () {
                          _fireStore
                              .collection('users')
                              .doc(widget.userID)
                              .update({
                            'verified': true,
                          });
                          sendEmail(widget.userEmail, "Volunteers Home", 'Thank you for trusting us. Your account has been approved as a committee. All the best wishes for success \n We hope you enjoy using our app');
                        },
                  child: RadioButton(
                    selected: 'Approve',
                    screen: 'events',
                    colour: inactiveColor.withOpacity(0.06),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: widget.screen == 'events'
                      ? () => {
                            _fireStore
                                .collection('events')
                                .doc(widget.eventID)
                                .update({
                              'deleted': true,
                            }),
                            _fireStore
                                .collection('users')
                                .doc(widget.userID)
                                .update({
                              'eventCount': FieldValue.increment(-1),
                            }),
                          }
                      : () {
                          _fireStore
                              .collection('users')
                              .doc(widget.userID)
                              .delete();
                        },
                  child: RadioButton(
                    selected: 'Reject',
                    screen: 'events',
                    colour: inactiveColor.withOpacity(0.06),
                  ),
                ),
              ),
            ],
          )
        : ((widget.screen == 'events' && widget.userID != loggedInUser.uid) ||
                (widget.screen == 'comingList' &&
                    widget.userID != loggedInUser.uid))
            ? widget.eventClass == 'All'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                            onTap: () => {
                                  widget.comingAttendanceID
                                          .contains(loggedInUser.uid)
                                      ? ScaffoldMessenger.of(context)
                                          .showSnackBar(attendSnackBar)
                                      : widget.comingVolunteerID
                                              .contains(loggedInUser.uid)
                                          ? addRemoveEvent('volunteerCanceled')
                                          : addRemoveEvent('Volunteer'),
                                },
                            child: RadioButton(
                              selected: 'Volunteer',
                              screen: 'events',
                              colour: widget.comingVolunteerID
                                      .contains(loggedInUser.uid)
                                  ? activeColor.withOpacity(0.17)
                                  : inactiveColor.withOpacity(0.06),
                            )),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => {
                            widget.comingVolunteerID.contains(loggedInUser.uid)
                                ? ScaffoldMessenger.of(context)
                                    .showSnackBar(volunteerSnackBar)
                                : widget.comingAttendanceID
                                        .contains(loggedInUser.uid)
                                    ? addRemoveEvent('attendCanceled')
                                    : addRemoveEvent('Attend'),
                          },
                          child: RadioButton(
                            selected: 'Attend',
                            screen: 'events',
                            colour: widget.comingAttendanceID
                                    .contains(loggedInUser.uid)
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
                              widget.comingVolunteerID
                                      .contains(loggedInUser.uid)
                                  ? addRemoveEvent('volunteerCanceled')
                                  : addRemoveEvent('Volunteer'),
                            },
                        child: RadioButton(
                          selected: 'Volunteer',
                          screen: 'events',
                          colour: widget.comingVolunteerID
                                  .contains(loggedInUser.uid)
                              ? activeColor.withOpacity(0.17)
                              : inactiveColor.withOpacity(0.06),
                        ))
                    : GestureDetector(
                        onTap: () => {
                          widget.comingAttendanceID.contains(loggedInUser.uid)
                              ? addRemoveEvent('attendCanceled')
                              : addRemoveEvent('Attend'),
                        },
                        child: RadioButton(
                          selected: 'Attend',
                          screen: 'events',
                          colour: widget.comingAttendanceID
                                  .contains(loggedInUser.uid)
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
