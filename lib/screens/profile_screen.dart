import 'package:flutter/material.dart';
import 'package:volunteering/components/CheckBoxListTileDemo.dart';

import 'package:volunteering/constants.dart';
import 'package:volunteering/screens/updateProfile.dart';
import 'package:volunteering/services/events_stream_builder.dart';
import 'package:volunteering/services/get_user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteering/screens/events_screen.dart';
import 'create_event_screen.dart';
import 'login_screen.dart';

final _auth = FirebaseAuth.instance;

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    @required this.userID,
  });
  final String userID;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: InkWell(child: Text('name')),
      accountEmail: Text('Email'),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: FlutterLogo(
          size: 50,
        ),
      ),
    );

    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          title: const Text('Update Profile page'),
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return EditProfile();
          })),
        ),
        Divider(
          thickness: 2,
        ),
        ListTile(
          title: const Text('preferred Events'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return CheckBoxListTileDemo();
            }));
          },
        ),
        Divider(
          thickness: 2,
        ),
        ListTile(
          title: const Text('Log out'),
          onTap: () {
            _auth.signOut();
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (ctx) {
              return LogIn();
            }));
          },
        ),
        Divider(
          thickness: 2,
        ),
      ],
    );

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          // backgroundColor: Color.fromRGBO(16, 17, 18, 1),
          appBar: AppBar(
            toolbarHeight: MediaQuery.of(context).size.height / 3.1,
            title: GetUser(userID: widget.userID, screen: 'profile'),
            // automaticallyImplyLeading: false,
            bottom: TabBar(
              //labelPadding: EdgeInsets.symmetric(horizontal: 0),
              tabs: [
                Tab(
                  child: Text('My Events', style: kTapControllerTextStyle),
                ),
                Tab(
                  child: Text('Calender', style: kTapControllerTextStyle),
                ),
              ],
            ),

            //  backgroundColor: Color.fromRGBO(16, 17, 18, 1),
          ),
          drawer: Drawer(
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
                child: drawerItems),
          ),
          // floatingActionButton: FloatingActionButton.extended(
          //   onPressed: () {
          //     widget.userID != loggedInUser.uid
          //         ? Navigator.pop(context)
          //         : _auth.signOut();
          //     Navigator.pushNamed(context, '/login_screen');
          //   },
          //   label: Text(
          //       widget.userID != loggedInUser.uid ? 'Events' : 'Log Out',
          //       style: widget.userID != loggedInUser.uid
          //           ? kTapControllerTextStyle
          //           : kTextFieldStyle),
          //   icon: widget.userID != loggedInUser.uid
          //       ? Icon(Icons.arrow_back_ios_outlined)
          //       : Icon(Icons.login_outlined, size: 20),
          //   backgroundColor: Color.fromRGBO(20, 21, 22, 1),
          // ),
          body: TabBarView(
            children: [
              EventStream(
                eventTapClass: 'MyEvent',
                tap: 'MyEvent',
                screen: 'comingList',
                userID: widget.userID,
              ),
              EventStream(
                eventTapClass: 'Calender',
                tap: 'Calender',
                screen: 'events',
                userID: widget.userID,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
