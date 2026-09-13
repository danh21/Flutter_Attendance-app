import 'dart:async';

import 'package:attendance_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn = "--/--";
  String checkOut = "--/--";
  String date = "";
  String name = "";

  Color primary = const Color(0xffeef444c);

  @override
  void initState() {
    super.initState();
    _getRecord();
  }

  Future<DocumentReference<Map<String, dynamic>>?>
      _getEmployeeReference() async {
    final email = firebase_auth.FirebaseAuth.instance.currentUser?.email;
    if (email == null || email.isEmpty) return null;

    final snapshot = await FirebaseFirestore.instance
        .collection('Employee')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.reference;
  }

  void _getRecord() async {
    try {
      final employeeReference = await _getEmployeeReference();
      if (employeeReference == null) throw StateError('Employee not linked');

      final recordSnapshot = await employeeReference
          .collection("Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();

      if (!mounted) return;
      final record = recordSnapshot.data();
      setState(() {
        checkIn = record?['checkIn'] as String? ?? "--/--";
        checkOut = record?['checkOut'] as String? ?? "--/--";
        date = record?['date'] as String? ?? "dd MMMM yyyy";
        name = User.username;
      });
    } catch (e, stack) {
      debugPrint('[TODAY] Failed to load attendance record: $e');
      debugPrintStack(stackTrace: stack);
      if (!mounted) return;
      setState(() {
        checkIn = "--/--";
        checkOut = "--/--";
        date = "dd MMMM yyyy";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Welcome, ",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: screenWidth / 20,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Employee " + User.username,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Today's Status",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 32),
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Check In",
                          style: TextStyle(
                            fontSize: screenWidth / 20,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          checkIn,
                          style: TextStyle(
                            fontSize: screenWidth / 18,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Check Out",
                        style: TextStyle(
                          fontSize: screenWidth / 20,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        checkOut,
                        style: TextStyle(
                          fontSize: screenWidth / 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: DateTime.now().day.toString(),
                    style: TextStyle(
                      color: primary,
                      fontSize: screenWidth / 18,
                    ),
                    children: [
                      TextSpan(
                        text: DateFormat(' MMMM yyyy').format(DateTime.now()),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth / 20,
                        ),
                      ),
                    ],
                  ),
                )),
            StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('HH:mm:ss').format(DateTime.now()),
                      style: TextStyle(
                        fontSize: screenWidth / 20,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }),
            checkOut == "--/--"
                ? Container(
                    margin: const EdgeInsets.only(top: 24),
                    child: Builder(
                      builder: (context) {
                        final GlobalKey<SlideActionState> key = GlobalKey();

                        return SlideAction(
                          text: checkIn == "--/--"
                              ? "Slide to Check In "
                              : "Slide to Check Out ",
                          textStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: screenWidth / 20,
                          ),
                          outerColor: Colors.white,
                          innerColor: primary,
                          key: key,
                          onSubmit: () async {
                            Timer(const Duration(seconds: 1), () {
                              key.currentState?.reset();
                            });

                            final employeeReference =
                                await _getEmployeeReference();
                            if (employeeReference == null) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'This email is not linked to an employee.',
                                  ),
                                ),
                              );
                              return;
                            }

                            final recordReference = employeeReference
                                .collection("Record")
                                .doc(DateFormat('dd MMMM yyyy')
                                    .format(DateTime.now()));
                            final recordSnapshot = await recordReference.get();

                            try {
                              final record = recordSnapshot.data();
                              final existingCheckIn = record?['checkIn'];
                              if (existingCheckIn is! String) {
                                throw StateError('No check-in record');
                              }

                              if (!mounted) return;
                              setState(() {
                                checkOut =
                                    DateFormat('HH:mm').format(DateTime.now());
                              });

                              await recordReference.update({
                                'checkIn': existingCheckIn,
                                'checkOut': checkOut,
                              });
                            } catch (e, stack) {
                              debugPrint('[TODAY] Record update failed: $e');
                              debugPrintStack(stackTrace: stack);
                              if (!mounted) return;
                              setState(() {
                                checkIn =
                                    DateFormat('HH:mm').format(DateTime.now());
                              });

                              await recordReference.set({
                                'checkIn':
                                    DateFormat('HH:mm').format(DateTime.now()),
                                'date': DateFormat('dd MMMM yyyy')
                                    .format(DateTime.now()),
                                'name': User.username,
                              });
                            }
                          },
                        );
                      },
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 32),
                    child: Text(
                      "You have completed this day!",
                      style: TextStyle(
                        fontSize: screenWidth / 20,
                        color: Colors.black54,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
