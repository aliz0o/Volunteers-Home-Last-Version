import 'package:flutter/material.dart';
import 'package:volunteering/components/event_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/screens/events_screen.dart';

final _fireStore = FirebaseFirestore.instance;
String loggedInUserType;
List preferredEvent = [];

class EventStream extends StatefulWidget {
  EventStream({
    @required this.eventTapClass,
    @required this.tap,
    @required this.screen,
    this.userID,
  });
  final String eventTapClass;
  final String tap;
  final String userID;
  final String screen;

  @override
  _EventStreamState createState() => _EventStreamState();
}

class _EventStreamState extends State<EventStream> {
  void getUserType() async {
    DocumentSnapshot loggedInUserSnapshot =
        await users.doc(loggedInUser.uid).get();
    var data = loggedInUserSnapshot.data();
    loggedInUserType = data['userType'];
    preferredEvent = data['preferredEvents'];
  }

  @override
  Widget build(BuildContext context) {
    getUserType();
    setState(() {});
    return StreamBuilder<QuerySnapshot>(
        stream: widget.tap == 'events'
            ? loggedInUserType == 'Admin'
                ? _fireStore
                    .collection('events')
                    .where('approved', isEqualTo: false)
                    .where('deleted', isEqualTo: false)
                    .orderBy('createdOn', descending: true)
                    .snapshots()
                : _fireStore
                    .collection('events')
                    .where('approved', isEqualTo: true)
                    .where('deleted', isEqualTo: false)
                    .orderBy('createdOn', descending: true)
                    .snapshots()
            : widget.tap == 'Calender'
                ? _fireStore
                    .collection('events')
                    .where('approved', isEqualTo: true)
                    .where('deleted', isEqualTo: false)
                    .where('all', arrayContains: widget.userID)
                    .orderBy('eventDateTime', descending: false)
                    .snapshots()
                : _fireStore
                    .collection('events')
                    .where('approved', isEqualTo: true)
                    .where('deleted', isEqualTo: false)
                    .where('all', arrayContains: widget.userID)
                    .orderBy('eventDateTime', descending: true)
                    .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text("Something went wrong..",
                    style: kUserInfoTextStyle.copyWith(color: Colors.black)));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final documents = snapshot.data.docs;
            List<EventCard> eventsCard = [];
            List<EventCard> volunteeringCard = [];
            List<EventCard> attendingCard = [];
            List<EventCard> myEventCard = [];
            List<EventCard> calenderCard = [];
            for (var event in documents) {
              final createdOn = event['createdOn'];
              final eventClass = event['eventClass'];
              final noOfVolunteers = event['noOfVolunteers'];
              final noOfAttendees = event['noOfAttendees'];
              final eventDateTime = event['eventDateTime'];
              final city = event['city'];
              final details = event['details'];
              final imageURL = event['images'];
              final eventID = event.id;
              final volunteersCounter = event['volunteersCounter'];
              final attendanceCounter = event['attendanceCounter'];
              final userID = event['userID'];
              final comingVolunteerID = event['comingVolunteerID'];
              final comingAttendanceID = event['comingAttendanceID'];
              final comment = event['comment'];
              final eventType = event['eventType'];
              final userEmail = event['UserEmail'];
              final commentSender = event['commentSender'];
              final DateTime formattedCreatedOn = createdOn.toDate();
              String stringCreatedOn =
                  DateFormat('kk:mm  EEE d MMM').format(formattedCreatedOn);
              DateTime formattedDateTime = eventDateTime.toDate();
              String stringDateTime =
                  DateFormat('  kk:mm\n  d MMM').format(formattedDateTime);
              final eventCard = EventCard(
                userEmail: userEmail,
                eventClass: eventClass,
                noOfVolunteers: noOfVolunteers,
                noOfAttendees: noOfAttendees,
                eventDateTime: stringDateTime,
                city: city,
                details: details,
                imageURL: imageURL,
                createdOn: stringCreatedOn,
                eventID: eventID,
                volunteersCounter: volunteersCounter,
                attendanceCounter: attendanceCounter,
                userID: userID,
                screen: 'events',
                comingVolunteerID: comingVolunteerID,
                comingAttendanceID: comingAttendanceID,
                comment: comment,
                commentSender: commentSender,
              );
              if (formattedDateTime.compareTo(DateTime.now()) >= 0) {
                if (eventClass == 'All' &&
                    (preferredEvent.contains(eventType) ||
                        preferredEvent.length == 0)) {
                  eventsCard.add(eventCard);
                } else if (eventClass == 'Volunteering' &&
                    (preferredEvent.contains(eventType) ||
                        preferredEvent.length == 0)) {
                  volunteeringCard.add(eventCard);
                } else if (eventClass == 'Attending' &&
                    (preferredEvent.contains(eventType) ||
                        preferredEvent.length == 0)) {
                  attendingCard.add(eventCard);
                }
              }
              if (widget.tap == 'Calender') {
                if (formattedDateTime.compareTo(DateTime.now()) >= 0) {
                  calenderCard.add(eventCard);
                }
              } else if (widget.tap == 'MyEvent') {
                if (formattedDateTime.compareTo(DateTime.now()) < 0) {
                  myEventCard.add(eventCard);
                }
              }
            }
            return widget.eventTapClass == 'All'
                ? ListView.builder(
                    itemCount: eventsCard.length,
                    itemBuilder: (context, index) {
                      return eventsCard[index];
                    },
                  )
                : widget.eventTapClass == 'Volunteering'
                    ? ListView.builder(
                        itemCount: volunteeringCard.length,
                        itemBuilder: (context, index) {
                          return volunteeringCard[index];
                        },
                      )
                    : widget.eventTapClass == 'Attending'
                        ? ListView.builder(
                            itemCount: attendingCard.length,
                            itemBuilder: (context, index) {
                              return attendingCard[index];
                            })
                        : widget.eventTapClass == 'MyEvent'
                            ? ListView.builder(
                                itemCount: myEventCard.length,
                                itemBuilder: (context, index) {
                                  return myEventCard[index];
                                },
                              )
                            : ListView.builder(
                                itemCount: calenderCard.length,
                                itemBuilder: (context, index) {
                                  return calenderCard[index];
                                },
                              );
          } else
            return Center(child: CircularProgressIndicator());
        });
  }
}
