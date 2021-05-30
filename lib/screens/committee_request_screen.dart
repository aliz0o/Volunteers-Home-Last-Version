import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:intl/intl.dart';
import 'package:volunteering/components/event_card.dart';

final _fireStore = FirebaseFirestore.instance;

class CommitteeRequest extends StatefulWidget {
  @override
  _CommitteeRequestState createState() => _CommitteeRequestState();
}

class _CommitteeRequestState extends State<CommitteeRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
       centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Committee Request', style: kAppBarTextStyle),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fireStore
            .collection('users')
            .where('userType', isEqualTo: 'committee')
            .where('verified', isEqualTo: false)
            .orderBy('createdOn', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text("Something went wrong..",
                    style: kUserInfoTextStyle.copyWith(color: Colors.white)));
          }
          if (snapshot.hasData) {
            final documents = snapshot.data.docs;
            List<EventCard> userCard = [];
            for (var user in documents) {
              final userID = user.id;
              final createdOn = user['createdOn'];
              final about = user['about'];
              final userEmail = user['email'];
              final city = user['city'];
              final verificationDocument = user['verificationDocument'];
              final DateTime formattedCreatedOn = createdOn.toDate();
              String stringCreatedOn =
                  DateFormat('kk:mm  EEE d MMM').format(formattedCreatedOn);

              final eventCard = EventCard(
                userEmail: userEmail,
                userID: userID,
                eventID: userID,
                city: city,
                details: about,
                imageURL: verificationDocument,
                createdOn: stringCreatedOn,
                screen: 'committeeRequest',
                eventDateTime: '',
              );
              userCard.add(eventCard);
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
              itemCount: userCard.length,
              itemBuilder: (context, index) {
                return userCard[index];
              },
            );
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
