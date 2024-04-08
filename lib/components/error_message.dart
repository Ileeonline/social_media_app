// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ErrorBar {
  static void errorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.black,
      timeInSecForIosWeb: 3,
      textColor: Colors.white,
      fontSize: 18,
    );
  }
}
