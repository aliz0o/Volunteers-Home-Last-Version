import 'package:flutter/material.dart';
import 'package:volunteering/components/CheckBoxListTileDemo.dart';
import 'package:volunteering/screens/events_screen.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/services/events_stream_builder.dart';
import 'package:volunteering/services/get_user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
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


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          // backgroundColor: Color.fromRGBO(16, 17, 18, 1),
          appBar: AppBar(
            toolbarHeight: MediaQuery.of(context).size.height / 3.1,
            title: GetUser(userID: widget.userID, screen: 'profile'),
            bottom: TabBar(
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
          drawer: loggedInUser.uid == widget.userID
              ? GetUser(userID: loggedInUser.uid, screen: 'Drawer')
              : null,
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
