import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/navBar/navBar.dart';
import 'package:flutter_application_1/screens/Quizes/certificate.dart';
import 'package:flutter_application_1/screens/Quizes/course_certification.dart';
// import 'package:flutter_application_1/screens/chatbot.dart';
import 'package:flutter_application_1/screens/chatbot/chatbot_screen.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/settings/change_pass.dart';
import 'package:flutter_application_1/screens/settings/del_account.dart';
import 'package:flutter_application_1/screens/settings/privacy_policy.dart';
import 'package:flutter_application_1/screens/signUp.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
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
  //  late final String? email;
  // late final String courseName;

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
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the menu icon to white
        ),
        actions: [
          Switch(
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged: (value) {
              final provider =
                  Provider.of<ThemeProvider>(context, listen: false);
              provider.toggleTheme(value);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: appColor.primaryColor,
              ),
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy and Policy'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_reset),
              title: Text('Reset Password'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('License'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LicensePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign Out'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Are you sure?'),
                      content: Text('Do you really want to logout?'),
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
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Account'),
              onTap: () {
                DeleteAccountHandler.deleteAccount(context);
              },
            ),
          ],
        ),
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
                  color: appColor.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  Icons.email,
                  color: appColor.primaryColor,
                  size: 30.0,
                ),
              ),
              title: Text(
                'Email',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              subtitle: Text(
                _user?.email ?? 'No Email',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16.0,
                      color: _user?.email != null
                          ? Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .color!
                              .withOpacity(0.7)
                          : Colors.redAccent,
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
                  color: appColor.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  Icons.person_3_outlined,
                  color: appColor.primaryColor,
                  size: 30.0,
                ),
              ),
              title: Text(
                'Mr. AI Programmer',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              subtitle: Text(
                'Ask me to code for you',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16.0,
                      color: _user?.email != null
                          ? Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .color!
                              .withOpacity!(0.7)
                          : Colors.redAccent,
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
                    MaterialPageRoute(builder: (context) => ChatbotAi()));
              },
            ),
            Divider(),
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              leading: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: appColor.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  Icons.email,
                  color: appColor.primaryColor,
                  size: 30.0,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16.0,
              ),
              title: Text(
                'Certificates',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              subtitle: Text(
                'View your achievements',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.7),
                      fontSize: 16.0,
                    ),
              ),
              tileColor: Colors.grey.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CertificatePageSelector()));
              },
            ),

            Divider(),
            // Divider(),
            // ListTile(
            //   contentPadding:
            //       EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            //   leading: Container(
            //     padding: EdgeInsets.all(8.0),
            //     decoration: BoxDecoration(
            //       color: appColor.primaryColor.withOpacity(0.1),
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //     child: Icon(
            //       Icons.person_3_outlined,
            //       color: appColor.primaryColor,
            //       size: 30.0,
            //     ),
            //   ),
            //   title: Text(
            //     'Mr. AI Programmer',
            //     style: TextStyle(
            //       fontSize: 18.0,
            //       fontWeight: FontWeight.bold,
            //       color: Theme.of(context).textTheme.bodyText1!.color,
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
