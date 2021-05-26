import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteering/backEnd/dataBase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';

final _fireStore = FirebaseFirestore.instance;

class CheckBoxListTileDemo extends StatefulWidget {
  @override
  CheckBoxListTileDemoState createState() => new CheckBoxListTileDemoState();
}

class CheckBoxListTileDemoState extends State<CheckBoxListTileDemo> {
  List<CheckBoxListTileModel> checkBoxListTileModel;

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
        backgroundColor: Colors.white,
        centerTitle: true,
        title: new Text(
          'Preferred Events',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          if (checkBoxListTileModel == null)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (checkBoxListTileModel != null)
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: checkBoxListTileModel == null
                    ? 0
                    : checkBoxListTileModel.length,
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
          if (checkBoxListTileModel != null)
            SizedBox(
              height: 20,
            ),
          if (checkBoxListTileModel != null)
            ElevatedButton(
                onPressed: () {
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
                  Provider.of<Authentication>(context, listen: false)
                      .eventTypes = _preferredEvents;
                  Provider.of<Authentication>(context, listen: false)
                      .notifyListeners();
                  // preferredEvents = [];
                  Navigator.pushNamed(context, '/events_screen');
                },
                child: Text(
                  'Save',
                  textAlign: TextAlign.center,
                )),
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
