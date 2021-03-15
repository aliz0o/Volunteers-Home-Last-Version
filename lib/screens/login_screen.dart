import 'package:flutter/material.dart';
import 'package:volunteering/components/rounded_button.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/components/label.dart';
import 'package:volunteering/components/sub_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(16, 17, 18, 1),
        appBar: AppBar(
          title: Center(
            child: Text(
              'log in',
              style: kAppBarTextStyle,
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: MyStateFull());
  }
}

class MyStateFull extends StatefulWidget {
  @override
  _MyStateFullState createState() => _MyStateFullState();
}

class _MyStateFullState extends State<MyStateFull> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Column(
        children: [
          Flexible(child: SizedBox(height: 155)),
          Flexible(
            child: Text(
              'Volunteers\nHome',
              style: TextStyle(
                  fontFamily: 'Aclonica', fontSize: 40, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(child: SizedBox(height: 150)),
          Label(label: 'Email'),
          Padding(
            padding: textFieldPadding,
            child: TextFormField(
              onChanged: (value) {
                email = value;
              },
              keyboardType: TextInputType.emailAddress,
              style: kTextFieldStyle,
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'You@Email.com'),
            ),
          ),
          SizedBox(height: 15),
          Label(label: 'Password'),
          Padding(
            padding: textFieldPadding,
            child: TextFormField(
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              style: kTextFieldStyle,
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Your Password'),
            ),
          ),
          SizedBox(height: 15),
          RoundedButton(
            text: 'log in',
            color: Color(0xff0962ff),
            function: () async {
              setState(() {
                showSpinner = true;
              });
              try {
                final existUser = await _auth.signInWithEmailAndPassword(
                    email: email, password: password);
                if (existUser != null) {
                  Navigator.pushNamed(context, '/events_screen');
                }
                setState(() {
                  showSpinner = false;
                });
              } catch (e) {
                print(e);
              }
            },
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                Navigator.pushNamed(context, '/registration_screen');
              });
            },
            child: SubText(
              first: 'Don\'t have Account \?',
              last: '  Sign In',
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
