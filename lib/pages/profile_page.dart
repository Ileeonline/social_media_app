// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('Users');

  Future<void> editField(String field) async {
    String newValue = "";

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit  $field',
          style: const TextStyle(),
        ),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Edit $field',
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, newValue);
            },
            child: const Text(
              "Save",
            ),
          ),
        ],
      ),
    );
    if (newValue.trim().isNotEmpty) {
      await userCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.person,
                  size: 75,
                ),
                const SizedBox(height: 10),
                Text(
                  currentUser.email!,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                MyTextBox(
                  text: userData['Username'].toString(),
                  sectionName: 'User Name',
                  onPressed: () => editField('Username'),
                ),
                MyTextBox(
                  text: userData['bio'].toString(),
                  sectionName: 'Bio',
                  onPressed: () => editField('bio'),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Posts',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
