import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_app/database/db_helper.dart';
import 'package:my_app/presentation/roundFinalScore.dart';
import '../models/match.dart';
import '../services/match_generator.dart';

class LiveScoreScreen extends StatefulWidget {
  @override
  _LiveScoreScreenState createState() => _LiveScoreScreenState();
}

class _LiveScoreScreenState extends State<LiveScoreScreen> {
// List of stadiums in Algeria

  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _timer;

  List<Match> currentRoundMatches = [];
  List<Match> nextRoundMatches = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMatches();
    _startAutoScroll();
  }

  Future<void> _loadMatches() async {
    try {
      final String jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/jsons/Algerian_fantasy_data.json');
      final data = json.decode(jsonString);
      final clubs = List<Map<String, dynamic>>.from(data['clubs']);

      setState(() {
        currentRoundMatches = MatchGenerator.generateCurrentRoundMatches(clubs);
        nextRoundMatches = MatchGenerator.generateNextRoundMatches(clubs);
        isLoading = false;
      });
    } catch (e) {
      print('Error loading matches: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!mounted) return;
      setState(() {
        _currentPage = (_currentPage + 1) % currentRoundMatches.length;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  List<Map<String, dynamic>> _convertMatchesToMap(List<Match> matches) {
    return matches.map((match) {
      return {
        "team1_logo": match.logo1,
        "team1_name": match.club1,
        "team2_logo": match.logo2,
        "team2_name": match.club2,
      };
    }).toList();
  }

  void _navigateToPlayRound() async {
    final dbHelper = DatabaseHelper();
    final lineup = await dbHelper.getUserLineup();

    // Convert List<Match> to List<Map<String, dynamic>>
    final List<Map<String, dynamic>> matchesAsMap =
        _convertMatchesToMap(currentRoundMatches);

    // Pass the converted list and lineup to MatchScreen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            MatchScreen(matches: matchesAsMap, userLineup: lineup),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFF181928),
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF181928),
      appBar: AppBar(
        title: Text('LiveScore', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
              child: PageView.builder(
                controller: _pageController,
                itemCount: currentRoundMatches.length,
                itemBuilder: (context, index) {
                  return _buildMatchCard(currentRoundMatches[index]);
                },
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: _navigateToPlayRound,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Play Round',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Next Round',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            buildMatchList(nextRoundMatches),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCard(Match match) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          alignment: Alignment.bottomRight,
          fit: BoxFit.contain,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildClubInfo(match.club1, match.logo1),
          Text(
            'VS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildClubInfo(match.club2, match.logo2),
        ],
      ),
    );
  }

  Widget _buildClubInfo(String clubName, String logoPath) {
    // Club Name is of the form "full name - short name", keep only the short name
    clubName = clubName.split(' - ')[1];
    return Column(
      children: [
        Image.asset(
          logoPath,
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.broken_image, size: 50, color: Colors.red);
          },
        ),
        SizedBox(height: 8),
        Text(
          clubName,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget buildMatchList(List<Match> matches) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        return buildMatchCard(matches[index]);
      },
    );
  }

  Widget buildMatchCard(Match match) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF292B3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildClubInfoSimple(match.club1, match.logo1),
          Column(
            children: [
              Text(
                '${match.date.day}/${match.date.month}/${match.date.year}',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                '${match.time.hour}:${match.time.minute.toString().padLeft(2, '0')}',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                match.stadium,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          _buildClubInfoSimple(match.club2, match.logo2),
        ],
      ),
    );
  }

  Widget _buildClubInfoSimple(String clubName, String logoPath) {
    clubName = clubName.split(' - ')[1];
    return Row(
      children: [
        Image.asset(
          logoPath,
          width: 40,
          height: 40,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.broken_image, size: 40, color: Colors.red);
          },
        ),
        SizedBox(width: 8),
        Text(
          clubName,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
