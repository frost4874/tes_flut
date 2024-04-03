import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              // Color(0xFF4169E1),
              // Color(0xFF007BA7),
              Colors.white,
              Colors.white,
              // Color(0xFF00C853), // Hijau Michat (diasumsikan)
              // Color(0xFF4CAF50), // Warna hijau yang lebih terang
              // Color(0xFF66BC6D), // Liveable Green
              // Color(0xFFABAB88), // Clary Sage
              // Color(0xFF88A37E), // Softened Green
              // Color(0xFF00796B), // Emerald
              // Color(0xFF009688), // Shamrock
              // Color(0xFF71EEB8), // Seafoam
              // Color(0xFF2AF598), // Warna hijau yang lebih terang
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top:
                  200, // Position for the logo and application name from the top
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    // Your logo or image here
                    Image.asset(
                      'images/kabjember1.png', // Replace with your image path
                      width: 120,
                      height: 120,
                    ),
                    SizedBox(height: 10),
                    // Application name or any text you want
                    Text(
                      'RISMA',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                          // Text color that contrasts well with the background
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Button to navigate to the login page
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 200),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade400, // Change color as needed
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors
                              .white, // Ensuring text is readable against the button color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Application version or other additional information
                  Text(
                    'Version 1.0',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade400, // Ensuring readability
                    ),
                  ),
                  SizedBox(
                      height:
                          20), // Adjust the spacing between the version text and the bottom of the screen
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
