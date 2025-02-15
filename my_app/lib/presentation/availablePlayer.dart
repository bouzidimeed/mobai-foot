// AvailablePlayer Widget
import 'package:flutter/material.dart';

class AvailablePlayer extends StatelessWidget {
  final List<Map<String, String>> players;
  final Function(Map<String, String>) onPlayerSelected;

  const AvailablePlayer({
    Key? key,
    required this.players,
    required this.onPlayerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121829),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Player available",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              return GestureDetector(
                onTap: () => onPlayerSelected(player),
                child: Container(
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
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(player["image"] ??
                                "assets/images/placeholder.png"),
                            onError: (exception, stackTrace) {
                              print('Error loading image: $exception');
                            },
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Player details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              player["name"] ?? "Unknown",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              player["position"] ?? "Unknown",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white54,
                              ),
                            ),
                            Text(
                              "${player["price"] ?? "0"}M DZD",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.purpleAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Jersey image
                      SizedBox(width: 10),
                      Container(
                        width: 112,
                        height: 117,
                        child: Image.asset(
                          player["image"] ?? "assets/images/placeholder.png",
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading jersey image: $error');
                            return Icon(Icons.person,
                                color: Colors.white, size: 50);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
