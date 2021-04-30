import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:volunteering/screens/comment_screen.dart';
import 'package:volunteering/services/get_user_info.dart';
import 'package:volunteering/components/event_card_button.dart';

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
    @required this.userEmail,
    @required this.volunteersList,
    @required this.attendanceList,
    @required this.comingVolunteerID,
    @required this.comingAttendanceID,
    @required this.screen,
    @required this.comment,
    @required this.commentSender,
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
  final String userEmail;
  final List volunteersList;
  final List attendanceList;
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
    if (widget.imageURL != '') {
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
        decoration: BoxDecoration(color: Color(0xFF1B222E)),
        child: Column(
          children: [
            GetUser(
              userID: widget.userID,
              screen: 'events',
              createdOn: widget.createdOn,
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.date_range, color: Colors.white, size: 20),
                        Text(widget.eventDateTime,
                            style: kEventInfoTextStyle.copyWith(fontSize: 11)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 20),
                        Text('' + widget.city,
                            style: kEventInfoTextStyle.copyWith(fontSize: 14)),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Icon(Icons.folder_special, color: Colors.white),
                    //     Text(' ' + widget.eventType,
                    //         style: kEventInfoTextStyle),
                    //   ],
                    // ),
                    GestureDetector(
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
                              color: Colors.white, size: 20),
                          Text(' Comments',
                              style:
                                  kEventInfoTextStyle.copyWith(fontSize: 14)),
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
            Container(
              //decoration: kEventCardBorderDecoration,
              child: EventCardButton(
                eventClass: widget.eventClass,
                eventID: widget.eventID,
                noOfVolunteers: widget.noOfVolunteers,
                noOfAttendance: widget.noOfAttendees,
                volunteersCounter: widget.volunteersCounter,
                attendanceCounter: widget.attendanceCounter,
                volunteersList: widget.volunteersList,
                attendanceList: widget.attendanceList,
                screen: widget.screen,
                userEmail: widget.userEmail,
                comingVolunteerID: widget.comingVolunteerID,
                comingAttendanceID: widget.comingAttendanceID,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
