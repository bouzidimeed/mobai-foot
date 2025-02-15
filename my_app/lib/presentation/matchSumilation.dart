import 'package:flutter/material.dart';

class MatchSimulationScreen extends StatelessWidget {
  final Map<String, dynamic> match; // Match data including events

  const MatchSimulationScreen({Key? key, required this.match})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use match data to populate the screen
    final String team1Name = match["team1_name"].split(' - ')[1];
    final String team2Name = match["team2_name"].split(' - ')[1];
    final String score = match["score"];
    final List<Map<String, dynamic>> events =
        List<Map<String, dynamic>>.from(match["events"]);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Match Simulation",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
            onPressed: () {
              // Handle info action
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/stadium.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark Overlay
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Live",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        match["team1_logo"], // Team 1 logo
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        team1Name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Text(
                    score,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      Image.asset(
                        match["team2_logo"], // Team 2 logo
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        team2Name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    ...events.map((event) {
                      // Parse the event to determine the icon
                      String iconPath =
                          "assets/images/goal.png"; // Default to goal
                      if (event["event"].contains("Yellow card")) {
                        iconPath = "assets/images/yellow.png";
                      } else if (event["event"].contains("Red card")) {
                        iconPath = "assets/images/red.png";
                      }

                      return SimulationEventRow(
                        minute: event["event"], // Extract minute
                        leftImage: event["team"] == "team1" ? iconPath : "",
                        rightImage: event["team"] == "team2" ? iconPath : "",
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        showDivider: true,
                      );
                    }).toList(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Full Time",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SimulationEventRow extends StatelessWidget {
  final String minute; // The event's minute
  final String leftImage; // Image path on the left
  final String rightImage; // Image path on the right
  final TextStyle? textStyle; // Optional text style
  final bool showDivider; // Option to display a divider

  const SimulationEventRow({
    Key? key,
    required this.minute,
    required this.leftImage,
    required this.rightImage,
    this.textStyle,
    this.showDivider = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Image
              if (leftImage.isNotEmpty)
                Image.asset(
                  leftImage,
                  width: 50, // Adjust the size as needed
                  height: 50,
                ),

              // Flexible Spacer
              const Spacer(),

              // Event Text (wrapped in Expanded to allow wrapping)
              Expanded(
                child: Text(
                  minute,
                  style: textStyle ??
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                  softWrap: true, // Allow text to wrap to the next line
                  overflow: TextOverflow.visible, // Handle overflow
                  textAlign: TextAlign.center, // Center the text
                ),
              ),

              // Flexible Spacer
              const Spacer(),

              // Right Image
              if (rightImage.isNotEmpty)
                Image.asset(
                  rightImage,
                  width: 50, // Adjust the size as needed
                  height: 50,
                ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            color: Colors.grey,
            thickness: 1,
            height: 20,
          ),
      ],
    );
  }
}
