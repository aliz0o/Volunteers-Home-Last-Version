import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/events_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/create_event_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login_screen',
      routes: {
        '/login_screen': (context) => LogIn(),
        '/registration_screen': (context) => RegisterScreen(),
        '/events_screen': (context) => EventsScreen(),
        '/create_event_screen': (context) => CreateEvent(),
        '/profile_screen': (context) => ProfileScreen(),
      },
    );
  }
}
