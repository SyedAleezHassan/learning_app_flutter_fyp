import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/color/color.dart'; // Assuming appColor is defined in this file

import 'certificate.dart';

class CertificatePageSelector extends StatefulWidget {
  @override
  _CertificatePageSelectorState createState() =>
      _CertificatePageSelectorState();
}

class _CertificatePageSelectorState extends State<CertificatePageSelector> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _certificates = [];
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchCertificates();
  }

  void _fetchCertificates() async {
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      // Fetch certificates only for the logged-in user
      final QuerySnapshot snapshot = await _firestore
          .collection('certificates')
          .doc(_currentUser!.uid)
          .collection('records')
          .get();

      setState(() {
        _certificates = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    }
  }

  void _navigateToCertificatePage(String courseName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CertificatePage(courseName: courseName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Certificate',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appColor.primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the menu icon to white
        ), // Set the appBar color
      ),
      body: _certificates.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
                SizedBox(height: 16),
                Text(
                  'No certificates available',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ],
            )
          : ListView.builder(
              itemCount: _certificates.length,
              itemBuilder: (context, index) {
                final certificate = _certificates[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    tileColor: Colors.grey.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    leading: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: appColor.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(
                        Icons.book,
                        color: appColor.primaryColor,
                        size: 30.0,
                      ),
                    ),
                    title: Text(
                      certificate['course'],
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      'Tap to view certificate',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16.0,
                    ),
                    onTap: () =>
                        _navigateToCertificatePage(certificate['course']),
                  ),
                );
              },
            ),
    );
  }
}
















// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'certificate.dart';

// class CertificatePageSelector extends StatefulWidget {
//   @override
//   _CertificatePageSelectorState createState() => _CertificatePageSelectorState();
// }

// class _CertificatePageSelectorState extends State<CertificatePageSelector> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   List<Map<String, dynamic>> _certificates = [];
//   User? _currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _fetchCertificates();
//   }


  
//   void _fetchCertificates() async {
//     _currentUser = _auth.currentUser;
//     if (_currentUser != null) {
//       // Fetch certificates only for the logged-in user
//       final QuerySnapshot snapshot = await _firestore
//           .collection('certificates').doc(_currentUser!.uid).collection('records')
//           .get();

//       setState(() {
//         _certificates = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//       });
//     }
//   }

//   void _navigateToCertificatePage(String courseName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CertificatePage(courseName: courseName),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Certificate'),
//       ),
//       body: _certificates.isEmpty
//           ? Column(
//             children: [
//               Center(child: CircularProgressIndicator(),),
//               Text('No certificates'),
//             ],
//           )
//           : ListView.builder(
//               itemCount: _certificates.length,
//               itemBuilder: (context, index) {
//                 final certificate = _certificates[index];
//                 return ListTile(
//                   title: Text(certificate['course']),
//                   onTap: () => _navigateToCertificatePage(certificate['course']),
//                 );
//               },
//             ),
//     );
//   }
// }






// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:fluttertoast/fluttertoast.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';

// // import 'certificate.dart';
 
// // // final String courseName;
// // class CertificatePageSelector extends StatefulWidget {

// //   //=========================================
// //   @override
// //   _CertificatePageSelectorState createState() => _CertificatePageSelectorState();
// // }

// // class _CertificatePageSelectorState extends State<CertificatePageSelector> {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   List<Map<String, dynamic>> _certificates = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchCertificates();
// //   }
  
// // //fetch karo certificates ko bhai sahab dash nh khao
// //   void _fetchCertificates() async {
// //     final QuerySnapshot snapshot = await _firestore.collection('certificates').get();
// //     setState(() {
// //       _certificates = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
// //     });
// //   }

// //   void _navigateToCertificatePage(String courseName) {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => CertificatePage(courseName: courseName),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Select Certificate'),
// //       ),
// //       body: _certificates.isEmpty
// //           ? Center(child: CircularProgressIndicator())
// //           : ListView.builder(
// //               itemCount: _certificates.length,
// //               itemBuilder: (context, index) {
// //                 final certificate = _certificates[index];
// //                 return ListTile(
// //                   title: Text(certificate['course']),
// //                    onTap: //(){_navigateToCertificatePage(context, certificate[]);}
// //                   () => _navigateToCertificatePage(certificate['course']),
// //                 );
// //               },
// //             ),
// //     );
// //   }
// // }



