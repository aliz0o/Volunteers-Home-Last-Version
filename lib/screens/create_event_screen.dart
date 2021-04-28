import 'dart:async';
import 'package:volunteering/components/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:volunteering/components/rounded_button.dart';
import 'package:volunteering/components/sub_text.dart';
import 'package:volunteering/constants.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io';

final snackBar = SnackBar(
  content: Text('Successfully Added... Waiting For Admin Approval.',
      style: TextStyle(fontSize: 10, fontFamily: 'Aclonica')),
  elevation: 5,
  backgroundColor: Color(0xff0962ff),
);
final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
DocumentReference ref = FirebaseFirestore.instance.collection('images').doc();
User loggedInUser;

const inactiveColor = Colors.white;
const activeColor = Color(0xff0962ff);
final format = DateFormat("yyyy-MM-dd HH:mm");

class CreateEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(16, 17, 18, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Create Event',
            style: kAppBarTextStyle,
          ),
        ),
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
  final picker = ImagePicker();
  var _currentCitySelected = 'Amman';
  var _currentTypeSelected = 'Medical';
  bool _volunteeringVisible = false;
  bool _attendingVisible = false;
  bool _imageUploadedVisibility = false;
  bool _timeDateAlertVisibility = false;
  bool _eventClassVisibility = false;

  String eventClass;
  int noOfAttendees = 0;
  int noOfVolunteers = 0;
  Timestamp eventDateTime;
  String city = 'Amman';
  String eventType = 'Medical';
  String details = '';
  Timestamp createdOn;
  String imageURL = '';
  File _selectedImage;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void setEventClass() {
    if ((_volunteeringVisible && _attendingVisible) == true) {
      setState(() {
        eventClass = 'All';
        _eventClassVisibility = false;
      });
    } else if ((_volunteeringVisible == true) && (_attendingVisible == false)) {
      setState(() {
        eventClass = 'Volunteering';
        _eventClassVisibility = false;
      });
    } else if ((_volunteeringVisible == false) && (_attendingVisible == true)) {
      eventClass = 'Attending';
      setState(() {
        eventClass = 'Attending';
        _eventClassVisibility = false;
      });
    } else
      setState(() {
        eventClass = null;
        _eventClassVisibility = true;
      });
  }

  void checkNullValue() {
    if (eventDateTime == null) {
      setState(() {
        _timeDateAlertVisibility = true;
      });
    } else {
      setState(() {
        _timeDateAlertVisibility = false;
      });
    }

    if (eventClass == null) {
      setState(() {
        _eventClassVisibility = true;
      });
    } else {
      setState(() {
        _eventClassVisibility = false;
      });
    }
  }

  void addDataToCloud() async {
    setState(() {
      showSpinner = true;
    });
    if (_selectedImage != null) {
      imageURL = await uploadFile(_selectedImage);
    }
    final eventID = await _fireStore.collection('events').add({
      'email': loggedInUser.email,
      'eventClass': eventClass,
      'noOfVolunteers': noOfVolunteers,
      'noOfAttendees': noOfAttendees,
      'eventDateTime': eventDateTime,
      'city': city,
      'eventType': eventType,
      'details': details,
      'createdOn': FieldValue.serverTimestamp(),
      "images": imageURL,
      'volunteersCounter': 0,
      'attendanceCounter': 0,
      'volunteers': FieldValue.arrayUnion([]),
      'attendance': FieldValue.arrayUnion([]),
      'comingVolunteerID': FieldValue.arrayUnion([]),
      'comingAttendanceID': FieldValue.arrayUnion([]),
      'all': FieldValue.arrayUnion([]),
      'userID': loggedInUser.uid,
      'approved': false,
    });

    await _fireStore.collection('users').doc(loggedInUser.uid).update({
      'eventCount': FieldValue.increment(1),
    });

    _fireStore.collection('messages').doc(eventID.id).set({
      'sender': FieldValue.arrayUnion([]),
      'message': FieldValue.arrayUnion([]),
      'eventId': eventID.id,
    });
    setState(() {
      showSpinner = false;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
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

  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.20)),
                    color: Colors.white.withOpacity(0.06)),
                height: 180,
                child: GestureDetector(
                  onTap: () async {
                    final pickedFile =
                        await picker.getImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      _selectedImage = File(pickedFile.path);
                      setState(() {
                        _imageUploadedVisibility = true;
                      });
                    } else {
                      print('No image selected.');
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.cloud_upload_rounded,
                          color: Colors.white, size: 80),
                      Align(
                        child: Text(
                          'Upload Image',
                          style: TextStyle(
                            fontFamily: 'Aclonica',
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Visibility(
              child: Text(
                'Image selected',
                style: TextStyle(color: Colors.white, fontFamily: 'Aclonica'),
              ),
              visible: _imageUploadedVisibility,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _volunteeringVisible = !_volunteeringVisible;
                    });
                    setEventClass();
                  },
                  child: RadioButton(
                      selected: 'Volunteering',
                      colour: _volunteeringVisible == true
                          ? activeColor.withOpacity(0.17)
                          : inactiveColor.withOpacity(0.06)),
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _attendingVisible = !_attendingVisible;
                      });
                      setEventClass();
                    },
                    child: RadioButton(
                        selected: 'Attending',
                        colour: _attendingVisible == true
                            ? activeColor.withOpacity(0.17)
                            : inactiveColor.withOpacity(0.06))),
              ],
            ),
            SizedBox(height: 5),
            Visibility(
              child: Text(
                'Select Your Event Type',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Aclonica',
                  fontSize: 10,
                ),
              ),
              visible: _eventClassVisibility,
            ),
            Visibility(
                visible: _eventClassVisibility, child: SizedBox(height: 7)),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 30, 0),
              child: Row(
                children: [
                  Visibility(
                      visible: _volunteeringVisible,
                      child: Text('Number Of\nVolunteers   ',
                          style: kNumberTextStyle)),
                  Visibility(
                    visible: _volunteeringVisible,
                    child: Flexible(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          noOfVolunteers = int.parse(value);
                        },
                        style: kTextFieldStyle,
                        decoration: kNumberFieldDecoration,
                      ),
                    ),
                  ),
                  Visibility(
                    child: SizedBox(width: 16),
                    visible: (_volunteeringVisible && _attendingVisible),
                  ),
                  Visibility(
                    visible: _attendingVisible,
                    child: Text('Number Of\nAttendees    ',
                        style: kNumberTextStyle),
                  ),
                  Visibility(
                    visible: _attendingVisible,
                    child: Flexible(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          noOfAttendees = int.parse(value);
                        },
                        style: kTextFieldStyle,
                        decoration: kNumberFieldDecoration,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
                visible: _volunteeringVisible || _attendingVisible,
                child: SizedBox(height: 13)),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: DateTimeField(
                onChanged: (value) {
                  setState(() {
                    eventDateTime = Timestamp.fromDate(value);
                    // var temp =
                    //     DateFormat('kk:mm:ss\n  EEE d MMM').format(value);
                    // eventDateTime = temp.toString();
                    _timeDateAlertVisibility = false;
                  });
                },
                resetIcon:
                    Icon(Icons.close, color: Colors.white.withOpacity(0.89)),
                format: format,
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                style: kDateTimeTextStyle,
                decoration: kDateTimeDecoration,
              ),
            ),
            Visibility(
                visible: _timeDateAlertVisibility, child: SizedBox(height: 12)),
            Visibility(
              child: Text(
                'Select Your Event Date And Time',
                style: TextStyle(
                    color: Colors.red, fontFamily: 'Aclonica', fontSize: 10),
              ),
              visible: _timeDateAlertVisibility,
            ),
            SizedBox(height: 10),
            Container(
              //height: 76,
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
                      city = newValueSelected;
                    },
                    value: _currentCitySelected,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              //height: 76,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    style: kDropDownTextStyle,
                    decoration: kDropDownInputDecoration,
                    dropdownColor: Color.fromRGBO(16, 17, 18, 1),
                    items: kEventTypeList.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                          child: Text(dropDownStringItem),
                          value: dropDownStringItem);
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      eventType = newValueSelected;
                    },
                    value: _currentTypeSelected,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextFormField(
                onChanged: (value) {
                  details = value;
                },
                textAlign: TextAlign.right,
                maxLines: null,
                //expands: true,
                keyboardType: TextInputType.multiline,
                style: kArabicTextStyle,
                decoration: kArabicTextDecoration,
              ),
            ),
            RoundedButton(
                text: 'Create',
                color: Color(0xff0962ff),
                function: ((eventDateTime == null) || (eventClass == null))
                    ? () {
                        checkNullValue();
                      }
                    : () {
                        addDataToCloud();
                      }),
            GestureDetector(
                onTap: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: SubText(last: 'Back')),
            SizedBox(height: 17),
          ],
        ),
      ),
    );
  }
}
