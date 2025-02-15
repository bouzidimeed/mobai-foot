import 'package:flutter/material.dart';
import 'package:my_app/database/db_helper.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> users = [
    {"name": "User one", "score": 200},
    {"name": "User two", "score": 50},
    {"name": "User three", "score": 22},
    {"name": "User four", "score": 11},
  ];

  final String currentUserName =
      "Current User"; // Replace with actual current user name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181928), // Dark background
      appBar: AppBar(
        title: const Text(
          "Leaderboard",
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
        future: _getLeaderboardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading leaderboard"));
          } else {
            final leaderboardData = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0), // Add padding here
              itemCount: leaderboardData.length,
              itemBuilder: (context, index) {
                final user = leaderboardData[index];
                final isCurrentUser = user["name"] == currentUserName;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? Colors.purple.shade800 // Highlight current user
                        : const Color(0xFF222232),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "${index + 1}",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade400,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user["name"] ?? "Unknown User",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color:
                                    isCurrentUser ? Colors.white : Colors.white,
                              ),
                            ),
                            if (user['score'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  "Score: ${user['score']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isCurrentUser
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Image.asset(
                        "assets/images/user.png",
                        width: 50,
                        height: 50,
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

  Future<List<Map<String, dynamic>>> _getLeaderboardData() async {
    final dbHelper = DatabaseHelper();
    final currentUserScore = await dbHelper.getTotalUserScore();

    // Combine hardcoded users with the current user
    final List<Map<String, dynamic>> leaderboardData = List.from(users);
    leaderboardData.add({
      "name": currentUserName,
      "score": currentUserScore,
    });

    // Sort by score in descending order
    leaderboardData
        .sort((a, b) => (b["score"] as int).compareTo(a["score"] as int));

    return leaderboardData;
  }
}
