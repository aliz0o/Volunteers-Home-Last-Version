import 'package:flutter/material.dart';
import 'package:volunteering/components/event_card_button.dart';
import 'package:volunteering/constants.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;
String name = '';
String gender = '';

class EventCard extends StatefulWidget {
  const EventCard({
    @required this.eventClass,
    @required this.noOfVolunteers,
    @required this.noOfAttendees,
    @required this.eventDateTime,
    @required this.city,
    @required this.eventType,
    @required this.details,
    @required this.imageURL,
    @required this.createdOn,
    @required this.eventID,
    @required this.volunteersCounter,
    @required this.attendanceCounter,
    @required this.userID,
  });

  final String eventClass;
  final int noOfAttendees;
  final int noOfVolunteers;
  final String eventDateTime;
  final String city;
  final String eventType;
  final String details;
  final String imageURL;
  final String createdOn;
  final String eventID;
  final int volunteersCounter;
  final int attendanceCounter;
  final String userID;

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  void eventCreator() async {
    DocumentReference document =
        _fireStore.collection('users').doc(widget.userID);
    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      if (snapshot == null) {
        return Center(child: CircularProgressIndicator());
      }
      setState(() {
        Map<String, dynamic> data = snapshot.data();
        name = data['name'];
        gender = data['gender'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    eventCreator();
    bool imageVisibility = false;
    bool textVisibility = false;
    if (widget.imageURL != '') {
      if (mounted) {
        setState(() {
          imageVisibility = true;
        });
      }
    }
    if (widget.details != '') {
      if (mounted) {
        setState(() {
          textVisibility = true;
        });
      }
    }
    double scrWidth = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        decoration: BoxDecoration(color: Color(0xFF1B222E)),
        child: Column(
          children: [
            ListTile(
                leading: CircleAvatar(
                  backgroundImage: gender == 'Male'
                      ? AssetImage('images/male.png')
                      : AssetImage('images/female.png'),
                ),
                title: Text(
                  name,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Aclonica',
                      color: Colors.white),
                ),
                subtitle: Text(
                  widget.createdOn,
                  style: TextStyle(
                      fontSize: 11.5, color: Colors.white.withOpacity(0.50)),
                ),
                trailing: EventCardButton(
                  eventClass: widget.eventClass,
                  eventID: widget.eventID,
                  noOfVolunteers: widget.noOfVolunteers,
                  noOfAttendance: widget.noOfAttendees,
                  volunteersCounter: widget.volunteersCounter,
                  attendanceCounter: widget.attendanceCounter,
                )),
            Visibility(
              visible: imageVisibility,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.30),
                  ),
                ),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: widget.imageURL,
                ),
              ),
            ),

            Container(
              decoration: kEventCardBorderDecoration,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.date_range, color: Colors.white),
                        Text('  ' + widget.eventDateTime,
                            style: kEventInfoTextStyle.copyWith(fontSize: 10)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white),
                        Text('' + widget.city,
                            style: kEventInfoTextStyle.copyWith(fontSize: 15)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.folder_special, color: Colors.white),
                        Text(' ' + widget.eventType,
                            style: kEventInfoTextStyle),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: textVisibility,
              child: Container(
                width: scrWidth,
                decoration: kEventCardBorderDecoration,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 15, 5),
                  child: Text(
                    widget.details,
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'Amiri', fontSize: 15),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
            //this.click,
          ],
        ),
      ),
    );
  }
}
