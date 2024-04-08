// format date nicely

// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  String year = dateTime.year.toString();

  String month = dateTime.month.toString();

  String day = dateTime.day.toString();

  String formatedDate = '$day/$month/$month';

  return formatedDate;
}
