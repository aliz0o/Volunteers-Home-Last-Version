import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/screens/profile_screen.dart';
import 'package:volunteering/services/events_stream_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteering/services/get_user_info.dart';

final _auth = FirebaseAuth.instance;
User loggedInUser;

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    super.initState();
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(16, 17, 18, 1),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Events', style: kAppBarTextStyle),
            actions: [
              loggedInUser.uid == 'bcz40Yqcb1ch0OBMA6yNPvRHz5V2'
                  ? TextButton(
                      child: Text(
                        'Committee\nRequest',
                        style: TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/committee_request');
                      },
                    )
                  : Container(),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(userID: loggedInUser.uid),
                    ),
                  );
                },
              )
            ],
            bottom: TabBar(
              labelPadding: EdgeInsets.symmetric(horizontal: 0),
              tabs: [
                Tab(
                  child: Text('All', style: kTapControllerTextStyle),
                ),
                Tab(
                  child: Text('Volunteering', style: kTapControllerTextStyle),
                ),
                Tab(
                  child: Text('Attending', style: kTapControllerTextStyle),
                ),
              ],
            ),
            backgroundColor: Colors.black,
          ),
          floatingActionButton:
              GetUser(userID: loggedInUser.uid, screen: 'button'),
          body: TabBarView(
            children: [
              EventStream(
                eventTapClass: 'All',
                tap: 'events',
                screen: 'events',
              ),
              EventStream(
                eventTapClass: 'Volunteering',
                tap: 'events',
                screen: 'events',
              ),
              EventStream(
                eventTapClass: 'Attending',
                tap: 'events',
                screen: 'events',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
