import 'package:flutter/material.dart';

class AvailablePlayer extends StatefulWidget {
  final List<Map<String, String>> players;
  final Function(Map<String, String>) onPlayerSelected;

  const AvailablePlayer({
    Key? key,
    required this.players,
    required this.onPlayerSelected,
  }) : super(key: key);

  @override
  State<AvailablePlayer> createState() => _AvailablePlayerState();
}

class _AvailablePlayerState extends State<AvailablePlayer> {
  String? selectedClub;
  RangeValues _currentPriceRange =
      RangeValues(0, 30); // Assuming max price is 30M
  List<Map<String, String>> filteredPlayers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredPlayers = widget.players;

    // Extract unique club names from players
    clubs = [
      "Mouloudia Club d'Alger - MCA",
      'Chabab Riadhi Belouizdad - CRB',
      "Union sportive de la médina d'Alger - USMA",
      'Jeunesse sportive de Kabylie - JSK',
      'Paradou Athletic Club - PAC',
      'Club sportif constantinois - CSC',
      'Entente sportive sétifienne - ESS',
      'Association sportive olympique de Chlef - ASOC',
      'Union sportive madinet Khenchela - USMK',
      'Olympique Akbou - OA',
      "Mouloudia Club d'Oran - MCO",
      'Mouloudia Club El Bayadh - MCB',
      'Jeunesse sportive de Saoura - JSS',
      'Nadjem Chabab Magra - NCM',
      'Espérance sportive de Mostaganem - ESM',
      'Union sportive de Biskra - USB',
    ];
  }

  late final List<String> clubs;

  void _filterPlayers() {
    setState(() {
      filteredPlayers = widget.players.where((player) {
        // Convert price string to double
        double playerPrice = double.tryParse(player['price'] ?? '0') ?? 0;

        // Club filter
        bool clubMatch =
            selectedClub == null || player['club_name'] == selectedClub;

        // Price range filter
        bool priceMatch = playerPrice >= _currentPriceRange.start &&
            playerPrice <= _currentPriceRange.end;

        // Search text filter
        bool searchMatch = _searchController.text.isEmpty ||
            player['name']!
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        return clubMatch && priceMatch && searchMatch;
      }).toList();
    });
  }

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
      body: Column(
        children: [
          // Filters section
          Container(
            padding: EdgeInsets.all(16),
            color: Color(0xFF1D2336),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search player...',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: Color(0xFF121829),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => _filterPlayers(),
                ),
                SizedBox(height: 16),

                // Club dropdown
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFF121829),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedClub,
                    hint: Text('Select Club',
                        style: TextStyle(color: Colors.white54)),
                    dropdownColor: Color(0xFF121829),
                    style: TextStyle(color: Colors.white),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    underline: SizedBox(),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text('All Clubs',
                            style: TextStyle(color: Colors.white)),
                      ),
                      ...clubs.map((String club) {
                        return DropdownMenuItem<String>(
                          value: club,
                          child:
                              Text(club, style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedClub = newValue;
                        _filterPlayers();
                      });
                    },
                  ),
                ),
                SizedBox(height: 16),

                // Price range slider
                Text('Price Range (M DZD):',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                RangeSlider(
                  values: _currentPriceRange,
                  min: 0,
                  max: 30,
                  divisions: 30,
                  labels: RangeLabels(
                    _currentPriceRange.start.round().toString(),
                    _currentPriceRange.end.round().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _currentPriceRange = values;
                      _filterPlayers();
                    });
                  },
                ),
              ],
            ),
          ),

          // Players list
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: filteredPlayers.map((player) {
                    return GestureDetector(
                      onTap: () => widget.onPlayerSelected(player),
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
                                player["image"] ??
                                    "assets/images/placeholder.png",
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
