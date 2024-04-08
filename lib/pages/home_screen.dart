// ignore_for_file: unused_catch_clause, use_build_context_synchronously, unused_local_variable, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_media_app/auth/login_or_regester.dart';
import 'package:social_media_app/components/drawer.dart';
import 'package:social_media_app/components/error_message.dart';
import 'package:social_media_app/components/my_text_fields.dart';
import 'package:social_media_app/components/wall_posts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/helper/helper_method.dart';
import 'package:social_media_app/pages/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  void logOut() async {
    try {
      await auth.signOut();
      ErrorBar.errorMessage("Logout Sucessfully");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginOrRegester()));
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message.toString());
    }
  }

  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('User Posts').add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }
    setState(() {
      textController.clear();
    });
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(
          onProfileTap: goToProfilePage,
          onSignOutTap: logOut,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text('The Wall'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('User Posts')
                    .orderBy('TimeStamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, Index) {
                        final post = snapshot.data!.docs[Index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          likes: List<String>.from(post['Likes'] ?? []),
                          postId: post.id,
                          time: formatDate(post['TimeStamp']),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error${snapshot.error}'),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey[900],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                        keyboard: TextInputType.text,
                        controller: textController,
                        hintText: 'Write Something on the Wall',
                        obscureText: false,
                        validator: (value) => null),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(
                      CupertinoIcons.arrow_up_circle_fill,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                'Logged in as : ${currentUser.email!}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ));
  }
}
