import 'package:flutter/material.dart';
import 'dart:async';

import 'package:my_app/presentation/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _text = "";
  String _fullText = "Welcome to LiveScore";
  int _textIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(microseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();

    Timer.periodic(Duration(milliseconds: 75), (timer) {
      if (_textIndex < _fullText.length) {
        setState(() {
          _text += _fullText[_textIndex];
          _textIndex++;
        });
      } else {
        timer.cancel();
      }
    });

    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181928),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/images/Ligue_1_Mobilis.png',
                width: 300,
                height: 300,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _text,
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(child: Text("Login Page")),
    );
  }
}
