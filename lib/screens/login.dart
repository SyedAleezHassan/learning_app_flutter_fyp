import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
// import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/signUp.dart';

import '../navBar/navBar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                margin: const EdgeInsets.all(18),
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
                      height: 55,
                      child: TextField(
                        decoration: InputDecoration(
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
                margin: const EdgeInsets.all(18),
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
                      height: 55,
                      child: TextField(
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9)),
                          // hintText: "Password",
                          // labelText: "Password",
                          // helperText: "Password must contain special character",
                          // helperStyle: TextStyle(color: Colors.green),
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
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GoogleNavBar()));
                      // Add your button action here
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
    );
  }
}
