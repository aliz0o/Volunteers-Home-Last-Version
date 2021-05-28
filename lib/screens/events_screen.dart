import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/screens/profile_screen.dart';
import 'package:volunteering/services/events_stream_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteering/services/get_user_info.dart';

final _auth = FirebaseAuth.instance;
CollectionReference users = FirebaseFirestore.instance.collection('users');
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

  bool searchState = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          //backgroundColor: Color.fromRGBO(16, 17, 18, 1),
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: !searchState
                ? Text('Events', style: kAppBarTextStyle)
                : Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      onChanged: (text) {
                        searchMethod(text);
                      },
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15),
                        hintText: 'Search. . .',
                        helperStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
            actions: [
              !searchState
                  ? IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          searchState = !searchState;
                        });
                      })
                  : IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          searchState = !searchState;
                        });
                      }),
              GetUser(userID: loggedInUser.uid, screen: 'requestButton'),
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

  void searchMethod(String text) {}
}
