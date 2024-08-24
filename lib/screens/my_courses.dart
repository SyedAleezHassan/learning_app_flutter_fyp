import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:flutter_application_1/screens/course_screen.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({super.key});

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

User? get currentUser => _auth.currentUser;

class _MyCoursesState extends State<MyCourses> {
  Stream<QuerySnapshot> _getUserRecordsStream() {
    if (currentUser != null) {
      return _firestore
          .collection('wishlist')
          .doc(currentUser!.uid)
          .collection('records')
          .snapshots();
    } else {
      print("No user");
      return Stream<QuerySnapshot>.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor.primaryColor,
        title: Text(
          "My Courses",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getUserRecordsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No records found'));
          } else {
            final userRecords = snapshot.data!.docs;
            return ListView.builder(
              itemCount: userRecords.length,
              itemBuilder: (context, index) {
                var record = userRecords[index].data() as Map<String, dynamic>;
                return ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(record['imageUrl'] ??
                        'https://i.pinimg.com/474x/1b/d7/8d/1bd78daab0bd76b6352dcefceb72c6ca.jpg'),
                  ),
                  title: Text(
                    record['name'] ?? 'Unknown Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    record['video'] ?? 'No Video Available',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[600],
                    size: 18.0,
                  ),
                  onTap: () {
                    DocumentSnapshot abc = snapshot.data!.docs[index];

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseScreen(abc["name"],
                            abc["price"], abc["imgLink"], abc['video']),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/color/color.dart';
// import 'package:flutter_application_1/screens/course_screen.dart';

// class MyCourses extends StatefulWidget {
//   const MyCourses({super.key});

//   @override
//   State<MyCourses> createState() => _MyCoursesState();
// }

// final FirebaseAuth _auth = FirebaseAuth.instance;
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// User? get currentUser => _auth.currentUser;

// class _MyCoursesState extends State<MyCourses> {
//   // List<Map<String, dynamic>> userRecords = [];

//   Stream<QuerySnapshot> _getUserRecordsStream() {
//     if (currentUser != null) {
//       return _firestore
//           .collection('wishlist')
//           .doc(currentUser!.uid)
//           .collection('records')
//           .snapshots();
//     } else {
//       print("No user");
//       return Stream<QuerySnapshot>.empty();
//     }
//   }

// //   @override
// //   void initState()  {
// //     // TODO: implement initState
// //     super.initState();
// //     getData();
// // setState(() {

// // });
//   //   print(userRecords);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: appColor.primaryColor,
//         title: Text(
//           "My Courses",
//           style: TextStyle(fontSize: 25, color: Colors.white),
//         ),
//         automaticallyImplyLeading: false,
//         iconTheme: IconThemeData(
//           color: Colors.white,
//         ),
//       ),
//       body: Flexible(
//         child: StreamBuilder<QuerySnapshot>(
//           stream: _getUserRecordsStream(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return Center(child: Text('No records found'));
//             } else {
//               final userRecords = snapshot.data!.docs;
//               return ListView.builder(
//                 itemCount: userRecords.length,
//                 itemBuilder: (context, index) {
//                   var record =
//                       userRecords[index].data() as Map<String, dynamic>;
//                   return
//                       // ListTile(
//                       //   title: Text(record['name']),
//                       //   subtitle: Text(record['video']),
//                       // );  xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//                       ListTile(
//                     contentPadding: EdgeInsets.all(16.0),
//                     leading: CircleAvatar(
//                       radius: 30,
//                       backgroundImage: NetworkImage(record['imageUrl'] ??
//                           'https://via.placeholder.com/150'),
//                     ),
//                     title: Text(
//                       record['name'] ?? 'Unknown Name',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18.0,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     subtitle: Text(
//                       record['video'] ?? 'No Video Available',
//                       style: TextStyle(
//                         fontSize: 14.0,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     trailing: Icon(
//                       Icons.arrow_forward_ios,
//                       color: Colors.grey[600],
//                       size: 18.0,
//                     ),
//                     onTap: () {
//                       DocumentSnapshot abc = snapshot.data!.docs[index];

//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CourseScreen(abc["name"],
//                               abc["price"], abc["imgLink"], abc['video']),
//                         ),
//                       );
//                     },
//                   );
//                   //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//                 },
//               );
//             }
//           },
//         ),
//       ),
    
//     );
//   }
// }
