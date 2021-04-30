import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/services/get_user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteering/services/events_stream_builder.dart';

final _fireStore = FirebaseFirestore.instance;
final messageTextController = TextEditingController();
String commentText;

class CommentScreen extends StatefulWidget {
  final List comment;
  final List commentSender;
  final String eventID;

  CommentScreen({
    @required this.comment,
    @required this.commentSender,
    @required this.eventID,
  });
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Color.fromRGBO(16, 17, 18, 1),
          appBar: AppBar(
            title: Center(
              child: Text('Comments',
                  style: kAppBarTextStyle.copyWith(fontSize: 21)),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
          ),
          // floatingActionButton: FloatingActionButton.extended(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   label: Text('Events', style: kTapControllerTextStyle),
          //   icon: Icon(Icons.arrow_back_ios_outlined),
          //   backgroundColor: Color.fromRGBO(20, 21, 22, 1),
          // ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CommentStream(eventID: widget.eventID),
                Container(
                  child: TextFormField(
                    controller: messageTextController,
                    onChanged: (value) {
                      commentText = value;
                    },
                    style: kTextFieldStyle,
                    maxLines: null,
                    decoration: kArabicTextDecoration.copyWith(
                      hintText: 'Type your comment here...',
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: GestureDetector(
                          onTap: () {
                            messageTextController.clear();

                            widget.commentSender.add(loggedInUser.uid);
                            widget.comment.add(commentText);
                            _fireStore
                                .collection('events')
                                .doc(widget.eventID)
                                .update({
                              'comment': widget.comment,
                              'commentSender': widget.commentSender,
                            });
                          },
                          child: Icon(
                            Icons.send,
                            color: Color(0xff0962ff),
                          ),
                        ), // icon is 48px widget.
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class CommentStream extends StatelessWidget {
  final String eventID;
  CommentStream({@required this.eventID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _fireStore.collection('events').doc(this.eventID).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final documents = snapshot.data.data();
          List<dynamic> comment = documents['comment'];
          List<dynamic> commentSender = documents['commentSender'];

          return Expanded(
            child: ListView.builder(
                itemCount: comment.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GetUser(
                            userID: commentSender[index],
                            screen: 'commentScreen'),
                        Material(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          elevation: 5,
                          color: Color(0xff0962ff),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: Text(
                              comment[index],
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontFamily: 'Lalezar'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          );
        });
  }
}
