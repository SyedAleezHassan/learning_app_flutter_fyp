import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login.dart'; // Replace with the actual path to your login screen

class DeleteAccountHandler {
  static Future<void> deleteAccount(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    bool _isLoading = false;

    Future<void> _deleteAccount() async {
      // setState(() {
      //   _isLoading = true;
      // }
     // );

      try {
        User? user = _auth.currentUser;

        // Delete user data from Firestore
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).delete();

          // Delete the user's account
          await user.delete();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account deleted successfully')),
          );

          // Navigate to the login screen and remove all previous routes
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user is currently signed in')),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'requires-recent-login') {
          message =
              'This operation is sensitive and requires recent authentication. Please log in again and try again.';
        } else {
          message = e.message ?? 'An error occurred. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } finally {
        // setState(() {
        //   _isLoading = false;
        // });
      }
    }

    void _showDeleteAccountDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Account'),
            content: Text('Are you sure you want to delete your account? This action is irreversible.'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              ElevatedButton(
                child: _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text('Delete'),
                onPressed: _isLoading
                    ? null
                    : () async {
                        await _deleteAccount();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          );
        },
      );
    }

    _showDeleteAccountDialog();
  }
}




// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_application_1/screens/login.dart';
// // import 'package:flutter_application_1/screens/login_screen.dart'; // Make sure to use the correct path to your LoginScreen

// class DeleteAccountScreen extends StatefulWidget {
//   @override
//   _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
// }

// class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool _isLoading = false;

//   Future<void> _deleteAccount() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       User? user = _auth.currentUser;

//       // Delete user data from Firestore
//       if (user != null) {
//         await _firestore.collection('users').doc(user.uid).delete();

//         // Delete the user's account
//         await user.delete();

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Account deleted successfully')),
//         );

//         // Navigate to the login screen and remove all previous routes
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => LoginScreen()),
//           (Route<dynamic> route) => false,
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('No user is currently signed in')),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       String message;
//       if (e.code == 'requires-recent-login') {
//         message =
//             'This operation is sensitive and requires recent authentication. Please log in again and try again.';
//       } else {
//         message = e.message ?? 'An error occurred. Please try again.';
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Delete Account'),
//         backgroundColor: Colors.red,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               'Are you sure you want to delete your account? This action is irreversible.',
//               style: TextStyle(fontSize: 18.0),
//             ),
//             SizedBox(height: 20),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _deleteAccount,
//                     child: Text('Delete Account'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
