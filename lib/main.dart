import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/events_screen.dart';
import 'screens/create_event_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;
User loggedInUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final user = _auth.currentUser;
  loggedInUser = user;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: loggedInUser == null ? '/login_screen' : '/events_screen',
        routes: {
          '/login_screen': (context) => LogIn(),
          '/registration_screen': (context) => RegisterScreen(),
          '/events_screen': (context) => EventsScreen(),
          '/create_event_screen': (context) => CreateEvent(),
        },
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CircularProgressIndicator());
        ));
  }
}
