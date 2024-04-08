// ignore_for_file: unused_field, prefer_final_field, use_build_context_synchronously, unused_catch_clause, no_leading_underscores_for_local_identifiers, unused_local_variable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/error_message.dart';
import 'package:social_media_app/components/my_button.dart';
import 'package:social_media_app/components/my_text_fields.dart';
import 'package:social_media_app/pages/login_page.dart';

// ignore: must_be_immutable
class RegesterPage extends StatefulWidget {
  final Function()? onTap;
  const RegesterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegesterPage> createState() => _RegesterPageState();
}

class _RegesterPageState extends State<RegesterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    confirmPasswordController.dispose();
  }

  bool loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void registerUser(String _email, String _password) async {
    setState(() {
      loading = true;
    });
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'Username': emailTextController.text.split('@')[0],
        'bio': "Empty Bio"
      });

      ErrorBar.errorMessage("Signup Sucessfully");
      setState(() {
        loading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen(
                    onTap: () {},
                  )));
    } catch (e) {
      ErrorBar.errorMessage(e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
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
                    "Let's Create an account for you",
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
                        const SizedBox(height: 10),
                        // confirm password
                        MyTextField(
                          keyboard: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Confirm Password";
                            } else {
                              return null;
                            }
                          },
                          controller: confirmPasswordController,
                          hintText: 'confirm Password',
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        MyButton(
                          loading: loading,
                          buttonText: 'Sign Up',
                          Ontap: () {
                            if (_key.currentState!.validate()) {
                              if (passwordTextController.text.toString() !=
                                  confirmPasswordController.text.toString()) {
                                setState(() {
                                  loading = false;
                                });
                                return ErrorBar.errorMessage(
                                    "Password is Re-matched");
                              } else {
                                return registerUser(
                                  emailTextController.text.toString(),
                                  passwordTextController.text.toString(),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  //login button

                  const SizedBox(height: 15),

                  //not have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login Now",
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
    );
  }
}
