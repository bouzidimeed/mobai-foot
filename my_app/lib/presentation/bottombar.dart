import 'package:flutter/material.dart';

class BottomNavigationBarExample extends StatefulWidget {
  @override
  _BottomNavigationBarExampleState createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  // List of icons for the bottom bar
  final List<IconData> _icons = [
    Icons.home, // Home icon
    Icons.list, // List icon
    Icons.bookmark_border, // Bookmark icon
    Icons.person, // Profile icon
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Selected Tab: ${_selectedIndex + 1}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1E1D2A), // Dark color for the bottom bar
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_icons.length, (index) {
              return IconButton(
                icon: Icon(
                  _icons[index],
                  color: _selectedIndex == index
                      ? Colors.white
                      : Colors.grey, // Highlight selected icon
                  size: 24, // Icon size
                ),
                onPressed: () => _onItemTapped(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}


