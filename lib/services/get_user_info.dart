import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/screens/profile_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:volunteering/screens/events_screen.dart';
import 'package:volunteering/components/CheckBoxListTileDemo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteering/screens/update_profile_screen.dart';
import 'package:volunteering/screens/committee_request_screen.dart';
import 'package:volunteering/screens/login_screen.dart';

final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String userType;
bool verifiedUser;

String getUserType() {
  return userType;
}

bool getVerifiedUser() {
  return verifiedUser;
}

class GetUser extends StatefulWidget {
  final String userID;
  final String screen;
  final String createdOn;
  final String eventID;
  final String email;

  GetUser({
    this.email,
    @required this.userID,
    @required this.screen,
    this.eventID,
    this.createdOn,
  });

  @override
  _GetUserState createState() => _GetUserState();
}

class _GetUserState extends State<GetUser> {
  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else
      print('could not launch');
  }

  sendEmail() {
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'mahmoud_sleem44@hotmail.com',
        queryParameters: {
          'subject': 'Ask to be admin in Volunteers Home',
          'body': 'why you want to be Admin??'
              '\n\n\n write 200 words describe your self',
        });

    launch(_emailLaunchUri.toString());
  }
  sendEmail2(email,subject,body) {
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          'subject': subject,
          'body': body,
        });

    launch(_emailLaunchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(this.widget.userID).get(),
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
          verifiedUser = data['verified'];
          return this.widget.screen == 'profile'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                              radius: 35,
                              backgroundImage: data['photoUrl'] == '' ||
                                      data['photoUrl'] == null
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
                    SizedBox(height: 10),
                    Text(data['name'], style: kUserInfoTextStyle),
                    SizedBox(height: 10),
                    InkWell(
                        onTap: () => null,
                        child: Row(
                          children: [
                            Icon(Icons.location_on),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              ": " + '${data['city']}',
                              style: kUserInfoTextStyle,
                            ),
                          ],
                        )),
                    SizedBox(height: 10),
                    InkWell(
                        onTap: () => customLaunch('mailto:${data['email']}'),
                        child: Row(
                          children: [
                            Icon(Icons.email),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              ": " + '${data['email']}',
                              style: kUserInfoTextStyle,
                            ),
                          ],
                        )),
                    SizedBox(height: 10),
                    InkWell(
                        onTap: () => customLaunch('tel:${data['phoneNumber']}'),
                        child: Row(
                          children: [
                            Icon(Icons.phone),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              ": " + '${data['phoneNumber']}',
                              style: kUserInfoTextStyle,
                            ),
                          ],
                        )),
                  ],
                )
              : this.widget.screen == 'commentScreen'
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(userID: widget.userID),
                          ),
                        );
                      },
                      child: Text(data['name'],
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: 'Aclonica')),
                    )
                  : this.widget.screen == 'button'
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
                      : this.widget.screen == 'requestButton'
                          ? data['userType'] == 'Admin'
                              ? IconButton(
                                  color: Colors.white.withOpacity(0.25),
                                  icon:
                                      Icon(Icons.add_box, color: Colors.white),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (ctx) {
                                      return CommitteeRequest();
                                    }));
                                  },
                                )
                              : Container()
                          : this.widget.screen == 'Drawer'
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
                                              child: CircleAvatar(
                                                  radius: 35,
                                                  backgroundImage: data[
                                                                  'photoUrl'] ==
                                                              '' ||
                                                          data['photoUrl'] ==
                                                              null
                                                      ? AssetImage(
                                                          'images/male.png')
                                                      : NetworkImage(
                                                          data['photoUrl'])),
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
                                          getUserType() == 'committee'
                                              ? ListTile(
                                                  title: const Text(
                                                      'Ask to be Admin',
                                                      style:
                                                          kUserInfoTextStyle),
                                                  onTap: () {
                                                    sendEmail();
                                                  },
                                                )
                                              : Container(
                                                  child: null,
                                                ),
                                          getUserType() == 'committee'
                                              ? Divider(
                                                  thickness: 2,
                                                )
                                              : Container(
                                                  child: null,
                                                ),
                                          ListTile(
                                            title: const Text('Log out',
                                                style: kUserInfoTextStyle),
                                            onTap: () {
                                              _auth.signOut();
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LogIn()),
                                                      (Route<dynamic> route) =>
                                                          false);
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
                                          userID: widget.userID,
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
                                          fontSize:
                                              this.widget.screen == 'comingList'
                                                  ? 20
                                                  : 14,
                                          fontFamily: 'Aclonica',
                                          color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      this.widget.screen == 'comingList'
                                          ? data['email']
                                          : this.widget.createdOn,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white.withOpacity(0.50),
                                        fontFamily: 'Product Sans',
                                      ),
                                    ),
                                    trailing: PopupMenuButton(
                                      onSelected: (value) {

                                        if (widget.screen == 'comingList') {
                                          sendEmail2(data['UserEmail'], "Volunteers Home", 'Thank you for trusting us. Your request to join our event has been approved by committee. All the best wishes for success ');

                                        } else if (this.widget.userID ==
                                            loggedInUser.uid) {
                                          _fireStore
                                              .collection('events')
                                              .doc(this.widget.eventID)
                                              .update({'deleted': value});
                                          _fireStore
                                              .collection('users')
                                              .doc(this.widget.userID)
                                              .update({
                                            'eventCount':
                                                FieldValue.increment(-1)
                                          });
                                        } else {
                                          if (this.widget.screen == 'committeeRequest') {
                                            _fireStore
                                                .collection('users')
                                                .doc(this.widget.userID)
                                                .update({
                                              'reportedCount':
                                                  FieldValue.increment(1)
                                            });
                                          } else {
                                            _fireStore
                                                .collection('events')
                                                .doc(this.widget.eventID)
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
                                          child: widget.screen == 'comingList'
                                              ? Text("Send Email",
                                                  style: kNumberTextStyle)
                                              : this.widget.userID ==
                                                      loggedInUser.uid
                                                  ? Text("Delete",
                                                      style: kNumberTextStyle)
                                                  : Text("Report",
                                                      style: kNumberTextStyle),
                                        ),
                                      ],
                                    ),
                                  ));
        }

        return this.widget.screen == 'commentScreen'
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
            : this.widget.screen == 'button' ||
                    this.widget.screen == 'requestButton' ||
                    this.widget.screen == 'Drawer'
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
