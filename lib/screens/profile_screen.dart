import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/services/events_stream_builder.dart';
import 'package:volunteering/services/get_user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteering/screens/events_screen.dart';

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
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(16, 17, 18, 1),
          appBar: AppBar(
            toolbarHeight: 180,
            title: GetUser(userID: widget.userID, screen: 'profile'),
            automaticallyImplyLeading: false,
            bottom: TabBar(
              labelPadding: EdgeInsets.symmetric(horizontal: 0),
              tabs: [
                Tab(
                  child: Text('My Events', style: kTapControllerTextStyle),
                ),
                Tab(
                  child: Text('Calender', style: kTapControllerTextStyle),
                ),
              ],
            ),
            backgroundColor: Color.fromRGBO(16, 17, 18, 1),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              widget.userID != loggedInUser.uid
                  ? Navigator.pop(context)
                  : _auth.signOut();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            label: Text(
                widget.userID != loggedInUser.uid ? 'Events' : 'Log Out',
                style: widget.userID != loggedInUser.uid
                    ? kTapControllerTextStyle
                    : kTextFieldStyle),
            icon: widget.userID != loggedInUser.uid
                ? Icon(Icons.arrow_back_ios_outlined)
                : Icon(Icons.login_outlined, size: 20),
            backgroundColor: Color.fromRGBO(20, 21, 22, 1),
          ),
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
