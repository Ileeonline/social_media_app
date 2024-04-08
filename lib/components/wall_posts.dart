// ignore_for_file: unused_local_variable, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/comment.dart';
import 'package:social_media_app/components/comment_button.dart';
import 'package:social_media_app/components/delete_button.dart';
import 'package:social_media_app/components/like_button.dart';
import 'package:social_media_app/helper/helper_method.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.time,
    required this.postId,
    required this.likes,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  bool isLiked = false;

// comment text controller

  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    isLiked = widget.likes.contains(currentUser.email);
  }

//toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

//add a comment
  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .collection('Comments')
        .add({
      'CommentText': commentText,
      'CommentedBy': currentUser.email,
      'CommentTime': Timestamp.now(),
    });
  }
// show a dialogue box for user to comment

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add a Comment',
        ),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(
            hintText: 'Write a Comment..',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              //pop box
              Navigator.pop(context);

              //clear controller
              _commentTextController.clear();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[900]),
            ),
          ),
          TextButton(
            onPressed: () {
              //add comment
              addComment(_commentTextController.text);

              // pop the box
              Navigator.pop(context);

              //clear controller
              _commentTextController.clear();
            },
            child: Text(
              'Post',
              style: TextStyle(color: Colors.grey[900]),
            ),
          ),
        ],
      ),
    );
  }

// delete post method

  void deletePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are You Sure You Want to delete the Post'),
        actions: [
          //  CANCEL BUTTON
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          // CANCEL BUTTON
          TextButton(
            onPressed: () async {
              // delete the comments form firestore
              final commentDocs = await FirebaseFirestore.instance
                  .collection('User Posts')
                  .doc(widget.postId)
                  .collection("Comments")
                  .get();

              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .doc(doc.id)
                    .delete();
              }

              // delete the wall post

              FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .delete()
                  .then((value) => print("Post Deleted"))
                  .catchError(
                      (error) => print("Failed to delete the post: $error"));
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //group of texts

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      //user text
                      Text(
                        widget.user.split('@')[0],
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                      //dot in center
                      Text(
                        ' • ',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                      //time stamp
                      Text(
                        widget.time,
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  )
                ],
              ),

              // delete button

              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost)
            ],
          ),
          const SizedBox(height: 10),
          //button section

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // like button

              Column(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              // comment button
              Column(
                children: [
                  CommentButton(onTap: showCommentDialog),
                  const SizedBox(height: 5),
                  const Text(
                    '0',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('User Posts')
                .doc(widget.postId)
                .collection('Comments')
                .orderBy('CommentTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              //show loading circle if there is no data in snapshot \
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  //get the comment
                  final commentData = doc.data() as Map<String, dynamic>;
                  // return the comment
                  return Comment(
                    text: commentData['CommentText'],
                    user: commentData['CommentedBy'],
                    time: formatDate(commentData['CommentTime']),
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
