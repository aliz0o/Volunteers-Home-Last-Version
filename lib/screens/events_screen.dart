import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteering/services/events_stream_builder.dart';

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
    getCurrentUser();
  }

  void getCurrentUser() {
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(16, 17, 18, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Events', style: kAppBarTextStyle),
          actions: [
            IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile_screen');
                })
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/create_event_screen');
          },
          label: Text('Create', style: kTapControllerTextStyle),
          icon: Icon(Icons.add),
          backgroundColor: Color.fromRGBO(20, 21, 22, 1),
        ),
        body: TabBarView(
          children: [
            EventStream(eventTapClass: 'All', loggedInUser: loggedInUser),
            EventStream(
                eventTapClass: 'Volunteering', loggedInUser: loggedInUser),
            EventStream(eventTapClass: 'Attending', loggedInUser: loggedInUser),
          ],
        ),
      ),
    );
  }
}
