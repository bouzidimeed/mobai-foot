import 'package:flutter/material.dart';

class MatchSimulationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Match simulation",
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
                image: AssetImage("assets/images/stadium.jpg"), // Replace with your background image
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
                        "assets/images/jsk.png", // Replace with team 1 logo
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "USMA",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "2 - 3",
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
                        "assets/images/mca.png", // Replace with team 2 logo
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "IOK",
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
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: const [
                        Text(
                          "De Jong 66'",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Depay 79'",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: const [
                        Text(
                          "Alvarez 21'",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Palmer 70'",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "match simulation",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
              
                    
                  
                    SimulationEventRow(
              minute: "20'",
              leftImage: "assets/images/goal.png",
              rightImage: "assets/images/yellow.png",
              textStyle: const TextStyle(color: Colors.white, fontSize: 16),
              showDivider: true,
            ),
            SimulationEventRow(
              minute: "40'",
              leftImage: "assets/images/goal.png",
              rightImage: "assets/images/yellow.png",
              textStyle: const TextStyle(color: Colors.white, fontSize: 16),
              showDivider: true,
            ),
            SimulationEventRow(
              minute: "90'",
              leftImage: "assets/images/goal.png",
              rightImage: "assets/images/yellow.png",
              textStyle: const TextStyle(color: Colors.white, fontSize: 16),
              showDivider: true,
            ),
            SimulationEventRow(
              minute: "90'",
              leftImage: "assets/images/goal.png",
              rightImage: "assets/images/yellow.png",
              textStyle: const TextStyle(color: Colors.white, fontSize: 16),
              showDivider: true,
            ),
            
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
              )
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
              Image.asset(
                leftImage,
                width: 50, // Adjust the size as needed
                height: 50,
              ),

              // Flexible Spacer
              const Spacer(),

              // Time (centered text)
              Text(
                minute,
                style: textStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
              ),

              // Flexible Spacer
              const Spacer(),

              // Right Image
              Image.asset(
                rightImage,
                width: 50, // Adjust the size as needed
                height: 50,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
