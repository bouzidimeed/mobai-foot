import 'package:flutter/material.dart';
import 'package:my_app/presentation/chooseYourTeam.dart';
import 'package:my_app/presentation/homePage.dart';
import 'package:my_app/presentation/leaderboard.dart';
import 'package:my_app/presentation/matchSumilation.dart';
import 'package:my_app/presentation/roundFinalScore.dart' show MatchScreen;
import 'package:my_app/presentation/splash.dart';

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    LiveScoreScreen(),
    MatchScreen(),
    LeaderboardScreen(),
    FormationScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1E1D2A),
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0 ? Colors.white : Colors.grey,
                  size: 24,
                ),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.list,
                  color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                  size: 24,
                ),
                onPressed: () => _onItemTapped(1),
              ),
              IconButton(
                icon: Icon(
                  Icons.bookmark_border,
                  color: _selectedIndex == 2 ? Colors.white : Colors.grey,
                  size: 24,
                ),
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _selectedIndex == 3 ? Colors.white : Colors.grey,
                  size: 24,
                ),
                onPressed: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
          debugShowCheckedModeBanner: false, // Removes the debug banner
    theme: ThemeData.dark(),
    home: SplashScreen(),
  ));
}
