import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/services/get_user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteering/screens/events_screen.dart';

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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          //  backgroundColor: Color.fromRGBO(16, 17, 18, 1),
          appBar: AppBar(
            title: Center(
              child: Text('Comments',
                  style: kAppBarTextStyle.copyWith(fontSize: 21)),
            ),
            automaticallyImplyLeading: false,
            //backgroundColor: Colors.black,
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CommentStream(eventID: widget.eventID),
                SizedBox(height: 7),
                Container(
                  child: TextFormField(
                    controller: messageTextController,
                    onChanged: (value) {
                      commentText = value;
                    },
                    style: kArabicTextStyle.copyWith(color: Colors.black),
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.right,
                    maxLines: null,
                    decoration: kArabicTextDecoration.copyWith(
                      hintText: '..???????? ???????????? ??????',
                      hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.47),
                          fontSize: 12,
                          fontFamily: 'Amiri'),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xff0962ff),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.black.withOpacity(0.20)),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          messageTextController.clear();
                          widget.commentSender.add(loggedInUser.uid);
                          widget.comment.add(commentText);
                          _fireStore
                              .collection('events')
                              .doc(widget.eventID)
                              .update({
                            'comment': widget.comment,
                            'commentSender': widget.commentSender
                          });
                          setState(() {});
                          //Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.send,
                          color: Color(0xff0962ff),
                        ),
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
          if (snapshot.hasError) {
            return Center(
                child: Text("Something went wrong..",
                    style: kUserInfoTextStyle.copyWith(color: Colors.black)));
          }
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
                reverse: true,
                shrinkWrap: true,
                itemCount: comment.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GetUser(
                            userID: commentSender[comment.length - index - 1],
                            screen: 'commentScreen'),
                        Material(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          elevation: 5,
                          color: Color(0xff0888ff),
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 10, left: 30, top: 10, bottom: 10),
                            child: Text(
                              comment[comment.length - index - 1],
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
