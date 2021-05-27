import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteering/backEnd/dataBase.dart';


class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    Authentication authentication =
        Provider.of<Authentication>(context, listen: false);

    Map<String, dynamic> _userData = {};
    // _userData.add({ 'number' : '',
    //   'Item' : '',
    //   'Qty' : ''
    // });

    String _Name;
    String _Email;
    int _Phone;

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    InputDecoration textFieldInputDecoration(String hintText) {
      return InputDecoration(
          hintText: hintText,
          // hintStyle: TextStyle(color: Colors.white54),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black)));
    }

    TextStyle biggerTextStyle() {
      return TextStyle(color: Colors.white, fontSize: 17);
    }

    TextStyle simpleTextStyle() {
      return TextStyle(color: Colors.black, fontSize: 16);
    }

    return Scaffold(
      //    backgroundColor: Colors.black87,
      appBar: AppBar(
        //   backgroundColor: Colors.black87,
        title: Text("Edit  Profile"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                InkWell(
                  onTap: null,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: Column(
                      children: [
                        Container(
                            width: 130.0,
                            height: 130.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new NetworkImage(
                                        "https://style.anu.edu.au/_anu/4/images/placeholders/person.png")))),
                        TextButton(
                            onPressed: () {



                            },
                            child: Text(
                              'Edit profile pic',
                              style: TextStyle(color: Colors.blue),
                            ))
                      ],
                    ),
                  ),
                ),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty ? "Enter Name " : null;
                  },
                  onChanged: (val) {
                    _Name = val;
                  },
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration("   Name"),
                ),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty ? "Enter Email" : null;
                  },
                  onChanged: (val) {
                    _Email = val;
                  },
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration("   Email"),
                ),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty ? "Enter phone number" : null;
                  },
                  onChanged: (val) {
                    _Phone = int.parse(val);
                  },
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration("   phone"),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      _userData.addAll({
                        'email': _Email,
                        'name': _Name,
                        'phoneNumber': _Phone,
                      });

                      authentication.updateCollectionFields(
                          collectionName: 'users',
                          fields: _userData,
                          document_Id: authentication.getUserId);
                    },
                    child: Text('          Save          ')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
