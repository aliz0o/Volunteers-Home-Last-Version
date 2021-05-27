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
String userType;

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
        void getUserType(String val) async {
          DocumentSnapshot snapshot = await users.doc(loggedInUser.uid).get();
          var data = snapshot.data();
          userType = data['userType'];
          print(userType);
        }

        getUserType(loggedInUser.uid);
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
                      onChanged: (text){
                        SearchMethod(text);
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
              userType == 'Admin'
                  ? FlatButton(
                      color: Colors.white.withOpacity(0.25),
                      child: Text(
                        'Request',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontFamily: 'Product Sans'),
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

  void SearchMethod(String text) {




  }
}
