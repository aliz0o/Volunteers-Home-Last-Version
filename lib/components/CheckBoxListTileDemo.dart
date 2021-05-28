import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteering/components/rounded_button.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/screens/events_screen.dart';

final _fireStore = FirebaseFirestore.instance;

final saveSuccessfullySnackBar = SnackBar(
  content: Text('Your Preferred Events Updated Successfully',
      style: TextStyle(fontSize: 10, fontFamily: 'Aclonica')),
  elevation: 5,
  backgroundColor: Color(0xff0962ff),
);

class CheckBoxListTileDemo extends StatefulWidget {
  @override
  CheckBoxListTileDemoState createState() => new CheckBoxListTileDemoState();
}

class CheckBoxListTileDemoState extends State<CheckBoxListTileDemo> {
  List<CheckBoxListTileModel> checkBoxListTileModel = [];

  void getElements() async {
    var data = await _fireStore.collection('users').doc(loggedInUser.uid).get();
    List<dynamic> check = data.data()['preferredEvents'];
    List<CheckBoxListTileModel> _checkBoxListTileModel =
        <CheckBoxListTileModel>[
      CheckBoxListTileModel(
          title: "Educational", isCheck: check.contains('Educational')),
      CheckBoxListTileModel(
          title: "Medical", isCheck: check.contains('Medical')),
      CheckBoxListTileModel(
          title: "Cultural", isCheck: check.contains('Cultural')),
      CheckBoxListTileModel(
          title: "Religious", isCheck: check.contains('Religious')),
      CheckBoxListTileModel(
          title: "Entertaining", isCheck: check.contains('Entertaining')),
      CheckBoxListTileModel(
          title: "Environmental", isCheck: check.contains('Environmental')),
      CheckBoxListTileModel(title: "Other", isCheck: check.contains('Other')),
    ];
    setState(() {
      checkBoxListTileModel = _checkBoxListTileModel;
    });
  }

  @override
  void initState() {
    super.initState();
    getElements();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        //backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: new Text(
          'Preferred Events',
          style: kAppBarTextStyle.copyWith(fontSize: 22),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: checkBoxListTileModel.length,
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                  elevation: 5,
                  child: new Container(
                    padding: new EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        new CheckboxListTile(
                            activeColor: Colors.pink[300],
                            dense: true,
                            title: new Text(
                              checkBoxListTileModel[index].title,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  fontFamily: 'Product Sans'),
                            ),
                            value: checkBoxListTileModel[index].isCheck,
                            onChanged: (bool val) {
                              itemChange(val, index);
                            })
                      ],
                    ),
                  ),
                );
              }),
          SizedBox(
            height: 20,
          ),
          RoundedButton(
              text: 'Save',
              function: () {
                List<String> _preferredEvents = [];
                for (var index = 0;
                    index < checkBoxListTileModel.length;
                    index++) {
                  if (checkBoxListTileModel[index].isCheck == true) {
                    print(checkBoxListTileModel[index].title);
                    _preferredEvents.add(checkBoxListTileModel[index].title);
                  }
                }
                _fireStore
                    .collection('users')
                    .doc(loggedInUser.uid)
                    .update({'preferredEvents': _preferredEvents});
                ScaffoldMessenger.of(context)
                    .showSnackBar(saveSuccessfullySnackBar);
              },
              color: Color(0xff0962ff)),
        ],
      ),
    );
  }

  void itemChange(bool val, int index) {
    setState(() {
      checkBoxListTileModel[index].isCheck = val;
    });
  }
}

class CheckBoxListTileModel {
  String title;
  bool isCheck;
  CheckBoxListTileModel({this.title, this.isCheck});
}
