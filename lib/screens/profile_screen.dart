import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;
User loggedInUser;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(16, 17, 18, 1),
          appBar: AppBar(
            toolbarHeight: 180,
            title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircleAvatar(
                backgroundImage: AssetImage('images/2.jpg'),
                radius: 40,
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ali Mustafa', style: kAppBarTextStyle),
                  Text('Software Engineering', style: proto),
                  Text('Amman', style: proto),
                ],
              ),
              SizedBox(width: 20),
              Container(
                color: Colors.white.withOpacity(0.70),
                height: 70,
                width: 0.4,
              ),
              SizedBox(width: 15),
              Column(
                children: [
                  Text(
                    '72',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3),
                  Text('Events', style: kTapControllerTextStyle),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.star, size: 12),
                      Icon(Icons.star, size: 12),
                      Icon(Icons.star, size: 12),
                      Icon(Icons.star, size: 12),
                      Icon(Icons.star, size: 12),
                    ],
                  )
                ],
              )
            ]),
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
        ),
      ),
    );
  }
}
