// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers, must_be_immutable

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextInputType keyboard;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final FormFieldValidator validator;

  const MyTextField({
    super.key,
    required this.keyboard,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboard,
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        fillColor: Theme.of(context).colorScheme.primary,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 18,
        ),
      ),
      cursorColor: Colors.grey[800],
    );
  }
}
