// ignore_for_file: unused_field, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_media_app/components/error_message.dart';
import 'package:social_media_app/components/my_button.dart';
import 'package:social_media_app/components/my_text_fields.dart';
import 'package:social_media_app/components/square_tiles.dart';
import 'package:social_media_app/pages/home_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser(String _email, String _password) async {
    setState(() {
      loading = true;
    });
    try {
      await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      ErrorBar.errorMessage("Login Sucessfully");
      setState(() {
        loading = false;
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } catch (e) {
      ErrorBar.errorMessage(e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //logo
                    const Icon(
                      Icons.lock,
                      size: 100,
                    ),
                    const SizedBox(height: 25),
                    //greeting message
                    Text(
                      "Welcome back! you've been missed",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                      ),
                    ),

                    const SizedBox(height: 50),
                    // email text fields

                    Form(
                      key: _key,
                      child: Column(
                        children: [
                          MyTextField(
                            keyboard: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter Email";
                              } else if (!value.contains("@")) {
                                return "@ is missing";
                              } else {
                                return null;
                              }
                            },
                            controller: emailTextController,
                            obscureText: false,
                            hintText: 'Email',
                          ),
                          const SizedBox(height: 10),
                          // passwords text fields
                          MyTextField(
                            keyboard: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter Password";
                              } else {
                                return null;
                              }
                            },
                            controller: passwordTextController,
                            hintText: 'Password',
                            obscureText: true,
                          ),
                          const SizedBox(height: 8),
                          // forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          //login button
                          MyButton(
                            buttonText: 'Sign In',
                            loading: loading,
                            Ontap: () {
                              if (_key.currentState!.validate()) {
                                loginUser(emailTextController.text.toString(),
                                    passwordTextController.text.toString());
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),
                    // continue with
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: .5,
                            color: Colors.grey[600],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: .5,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    //google and apple logo
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SquareTiles(imagePath: 'asssets/logos/google.png'),
                        SizedBox(width: 20),
                        SquareTiles(imagePath: 'asssets/logos/apple.png'),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    //not have an account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not a Member ?",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Register Now",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
