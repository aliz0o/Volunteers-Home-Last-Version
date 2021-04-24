import 'package:flutter/material.dart';
import 'package:volunteering/components/event_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:volunteering/components/event_card_button.dart';

final _fireStore = FirebaseFirestore.instance;

class EventStream extends StatefulWidget {
  EventStream(
      {@required this.eventTapClass,
      @required this.loggedInUser,
      @required this.tap});
  final String eventTapClass;
  final User loggedInUser;
  final String tap;

  @override
  _EventStreamState createState() => _EventStreamState();
}

class _EventStreamState extends State<EventStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.tap == 'events'
            ? _fireStore
                .collection('events')
                .where('approved', isEqualTo: true)
                .orderBy('createdOn', descending: true)
                .snapshots()
            : _fireStore
                .collection('events')
                .where('approved', isEqualTo: true)
                .where('all', arrayContains: loggedInUser.email)
                .orderBy('eventDateTime', descending: false)
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
              DateTime formattedCreatedOn = createdOn.toDate();
              String stringCreatedOn =
                  DateFormat('kk:mm:ss  EEE d MMM').format(formattedCreatedOn);
              DateTime formattedDateTime = eventDateTime.toDate();
              String stringDateTime =
                  DateFormat('kk:mm:ss  EEE d MMM').format(formattedDateTime);

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
              );
              if (eventClass == 'All') {
                eventsCard.add(eventCard);
              } else if (eventClass == 'Volunteering') {
                volunteeringCard.add(eventCard);
              } else if (eventClass == 'Attending') {
                attendingCard.add(eventCard);
              }
              if (widget.tap == 'profile') {
                if (formattedDateTime.compareTo(DateTime.now()) < 0) {
                  myEventCard.add(eventCard);
                } else
                  calenderCard.add(eventCard);
              }
            }
            return widget.eventTapClass == 'All'
                ? ListView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
                    children: eventsCard,
                  )
                : widget.eventTapClass == 'Volunteering'
                    ? ListView(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.0, vertical: 3.0),
                        children: volunteeringCard,
                      )
                    : widget.eventTapClass == 'Attending'
                        ? ListView(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.0, vertical: 3.0),
                            children: attendingCard,
                          )
                        : widget.eventTapClass == 'MyEvent'
                            ? ListView(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.0, vertical: 3.0),
                                children: myEventCard,
                              )
                            : ListView(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.0, vertical: 3.0),
                                children: calenderCard,
                              );
          } else
            return Center(child: CircularProgressIndicator());
        });
  }
}
