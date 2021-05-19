import 'package:flutter/material.dart';
import 'package:volunteering/components/radio_button.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/screens/registration_screen.dart';

const inactiveColor = Colors.white;
const activeColor = Color(0xff0962ff);

class RegisterType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(16, 17, 18, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'Register As',
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
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('images/1.png'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RegistrationScreen(userType: 'Volunteer')),
              );
            },
            child: RadioButton(
              colour: inactiveColor.withOpacity(0.06),
              selected: 'Volunteer',
              screen: 'events',
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(right: 40, left: 40, top: 3, bottom: 20),
          child: Text(
            'Register as a volunteer to be able to volunteer and attend charitable activities established by accredited committees.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.50),
              fontFamily: 'Aclonica',
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Image.asset('images/2.png'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RegistrationScreen(userType: 'committee')),
              );
            },
            child: RadioButton(
              colour: inactiveColor.withOpacity(0.06),
              selected: 'committee',
              screen: 'events',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, top: 3),
          child: Text(
            'Contribute to the establishment of volunteer activities that benefit the community.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.50),
              fontFamily: 'Aclonica',
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
