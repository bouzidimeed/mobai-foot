import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_app/database/db_helper.dart';
import 'package:my_app/presentation/availablePlayer.dart';
import 'package:path_provider/path_provider.dart';

class FormationScreen extends StatefulWidget {
  @override
  _FormationScreenState createState() => _FormationScreenState();
}

class _FormationScreenState extends State<FormationScreen> {
  String selectedFormation = "4-4-2";
  double budget = 100.00;
  Map<int, Map<String, String>> selectedPlayers = {};
  Map<int, Map<String, String>> substitutes = {};
  final int maxSubstitutes = 4;
  bool isLoading = true;

  final Map<String, List<Offset>> formations = {
    "4-3-3": [
      Offset(0.5, 0.9),
      Offset(0.2, 0.7),
      Offset(0.4, 0.7),
      Offset(0.6, 0.7),
      Offset(0.8, 0.7),
      Offset(0.3, 0.5),
      Offset(0.5, 0.5),
      Offset(0.7, 0.5),
      Offset(0.3, 0.3),
      Offset(0.5, 0.25),
      Offset(0.7, 0.3),
    ],
    "5-3-1": [
      Offset(0.5, 0.9),
      Offset(0.1, 0.7),
      Offset(0.3, 0.7),
      Offset(0.5, 0.7),
      Offset(0.7, 0.7),
      Offset(0.9, 0.7),
      Offset(0.3, 0.5),
      Offset(0.5, 0.5),
      Offset(0.7, 0.5),
      Offset(0.5, 0.3),
    ],
    "4-4-2": [
      Offset(0.5, 0.9),
      Offset(0.2, 0.7),
      Offset(0.4, 0.7),
      Offset(0.6, 0.7),
      Offset(0.8, 0.7),
      Offset(0.2, 0.5),
      Offset(0.4, 0.5),
      Offset(0.6, 0.5),
      Offset(0.8, 0.5),
      Offset(0.4, 0.3),
      Offset(0.6, 0.3),
    ],
  };

