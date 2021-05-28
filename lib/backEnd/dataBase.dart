import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Authentication with ChangeNotifier {
  Authentication() {
    print('Authentication condtructor');
    getCurrentUser();
  }
  String name;
  String user_id;
  String Email;
  String Fname;
  String Lname;
  String Age;
  String Phone;
  String PhotoUrl;
  List<String> eventTypes = [];
  bool get isAuth {
    return _auth.currentUser != null;
  }

  String get getUserId {
    return user_id;
  }

  String get getUserEmail {
    return Email;
  }

  Future<int> get getPostsNo async {
    var querySnapshotData = await _cloudInstance.collection('posts').get();
    var userData =
        querySnapshotData.docs.where((element) => element['userId'] == user_id);
    // var userData = querySnapshotData.docs;
    if (userData != null) {
      return userData.length;
    }
    return 0;
  }

  final String _collection = 'collectionName';

  Future<int> getUserPostsNo(String user_Id) async {
    var querySnapshotData = await _cloudInstance.collection('posts').get();
    var userData =
        querySnapshotData.docs.where((element) => element['userId'] == user_Id);
    // var userData = querySnapshotData.docs;
    if (userData != null) {
      return userData.length;
    }
    return 0;
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  final _cloudInstance = FirebaseFirestore.instance;

  Future<bool> SignUp_user(String Email, String password, context, Fname, Lname,
      Age, Phone, type, gender) async {
    bool success = false;

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: Email,
        password: password,
      );

      if (userCredential != null) {
        user_id = userCredential.user.uid;
        Email = userCredential.user.email;
        _cloudInstance.collection('users').doc(userCredential.user.uid).set({
          'Age': Age,
          'Email': Email,
          'Fname': Fname,
          'Lname': Lname,
          'phon': Phone,
          'photoUrl': '',
          'type': type,
          'gender': gender,
          'userId': userCredential.user.uid,
          'createdOn': FieldValue.serverTimestamp(),
          'eventCount': 0,
        });
        _auth.currentUser.displayName;
        _auth.currentUser.photoURL;
        _auth.currentUser.updateProfile(displayName: Fname + ' ' + Lname);
        return true;
      }
    } catch (e) {
      Alert(
        context: context,
        title: e.code + ' Error',
        desc: e.message,
        buttons: [
          DialogButton(
            child: Text(
              "Try Again",
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
    return false;
    // return success;
  }

  Future<void> changeUserProfileImage({@required File file}) async {
    String fileURL = '';
    try {
      print('Start upload Profile Image To Firebase');
      String userId = getUserId;

      Reference firebaseStorageRef = FirebaseStorage.instance.ref();
      firebaseStorageRef
          .child('$userId/$userId')
          .putFile(file)
          .then((TaskSnapshot taskSnapshot) {
        taskSnapshot.ref.getDownloadURL().then((value) async {
          print("Done: $value");
          fileURL = value;
          await _auth.currentUser.updateProfile(photoURL: fileURL);
          _auth.currentUser.reload();
          PhotoUrl = value;
          updateCollectionField(
              collectionName: 'users',
              fieldName: 'photoUrl',
              fieldValue: value,
              document_Id: userId);
          print(
              'ttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt');
        });
      });
    } catch (e) {
      print('error From change User profile Image\n$e');
    }
  }

  Future<String> uploadtoFireStorage(
      {@required String filePath, @required File file}) async {
    String fileURL = '';
    try {
      print('Start upload Profile Image To Firebase');
      String userId = getUserId;

      Reference firebaseStorageRef = FirebaseStorage.instance.ref();
      await firebaseStorageRef
          .child(filePath)
          .putFile(file)
          .whenComplete(() async {
        fileURL = await firebaseStorageRef.child(filePath).getDownloadURL();
      });
      print('fileURL from method $fileURL ');
      // fileURL= await firebaseStorageRef
      //     .child(filePath)
      //     .getDownloadURL();
    } catch (e) {
      print('error From change User profile Image\n$e');
    }
    return fileURL;
  }

  Future<void> getCurrentUser() async {
    try {
      var user = _auth.currentUser;

      if (user != null) {
        user_id = user.uid;
        Email = user.email;
        PhotoUrl = user.photoURL;
        print(user.uid);
        var userInfo =
            await _cloudInstance.collection('users').doc(user.uid).get();
        Age = userInfo.data()['Age'];
        Fname = userInfo.data()['Fname'];
        Lname = userInfo.data()['Lname'];
        Phone = userInfo.data()['phon'];
        List<dynamic> events = userInfo.data()['preferredEvents'];
        print(events);
        if (events != null) {
          events.forEach((element) {
            eventTypes.add(element.toString());
          });
          print('eventTypes $eventTypes');
          if (eventTypes == null) eventTypes = [];
        } else {
          eventTypes = [];
        }
        // List<String>events =  userInfo.data()[ 'eventTypes'];
        // for(String event in events ){
        //   switch(event){
        //     case 'Education':
        //       eventTypes.add(EventType.Education);
        //       break;
        //   }
        // }
        //update user information in firestore
        //updateCollectionField(collectionName: 'users', fieldName: 'Fname', fieldValue: Fname, document_Id: user.uid);
      }
    } catch (e) {
      print('Error from getCurrentUserData Method $e');
    }
  }

  Future<void> addVolunters(String eventUserID, int postNo) async {
    try {
      _cloudInstance.collection('volunters').doc().set({
        'userId': eventUserID,
        'postNo': postNo,
        'volUserId': getUserId,
      });
      //
      // await _cloudInstance.collection('events').doc('MdWLniWrTxSXluTLq4Gj').delete();
      // await _cloudInstance.collection('events').doc('ZkjalPBd7lgPR55azJFf').delete();
      // await _cloudInstance.collection('events').doc('jP2lMmii7z2v2km7jMJt').delete();
      // await _cloudInstance.collection('events').doc('sazozXHP1SzPMq9ruHSt').delete();

    } catch (e) {
      print('Error from addVolunters Method $e');
    }
  }

  Future<void> AddNewPost(
      String title,
      String description,
      String eventType,
      String volunteersNo,
      String attendingNo,
      String date,
      String time,
      File file) async {
    try {
      print('5555555555555555555555555');
      int postNo = await getPostsNo;
      print('6666666666666666666666666');
      String fileUrl = '';
      if (file != null)
        fileUrl = await uploadtoFireStorage(
            filePath: getUserId +
                postNo.toString() +
                "/" +
                getUserId +
                postNo.toString(),
            file: file);
      print('777777777777777777777777777');

      print("fileUrl from add post $fileUrl");
      var posts = _cloudInstance.collection('posts').doc();
      posts.set({
        'title': title,
        'description': description,
        'eventType': eventType,
        'volunteersNo': volunteersNo,
        'attendingNo': attendingNo,
        'date': date,
        'time': time,
        'userId': getUserId,
        'userEmail': getUserEmail,
        'imageUrl': fileUrl,
        'Fname': Fname,
        'Lname': Lname,
        'post_number': await getPostsNo,
        'createdOn': FieldValue.serverTimestamp(),
      });
      print('1111111111111111111111111111111111111111111');
    } catch (e) {
      print('22222222222222222222222222222222222222222222');
      print(e);
    }
  }

  Future<void> deletePost(String postDocumentId) async {
    try {
      _cloudInstance.collection('posts').doc(postDocumentId).delete();
    } catch (e) {}
  }

  List<String> posts = [];
  List<String> CurrentUserPosts = [];

  Future<void> getCurrentUserPost() async {
    try {
      if (CurrentUserPosts == null) CurrentUserPosts = [];
      var querySnapshotData = await _cloudInstance.collection('posts').get();
      var userData = querySnapshotData.docs
          .where((element) => element['user_id'] == user_id);
      if (userData != null) {
        userData.forEach((element) {
          var docId = element.id;
          var title = element.data()['title'];
          var body = element.data()['body'];
          CurrentUserPosts.add(docId);
        });
      }
      notifyListeners();
    } catch (e) {}
  }

  Future<void> getAllPost() async {
    try {
      if (posts == null) posts = [];
      var querySnapshotData = await _cloudInstance.collection('posts').get();
      var userData = querySnapshotData.docs;
      if (userData != null) {
        userData.forEach((element) {
          var docId = element.id;
          var title = element.data()['title'];
          var body = element.data()['body'];
          var Fname = element.data()['Email'];

          posts.add(docId);
        });
      }
      notifyListeners();
    } catch (e) {}
  }

  Future<bool> LogIn_user(String Email, String password, context) async {
    bool success = false;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: Email, password: password);

      if (userCredential != null) {
        // user_id = userCredential.user.uid;
        // Email = userCredential.user.email;
        getCurrentUser();

        return true;
      }
    } catch (e) {
      Alert(
        context: context,
        title: e.code + ' Error',
        desc: e.message,
        buttons: [
          DialogButton(
            child: Text(
              "Try Again",
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    }
    return false;
  }

  Future<void> updateCollectionField(
      {@required String collectionName,
      @required String fieldName,
      @required dynamic fieldValue,
      @required String document_Id}) async {
    try {
      _cloudInstance
          .collection(collectionName)
          .doc(document_Id)
          .update({fieldName: fieldValue});
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateCollectionFields(
      {@required String collectionName,
      @required Map<String, dynamic> fields,
      @required String document_Id}) async {
    try {
      _cloudInstance.collection(collectionName).doc(document_Id).update(fields);
    } catch (e) {
      throw e;
    }
  }

  void Sighn_out() async {
    await _auth.signOut();
  }
}
