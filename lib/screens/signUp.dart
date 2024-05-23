import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:learning_app_fyp/screens/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool passwordVisible = false;
  bool value = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  void register() async {
    final String email = emailController.text;
    final String password = passwordController.text;
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } on FirebaseAuthException catch (e) {
      // if (e.code == 'weak-password') {
      //   print('The password provided is too weak.');
      // } else if (e.code == 'email-already-in-use') {
      //   print('The account already exists for that email.');
      // }
      if (_formKey.currentState!.validate()) {
        // Perform registration logic here
        print("Registration successful");
      } else {
        print("Validation failed");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 130, left: 20),
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(233, 236, 239, 10),
                child: const Text(
                  "SIGN UP",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Color.fromRGBO(128, 0, 128, 5)),
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
                          child: TextFormField(
                            controller: emailController,
                            validator: (text) {
                              if (text == null || text.isEmpty)
                                return "Fill this field";
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(text)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
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
                          child: TextFormField(
                            controller: passwordController,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (text.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                            obscureText: passwordVisible,
                            decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9)),
                              //@@@@@@yevphle tha@@@@@@@@
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
                        onPressed: register,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Rectangular border
                          ),
                          backgroundColor: const Color.fromRGBO(128, 0, 128, 5),
                        ),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  const SizedBox(width: 10), //SizedBox

                  Checkbox(
                    value: value,
                    onChanged: (bool? value) {
                      setState(() {
                        this.value = value!;
                      });
                    },
                  ),

                  const Text(
                    "By creating an account you have to agree\n with our terms & condition",
                    style: TextStyle(fontSize: 13.0),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text(
                      " Login",
                      style: TextStyle(
                          color: Color.fromRGBO(128, 0, 128, 5),
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      height: 30,
                      thickness: 1,
                      indent: 15,
                      endIndent: 20,
                      color: Colors.black,
                    ),
                  ),
                  Text("Or sign up with"),
                  Expanded(
                    child: Divider(
                      height: 30,
                      thickness: 1,
                      indent: 10,
                      endIndent: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      "assets/images/gugal.png",
                      height: 100,
                      width: 60,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      "assets/images/facebook.png",
                      height: 100,
                      width: 60,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
