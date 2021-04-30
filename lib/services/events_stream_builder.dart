import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:volunteering/components/event_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedInUser;

class EventStream extends StatefulWidget {
  EventStream({
    @required this.eventTapClass,
    @required this.tap,
    @required this.screen,
    this.userEmail,
  });
  final String eventTapClass;
  final String tap;
  final String userEmail;
  final String screen;

  @override
  _EventStreamState createState() => _EventStreamState();
}

class _EventStreamState extends State<EventStream> {
  @override
  void initState() {
    super.initState();
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
    return StreamBuilder<QuerySnapshot>(
        stream: widget.tap == 'events'
            ? _fireStore
                .collection('events')
                .where('approved', isEqualTo: true)
                .orderBy('createdOn', descending: true)
                .snapshots()
            : widget.tap == 'Calender'
                ? _fireStore
                    .collection('events')
                    .where('approved', isEqualTo: true)
                    .where('all', arrayContains: widget.userEmail)
                    .orderBy('eventDateTime', descending: false)
                    .snapshots()
                : _fireStore
                    .collection('events')
                    .where('approved', isEqualTo: true)
                    .where('email', isEqualTo: widget.userEmail)
                    .orderBy('eventDateTime', descending: true)
                    .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
              final eventType = event['eventType'];
              final city = event['city'];
              final details = event['details'];
              final imageURL = event['images'];
              final eventID = event.id;
              final volunteersCounter = event['volunteersCounter'];
              final attendanceCounter = event['attendanceCounter'];
              final userID = event['userID'];
              final userEmail = event['email'];
              final volunteersList = event['volunteers'];
              final attendanceList = event['attendance'];
              final comingVolunteerID = event['comingVolunteerID'];
              final comingAttendanceID = event['comingAttendanceID'];
              final comments = event['comments'];
              final DateTime formattedCreatedOn = createdOn.toDate();
              String stringCreatedOn =
                  DateFormat('kk:mm  EEE d MMM').format(formattedCreatedOn);
              DateTime formattedDateTime = eventDateTime.toDate();
              String stringDateTime =
                  DateFormat('  kk:mm\n  d MMM').format(formattedDateTime);

              final eventCard = EventCard(
                eventClass: eventClass,
                noOfVolunteers: noOfVolunteers,
                noOfAttendees: noOfAttendees,
                eventDateTime: stringDateTime,
                eventType: eventType,
                city: city,
                details: details,
                imageURL: imageURL,
                createdOn: stringCreatedOn,
                eventID: eventID,
                volunteersCounter: volunteersCounter,
                attendanceCounter: attendanceCounter,
                userID: userID,
                userEmail: userEmail,
                volunteersList: volunteersList,
                attendanceList: attendanceList,
                screen: widget.screen,
                comingVolunteerID: comingVolunteerID,
                comingAttendanceID: comingAttendanceID,
                comment: comments['comment'],
                commentSender: comments['commentSender'],
              );
              if (eventClass == 'All') {
                eventsCard.add(eventCard);
              } else if (eventClass == 'Volunteering') {
                volunteeringCard.add(eventCard);
              } else if (eventClass == 'Attending') {
                attendingCard.add(eventCard);
              }
              if (widget.tap == 'Calender') {
                if (formattedDateTime.compareTo(DateTime.now()) >= 0) {
                  calenderCard.add(eventCard);
                }
              } else if (widget.tap == 'MyEvent') {
                myEventCard.add(eventCard);
              }
            }
            return widget.eventTapClass == 'All'
                ? ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
                    itemCount: eventsCard.length,
                    itemBuilder: (context, index) {
                      return eventsCard[index];
                    },
                  )
                : widget.eventTapClass == 'Volunteering'
                    ? ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.0, vertical: 3.0),
                        itemCount: volunteeringCard.length,
                        itemBuilder: (context, index) {
                          return volunteeringCard[index];
                        },
                      )
                    : widget.eventTapClass == 'Attending'
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.0, vertical: 3.0),
                            itemCount: attendingCard.length,
                            itemBuilder: (context, index) {
                              return attendingCard[index];
                            })
                        : widget.eventTapClass == 'MyEvent'
                            ? ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.0, vertical: 3.0),
                                itemCount: myEventCard.length,
                                itemBuilder: (context, index) {
                                  return myEventCard[index];
                                },
                              )
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.0, vertical: 3.0),
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
