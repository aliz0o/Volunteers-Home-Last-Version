import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:volunteering/components/rounded_button.dart';
import 'package:volunteering/components/label.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteering/screens/events_screen.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:volunteering/screens/profile_screen.dart';

final _fireStore = FirebaseFirestore.instance;

DocumentReference ref = FirebaseFirestore.instance.collection('images').doc();
String newName;
int newPhoneNumber;
String newCity;
String newProfilePicture;

File selectedImage;

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
            height: MediaQuery.of(context).size.height,
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
  final String name;
  final int phoneNumber;
  final String city;
  final String profilePicture;
  MyStateFull({this.name, this.phoneNumber, this.city, this.profilePicture});

  @override
  _MyStateFullState createState() => _MyStateFullState();
}

class _MyStateFullState extends State<MyStateFull> {
  @override
  void initState() {
    newName = widget.name;
    newPhoneNumber = widget.phoneNumber;
    newCity = widget.city;
    newProfilePicture = widget.profilePicture;
    super.initState();
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

  bool imageUploadedVisibility = false;
  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
    bool showSpinner = false;
    return ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              GestureDetector(
                onTap: () async {
                  final pickedFile =
                      await picker.getImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    selectedImage = File(pickedFile.path);
                    setState(() {
                      imageUploadedVisibility = true;
                    });
                  } else {
                    print('No image selected.');
                  }
                },
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
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
                              image: newProfilePicture == '' ||
                                      newProfilePicture == null
                                  ? AssetImage('images/male.png')
                                  : NetworkImage(
                                      newProfilePicture,
                                    ),
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
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
              ),
              Visibility(
                child: Text(
                  '\nImage selected',
                  style: TextStyle(color: Colors.white, fontFamily: 'Aclonica'),
                ),
                visible: imageUploadedVisibility,
              ),
              SizedBox(height: 50),
              Label(label: 'Name'),
              Padding(
                padding: textFieldPadding,
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s")),
                    LengthLimitingTextInputFormatter(20),
                  ],
                  keyboardType: TextInputType.text,
                  //controller: TextEditingController()..text = widget.name,
                  onChanged: (value) {
                    newName = value;
                  },
                  style: kTextFieldStyle,
                  decoration: kTextFieldDecoration.copyWith(hintText: newName),
                ),
              ),
              SizedBox(height: 23),
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
                      value: newCity,
                      onChanged: (value) {
                        newCity = value;
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Label(label: 'Phone Number'),
              Padding(
                padding: textFieldPadding,
                child: TextFormField(
                  // controller: TextEditingController()
                  //   ..text = widget.phoneNumber.toString(),
                  onChanged: (value) {
                    newPhoneNumber = int.parse(value);
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  style: kTextFieldStyle,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: newPhoneNumber.toString()),
                ),
              ),
              SizedBox(height: 15),
              RoundedButton(
                  text: 'Update',
                  color: Color(0xff0962ff),
                  function: () async {
                    setState(() {
                      showSpinner =!showSpinner;
                    });


                      await _fireStore
                          .collection('users')
                          .doc(loggedInUser.uid)
                          .update({
                        'name': newName,
                        'phoneNumber': newPhoneNumber,
                        'city': newCity,
                      });
                      if (selectedImage != null) {
                        newProfilePicture = await uploadFile(selectedImage);
                        await _fireStore
                            .collection('users')
                            .doc(loggedInUser.uid)
                            .update({'photoUrl': newProfilePicture});




                      }
                    setState(() {
                      showSpinner =!showSpinner;
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(saveSuccessfullySnackBar);







                    //Navigator.pop(context);
                  }),
              SizedBox(height: 215),
            ],
          ),
        ));
  }

  final saveSuccessfullySnackBar = SnackBar(
    content: Text('Your information  Updated Successfully',
        style: TextStyle(fontSize: 15, fontFamily: 'Aclonica')),
    elevation: 5,
    backgroundColor: Colors.black,
  );



}
