// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/color/color.dart';
// import 'package:flutter_application_1/screens/signUp.dart';
// import 'package:flutter_application_1/screens/welcome_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../navBar/navBar.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool passwordVisible = false;
//   bool isPasswordError = false; // Boolean to check for incorrect password
//   String passwordErrorMessage = ''; // Error message to display
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
  
//   // Method to login user
//   void login() async {
//     final String email = emailController.text;
//     final String password = passwordController.text;

//     if (_formKey.currentState!.validate()) {
//       try {
//         // Firebase login
//         final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: email, 
//           password: password
//         );
        
//         print(credential);
        
//         // Reset password error state if login is successful
//         setState(() {
//           isPasswordError = false;
//           passwordErrorMessage = '';
//         });
        
//         // Save login state and navigate to GoogleNavBar
//         var sharedPref = await SharedPreferences.getInstance();
//         sharedPref.setBool(WelcomeScreenState.KEYLOGIN, true);
        
//         Navigator.pushReplacement(
//           context, 
//           MaterialPageRoute(builder: (context) => GoogleNavBar())
//         );
//       } on FirebaseAuthException catch (e) {
//         // Handle specific FirebaseAuthException errors
//         if (e.code == 'user-not-found') {
//           _showErrorDialog('No user found for that email.');
//         } else if (e.code == 'wrong-password') {
//           setState(() {
//             isPasswordError = true; // Set password error state
//             passwordErrorMessage = 'Wrong password. Please try again.';
//           });
//         }
//       }
//     }
//   }

//   // Method to show error dialog
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Login Error'),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(children: [
//             // LOGIN header
//             Container(
//               padding: const EdgeInsets.only(top: 130, left: 20),
//               height: 200,
//               width: MediaQuery.of(context).size.width,
//               color: const Color.fromRGBO(233, 236, 239, 10),
//               child: const Text(
//                 "LOGIN",
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.w900,
//                   color: appColor.primaryColor,
//                 ),
//               ),
//             ),
            
//             // Email input
//             Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 10, top: 18, left: 18, right: 18),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Your Email",
//                         style: TextStyle(fontSize: 15),
//                       ),
//                       const SizedBox(height: 8),
//                       SizedBox(
//                         child: TextFormField(
//                           controller: emailController,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter an email';
//                             }
//                             if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                               return 'Please enter a valid email address';
//                             }
//                             return null;
//                           },
//                           decoration: InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
            
//             // Password input
//             Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(top: 10, bottom: 18, left: 18, right: 18),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Your Password",
//                         style: TextStyle(fontSize: 15),
//                       ),
//                       const SizedBox(height: 8),
//                       SizedBox(
//                         child: TextFormField(
//                           controller: passwordController,
//                           obscureText: passwordVisible,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter a password';
//                             }
//                             if (value.length < 6) {
//                               return 'Password must be at least 6 characters long';
//                             }
//                             return null;
//                           },
//                           decoration: InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(9),
//                               borderSide: BorderSide(
//                                 color: isPasswordError ? Colors.red : Colors.grey,
//                                 width: 2,
//                               ),
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
//                               onPressed: () {
//                                 setState(() {
//                                   passwordVisible = !passwordVisible;
//                                 });
//                               },
//                             ),
//                           ),
//                           keyboardType: TextInputType.visiblePassword,
//                           textInputAction: TextInputAction.done,
//                         ),
//                       ),
//                       if (isPasswordError)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(
//                             passwordErrorMessage,
//                             style: const TextStyle(
//                               color: Colors.red,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),

//                 // Login button
//                 Container(
//                   height: 55,
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   child: ElevatedButton(
//                     onPressed: login,
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       backgroundColor: appColor.primaryColor,
//                     ),
//                     child: const Text(
//                       'Login',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
            
//             const SizedBox(height: 20),

//             // Sign-up option
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Don't have an account?"),
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context, 
//                       MaterialPageRoute(builder: (context) => const SignUpScreen())
//                     );
//                   },
//                   child: const Text(
//                     " Sign up",
//                     style: TextStyle(
//                       color: appColor.primaryColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }










import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:flutter_application_1/screens/signUp.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../navBar/navBar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void login() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (context) => GoogleNavBar()),
    // );
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(credential);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => GoogleNavBar()));
    } on FirebaseAuthException catch (e) {
      // if (e.code == 'user-not-found') {
      //   print('No user found for that email.');
      // } else if (e.code == 'wrong-password') {
      //   print('Wrong password provided for that user.');
      if (_formKey.currentState!.validate()) {
        // Perform registration logic here
        print("Registration successful");
      } else {
        print("Validation failed");
      }
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            Container(
              padding: const EdgeInsets.only(top: 130, left: 20),
              height: 200,
              width: MediaQuery.of(context).size.width,
              color: const Color.fromRGBO(233, 236, 239, 10),
              child: const Text(
                "LOGIN",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: appColor.primaryColor),
              ),
            ),
            Column(
              children: [
                Container(
                  // margin: const EdgeInsets.all(18),
                  margin: const EdgeInsets.only(
                      bottom: 10, top: 18, left: 18, right: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Email",
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        // height: 55,
                        child: TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),

                            // hintText: 'Enter a search term',
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Column(
              children: [
                Container(
                  // margin: const EdgeInsets.all(18),
                  margin: const EdgeInsets.only(
                      top: 10, bottom: 18, left: 18, right: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Password",
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        // height: 55,
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: passwordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                           
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9)),
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(
                                  () {
                                    passwordVisible = !passwordVisible;
                                  },
                                );
                              },
                            ),
                            alignLabelWithHint: false,
                            filled: true,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(),
                  child: ElevatedButton(
                      onPressed: () async {
                        var sharedPref = await SharedPreferences.getInstance();
                        sharedPref.setBool(WelcomeScreenState.KEYLOGIN, true);
                        login();
                        //                Navigator.pushReplacement(
                        // context, MaterialPageRoute(builder: (context) => GoogleNavBar()));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // Rectangular border
                        ),
                        backgroundColor: appColor.primaryColor,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Dont have an account ?"),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                  child: const Text(
                    " Sign up",
                    style: TextStyle(
                        color: appColor.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
