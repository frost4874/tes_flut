import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:tes_flut/views/LandingPage.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    _animationController.forward();

    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LandingPage()));
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Membuat efek visual lebih lambat, opsional, hanya untuk demo
    timeDilation = 1.5;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/kabjember1.png',
                width: 95,
                height: 110,
              ),
              SizedBox(height: 10),
              Text(
                'SURAT DESA JEMBER',
                style: TextStyle(
                  color: Color(0xFF057438),
                  fontSize: 18,
                  fontFamily: 'Interbold',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
