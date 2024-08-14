import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:flutter_application_1/navBar/navBar.dart';
// import 'package:flutter_application_1/screens/chatbot.dart';
import 'package:flutter_application_1/screens/chatbot/chatbot_screen.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/signUp.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Myaccount extends StatefulWidget {
  @override
  _MyaccountState createState() => _MyaccountState();
}

class _MyaccountState extends State<Myaccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_user!.uid).get();
      setState(() {
        _userName = userDoc.get('name') ?? 'No Name';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the first letter of the user's email
    String emailInitial = _user?.email?.substring(0, 1).toUpperCase() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        backgroundColor: appColor.primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              // await _auth.signOut();
              // Navigator.of(context).pushReplacementNamed('/login');

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text('Do you really want to logout'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Closes the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          var sharedpref =
                              await SharedPreferences.getInstance();

                          sharedpref.setBool(
                              WelcomeScreenState.KEYLOGIN, false);
                          // ignore: use_build_context_synchronously
                          // Perform action
                          
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false,
                          ); // Closes the dialog
                          
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor:
                    appColor.primaryColor, // You can choose any color
                child: Text(
                  emailInitial,
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                _userName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            // ListTile(
            //   leading: Icon(Icons.email),
            //   title: Text('Email'),
            //   subtitle: Text(_user?.email ?? 'No Email'),
            // ),
            //newwwwwwwwwwwwwwwwwwww
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              leading: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  Icons.email,
                  color: Colors.blueAccent,
                  size: 30.0,
                ),
              ),
              title: Text(
                'Email',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                _user?.email ?? 'No Email',
                style: TextStyle(
                  fontSize: 16.0,
                  color:
                      _user?.email != null ? Colors.black54 : Colors.redAccent,
                ),
              ),
              tileColor: Colors.grey.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),

            Divider(),
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              leading: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  Icons.person_3_outlined,
                  color: Colors.blueAccent,
                  size: 30.0,
                ),
              ),
              title: Text(
                'Mr. AI Programmer',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                'Ask me to code for you',
                style: TextStyle(
                  fontSize: 16.0,
                  color:
                      _user?.email != null ? Colors.black54 : Colors.redAccent,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16.0,
              ),
              tileColor: Colors.grey.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => chatbotAi()));
              },
            ),
            // Divider(),
            // ListTile(
            //   contentPadding:
            //       EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            //   leading: Container(
            //     padding: EdgeInsets.all(8.0),
            //     decoration: BoxDecoration(
            //       color: Colors.blueAccent.withOpacity(0.1),
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //     child: Icon(
            //       Icons.person_3_outlined,
            //       color: Colors.blueAccent,
            //       size: 30.0,
            //     ),
            //   ),
            //   title: Text(
            //     'Mr. AI Programmer',
            //     style: TextStyle(
            //       fontSize: 18.0,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.black87,
            //     ),
            //   ),
            //   subtitle: Text(
            //     'Ask me to code for you',
            //     style: TextStyle(
            //       fontSize: 16.0,
            //       color:
            //           _user?.email != null ? Colors.black54 : Colors.redAccent,
            //     ),
            //   ),
            //   trailing: Icon(
            //     Icons.arrow_forward_ios,
            //     color: Colors.grey,
            //     size: 16.0,
            //   ),
            //   tileColor: Colors.grey.withOpacity(0.05),
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10.0),
            //   ),
            //   onTap: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => chatbotAi()));
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
