import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          
          decoration: BoxDecoration(
            color: Color(0xFF181928), // Dark background
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              
            ],
          ),
          child: Column(
            children: [
              // Top Image Section
              ClipRRect(
                
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/welcome.png', // Your background image
                      width: double.infinity,
                      height: 300, // Adjust height
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.black.withOpacity(0.4), // Overlay effect
                    ),
                    // Username Display
                    Positioned(
                      top: 130, // Adjust position
                      left: 20,
                      child: Column(
                        children: [
                         
                          // Welcome Text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to \nLiveScore.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Enter your name address and password \n to use the application",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
                        ],
                      ),

                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              

              SizedBox(height: 15),

              // Input Fields
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildInputField("UserName", "Spincer", false),
                    SizedBox(height: 30),
                    _buildInputField("Password", "************", true),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Remember Me & Forgot Password
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: true, onChanged: (value) {}),
                        Text("Remember Me", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color(0xFFD2B5FF  ), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              // Sign In Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFF4568DC), // Blue at 0%
        Color(0xFFB06AB3), // Purple at 100%
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.transparent, // Set transparent to let gradient show
      shadowColor: Colors.transparent, // Remove shadow if needed
    ),
    child: Text(
      "SIGN IN",
      style: TextStyle(fontSize: 18, color: Colors.white),
    ),
  ),
)

                ),
              ),

              SizedBox(height: 10),

              // Social Login
              Text("Or Login With", style: TextStyle(color: Colors.white70)),

              SizedBox(height: 10),

          


              // Register Now Link
              Text.rich(
                TextSpan(
                  text: "Don’t have an account? ",
                  style: TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: "Register Now",
                      style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Input Field Widget
  Widget _buildInputField(String label, String hint, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        SizedBox(height: 5),
        TextField(
          obscureText: isPassword,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFF1E1F3C),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white70),
            suffixIcon: isPassword
                ? Icon(Icons.visibility_off, color: Colors.white70)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // Social Login Button
  Widget _buildSocialButton(String text, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(Icons.circle, color: Colors.white, size: 18), // Placeholder icon
      label: Text(text, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
