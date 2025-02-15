import 'package:flutter/material.dart';

class Match {
  final String club1;
  final String logo1;
  final String club2;
  final String logo2;
  final DateTime date;
  final TimeOfDay time;
  final String stadium;

  Match({
    required this.club1,
    required this.logo1,
    required this.club2,
    required this.logo2,
    required this.date,
    required this.time,
    required this.stadium,
  });
}
