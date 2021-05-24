import 'package:flutter/material.dart';
import 'package:volunteering/components/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<String> preferredEvents;
final _fireStore = FirebaseFirestore.instance;

class CheckBoxListTileDemo extends StatefulWidget {
  final String userID;
  CheckBoxListTileDemo({@required this.userID});
  @override
  CheckBoxListTileDemoState createState() => new CheckBoxListTileDemoState();
}

class CheckBoxListTileDemoState extends State<CheckBoxListTileDemo> {
  List<CheckBoxListTileModel> checkBoxListTileModel =
      CheckBoxListTileModel.getUsers();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: new Text(
          'Preferred Events',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: checkBoxListTileModel.length,
              itemBuilder: (BuildContext context, int index) {
                return new Card(
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
          RoundedButton(
            text: 'Submit',
            color: Color(0xff0962ff),
            function: () {
              for (var index = 0;
                  index < checkBoxListTileModel.length;
                  index++) {
                if (checkBoxListTileModel[index].isCheck == true) {
                  _fireStore.collection('users').doc(widget.userID).update({
                    'preferredEvents': FieldValue.arrayUnion(
                        [checkBoxListTileModel[index].title]),
                  });
                }
              }
              Navigator.pushNamed(context, '/events_screen');
            },
          )
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

  static List<CheckBoxListTileModel> getUsers() {
    return <CheckBoxListTileModel>[
      CheckBoxListTileModel(title: "Educational", isCheck: false),
      CheckBoxListTileModel(title: "Medical", isCheck: false),
      CheckBoxListTileModel(title: "Cultural", isCheck: false),
      CheckBoxListTileModel(title: "Religious", isCheck: false),
      CheckBoxListTileModel(title: "Entertaining", isCheck: false),
      CheckBoxListTileModel(title: "Environmental", isCheck: false),
      CheckBoxListTileModel(title: "Other", isCheck: false),
    ];
  }
}
