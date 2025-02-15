import 'dart:math';
import 'package:flutter/material.dart';

import '../models/match.dart';

class MatchGenerator {
  static List<Match> generateCurrentRoundMatches(
      List<Map<String, dynamic>> clubs) {
    final List<Map<String, dynamic>> shuffledClubs = List.from(clubs)
      ..shuffle();
    final List<Match> matches = [];

    for (int i = 0; i < 8; i++) {
      final club1 = shuffledClubs[i * 2];
      final club2 = shuffledClubs[i * 2 + 1];

      matches.add(Match(
        club1: club1['club_name'],
        logo1: club1['kit_image_url'],
        club2: club2['club_name'],
        logo2: club2['kit_image_url'],
        date: getRandomDate(),
        time: getRandomTime(),
        stadium: getRandomStadium(),
      ));
    }
    return matches;
  }

  static List<Match> generateNextRoundMatches(
      List<Map<String, dynamic>> clubs) {
    final List<Map<String, dynamic>> shuffledClubs = List.from(clubs)
      ..shuffle();
    final List<Match> matches = [];

    for (int i = 0; i < 8; i++) {
      final club1 = shuffledClubs[i * 2];
      final club2 = shuffledClubs[i * 2 + 1];

      matches.add(Match(
        club1: club1['club_name'],
        logo1: club1['kit_image_url'],
        club2: club2['club_name'],
        logo2: club2['kit_image_url'],
        date: getRandomDate(),
        time: getRandomTime(),
        stadium: getRandomStadium(),
      ));
    }
    return matches;
  }
}

// List of stadiums in Algeria
final List<String> algerianStadiums = [
  "Stade du 5 Juillet 1962, Algiers",
  "Stade Mustapha Tchaker, Blida",
  "Stade 19 Mai 1956, Annaba",
  "Stade Ahmed Zabana, Oran",
  "Stade Mohamed Hamlaoui, Constantine",
  "Stade 24 Fevrier 1956, Sidi Bel Abbès",
  "Stade Colonel Lotfi, Tizi Ouzou",
  "Stade Ismaïl Makhlouf, Tlemcen",
  "Stade Birouana, Béjaïa",
  "Stade Mohamed Boumezrag, Chlef",
];

// Generate a random date within the next 7 days
DateTime getRandomDate() {
  final random = Random();
  final currentDate = DateTime.now();
  final randomDays = random.nextInt(7); // Random days between 0 and 6
  return currentDate.add(Duration(days: randomDays));
}

// Generate a random time between 14:00 and 22:00
TimeOfDay getRandomTime() {
  final random = Random();
  final hour = 14 + random.nextInt(9); // Random hour between 14 and 22
  final minute = random.nextInt(60); // Random minute between 0 and 59
  return TimeOfDay(hour: hour, minute: minute);
}

// Get a random stadium from the list
String getRandomStadium() {
  final random = Random();
  return algerianStadiums[random.nextInt(algerianStadiums.length)];
}