  late List<Map<String, dynamic>> clubs;
  List<Map<String, String>> players = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await loadClubData();
    await loadSavedFormation();
    setState(() {
      isLoading = false;
    });
  }

  Future<File> get _localFile async {
    // Hardcode the path to the JSON file
    return File(
        '/Users/tarekbn/Documents/GitHub/mobai-foot/my_app/lib/dummy_backend/formation.json');
  }

  Future<void> saveFormation() async {
    try {
      final dbHelper = DatabaseHelper();

      final lineup = json.encode(selectedPlayers.map((key, value) =>
          MapEntry(key.toString(), {...value, 'position_index': key})));

      final substitutesData = json.encode(substitutes.map((key, value) =>
          MapEntry(key.toString(), {...value, 'position_index': key})));

      await dbHelper.saveFormation(
          selectedFormation, lineup, substitutesData, budget);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Formation saved successfully!'),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error saving formation: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

// Replace loadSavedFormation() method
  Future<void> loadSavedFormation() async {
    try {
      final dbHelper = DatabaseHelper();
      final formationData = await dbHelper.loadFormation();

      print('Formation data: $formationData');

      if (formationData != null) {
        setState(() {
          selectedFormation = formationData['formation_type'];
          budget = formationData['budget'];

          // Decode lineup
          final lineupMap =
              json.decode(formationData['lineup']) as Map<String, dynamic>;
          selectedPlayers = Map.fromEntries(
            lineupMap.entries.map((e) => MapEntry(
                  int.parse(e.key),
                  Map<String, String>.from(e.value
                      .map((key, value) => MapEntry(key, value.toString()))),
                )),
          );

          // Decode substitutes
          final substitutesMap =
              json.decode(formationData['substitutes']) as Map<String, dynamic>;
          substitutes = Map.fromEntries(
            substitutesMap.entries.map((e) => MapEntry(
                  int.parse(e.key),
                  Map<String, String>.from(e.value
                      .map((key, value) => MapEntry(key, value.toString()))),
                )),
          );
        });
      }
    } catch (e) {
      print('Error loading formation: $e');
    }
  }

  Future<void> loadClubData() async {
    final String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/jsons/Algerian_fantasy_data.json');
    final data = json.decode(jsonString);
    setState(() {
      clubs = List<Map<String, dynamic>>.from(data['clubs']);
      players = clubs.expand((club) {
        return (club['players'] as List).map<Map<String, String>>((player) => {
              "name": player['name'].toString(),
              "image": club['kit_image_url'].toString(),
              "position": player['position'].toString(),
              "price": player['price'].toString(),
              "club_name": club['club_name'].toString(), // Add club_name here
            });
      }).toList();
    });
  }

// Updated _selectPlayer method for FormationScreen
  void _selectPlayer(int index, {bool isSubstitute = false}) async {
    String requiredPosition = isSubstitute ? "ANY" : getPositionForIndex(index);

    List<Map<String, String>> filteredPlayers = players.where((player) {
      return requiredPosition == "ANY" ||
          player['position'] == requiredPosition;
    }).toList();

    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => AvailablePlayer(
          players: filteredPlayers,
          onPlayerSelected: (player) {
            Navigator.pop(context, player);
          },
        ),
      ),
    );

    if (result != null) {
      double newPlayerPrice = double.parse(result["price"]!);

      if (selectedPlayers.containsValue(result) ||
          substitutes.containsValue(result)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("This player is already in your team!"),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      Map<int, Map<String, String>> targetMap =
          isSubstitute ? substitutes : selectedPlayers;

      if (budget - newPlayerPrice < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Insufficient budget to add this player!"),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      setState(() {
        if (targetMap.containsKey(index)) {
          budget += double.parse(targetMap[index]!["price"]!);
        }
        budget -= newPlayerPrice;
        targetMap[index] = result;
      });
    }
  }

  void _showSubstitutionsModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Substitutes",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(maxSubstitutes, (index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _selectPlayer(index, isSubstitute: true);
                        },
                        child: Container(
                          width: 80,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              substitutes.containsKey(index)
                                  ? Image.asset(
                                      substitutes[index]!['image']!,
                                      width: 40,
                                      height: 40,
                                    )
                                  : Icon(Icons.person_add, color: Colors.white),
                              SizedBox(height: 5),
                              if (substitutes.containsKey(index))
                                Text(
                                  substitutes[index]!['name']!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String getPositionForIndex(int index) {
    if (index == 0) return "GK";

    if (selectedFormation == "4-4-2") {
      if (index >= 1 && index <= 4) return "DF";
      if (index >= 5 && index <= 8) return "MF";
      if (index >= 9) return "FW";
    }

    if (selectedFormation == "4-3-3") {
      if (index >= 1 && index <= 4) return "DF";
      if (index >= 5 && index <= 7) return "MF";
      if (index >= 8) return "FW";
    }

    if (selectedFormation == "5-3-1") {
      if (index >= 1 && index <= 5) return "DF";
      if (index >= 6 && index <= 8) return "MF";
      if (index >= 9) return "FW";
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            Text("Formation d'équipe", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          TextButton.icon(
            onPressed: _showSubstitutionsModal,
            icon: Icon(Icons.sync_alt, color: Colors.white),
            label: Text('Substitutions', style: TextStyle(color: Colors.white)),
          ),
          TextButton.icon(
            onPressed: saveFormation,
            icon: Icon(Icons.save, color: Colors.white),
            label: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.monetization_on, color: Colors.white),
                Text("Budget: ${budget.toStringAsFixed(2)}M DZD",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Choose your team",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset("assets/images/stade3.png",
                    width: double.infinity, fit: BoxFit.cover),
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
                              ? Image.asset(
                                  selectedPlayers[index]!['image']!,
                                  width: 40,
                                  height: 40,
                                )
                              : CircleAvatar(
                                  radius: 18,
                                  backgroundImage: AssetImage(
                                      "assets/images/background.png"),
                                ),
                          if (selectedPlayers.containsKey(index))
                            Column(
                              children: [
                                Text(
                                  selectedPlayers[index]!['name']!.split(
                                      ' ')[0], // Take only the first word
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  textAlign:
                                      TextAlign.center, // Center-align text
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(height: 10),
          SizedBox(height: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormationDialog(),
        backgroundColor: Colors.green,
        child: Icon(Icons.sports_soccer),
      ),
    );
  }

  void _showFormationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Formation",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ...formations.keys.map((formation) {
                  bool isSelected = formation == selectedFormation;
                  return ListTile(
                    onTap: () {
                      setState(() {
                        budget = 100.00;
                        selectedFormation = formation;
                        selectedPlayers.clear();
                        substitutes.clear();
                      });
                      Navigator.pop(context);
                    },
                    title: Text(
                      formation,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    leading: Icon(
                      Icons.sports_soccer,
                      color: isSelected ? Colors.green : Colors.white,
                    ),
                    selected: isSelected,
                    selectedTileColor: Colors.green.withOpacity(0.2),
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
