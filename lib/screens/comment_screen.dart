import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/services/get_user_info.dart';

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
        backgroundColor: Color(0xff0962ff),
        appBar: AppBar(
          title: Center(
            child: Text('Comments',
                style: kAppBarTextStyle.copyWith(fontSize: 21)),
          ),
          automaticallyImplyLeading: false,
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
        body: ListView.builder(
            itemCount: widget.comment.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Text(widget.comment[index]),
                  GetUser(
                      userID: widget.commentSender[index],
                      screen: 'comingList'),
                ],
              );
            }),
      ),
    );
  }
}
