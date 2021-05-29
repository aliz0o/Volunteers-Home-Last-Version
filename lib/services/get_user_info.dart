import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/screens/profile_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:volunteering/screens/events_screen.dart';
import 'package:volunteering/screens/login_screen.dart';
import 'package:volunteering/components/CheckBoxListTileDemo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteering/screens/update_profile_screen.dart';

final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String userType;

String getUserType() {
  return userType;
}

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
                  style: kUserInfoTextStyle.copyWith(color: Colors.black)));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          userType = data['userType'];
          return this.screen == 'profile'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                              radius: 35,
                              backgroundImage: data['photoUrl'] == ''
                                  ? AssetImage('images/male.png')
                                  : NetworkImage(data['photoUrl'])),
                          Expanded(child: SizedBox(width: 20)),
                          Container(
                            color: Colors.white.withOpacity(0.70),
                            height: 70,
                            width: 0.4,
                          ),
                          SizedBox(width: 17.5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        ]),
                    SizedBox(
                      height: 5,
                    ),
                    Text('name : ' + data['name'], style: kUserInfoTextStyle),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Location : ' + data['city'],
                        style: kUserInfoTextStyle),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Email : ' + data['email'], style: kUserInfoTextStyle),
                    SizedBox(height: 5),
                    Text('PhoneNO : ' + '${data['phoneNumber']}',
                        style: kUserInfoTextStyle),
                    // TextButton(onPressed: null, child: Text('more Info :',style: TextStyle(color:Colors.white),) ),
                  ],
                )
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
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: 'Aclonica')),
                    )
                  : this.screen == 'button'
                      ? (userType == 'committee' || userType == 'Admin') &&
                              data['verified'] == true
                          ? FloatingActionButton.extended(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/create_event_screen');
                              },
                              label: Text('Create',
                                  style: kTapControllerTextStyle),
                              icon: Icon(Icons.add),
                              // backgroundColor: Color.fromRGBO(20, 21, 22, 1),
                            )
                          : Visibility(
                              child: Container(),
                              visible: false,
                            )
                      : this.screen == 'requestButton'
                          ? data['userType'] == 'Admin'
                              ? IconButton(
                                  color: Colors.white.withOpacity(0.25),
                                  icon:
                                      Icon(Icons.add_box, color: Colors.white),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/committee_request');
                                  },
                                )
                              : Container()
                          : this.screen == 'Drawer'
                              ? Drawer(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Colors.blue[200],
                                          Colors.indigo[600],
                                        ],
                                      )),
                                      child: ListView(
                                        children: <Widget>[
                                          UserAccountsDrawerHeader(
                                            accountName: InkWell(
                                                child: Text(data['name'],
                                                    style: kUserInfoTextStyle)),
                                            accountEmail: Text(data['email'],
                                                style: kEventInfoTextStyle),
                                            currentAccountPicture: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: FlutterLogo(
                                                size: 50,
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text(
                                                'Update Profile page',
                                                style: kUserInfoTextStyle),
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (ctx) {
                                              return UpdateProfilePage(
                                                name: data['name'],
                                                city: data['city'],
                                                phoneNumber:
                                                    data['phoneNumber'],
                                                profilePicture:
                                                    data['photoUrl'],
                                              );
                                            })),
                                          ),
                                          Divider(
                                            thickness: 2,
                                          ),
                                          ListTile(
                                            title: const Text(
                                                'preferred Events',
                                                style: kUserInfoTextStyle),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (ctx) {
                                                return CheckBoxListTileDemo();
                                              }));
                                            },
                                          ),
                                          Divider(
                                            thickness: 2,
                                          ),
                                          ListTile(
                                            title: const Text('Log out',
                                                style: kUserInfoTextStyle),
                                            onTap: () {
                                              _auth.signOut();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (ctx) {
                                                return LogIn();
                                              }));
                                            },
                                          ),
                                          Divider(
                                            thickness: 2,
                                          ),
                                        ],
                                      )),
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
                                      backgroundImage:
                                          data['profilePicture'] == ''
                                              ? AssetImage('images/male.png')
                                              : NetworkImage(
                                                  data['profilePicture']),
                                    ),
                                    title: Text(
                                      data['name'],
                                      style: TextStyle(
                                          fontSize: this.screen == 'comingList'
                                              ? 20
                                              : 14,
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
                                            'eventCount':
                                                FieldValue.increment(-1)
                                          });
                                        } else {
                                          if (this.screen == 'comingList' ||
                                              this.screen ==
                                                  'committeeRequest') {
                                            _fireStore
                                                .collection('users')
                                                .doc(this.userID)
                                                .update({
                                              'reportedCount':
                                                  FieldValue.increment(1)
                                            });
                                          } else {
                                            _fireStore
                                                .collection('events')
                                                .doc(this.eventID)
                                                .update({
                                              'reportedCount':
                                                  FieldValue.increment(1)
                                            });
                                          }
                                        }
                                      },
                                      elevation: 5,
                                      color: Color.fromRGBO(16, 17, 18, 1),
                                      icon: Icon(Icons.more_vert,
                                          color: Colors.white),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: true,
                                          child: this.userID == loggedInUser.uid
                                              ? Text("Delete",
                                                  style: kNumberTextStyle)
                                              : Text("Report",
                                                  style: kNumberTextStyle),
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
            : this.screen == 'button' ||
                    this.screen == 'requestButton' ||
                    this.screen == 'Drawer'
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
