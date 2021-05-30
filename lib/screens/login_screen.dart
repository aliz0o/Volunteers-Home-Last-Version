import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteering/components/rounded_button.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/components/label.dart';
import 'package:volunteering/components/sub_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'events_screen.dart';
import 'package:volunteering/screens/register_type_screen.dart';

final emailTextController = TextEditingController();
final passwordTextController = TextEditingController();

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //  backgroundColor: Color.fromRGBO(16, 17, 18, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'Log In',
              style: kAppBarTextStyle,
            ),
          ),
          // backgroundColor: Colors.black,
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
            child: MyStateFull()));
  }
}

class MyStateFull extends StatefulWidget {
  @override
  _MyStateFullState createState() => _MyStateFullState();
}

class _MyStateFullState extends State<MyStateFull>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  final _cloudInstance = FirebaseFirestore.instance;
  String email = '';
  String password = '';
  bool showSpinner = false;
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Column(
        children: [
          Flexible(child: SizedBox(height: 50)),
          Flexible(
            flex: 3,
            child: Image.asset(
              'images/volunteer.png',
            ),
          ),
          Flexible(
            child: Text(
              'Volunteers Home',
              style: TextStyle(
                  fontFamily: 'Aclonica', fontSize: 29, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(child: SizedBox(height: 20)),
          Label(label: 'Email'),
          Padding(
            padding: textFieldPadding,
            child: TextFormField(
              controller: emailTextController,
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
              controller: passwordTextController,
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
                await _auth.signInWithEmailAndPassword(
                    email: email, password: password);
                var querySnapshotData =
                    await _cloudInstance.collection('users').get();
                var userData1 = querySnapshotData.docs.where((element) =>
                    element['email'] == email &&
                    (element['userType'] == 'committee') &&
                    element['verified'] == true);
                var userData2 = querySnapshotData.docs.where((element) =>
                    element['email'] == email &&
                    element['userType'] == 'volunteer' &&
                    element['verified'] == false);
                var userData3 = querySnapshotData.docs.where((element) =>
                    element['email'] == email &&
                    element['userType'] == 'Admin' &&
                    element['verified'] == true);

                print('userData.length1' + userData1.length.toString());

                if (userData1.length > 0 ||
                    userData3.length > 0 && userData2.length == 0) {
                  print('userData.length1' + userData1.length.toString());
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => EventsScreen()),
                      (Route<dynamic> route) => false);
                } else if (userData1.length <= 0 && userData2.length == 0) {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text('Alert'),
                            content: Text(
                                'your account is not verified yet plz wait Admin approval soon'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Center(child: Text("okay")),
                              )
                            ],
                          ));
                  _auth.signOut();
                } else
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => EventsScreen()),
                      (Route<dynamic> route) => false);

                setState(() {
                  showSpinner = false;
                });
                emailTextController.clear();
                passwordTextController.clear();
              } on FirebaseAuthException catch (e) {
                setState(() {
                  showSpinner = false;
                });
                print('Failed with error code: ${e.code}');
                print(e.message);

                return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text(e.code + 'Error'),
                          content: Text(
                            e.message,
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Center(child: Text("Try Again")),
                            )
                          ],
                        ));
                //   Alert(
                //   context: context,
                //   title: e.code + ' Error',
                //   desc: e.message,
                //   buttons: [
                //     DialogButton(
                //       child: Text(
                //         "Try Again",
                //         style: kAlertButtonStyle,
                //       ),
                //       onPressed: () => Navigator.pop(context),
                //       width: 120,
                //     )
                //   ],
                //   style: kAlertStyle,
                // ).show();
              }
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return RegisterType();
              }));
              emailTextController.clear();
              passwordTextController.clear();
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
