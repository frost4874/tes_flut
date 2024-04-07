import 'package:flutter/material.dart';

  class ProfilPage extends StatefulWidget {
  final String Biodata; 

  ProfilPage({required this.Biodata});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Profil'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Konten Halaman Profil'),
      ),
      
    );
  }
}
