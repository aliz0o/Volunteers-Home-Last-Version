import 'package:flutter/material.dart';
import 'package:volunteering/components/event_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class EventStream extends StatefulWidget {
  EventStream({@required this.eventTapClass, @required this.loggedInUser});
  final String eventTapClass;
  final User loggedInUser;

  @override
  _EventStreamState createState() => _EventStreamState();
}

class _EventStreamState extends State<EventStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore
            .collection('events')
            .orderBy('createdOn', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final currentUser = widget.loggedInUser.email;
          final documents = snapshot.data.docs;
          List<EventCard> eventsCard = [];
          List<EventCard> volunteeringCard = [];
          List<EventCard> attendingCard = [];
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

            DateTime formattedDate = createdOn.toDate();
            String stringDate =
                DateFormat('kk:mm:ss  EEE d MMM').format(formattedDate);
            final eventCard = EventCard(
              eventClass: eventClass,
              noOfVolunteers: noOfVolunteers,
              noOfAttendees: noOfAttendees,
              eventDateTime: eventDateTime,
              eventType: eventType,
              city: city,
              details: details,
              imageURL: imageURL,
              createdOn: stringDate,
              eventID: eventID,
              volunteersCounter: volunteersCounter,
              attendanceCounter: attendanceCounter,
            );
            if (eventClass == 'All') {
              eventsCard.add(eventCard);
            } else if (eventClass == 'Volunteering') {
              volunteeringCard.add(eventCard);
            } else if (eventClass == 'Attending') {
              attendingCard.add(eventCard);
            }
          }
          return widget.eventTapClass == 'All'
              ? ListView(
                  padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
                  children: eventsCard,
                )
              : widget.eventTapClass == 'Volunteering'
                  ? ListView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
                      children: volunteeringCard,
                    )
                  : ListView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
                      children: attendingCard,
                    );
        });
  }
}
