import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/services/events_stream_builder.dart';
import 'package:volunteering/services/get_user_info.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({@required this.userID, @required this.userEmail});
  final String userID;
  final String userEmail;
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
              Navigator.pop(context);
            },
            label: Text('Events', style: kTapControllerTextStyle),
            icon: Icon(Icons.arrow_back_ios_outlined),
            backgroundColor: Color.fromRGBO(20, 21, 22, 1),
          ),
          body: TabBarView(
            children: [
              EventStream(
                eventTapClass: 'MyEvent',
                tap: 'MyEvent',
                screen: 'comingList',
                userEmail: widget.userEmail,
              ),
              EventStream(
                eventTapClass: 'Calender',
                tap: 'Calender',
                screen: 'events',
                userEmail: widget.userEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
