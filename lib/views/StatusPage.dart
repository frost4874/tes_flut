import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  final String Biodata;

  StatusPage({required this.Biodata});

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Status Permohonan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF057438),
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: EdgeInsets.fromLTRB(30, 40, 0, 40), // Tambahkan padding di sini
        ),
      ),
      backgroundColor: Color(0xFF057438),
      body: Center(
        child: Text('Status Page Content'),
      ),
    );
  }
}
