import 'package:flutter/material.dart';
import 'package:volunteering/screens/committee_request_screen.dart';
import 'screens/login_screen.dart';
import 'screens/events_screen.dart';
import 'screens/create_event_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteering/screens/register_type_screen.dart';

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
      debugShowCheckedModeBanner: false,
      initialRoute:
          _auth.currentUser == null ? '/login_screen' : '/events_screen',
      routes: {
        '/login_screen': (context) => LogIn(),
        '/events_screen': (context) => EventsScreen(),
        '/create_event_screen': (context) => CreateEvent(),
        '/register_type_screen': (context) => RegisterType(),
        '/committee_request': (context) => CommitteeRequest(),
      },
    );
  }
}
