import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const Comment({
    super.key,
    required this.text,
    required this.user,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // comment text
          Text(text),
          Row(
            children: [
              //user text
              Text(
                user,
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
                time,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
