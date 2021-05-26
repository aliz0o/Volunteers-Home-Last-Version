import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteering/screens/committe_request_screen.dart';
import 'backEnd/dataBase.dart';
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
  runApp(
    MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => Authentication())],
        child: MyApp()),
  );

  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: loggedInUser == null ? '/login_screen' : '/events_screen',
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
