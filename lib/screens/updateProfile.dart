import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {


    TextEditingController _Name = TextEditingController();
    TextEditingController _UserName = TextEditingController();
    TextEditingController _Wepsite = TextEditingController();
    TextEditingController _Bio = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    InputDecoration textFieldInputDecoration(String hintText) {
      return InputDecoration(
          hintText: hintText,
         // hintStyle: TextStyle(color: Colors.white54),
          focusedBorder:
         UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)));
    }
    TextStyle biggerTextStyle() {
      return TextStyle(color: Colors.white, fontSize: 17);
    }

    TextStyle simpleTextStyle() {
      return TextStyle(color: Colors.white, fontSize: 16);
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
                        TextButton(onPressed: null, child: Text('Edit profile pic',style: TextStyle(color: Colors.blue),))
                      ],
                    ),
                  ),
                ),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty
                        ? "Enter Name "
                        : null;},
                  controller: _Name,
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration("   Name"),
                ),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty
                        ? "Enter Email"
                        :null;
                  },
                  controller: _UserName,
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration("   Email"),
                ),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty
                        ? "Enter phone number"
                        : null;
                  },
                  controller: _Wepsite,
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration("   phone"),
                ),
                // TextFormField(
                //   validator: (val) {
                //     return val.isEmpty
                //         ? "Enter Bio"
                //         : null;
                //   },
                //   controller: _Bio,
                //   style: simpleTextStyle(),
                //   decoration: textFieldInputDecoration("   Bio"),
                // ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(

                    onPressed:(){

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