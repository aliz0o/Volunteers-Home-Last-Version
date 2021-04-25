import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:volunteering/components/radio_button.dart';
import 'package:volunteering/components/rounded_button.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/components/label.dart';
import 'package:volunteering/components/sub_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

const inactiveColor = Colors.white;
const activeColor = Color(0xff0962ff);

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(16, 17, 18, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'sign in',
            style: kAppBarTextStyle,
          ),
        ),
        //backgroundColor: Color(0xFF2C2C2C),
        backgroundColor: Colors.black,
      ),
      body: MyStateFull(),
    );
  }
}

class MyStateFull extends StatefulWidget {
  @override
  _MyStateFullState createState() => _MyStateFullState();
}

class _MyStateFullState extends State<MyStateFull> {
  var _currentCitySelected = 'Amman';
  String email;
  String password;
  bool showSpinner = false;
  String name;
  int phoneNumber;
  int age;
  String gender;
  String city = 'Amman';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Label(label: 'Name'),
            Padding(
              padding: textFieldPadding,
              child: TextFormField(
                onChanged: (value) {
                  name = value;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s")),
                ],
                keyboardType: TextInputType.text,
                style: kTextFieldStyle,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Your Name'),
              ),
            ),
            SizedBox(height: 10),
            Label(label: 'Phone Number'),
            Padding(
              padding: textFieldPadding,
              child: TextFormField(
                onChanged: (value) {
                  phoneNumber = int.parse(value);
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                keyboardType: TextInputType.phone,
                style: kTextFieldStyle,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: '0781234567'),
              ),
            ),
            SizedBox(height: 10),
            Label(label: 'Age'),
            Padding(
              padding: textFieldPadding,
              child: TextFormField(
                onChanged: (value) {
                  age = int.parse(value);
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2),
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                keyboardType: TextInputType.number,
                style: kTextFieldStyle,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Your Age'),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      gender = 'Male';
                    });
                  },
                  child: RadioButton(
                      selected: 'Male',
                      colour: gender == 'Male'
                          ? activeColor.withOpacity(0.17)
                          : inactiveColor.withOpacity(0.06)),
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = 'Female';
                      });
                    },
                    child: RadioButton(
                        selected: 'female',
                        colour: gender == 'Female'
                            ? activeColor.withOpacity(0.17)
                            : inactiveColor.withOpacity(0.06))),
              ],
            ),
            SizedBox(height: 10),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    style: kDropDownTextStyle,
                    decoration: kDropDownInputDecoration,
                    dropdownColor: Color.fromRGBO(16, 17, 18, 1),
                    items: kCityList.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                          child: Text(dropDownStringItem),
                          value: dropDownStringItem);
                    }).toList(),
                    onChanged: (value) {
                      city = value;
                    },
                    value: _currentCitySelected,
                  ),
                ),
              ),
            ),
            SizedBox(height: 13),
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
                    kTextFieldDecoration.copyWith(hintText: 'you@email.com'),
              ),
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 5),
            RoundedButton(
              text: 'sign up',
              color: Color(0xff0962ff),
              function: () async {
                setState(() {
                  showSpinner = true;
                });
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if (newUser != null) {
                    await _fireStore
                        .collection('users')
                        .doc(newUser.user.uid)
                        .set({
                      'email': email,
                      'name': name,
                      'phoneNumber': phoneNumber,
                      'age': age,
                      'gender': gender,
                      'city': city,
                      'createdOn': FieldValue.serverTimestamp(),
                    });
                    Navigator.pushNamed(context, '/events_screen');
                  }
                  setState(() {
                    showSpinner = false;
                  });
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    showSpinner = false;
                  });
                  print('Failed with error code: ${e.code}');
                  print(e.message);
                  return Alert(
                    context: context,
                    title: e.code + ' Error',
                    desc: e.message,
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Try Again",
                          style: kAlertButtonStyle,
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 120,
                      )
                    ],
                    style: kAlertStyle,
                  ).show();
                }
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: SubText(
                first: 'Already have Account \?',
                last: '  log In',
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
