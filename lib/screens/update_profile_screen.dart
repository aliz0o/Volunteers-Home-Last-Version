import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:volunteering/components/rounded_button.dart';
import 'package:volunteering/components/label.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteering/screens/events_screen.dart';

final _fireStore = FirebaseFirestore.instance;

class UpdateProfilePage extends StatelessWidget {
  final String name;
  final int phoneNumber;
  final String city;
  final String profilePicture;
  UpdateProfilePage(
      {this.name, this.phoneNumber, this.city, this.profilePicture});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'Update Profile',
              style: kAppBarTextStyle,
            ),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue[300],
                Colors.indigo[900],
              ],
            )),
            child: MyStateFull(
                name: this.name,
                city: this.city,
                phoneNumber: this.phoneNumber,
                profilePicture: this.profilePicture)));
  }
}

class MyStateFull extends StatefulWidget {
  String name;
  int phoneNumber;
  String city;
  String profilePicture;
  MyStateFull({this.name, this.phoneNumber, this.city, this.profilePicture});

  @override
  _MyStateFullState createState() => _MyStateFullState();
}

class _MyStateFullState extends State<MyStateFull> {
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: false,
        child: Column(
          children: [
            SizedBox(height: 50),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: widget.profilePicture == ''
                              ? AssetImage('images/male.png')
                              : NetworkImage(widget.profilePicture),
                        )),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Colors.green,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
            ),
            Label(label: 'Name'),
            Padding(
              padding: textFieldPadding,
              child: TextFormField(
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s")),
                //   LengthLimitingTextInputFormatter(20),
                // ],
                keyboardType: TextInputType.text,
                controller: TextEditingController()..text = widget.name,
                onChanged: (value) {
                  widget.name = value;
                },
                style: kTextFieldStyle,
                decoration: kTextFieldDecoration.copyWith(hintText: ''),
              ),
            ),
            SizedBox(height: 15),
            Label(label: 'Phone Number'),
            Padding(
              padding: textFieldPadding,
              child: TextFormField(
                controller: TextEditingController()
                  ..text = widget.phoneNumber.toString(),
                onChanged: (value) {
                  widget.phoneNumber = int.parse(value);
                },
                // obscureText: true,
                style: kTextFieldStyle,
                decoration: kTextFieldDecoration.copyWith(hintText: ''),
              ),
            ),
            SizedBox(height: 15),
            RoundedButton(
                text: 'Update',
                color: Color(0xff0962ff),
                function: () {
                  _fireStore.collection('users').doc(loggedInUser.uid).update({
                    'name': widget.name,
                    'phoneNumber': widget.phoneNumber,
                  });
                }),
          ],
        ));
  }
}
