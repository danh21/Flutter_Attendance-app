import 'dart:async';
import 'dart:ui';

import 'package:attendance_app/homescreen.dart';
import 'package:attendance_app/loginscreen.dart';
import 'package:attendance_app/model/user.dart';
import 'package:attendance_app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    debugPrint('[FLUTTER ERROR] ${details.exception}');
    if (details.stack != null) {
      debugPrintStack(stackTrace: details.stack);
    }
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint('[UNHANDLED ERROR] $error');
    debugPrintStack(stackTrace: stack);
    return false;
  };

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runZonedGuarded(
    () => runApp(const MyApp()),
    (Object error, StackTrace stack) {
      debugPrint('[ZONE ERROR] $error');
      debugPrintStack(stackTrace: stack);
    },
  );
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
  bool checkingUser = true;
  late final StreamSubscription<firebase_auth.User?> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = firebase_auth.FirebaseAuth.instance
        .authStateChanges()
        .listen(_handleAuthState);
  }

  Future<void> _handleAuthState(firebase_auth.User? currentUser) async {
    debugPrint(
      '[AUTH] authStateChanges: ${currentUser == null ? 'signed out' : currentUser.uid}',
    );

    if (currentUser == null) {
      User.username = ' ';
      if (!mounted) return;
      setState(() {
        userAvailable = false;
        checkingUser = false;
      });
      return;
    }

    if (mounted) {
      setState(() {
        checkingUser = true;
      });
    }

    try {
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

      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('employeeId', employeeId);

      // The user may have logged out while Firestore was loading.
      if (!mounted ||
          firebase_auth.FirebaseAuth.instance.currentUser?.uid !=
              currentUser.uid) {
        debugPrint('[AUTH] Ignoring stale employee lookup after auth change');
        return;
      }

      User.username = employeeId;
      setState(() {
        userAvailable = true;
        checkingUser = false;
      });
    } catch (e, stack) {
      debugPrint('[AUTH] Failed to load employee profile: $e');
      debugPrintStack(stackTrace: stack);
      if (!mounted) return;
      setState(() {
        userAvailable = false;
        checkingUser = false;
      });
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (checkingUser) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return userAvailable ? const HomeScreen() : const LoginScreen();
  }
}
