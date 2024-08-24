import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CertificatePage extends StatelessWidget {
  final String courseName;

  CertificatePage({required this.courseName});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _auth.currentUser;

  // void _generateCertificate() async {
  //   if (_userEmail != null && _studentName != null && currentUser != null) {
  //     await _firestore
  //         .collection('certificates')
  //         .doc(currentUser!.uid)
  //         .collection('records')
  //         .add({
  //       'name': _studentName,
  //       'email': _userEmail,
  //       'course': 'Flutter',
  //       'date': DateTime.now(),
  //     });
  //   }

  Future<Map<String, dynamic>> _fetchCertificateData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('certificates')
        .doc(currentUser!.uid)
        .collection('records')
        .where('course', isEqualTo: courseName)
        .get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.first.data() : {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$courseName Certificate',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appColor.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchCertificateData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(child: Text('No certificate found for $courseName.'));
          } else {
            final certificate = snapshot.data!;
            final completionDate =
                DateFormat.yMMMMd().format(certificate['date'].toDate());

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    border: Border.all(
                      color: appColor.primaryColor,
                      width: 3,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Certificate of Completion',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: appColor.primaryColor,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'This is to certify that',
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        certificate['name'],
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'has successfully completed the course',
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        certificate['course'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Date of Completion: $completionDate',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'SMIU',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: appColor.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/color/color.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class CertificatePage extends StatelessWidget {
//   final String courseName;

//   CertificatePage({required this.courseName});

//   Future<Map<String, dynamic>> _fetchCertificateData() async {
//     // Get the currently logged-in user
//     final User? currentUser = FirebaseAuth.instance.currentUser;

//     if (currentUser != null) {
//       // Fetch the certificate that matches the course and the current user's UID
//       final snapshot = await FirebaseFirestore.instance
//           .collection('certificates')
//           .where('course', isEqualTo: courseName)
//           .where('uid', isEqualTo: currentUser.uid) // Filter by user ID (uid)
//           .get();

//       // Return the certificate data if available
//       return snapshot.docs.isNotEmpty ? snapshot.docs.first.data() : {};
//     } else {
//       return {}; // Return an empty map if no user is logged in
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$courseName Certificate'),
//         backgroundColor: appColor.primaryColor,
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: _fetchCertificateData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No certificate found for $courseName.'));
//           } else {
//             final certificate = snapshot.data!;
//             final completionDate = DateFormat.yMMMMd().format(certificate['date'].toDate());

//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Container(
//                   padding: const EdgeInsets.all(24.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         spreadRadius: 5,
//                         blurRadius: 15,
//                         offset: Offset(0, 3), // Changes position of shadow
//                       ),
//                     ],
//                     border: Border.all(
//                       color: appColor.primaryColor,
//                       width: 3,
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Certificate of Completion',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: appColor.primaryColor,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         'This is to certify that',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontStyle: FontStyle.italic,
//                           color: Colors.black54,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         certificate['name'],
//                         style: TextStyle(
//                           fontSize: 26,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         'has successfully completed the course',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontStyle: FontStyle.italic,
//                           color: Colors.black54,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         certificate['course'],
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         'Date of Completion: $completionDate',
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.black54,
//                         ),
//                       ),
//                       SizedBox(height: 40),
//                       Text(
//                         'SMIU Students',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: appColor.primaryColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
