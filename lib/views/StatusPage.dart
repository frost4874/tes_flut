import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  final String nik;

  StatusPage({required this.nik});

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Page'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Status Page Content'),
      ),
    );
  }
}
