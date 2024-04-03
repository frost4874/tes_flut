import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tes_flut/views/StatusPage.dart';

class ProfilePage extends StatefulWidget {
  final String nik;

  ProfilePage({required this.nik});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _name = ''; // Initialize with empty string
  late String _kecamatan = ''; // Initialize with empty string
  late String _desa = ''; // Initialize with empty string
  int _selectedIndex = 0; // Initialize selectedIndex to 0
  late PageController _pageController; // Initialize PageController

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: _selectedIndex); // Initialize PageController
    _fetchProfile(); // Fetch profile data
  }

  Future<void> _fetchProfile() async {
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/profile/${widget.nik}'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        _name = responseData['name'];
        _kecamatan = responseData['kecamatan'];
        _desa = responseData['desa'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: PageView(
        controller: _pageController, // Assign PageController to PageView
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          // Your profile content here
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Name: ${_name}'),
                Text('Kecamatan: ${_kecamatan}'),
                Text('Desa: ${_desa}'),
              ],
            ),
          ),
          StatusPage(),
          // Add more pages for other functionalities
          // Example:
          // Container(
          //   color: Colors.blue,
          //   child: Center(
          //     child: Text('Dashboard Page'),
          //   ),
          // ),
          // Container(
          //   color: Colors.green,
          //   child: Center(
          //     child: Text('Status Page'),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.greenAccent,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
