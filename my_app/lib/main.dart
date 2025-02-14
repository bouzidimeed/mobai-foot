import 'package:flutter/material.dart';
import 'package:my_app/presentation/chooseYourTeam.dart';
import 'package:my_app/presentation/homePage.dart';
import 'package:my_app/presentation/leaderboard.dart';
import 'package:my_app/presentation/roundFinalScore.dart' show MatchScreen;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false, // Remove Debug Banner
      title: 'Flutter Demo',
      theme: ThemeData(
        
      ),
      home:  LeaderboardScreen(),
    );
  }
}

