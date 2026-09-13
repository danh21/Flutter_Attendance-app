import 'package:attendance_app/homescreen.dart';
import 'package:attendance_app/loginscreen.dart';
import 'package:attendance_app/model/user.dart';
import 'package:attendance_app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const KeyboardVisibilityProvider(
        child: AuthCheck(),
      ),
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();

    if (defaultTargetPlatform == TargetPlatform.windows) {
      return;
    }

    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final employeeSnapshot = await FirebaseFirestore.instance
            .collection('Employee')
            .where('email', isEqualTo: currentUser.email)
            .limit(1)
            .get();

        if (employeeSnapshot.docs.isEmpty) {
          await firebase_auth.FirebaseAuth.instance.signOut();
          return;
        }

        final employeeData = employeeSnapshot.docs.first.data();
        final employeeId = employeeData['id'];
        if (employeeId is! String || employeeId.isEmpty) {
          await firebase_auth.FirebaseAuth.instance.signOut();
          return;
        }

        await sharedPreferences.setString('employeeId', employeeId);
        setState(() {
          User.username = employeeId;
          userAvailable = true;
        });
      }
    } catch (e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable ? const HomeScreen() : const LoginScreen();
  }
}
