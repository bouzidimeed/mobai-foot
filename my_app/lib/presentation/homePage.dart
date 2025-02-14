import 'dart:async';
import 'package:flutter/material.dart';

class LiveScoreScreen extends StatefulWidget {
  @override
  _LiveScoreScreenState createState() => _LiveScoreScreenState();
}

class _LiveScoreScreenState extends State<LiveScoreScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> matches = [
    {"club1": "MCA", "logo1": "assets/images/mca.png", "score": "2 - 2", "club2": "USMA", "logo2": "assets/images/mca.png"},
    {"club1": "CRB", "logo1": "assets/images/crb.png", "score": "1 - 0", "club2": "JSS", "logo2": "assets/images/mca.png"},
    {"club1": "ESS", "logo1": "assets/images/ess.png", "score": "3 - 1", "club2": "CSC", "logo2": "assets/images/mca.png"},
    {"club1": "JSK", "logo1": "assets/images/jsk.png", "score": "0 - 0", "club2": "NAHD", "logo2": "assets/images/mca.png"},
    {"club1": "USB", "logo1": "assets/images/usb.png", "score": "1 - 3", "club2": "RCA", "logo2": "assets/images/mca.png"},
  ];

  final List<Map<String, dynamic>> nextRoundMatches = [
    {"club1": "Kabyle", "logo1": "assets/images/jsk.png", "date": "27 Aug 2022", "time": "01:40", "club2": "USMA", "logo2": "assets/images/usma.png"},
    {"club1": "Molodya", "logo1": "assets/images/mca.png", "date": "27 Aug 2022", "time": "00:10", "club2": "Essetif", "logo2": "assets/images/ess.png"},
    {"club1": "Belouzed", "logo1": "assets/images/crb.png", "date": "27 Aug 2022", "time": "00:10", "club2": "Rahim", "logo2": "assets/images/asb.png"},
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!mounted) return;
      setState(() {
        _currentPage = (_currentPage + 1) % matches.length;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  return _buildMatchCard(matches[index]);
                },
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
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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

 Widget _buildMatchCard(Map<String, dynamic> match) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/background.png"),
        alignment: Alignment.bottomRight, // Moves the image to the left
         // Update with your actual image path
        fit: BoxFit.contain, // Ensures the image covers the entire container
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    padding: EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildClubInfo(match["club1"], match["logo1"], [
          {"player": "Benzema", "minute": 10},
          {"player": "Modric", "minute": 20},
        ]),
        Text(
          match["score"],
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        _buildClubInfo(match["club2"], match["logo2"], [
          {"player": "Messi", "minute": 30},
          {"player": "Ronaldo", "minute": 45},
        ]),
      ],
    ),
  );
}


  Widget _buildClubInfo(String clubName, String logoPath, List<Map<String, dynamic>> scorers) {
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
        SizedBox(height: 5),
        ...scorers.map((scorer) {
          return Text(
            "${scorer['player']} ${scorer['minute']}'",
            style: TextStyle(color: Colors.white, fontSize: 14),
          );
        }).toList(),
      ],
    );
  }

  Widget buildMatchList(List<Map<String, dynamic>> matches) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        return buildMatchCard(matches[index]);
      },
    );
  }

  Widget buildMatchCard(Map<String, dynamic> match) {
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
          _buildClubInfoSimple(match["club1"], match["logo1"]),
          Column(
            children: [
              Text(
                match["date"],
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                match["time"],
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          _buildClubInfoSimple(match["club2"], match["logo2"]),
        ],
      ),
    );
  }

  Widget _buildClubInfoSimple(String clubName, String logoPath) {
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
