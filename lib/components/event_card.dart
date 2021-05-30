import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:volunteering/screens/comment_screen.dart';
import 'package:volunteering/services/get_user_info.dart';
import 'package:volunteering/components/event_card_button.dart';

class EventCard extends StatefulWidget {
  const EventCard({
    this.userEmail,
    this.eventClass,
    this.noOfVolunteers,
    this.noOfAttendees,
    this.eventDateTime,
    this.city,
    this.details,
    @required this.imageURL,
    @required this.createdOn,
    this.eventID,
    this.volunteersCounter,
    this.attendanceCounter,
    this.userID,
    this.comingVolunteerID,
    this.comingAttendanceID,
    @required this.screen,
    this.comment,
    this.commentSender,
  });
  final String userEmail;
  final String eventClass;
  final int noOfAttendees;
  final int noOfVolunteers;
  final String eventDateTime;
  final String city;
  final String details;
  final String imageURL;
  final String createdOn;
  final String eventID;
  final int volunteersCounter;
  final int attendanceCounter;
  final String userID;
  final List comingVolunteerID;
  final List comingAttendanceID;
  final String screen;
  final List comment;
  final List commentSender;

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    bool imageVisibility = false;
    bool textVisibility = false;
    if (widget.imageURL != '' || widget.imageURL != null) {
      setState(() {
        imageVisibility = true;
      });
    }
    if (widget.details != '') {
      setState(() {
        textVisibility = true;
      });
    }
    double scrWidth = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        decoration: BoxDecoration(color: Color(0xFF1B333E)),
        child: Column(
          children: [
            GetUser(
              userID: widget.userID,
              screen: widget.screen,
              createdOn: widget.createdOn,
              eventID: widget.eventID,
            ),
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
                  fadeInDuration: Duration(seconds: 2),
                ),
              ),
            ),

            Container(
              decoration: kEventCardBorderDecoration,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: widget.screen == 'committeeRequest'
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceAround,
                  children: [
                    widget.screen == 'committeeRequest'
                        ? Container()
                        : Row(
                            children: [
                              Icon(Icons.date_range,
                                  color: Colors.white, size: 20),
                              Text(widget.eventDateTime,
                                  style: kEventInfoTextStyle.copyWith(
                                      fontSize: 11)),
                            ],
                          ),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 20),
                        Text('' + widget.city,
                            style: kEventInfoTextStyle.copyWith(fontSize: 14)),
                      ],
                    ),
                    widget.screen == 'committeeRequest'
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentScreen(
                                          commentSender: widget.commentSender,
                                          comment: widget.comment,
                                          eventID: widget.eventID,
                                        )),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(Icons.comment_bank,
                                    color: Color(0xff0962ff), size: 20),
                                Text(' Comments',
                                    style: kEventInfoTextStyle.copyWith(
                                        fontSize: 14,
                                        color: Color(0xff0962ff))),
                              ],
                            ),
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
                  padding: const EdgeInsets.fromLTRB(25, 5, 13, 5),
                  child: Text(
                    widget.details,
                    style: kArabicTextStyle,
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
            //this.click,
            Container(
              child: widget.screen == 'events'
                  ? EventCardButton(
                      userEmail: widget.userEmail,
                      eventClass: widget.eventClass,
                      eventID: widget.eventID,
                      noOfVolunteers: widget.noOfVolunteers,
                      noOfAttendance: widget.noOfAttendees,
                      volunteersCounter: widget.volunteersCounter,
                      attendanceCounter: widget.attendanceCounter,
                      screen: widget.screen,
                      comingVolunteerID: widget.comingVolunteerID,
                      comingAttendanceID: widget.comingAttendanceID,
                      userID: widget.userID,
                    )
                  : EventCardButton(
                      eventID: widget.eventID,
                      screen: widget.screen,
                      userID: widget.userID,
                      userEmail: widget.userEmail,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
