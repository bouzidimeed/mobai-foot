import 'package:flutter/material.dart';
import 'package:my_app/database/db_helper.dart';

class PlayerRewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181928), // Dark background
      appBar: AppBar(
        title: const Text(
          "My Team Rewards",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF181928),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: _getPlayerRewards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading player rewards"));
          } else {
            final playerRewards = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: playerRewards.length,
              itemBuilder: (context, index) {
                final player = playerRewards[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF222232),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          player["player_name"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "Points: ${player["reward_points"]}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getPlayerRewards() async {
    final dbHelper = DatabaseHelper();
    final lineup = await dbHelper.getUserLineup();
    print('lineup: $lineup');

    if (lineup.isEmpty) {
      return [];
    }

    final List<Map<String, dynamic>> playerRewards = [];

    for (final playerName in lineup) {
      final List<Map<String, dynamic>> result =
          await dbHelper.getPlayerPerformance(playerName);
      if (result.isNotEmpty) {
        playerRewards.add({
          "player_name": playerName,
          "reward_points": result.first["reward_points"],
        });
      } else {
        playerRewards.add({
          "player_name": playerName,
          "reward_points": 0,
        });
      }
    }

    return playerRewards;
  }
}
