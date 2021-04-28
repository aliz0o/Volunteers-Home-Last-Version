import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/screens/profile_screen.dart';

class GetUser extends StatelessWidget {
  final String userID;
  final String userEmail;
  final String screen;
  final String createdOn;

  GetUser({
    @required this.userID,
    @required this.screen,
    this.createdOn,
    this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(this.userID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Something went wrong"));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return this.screen == 'profile'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      CircleAvatar(
                        backgroundImage: data['gender'] == 'Male'
                            ? AssetImage('images/male.png')
                            : AssetImage('images/female.png'),
                        radius: 35,
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data['name'],
                              style: kAppBarTextStyle.copyWith(fontSize: 20)),
                          Text(data['city'], style: kUserInfoTextStyle),
                        ],
                      ),
                      Expanded(child: SizedBox(width: 20)),
                      Container(
                        color: Colors.white.withOpacity(0.70),
                        height: 70,
                        width: 0.4,
                      ),
                      SizedBox(width: 17.5),
                      Column(
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
                    ])
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                            userID: userID, userEmail: data['email']),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: data['gender'] == 'Male'
                          ? AssetImage('images/male.png')
                          : AssetImage('images/female.png'),
                    ),
                    title: Text(
                      data['name'],
                      style: TextStyle(
                          fontSize: this.screen == 'comingList' ? 20 : 14,
                          fontFamily: 'Aclonica',
                          color: Colors.white),
                    ),
                    subtitle: Text(
                      this.screen == 'comingList'
                          ? data['email']
                          : this.createdOn,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.50),
                        fontFamily: 'Product Sans',
                      ),
                    ),
                  ),
                );
        }

        return Center(
          child: Container(
            height: 50,
            child: Center(child: Text('Loading..', style: kNumberTextStyle)),
          ),
        );
      },
    );
  }
}
