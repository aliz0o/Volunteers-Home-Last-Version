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
          backgroundColor: Color.fromRGBO(16, 17, 18, 1),
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
              reverse: true,
              itemCount: widget.comment.length,
              itemBuilder: (context, index) {
                return widget.commentSender.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Ali Mustafa',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontFamily: 'Aclonica')),
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
                                  widget.comment[index],
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
                      )
                    : Center(child: Text('Empty'));
              })),
    );
  }
}
