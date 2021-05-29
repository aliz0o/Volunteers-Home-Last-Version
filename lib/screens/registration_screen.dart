import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:volunteering/components/rounded_button.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/components/label.dart';
import 'package:volunteering/components/sub_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:volunteering/screens/events_screen.dart';

final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
DocumentReference ref = FirebaseFirestore.instance.collection('images').doc();

final nameTextController = TextEditingController();
final phoneNumberTextController = TextEditingController();
final emailTextController = TextEditingController();
final passwordTextController = TextEditingController();
final aboutTextController = TextEditingController();

const inactiveColor = Colors.white;
const activeColor = Color(0xff0962ff);

class RegistrationScreen extends StatelessWidget {
  final String userType;
  RegistrationScreen({@required this.userType});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Sign Up',
            style: kAppBarTextStyle,
          ),
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Colors.blue[400],
              Colors.blue[900],
            ],
          )),
          child: MyStateFull(userType: this.userType)),
    );
  }
}

class MyStateFull extends StatefulWidget {
  final String userType;
  MyStateFull({this.userType});
  @override
  _MyStateFullState createState() => _MyStateFullState();
}

class _MyStateFullState extends State<MyStateFull> {
  final picker = ImagePicker();
  var _currentCitySelected = 'Amman';
  String email;
  String password;
  bool showSpinner = false;
  String name;
  int phoneNumber;
  int age;
  String city = 'Amman';
  String about = '';
  String imageURL = '';
  File _selectedImage;
  bool _nameVisibility = false;
  bool _phoneNumberVisibility = false;
  bool _imageUploadedVisibility = false;
  bool _imageVisibility = false;

  void checkNullValue() {
    if (name == null || name == "") {
      setState(() {
        _nameVisibility = true;
      });
    } else
      setState(() {
        _nameVisibility = false;
      });

    if (phoneNumber.toString().length < 9) {
      print(phoneNumber.toString().length);
      setState(() {
        _phoneNumberVisibility = true;
      });
    } else
      setState(() {
        _phoneNumberVisibility = false;
      });

    if (_selectedImage == null)
      setState(() {
        _imageVisibility = true;
      });
    else
      setState(() {
        _imageVisibility = false;
      });
  }

  Future<String> uploadFile(File _image) async {
    String filename = _image.path;
    Reference storageReference =
        FirebaseStorage.instance.ref().child('events').child(filename);
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask;
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        returnURL = fileURL;
      });
    });
    return returnURL;
  }

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
                controller: nameTextController,
                onChanged: (value) {
                  name = value;
                  setState(() {
                    _nameVisibility = false;
                  });
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s")),
                  LengthLimitingTextInputFormatter(20),
                ],
                keyboardType: TextInputType.text,
                style: kTextFieldStyle,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Your Name'),
              ),
            ),
            SizedBox(height: 10),
            Visibility(
              child: Text(
                'You Should Enter Your Name',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Aclonica',
                  fontSize: 10,
                ),
              ),
              visible: _nameVisibility,
            ),
            Visibility(child: SizedBox(height: 10), visible: _nameVisibility),
            Label(label: 'Phone Number'),
            Padding(
              padding: textFieldPadding,
              child: TextFormField(
                controller: phoneNumberTextController,
                onChanged: (value) {
                  phoneNumber = int.parse(value);
                  setState(() {
                    _phoneNumberVisibility = false;
                  });
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
            Visibility(
              child: Text(
                'You Should Enter Enter A Valid 10-Digit Phone Number',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Aclonica',
                  fontSize: 10,
                ),
              ),
              visible: _phoneNumberVisibility,
            ),
            Visibility(
                child: SizedBox(height: 10), visible: _phoneNumberVisibility),
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
            Label(label: 'About'),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextFormField(
                controller: aboutTextController,
                onChanged: (value) {
                  about = value;
                },
                textAlign: TextAlign.right,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: kArabicTextStyle,
                decoration: kArabicTextDecoration,
              ),
            ),
            Visibility(
                visible: widget.userType == 'committee' ? true : false,
                child: SizedBox(height: 13)),
            Visibility(
                visible: widget.userType == 'committee' ? true : false,
                child: Label(label: 'Verification Documents')),
            Visibility(
              visible: widget.userType == 'committee' ? true : false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.20)),
                      color: Colors.white.withOpacity(0.06)),
                  height: 48,
                  child: GestureDetector(
                    onTap: () async {
                      final pickedFile =
                          await picker.getImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        _selectedImage = File(pickedFile.path);
                        setState(() {
                          _imageUploadedVisibility = true;
                          _imageVisibility = false;
                        });
                      } else {
                        print('No image selected.');
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          child: Text(
                            'Upload Image   ',
                            style: TextStyle(
                              fontFamily: 'Aclonica',
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Icon(Icons.cloud_upload_rounded,
                            color: Colors.white, size: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: widget.userType == 'committee'
                    ? _imageUploadedVisibility
                    : false,
                child: SizedBox(height: 10)),
            Visibility(
              child: Text(
                'Image selected',
                style: TextStyle(color: Colors.white, fontFamily: 'Aclonica'),
              ),
              visible: _imageUploadedVisibility,
            ),
            Visibility(
              child: SizedBox(height: 10),
              visible:
                  widget.userType == 'committee' ? _imageVisibility : false,
            ),
            Visibility(
              child: Text(
                'Upload An Verification Document To Sign in AS Committee',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Aclonica',
                  fontSize: 10,
                ),
              ),
              visible:
                  widget.userType == 'committee' ? _imageVisibility : false,
            ),
            SizedBox(height: 13),
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
                    kTextFieldDecoration.copyWith(hintText: 'you@email.com'),
              ),
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 5),
            RoundedButton(
              text: 'sign up',
              color: Color(0xff0962ff),
              function: ((name == null || name == "") ||
                      (phoneNumber.toString().length < 9) ||
                      (_selectedImage == null &&
                          widget.userType == 'committee'))
                  ? () {
                      print('1');
                      checkNullValue();
                    }
                  : () async {
                      print('2');
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        print('3');
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          print('4');
                          await _fireStore
                              .collection('users')
                              .doc(newUser.user.uid)
                              .set({
                            'email': email,
                            'name': name,
                            'phoneNumber': phoneNumber,
                            'city': city,
                            'createdOn': FieldValue.serverTimestamp(),
                            'eventCount': 0,
                            'reportedCount': 0,
                            'userType': widget.userType,
                            'about': about,
                            'preferredEvents': FieldValue.arrayUnion([]),
                            'verified': false,
                            'verificationDocument': '',
                            'profilePicture': '',
                          });
                          if (_selectedImage != null) {
                            imageURL = await uploadFile(_selectedImage);
                          }
                          await _fireStore
                              .collection('users')
                              .doc(newUser.user.uid)
                              .update({'verificationDocument': imageURL});

                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => EventsScreen()),
                              (Route<dynamic> route) => false);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                        nameTextController.clear();
                        phoneNumberTextController.clear();
                        emailTextController.clear();
                        passwordTextController.clear();
                        aboutTextController.clear();
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
                  Navigator.pushNamed(context, '/login_screen');
                  nameTextController.clear();
                  phoneNumberTextController.clear();
                  emailTextController.clear();
                  passwordTextController.clear();
                  aboutTextController.clear();
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
