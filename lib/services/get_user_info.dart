import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteering/constants.dart';

class GetUser extends StatelessWidget {
  final User loggedInUser;
  GetUser({this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(loggedInUser.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          print(data);
          return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircleAvatar(
              backgroundImage: AssetImage('images/2.jpg'),
              radius: 40,
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data['name'], style: kAppBarTextStyle),
                Text('Software Engineering', style: proto),
                Text(data['city'], style: proto),
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
          ]);
        }

        return Text("loading");
      },
    );
  }
}
