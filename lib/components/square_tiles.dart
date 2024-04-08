import 'package:flutter/material.dart';

class SquareTiles extends StatelessWidget {
  final String imagePath;

  const SquareTiles({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }
}
