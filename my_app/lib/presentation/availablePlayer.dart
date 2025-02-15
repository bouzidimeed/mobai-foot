import 'package:flutter/material.dart';

class AvailablePlayer extends StatelessWidget {
  final List<Map<String, dynamic>> players = [
    {
      "name": "Hamza benzaoui",
      "position": "Goalkeeper",
      "number": "19",
      "clubLogo": "assets/images/mca.png", // Replace with actual asset
      "jersey": "assets/images/usma_kit.png", // Replace with actual asset
    },
    {
      "position": "Right Back",
      "number": "24",
      "clubLogo": "assets/images/mca.png",
      "jersey": "assets/images/usma_kit.png",
    },
    {
      "name": "Youcef Belaili",
      "position": "Striker",
      "number": "79",
      "clubLogo": "assets/images/mca.png",
      "jersey": "assets/images/usma_kit.png",
    },
    {
      "name": "Adil Boulbina",
      "position": "Attacking Midfielder",
      "number": "66",
      "clubLogo": "assets/images/mca.png",
      "jersey": "assets/images/usma_kit.png",
    },
    {
      "name": "Adil Boulbina",
      "position": "Attacking Midfielder",
      "number": "66",
      "clubLogo": "assets/images/mca.png",
      "jersey": "assets/images/usma_kit.png",
    },
    {
      "name": "Adil Boulbina",
      "position": "Attacking Midfielder",
      "number": "66",
      "clubLogo": "assets/images/mca.png",
      "jersey": "assets/images/usma_kit.png",
    },
    {
      "name": "Adil Boulbina",
      "position": "Attacking Midfielder",
      "number": "66",
      "clubLogo": "assets/images/mca.png",
      "jersey": "assets/images/usma_kit.png",
    },
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121829), // Dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Player available", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: players.map((player) {
              return Container(
                height: 150,
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF1D2336),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Club logo
                    CircleAvatar(
                      backgroundImage: AssetImage(player["clubLogo"]),
                      backgroundColor: Colors.transparent,
                      radius: 18,
                    ),
                    SizedBox(width: 10),
                    // Player details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          Text(
                            player["name"],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            player["position"],
                            style: TextStyle(fontSize: 14, color: Colors.white54),
                          ),
                          Text(
                            player["number"],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                          ),
                        ],
                      ),
                    ),
                    // Jersey image
                    SizedBox(width: 10),
                    Image.asset(
                      player["jersey"],
                      width: 112,
                      height: 117,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
