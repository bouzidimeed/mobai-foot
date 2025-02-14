import 'package:flutter/material.dart';

class MatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> matches = [
      {
        "team1_logo": "assets/images/mca.png",
        "team1_name": "Team A",
        "team2_logo": "assets/images/ess.png",
        "team2_name": "Team B",
        "score": "5 - 3",
        "details": "De Jong 66', Depay 79' | Alvarez 21', Palmer 70'",
      },
      {
        "team1_logo": "assets/images/crb.png",
        "team1_name": "Team C",
        "team2_logo": "assets/images/usb.png",
        "team2_name": "Team D",
        "score": "2 - 3",
        "details": "De Jong 66', Depay 79' | Alvarez 21', Palmer 70'",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Final Score", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/stadium.jpg"), // Update with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent Overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5), // Adjust opacity here
          ),
          // Match List
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 20), // Adjust padding for AppBar
            child: buildMatchList(matches),
          ),
        ],
      ),
    );
  }

  Widget buildMatchList(List<Map<String, dynamic>> matches) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.transparent, // Fully transparent
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
                      Text(match["team1_name"], style: TextStyle(fontSize: 12, color: Colors.white)),
                    ],
                  ),
                  Text(
                    match["score"],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Column(
                    children: [
                      Image.asset(match["team2_logo"], width: 50, height: 50),
                      SizedBox(height: 5),
                      Text(match["team2_name"], style: TextStyle(fontSize: 12, color: Colors.white)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                match["details"],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        );
      },
    );
  }
}
