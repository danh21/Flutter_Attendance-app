import 'package:attendance_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employee")
          .where('id', isEqualTo: User.username)
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("Employee")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();

      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
        date = snap2['date'];
        name = User.username;
      });
    } catch (e) {
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
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
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
                              key.currentState!.reset();
                            });

                            QuerySnapshot snap = await FirebaseFirestore
                                .instance
                                .collection("Employee")
                                .where('id', isEqualTo: User.username)
                                .get();

                            DocumentSnapshot snap2 = await FirebaseFirestore
                                .instance
                                .collection("Employee")
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .doc(DateFormat('dd MMMM yyyy')
                                    .format(DateTime.now()))
                                .get();

                            try {
                              String checkIn = snap2['checkIn'];

                              setState(() {
                                checkOut =
                                    DateFormat('hh:mm').format(DateTime.now());
                              });

                              await FirebaseFirestore.instance
                                  .collection("Employee")
                                ..doc(snap.docs[0].id)
                                    .collection("Record")
                                    .doc(DateFormat('dd MMMM yyyy')
                                        .format(DateTime.now()))
                                    .update({
                                  'checkIn': checkIn,
                                  'checkOut': checkOut,
                                });
                            } catch (e) {
                              setState(() {
                                checkIn =
                                    DateFormat('hh:mm').format(DateTime.now());
                              });

                              await FirebaseFirestore.instance
                                  .collection("Employee")
                                ..doc(snap.docs[0].id)
                                    .collection("Record")
                                    .doc(DateFormat('dd MMMM yyyy')
                                        .format(DateTime.now()))
                                    .set({
                                  'checkIn': DateFormat('hh:mm')
                                      .format(DateTime.now()),
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

class Timer {
  Timer(Duration duration, Null Function() param1);
}
