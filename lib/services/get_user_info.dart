import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteering/constants.dart';

class GetUser extends StatelessWidget {
  final String user;
  final String screen;
  final String createdOn;
  GetUser({@required this.user, @required this.screen, this.createdOn});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(this.user).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return this.screen == 'profile'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      CircleAvatar(
                        backgroundImage: data['gender'] == 'Male'
                            ? AssetImage('images/male.png')
                            : AssetImage('images/female.png'),
                        radius: 40,
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data['name'],
                              style: kAppBarTextStyle.copyWith(fontSize: 20)),
                          Text(data['age'].toString() + ' Year Old',
                              style: kTextFieldStyle),
                          Text(data['city'], style: kTextFieldStyle),
                        ],
                      ),
                      Expanded(child: SizedBox(width: 20)),
                      // Container(
                      //   color: Colors.white.withOpacity(0.70),
                      //   height: 70,
                      //   width: 0.4,
                      // ),
                      //Expanded(child: SizedBox(width: 15)),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Color(0xff0962ff),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: Column(
                          children: [
                            Text(
                              data['eventCount'].toString(),
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 3),
                            Text('Events', style: kTapControllerTextStyle),
                          ],
                        ),
                      )
                    ])
              : ListTile(
                  leading: CircleAvatar(
                    backgroundImage: data['gender'] == 'Male'
                        ? AssetImage('images/male.png')
                        : AssetImage('images/female.png'),
                  ),
                  title: Text(
                    data['name'],
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Aclonica',
                        color: Colors.white),
                  ),
                  subtitle: Text(
                    this.createdOn,
                    style: TextStyle(
                        fontSize: 11.5, color: Colors.white.withOpacity(0.50)),
                  ),
                  // trailing: EventCardButton(
                  //   eventClass: widget.eventClass,
                  //   eventID: widget.eventID,
                  //   noOfVolunteers: widget.noOfVolunteers,
                  //   noOfAttendance: widget.noOfAttendees,
                  //   volunteersCounter: widget.volunteersCounter,
                  //   attendanceCounter: widget.attendanceCounter,
                  // )
                );
        }

        return Center(child: Container(height: 75));
      },
    );
  }
}
