import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tes_flut/auth/LoginPage.dart';

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset(
                    'images/jj1.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.black.withOpacity(0.8),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 100, 40, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 70,
                        height: 65,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 50,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'ngambil data nama',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'jotione',
                            ),
                          ),
                          Text(
                            'ngambil data email',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'jotione',
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20), // Atur padding sesuai kebutuhan Anda
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF057438), width: 2.0),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Warna shadow
                      spreadRadius: 2, // Seberapa jauh shadow tersebar
                      blurRadius: 5, // Seberapa blur shadow
                      offset: Offset(0, 3), // Perubahan posisi shadow
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Widget Edit
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.edit_document,
                          color: Color(0xFF057438),
                        ),
                        title: Text(
                          'Edit Biodata',
                          style: TextStyle(
                            color: Color(0xFF057438),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          // Action when Edit is tapped
                        },
                      ),
                    ),
                    Divider( // Garis pembatas di sini
                      color: Color(0xFF057438),
                      height: 0,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.history_rounded,
                          color: Color(0xFF057438),
                        ),
                        title: Text(
                          'Riwayat',
                          style: TextStyle(
                            color: Color(0xFF057438),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          // Action when Riwayat is tapped
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 80), // Atur padding sesuai kebutuhan Anda
              child: Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Konfirmasi Logout",
                            style: TextStyle(
                              color: Color(0xFF057438),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text("Apakah Anda yakin ingin logout?",
                            style: TextStyle(
                            color: Color(0xFF057438),
                          ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Tutup dialog
                              },
                              child: Text("Batal",
                                style: TextStyle(
                                  color: Color(0xFF057438),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Tambahkan logika logout di sini
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage()),
                                );
                              },
                              child: Text("Logout",
                                style: TextStyle(
                                    color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF057438), width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Warna shadow
                          spreadRadius: 2, // Seberapa jauh shadow tersebar
                          blurRadius: 5, // Seberapa blur shadow
                          offset: Offset(0, 3), // Perubahan posisi shadow
                        ),
                      ],
                      color: Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 130),
                      child: Text(
                        'LOGOUT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
