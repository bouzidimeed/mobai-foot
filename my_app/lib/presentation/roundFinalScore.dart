import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:my_app/database/db_helper.dart';
import 'package:my_app/presentation/matchSumilation.dart';
import 'package:my_app/presentation/player_rewards_screen.dart';

class MatchScreen extends StatelessWidget {
  final List<Map<String, dynamic>> matches;
  final List<String> userLineup;

  MatchScreen({required this.matches, required this.userLineup});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Final Score",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events,
                color: Colors.white), // Reward icon
            onPressed: () {
              // Navigate to PlayerRewardsScreen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PlayerRewardsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _loadClubData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data"));
          } else {
            final clubData = snapshot.data as List<Map<String, dynamic>>;
            return FutureBuilder(
              future: _simulateMatches(
                  matches, clubData), // Await simulated matches
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error simulating matches"));
                } else {
                  final simulatedMatches =
                      snapshot.data as List<Map<String, dynamic>>;
                  return Stack(
                    children: [
                      // Background Image
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/stadium.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Semi-transparent Overlay
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      // Match List
                      Padding(
                        padding:
                            const EdgeInsets.only(top: kToolbarHeight + 20),
                        child: buildMatchList(simulatedMatches),
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _loadClubData() async {
    final String jsonString =
        await rootBundle.loadString('assets/jsons/Algerian_fantasy_data.json');
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    return List<Map<String, dynamic>>.from(jsonData["clubs"]);
  }

  Future<List<Map<String, dynamic>>> _simulateMatches(
      List<Map<String, dynamic>> matches,
      List<Map<String, dynamic>> clubData) async {
    final List<Map<String, dynamic>> simulatedMatches = [];

    for (var match in matches) {
      final team1 = clubData
          .firstWhere((club) => club["club_name"] == match["team1_name"]);
      final team2 = clubData
          .firstWhere((club) => club["club_name"] == match["team2_name"]);

      final simulatedData =
          await _simulateMatchEvents(team1, team2); // Await here
      simulatedMatches.add({
        ...match,
        "events": simulatedData["events"],
        "score": simulatedData["score"], // Use the dynamic score
      });
    }

    return simulatedMatches;
  }

  Future<Map<String, dynamic>> _simulateMatchEvents(
      Map<String, dynamic> team1, Map<String, dynamic> team2) async {
    final List<Map<String, dynamic>> events = [];
    final Random random = Random();
    int team1Goals = 0;
    int team2Goals = 0;
    final dbHelper = DatabaseHelper();

    // Simulate goals and assists
    for (int i = 0; i < random.nextInt(5); i++) {
      final scorerTeam = random.nextBool() ? team1 : team2;
      final scorer =
          scorerTeam["players"][random.nextInt(scorerTeam["players"].length)];
      final assisterTeam = random.nextBool() ? team1 : team2;
      final assister = assisterTeam["players"]
          [random.nextInt(assisterTeam["players"].length)];

      events.add({
        "event": "Goal by ${scorer["name"]} (Assist: ${assister["name"]})",
        "team": scorerTeam == team1 ? "team1" : "team2",
      });

      // Update goals for the respective team
      if (scorerTeam == team1) {
        team1Goals++;
      } else {
        team2Goals++;
      }

      // Update player performance for scorer and assister
      await dbHelper.updatePlayerPerformance(
        playerName: scorer["name"],
        playerPosition: scorer["position"],
        goals: 1,
      );
      await dbHelper.updatePlayerPerformance(
        playerName: assister["name"],
        playerPosition: scorer["position"],
        assists: 1,
      );
    }

    // Simulate yellow cards
    for (int i = 0; i < random.nextInt(3); i++) {
      final team = random.nextBool() ? team1 : team2;
      final player = team["players"][random.nextInt(team["players"].length)];
      events.add({
        "event": "Yellow card for ${player["name"]}",
        "team": team == team1 ? "team1" : "team2",
      });

      // Update player performance for yellow card
      await dbHelper.updatePlayerPerformance(
        playerName: player["name"],
        playerPosition: player["position"],
        yellowCards: 1,
      );
    }

    // Simulate red cards
    for (int i = 0; i < random.nextInt(2); i++) {
      final team = random.nextBool() ? team1 : team2;
      final player = team["players"][random.nextInt(team["players"].length)];
      events.add({
        "event": "Red card for ${player["name"]}",
        "team": team == team1 ? "team1" : "team2",
      });

      // Update player performance for red card
      await dbHelper.updatePlayerPerformance(
        playerName: player["name"],
        playerPosition: player["position"],
        redCards: 1,
      );
    }

    return {
      "events": events,
      "score":
          "$team1Goals - $team2Goals", // Dynamic score based on simulated goals
    };
  }

  Widget buildMatchList(List<Map<String, dynamic>> matches) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        return GestureDetector(
          onTap: () {
            // Navigate to MatchSimulationScreen and pass the match data
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MatchSimulationScreen(match: match),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  "Full Time",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Image.asset(match["team1_logo"], width: 50, height: 50),
                        SizedBox(height: 5),
                        Text(match["team1_name"].split(' - ')[1],
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                      ],
                    ),
                    Text(
                      match["score"],
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Column(
                      children: [
                        Image.asset(match["team2_logo"], width: 50, height: 50),
                        SizedBox(height: 5),
                        Text(match["team2_name"].split(' - ')[1],
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ...match["events"].map((eventMap) {
                  final event =
                      eventMap["event"]; // Access the event string from the map
                  // Check if the event concerns a player in the user's lineup
                  final isUserPlayer =
                      userLineup.any((player) => event.contains(player));

                  return Text(
                    event,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight:
                          isUserPlayer ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
