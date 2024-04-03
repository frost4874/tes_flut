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
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation =
        CurvedAnimation(parent: _animationController!, curve: Curves.easeOut);

    _animationController!.forward();

    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LandingPage()));
    });
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Membuat efek visual lebih lambat, opsional, hanya untuk demo
    timeDilation = 2.0;

    return Scaffold(
      backgroundColor:
          Colors.blueGrey[900], // Warna latar belakang yang lebih elegan
      body: FadeTransition(
        opacity: _animation!,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tampilkan logo dengan animasi fade-in
              Image.asset(
                'images/kabjember1.png', // Sesuaikan dengan path gambar Anda
                width: 160, // Lebar gambar
                height: 160, // Tinggi gambar
              ),
              SizedBox(height: 24),
              // Tampilkan teks aplikasi dengan animasi
              Text(
                'NICE TRY APP', // Nama aplikasi Anda
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white
                      .withOpacity(_animation!.value), // Efek fade-in pada teks
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
