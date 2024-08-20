import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:flutter_application_1/screens/Quizes/c_quiz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/Quizes/Java_quiz.dart';
import '../screens/Quizes/flutter_quiz.dart';
import '../screens/Quizes/python_quiz.dart';
import '../screens/Quizes/react_quiz.dart';
import 'videoPlayer/flutter_intro_vid.dart';

class VideoSection extends StatefulWidget {
  final String courseName; // Add courseName as a parameter

  VideoSection({required this.courseName}); // Modify the constructor

  @override
  State<VideoSection> createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  List videoList = [
    'Introduction',
    'Installing on Windows, Mac & Linux',
    'Setup Emulator on Windows',
    'Creating Our First App',
  ];

////////////////////////////////////
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCertificatesList();
  }

  User? get currentUser => _auth.currentUser;
  List<Map<String, dynamic>> recordsLists = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _getCertificatesList() async {
    if (currentUser != null) {
      try {
        final snapshot = await _firestore
            .collection('certificates')
            .doc(currentUser!.uid)
            .collection('records')
            .get();

        recordsLists = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        print("Record listttttt$recordsLists");
        return recordsLists;
      } catch (e) {
        print('Error fetching user records: $e');
        throw e; // Rethrow the error for handling elsewhere if needed
      }
    } else {
      print("No user");
      return []; // Return an empty list if no user
    }
  }

  isNameInList(String namToCheck) {
    // final List<Map<String, dynamic>> recordsList = await _getCertificatesList();
    if (recordsLists.isNotEmpty) {
      for (final record in recordsLists) {
        final String name = record['course'];
        if (name == namToCheck) {
          print("true");
          print(name);
          return true; // Name found in the list
        }
      }
    } else {
      print("false");
      return false;
    }
    return false; // Name not found in the list
  }

//////////////////////////

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videoList.length +
          1, // Increase the item count by 1 for the quiz tile
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index < videoList.length) {
          return ListTile(
            leading: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: index == 0
                    ? appColor.primaryColor
                    : appColor.primaryColor.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            title: Text(videoList[index]),
            subtitle: Text("20 min 50 sec"),
            onTap: () {
              // Navigate to the video player
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => flutterIntro()));
            },
          );
        } else {
          return ListTile(
            leading: Icon(
              Icons.quiz,
              color: appColor.primaryColor,
              size: 30,
            ),
            title: Text("Course Quiz"),
            onTap: () {
              print("aaaaaaaaaaaaaaaaaa ${isNameInList(widget.courseName)}");

              if (isNameInList(widget.courseName) == false) {
                if (widget.courseName == 'Flutter') {
                  print(widget.courseName);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FlutterQuizPage()));
                } else if (widget.courseName == 'Java') {
                  print(widget.courseName);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => JavaQuizPage()));
                } else if (widget.courseName == 'Python') {
                  print(widget.courseName);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PythonQuizPage()));
                } else if (widget.courseName == 'C++') {
                  print(widget.courseName);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CQuizPage()));
                } else if (widget.courseName == 'React Native') {
                  print(widget.courseName);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ReactQuizPage()));
                }
              } else {
                Fluttertoast.showToast(
                  msg: "Already attempted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
          );
        }
      },
    );
  }
}


// class VideoSection extends StatefulWidget {
//   final String courseName;

//   VideoSection({required this.courseName});

//   @override
//   State<VideoSection> createState() => _VideoSectionState();
// }

// class _VideoSectionState extends State<VideoSection> {
//   List videoList = [
//     'Introduction',
//     'Installing on Windows, Mac & Linux',
//     'Setup Emulator on Windows',
//     'Creating Our First App',
//   ];

//   // Function to check if the user has already visited the quiz page
//   Future<bool> _hasVisitedQuiz(String courseName) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('quiz_visited_$courseName') ?? false;
//   }

//   // Function to set the flag in SharedPreferences after navigating to the quiz page
//   Future<void> _setVisitedQuiz(String courseName) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('quiz_visited_$courseName', true);
//   }

//   // Navigate to the quiz page with SharedPreferences check
//   Future<void> _navigateToQuizPage(String courseName, Widget quizPage) async {
//     bool hasVisited = await _hasVisitedQuiz(courseName);
//     if (hasVisited) {
//       // Show a message and prevent navigation if already visited
//       Fluttertoast.showToast(
//         msg: "You have already accessed this quiz.",
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//     } else {
//       // Navigate to the quiz page and set the flag in SharedPreferences
//       await Navigator.push(context, MaterialPageRoute(builder: (context) => quizPage));
//       await _setVisitedQuiz(courseName);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: videoList.length + 1, // Increase the item count by 1 for the quiz tile
//       physics: NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemBuilder: (context, index) {
//         if (index < videoList.length) {
//           return ListTile(
//             leading: Container(
//               padding: EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                 color: index == 0
//                     ? appColor.primaryColor
//                     : appColor.primaryColor.withOpacity(0.6),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.play_arrow_rounded,
//                 color: Colors.white,
//                 size: 30,
//               ),
//             ),
//             title: Text(videoList[index]),
//             subtitle: Text("20 min 50 sec"),
//             onTap: () {
//               // Navigate to the video player
//               Navigator.push(context, MaterialPageRoute(builder: (context) => flutterIntro()));
//             },
//           );
//         } else {
//           return ListTile(
//             leading: Icon(
//               Icons.quiz,
//               color: appColor.primaryColor,
//               size: 30,
//             ),
//             title: Text("Course Quiz"),
//             onTap: () {
//               if (widget.courseName == 'Flutter') {
//                 _navigateToQuizPage(widget.courseName, FlutterQuizPage());
//               } else if (widget.courseName == 'Java') {
//                 _navigateToQuizPage(widget.courseName, JavaQuizPage());
//               } else if (widget.courseName == 'Python') {
//                 _navigateToQuizPage(widget.courseName, PythonQuizPage());
//               } else if (widget.courseName == 'C++') {
//                 _navigateToQuizPage(widget.courseName, CQuizPage());
//               } else if (widget.courseName == 'React Native') {
//                 _navigateToQuizPage(widget.courseName, ReactQuizPage());
//               }
//             },
//           );
//         }
//       },
//     );
//   }
// }




