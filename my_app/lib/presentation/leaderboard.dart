import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> users = [
    {"name": "User one", "score": 200},
    {"name": "User two", "score": 50},
    {"name": "User three", "score": null},
    {"name": "User four", "score": null},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181928), // Dark background
      appBar: AppBar(
        title: const Text(
          "leaderboard",
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
  height: 400, // Specify the height here
  child: ListView.builder(
    itemCount: users.length,
    itemBuilder: (context, index) {
      final user = users[index];
      return Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFF222232),
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  if (user['score'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        "Score: ${user['score']}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
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
  ),
),
      ),
    );
  }
}     