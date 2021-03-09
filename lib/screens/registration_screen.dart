import 'package:flutter/material.dart';
import 'package:volunteering/components/radio_button.dart';
import 'package:volunteering/components/rounded_button.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/components/label.dart';
import 'package:volunteering/components/sub_text.dart';
import 'package:firebase_auth/firebase_auth.dart';

const inactiveColor = Colors.white;
const activeColor = Color(0xff0962ff);
enum Gender { male, female }

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
  Gender selectedGender;
  var _currentCitySelected = 'Amman';

  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Label(label: 'Name'),
          Padding(
            padding: textFieldPadding,
            child: TextFormField(
              keyboardType: TextInputType.phone,
              style: kTextFieldStyle,
              decoration: kTextFieldDecoration.copyWith(hintText: 'Your Name'),
            ),
          ),
          SizedBox(height: 10),
          Label(label: 'Phone Number'),
          Padding(
            padding: textFieldPadding,
            child: TextFormField(
              keyboardType: TextInputType.phone,
              style: kTextFieldStyle,
              decoration: kTextFieldDecoration.copyWith(hintText: '0781234567'),
            ),
          ),
          SizedBox(height: 10),
          Label(label: 'Age'),
          Padding(
            padding: textFieldPadding,
            child: TextFormField(
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
                    selectedGender = Gender.male;
                  });
                },
                child: RadioButton(
                    selected: 'male',
                    colour: selectedGender == Gender.male
                        ? activeColor.withOpacity(0.17)
                        : inactiveColor.withOpacity(0.06)),
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = Gender.female;
                    });
                  },
                  child: RadioButton(
                      selected: 'female',
                      colour: selectedGender == Gender.female
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
                  onChanged: (String newValueSelected) {
                    //city = newValueSelected;
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
                  //Navigator.pushNamed(context, ChatScreen.id);
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
    );
  }
}
