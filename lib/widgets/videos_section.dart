import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:flutter_application_1/screens/Quizes/c_quiz.dart';

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
              if (widget.courseName == 'Flutter') {
                print(widget.courseName);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FlutterQuizPage()));
              } else if (widget.courseName == 'Java') {
                 print(widget.courseName);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => JavaQuizPage()));
              }
               else if (widget.courseName == 'Python') {
                 print(widget.courseName);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PythonQuizPage()));
              }
               else if (widget.courseName == 'C++') {
                 print(widget.courseName);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CQuizPage()));
              }
               else if (widget.courseName == 'React Native') {
                 print(widget.courseName);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReactQuizPage()));
              }
              // Add more conditions if you have more courses
            },
          );
        }
      },
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/color/color.dart';
// import 'package:flutter_application_1/widgets/videoPlayer/flutter_intro_vid.dart';

// import '../screens/my_courses.dart';

// class VideoSection extends StatefulWidget {
 
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



//   @override
//   void setState(VoidCallback fn) {
//     // TODO: implement setState
//     super.setState(fn);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: videoList.length,
//       physics: NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemBuilder: (context, index) {
//         return ListTile(
//           leading: Container(
//             padding: EdgeInsets.all(5),
//             decoration: BoxDecoration(
//               color: index == 0
//                   ? appColor.primaryColor
//                   : appColor.primaryColor.withOpacity(0.6),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.play_arrow_rounded,
//               color: Colors.white,
//               size: 30,
//             ),
//           ),
//           title: Text(videoList[index]),
//           subtitle: Text("20 min 50 sec"),
//           onTap: () {
//             // yahan kro video dalny wala kam syed aleez hassan sahab jee
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => flutterIntro()));
//             //yahan khatam horha hai syed aleez hassan saahab
//           },
//         );
//       },
//     );
//   }
// }
