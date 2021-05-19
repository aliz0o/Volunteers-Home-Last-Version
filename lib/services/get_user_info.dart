import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/screens/profile_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:volunteering/screens/events_screen.dart';

final _fireStore = FirebaseFirestore.instance;

String userType;

class GetUser extends StatelessWidget {
  final String userID;
  final String screen;
  final String createdOn;
  final String eventID;

  GetUser({
    @required this.userID,
    @required this.screen,
    this.eventID,
    this.createdOn,
  });

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(this.userID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text("Something went wrong",
                  style: kUserInfoTextStyle.copyWith(color: Colors.white)));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          userType = data['userType'];
          return this.screen == 'profile'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      CircleAvatar(
                        backgroundImage: data['gender'] == 'Male'
                            ? AssetImage('images/male.png')
                            : AssetImage('images/female.png'),
                        radius: 35,
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data['name'],
                              style: kAppBarTextStyle.copyWith(fontSize: 20)),
                          Text(data['city'], style: kUserInfoTextStyle),
                        ],
                      ),
                      Expanded(child: SizedBox(width: 20)),
                      Container(
                        color: Colors.white.withOpacity(0.70),
                        height: 70,
                        width: 0.4,
                      ),
                      SizedBox(width: 17.5),
                      Column(
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
                    ])
              : this.screen == 'commentScreen'
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(userID: userID),
                          ),
                        );
                      },
                      child: Text(data['name'],
                          style: kDropDownTextStyle.copyWith(fontSize: 11)),
                    )
                  : this.screen == 'button'
                      ? userType == 'committee'
                          ? FloatingActionButton.extended(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/create_event_screen');
                              },
                              label: Text('Create',
                                  style: kTapControllerTextStyle),
                              icon: Icon(Icons.add),
                              backgroundColor: Color.fromRGBO(20, 21, 22, 1),
                            )
                          : Visibility(
                              child: Container(),
                              visible: false,
                            )
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  userID: userID,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: data['gender'] == 'Male'
                                  ? AssetImage('images/male.png')
                                  : AssetImage('images/female.png'),
                            ),
                            title: Text(
                              data['name'],
                              style: TextStyle(
                                  fontSize:
                                      this.screen == 'comingList' ? 20 : 14,
                                  fontFamily: 'Aclonica',
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              this.screen == 'comingList'
                                  ? data['email']
                                  : this.createdOn,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.50),
                                fontFamily: 'Product Sans',
                              ),
                            ),
                            trailing: PopupMenuButton(
                              onSelected: (value) {
                                if (this.userID == loggedInUser.uid) {
                                  _fireStore
                                      .collection('events')
                                      .doc(this.eventID)
                                      .update({'deleted': value});
                                  _fireStore
                                      .collection('users')
                                      .doc(this.userID)
                                      .update({
                                    'eventCount': FieldValue.increment(-1)
                                  });
                                } else {
                                  if (this.screen == 'comingList') {
                                    _fireStore
                                        .collection('users')
                                        .doc(this.userID)
                                        .update({
                                      'reportedCount': FieldValue.increment(1)
                                    });
                                  } else {
                                    _fireStore
                                        .collection('events')
                                        .doc(this.eventID)
                                        .update({
                                      'reportedCount': FieldValue.increment(1)
                                    });
                                  }
                                }
                              },
                              elevation: 5,
                              color: Color.fromRGBO(16, 17, 18, 1),
                              icon: Icon(Icons.more_vert, color: Colors.white),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: true,
                                  child: this.userID == loggedInUser.uid
                                      ? Text("Delete", style: kNumberTextStyle)
                                      : Text("Report", style: kNumberTextStyle),
                                ),
                              ],
                            ),
                          ));
        }

        return this.screen == 'commentScreen'
            ? Shimmer.fromColors(
                baseColor: Colors.white.withOpacity(0.5),
                highlightColor: Colors.blueGrey.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    '________',
                    style: TextStyle(fontSize: 15, fontFamily: 'Product Sans'),
                  ),
                ),
              )
            : this.screen == 'button'
                ? Visibility(
                    child: Container(),
                    visible: false,
                  )
                : SizedBox(
                    height: 75.0,
                    child: Shimmer.fromColors(
                      baseColor: Colors.white.withOpacity(0.5),
                      highlightColor: Colors.blueGrey.withOpacity(0.5),
                      child: ListTile(
                        leading: CircleAvatar(),
                        title: Text(
                          '________',
                          style: TextStyle(
                              fontSize: 25, fontFamily: 'Product Sans'),
                        ),
                        subtitle: Text(
                          '______________',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Product Sans',
                          ),
                        ),
                      ),
                    ),
                  );
      },
    );
  }
}
