import 'package:flutter/material.dart';

class FormationScreen extends StatefulWidget {
  @override
  _FormationScreenState createState() => _FormationScreenState();
}

class _FormationScreenState extends State<FormationScreen> {
  String selectedFormation = "4-4-2";

  final Map<String, List<Offset>> formations = {
  "4-3-3": [
    Offset(0.5, 0.9), // Goalkeeper at the top
    Offset(0.2, 0.7), Offset(0.4, 0.7), Offset(0.6, 0.7), Offset(0.8, 0.7),
    Offset(0.3, 0.5), Offset(0.5, 0.5), Offset(0.7, 0.5),
    Offset(0.3, 0.3), Offset(0.5, 0.25), Offset(0.7, 0.3),
  ],
  "5-3-1": [
    Offset(0.5, 0.9), // Goalkeeper at the top
    Offset(0.1, 0.7), Offset(0.3, 0.7), Offset(0.5, 0.7), Offset(0.7, 0.7), Offset(0.9, 0.7),
    Offset(0.3, 0.5), Offset(0.5, 0.5), Offset(0.7, 0.5),
    Offset(0.5, 0.3),
  ],
  "4-4-2": [
    Offset(0.5, 0.9), // Goalkeeper at the top
    Offset(0.2, 0.7), Offset(0.4, 0.7), Offset(0.6, 0.7), Offset(0.8, 0.7),
    Offset(0.2, 0.5), Offset(0.4, 0.5), Offset(0.6, 0.5), Offset(0.8, 0.5),
    Offset(0.4, 0.3), Offset(0.6, 0.3),
  ],
};


  final List<Map<String, String>> players = [
    {"name": "Messi", "image": "assets/images/usma_kit.png"},
    {"name": "Ronaldo", "image": "assets/images/usma_kit.png"},
    {"name": "Neymar", "image": "assets/images/usma_kit.png"},
  ];

  Map<int, Map<String, String>> selectedPlayers = {};

  void _selectPlayer(int index) async {
    Map<String, String>? chosenPlayer = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: players.map((player) {
              return ListTile(
                leading: Image.asset(player["image"]!, width: 40, height: 40),
                title: Text(player["name"]!),
                onTap: () => Navigator.pop(context, player),
              );
            }).toList(),
          ),
        );
      },
    );

    if (chosenPlayer != null) {
      setState(() {
        selectedPlayers[index] = chosenPlayer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Formation d'équipe", style: TextStyle(color: Colors.white)), backgroundColor: Colors.black),
      body: Column(
        children: [
          SizedBox(height: 10),
          Text("Choose your team", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 10),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset("assets/images/stadium2.jpg", width: double.infinity, fit: BoxFit.cover),
                ...formations[selectedFormation]!.asMap().entries.map((entry) {
                  int index = entry.key;
                  Offset position = entry.value;
                  return Positioned(
                    top: position.dy * MediaQuery.of(context).size.height * 0.6,
                    left: position.dx * MediaQuery.of(context).size.width * 0.9,
                    child: GestureDetector(
                      onTap: () => _selectPlayer(index),
                      child: Column(
                        children: [
                          selectedPlayers.containsKey(index)
                              ? Image.asset(selectedPlayers[index]!['image']!, width: 40, height: 40)
                              : CircleAvatar(radius: 18, backgroundImage: AssetImage("assets/images/player.png")),
                          if (selectedPlayers.containsKey(index))
                            Text(selectedPlayers[index]!['name']!, style: TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text("Choose your formation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: formations.keys.map((formation) {
              bool isSelected = formation == selectedFormation;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFormation = formation;
                    selectedPlayers.clear();
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: isSelected ? Colors.green : Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected ? Colors.black : Colors.transparent,
                  ),
                  child: Text(formation, style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
