import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tes_flut/views/StatusPage.dart';
import 'package:tes_flut/views/ProfilPage.dart';

class DashboardPage extends StatefulWidget {
  final String Biodata;

  DashboardPage({required this.Biodata});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late String _name = ''; // Initialize with empty string
  late String _kecamatan = ''; // Initialize with empty string
  late String _desa = ''; // Initialize with empty string
  late int _selectedIndex = 0; // Initialize selectedIndex
  late PageController _pageController;
  late List<String> _judulBerkas = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _fetchProfile();
    _fetchBerkas();
  }

  Future<void> _fetchProfile() async {
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/profile/${widget.Biodata}'),
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

  Future<void> _fetchBerkas() async {
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/berkas'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      List<String> judulBerkas = responseData['judul_berkas'].cast<String>();
      setState(() {
        _judulBerkas = judulBerkas;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF057438),
            ),
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                _buildBiodataList(),
                StatusPage(Biodata: _name),
                ProfilPage(Biodata: _name),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavigationBar(
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
              selectedItemColor: Color(0xFF057438),
              onTap: _onBottomNavigationBarItemTapped,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiodataList() {
  return CustomScrollView(
    slivers: <Widget>[
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Card(
              elevation: 100,
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Hallo !!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF057438),
                              ),
                            ),
                            Text(
                              '$_name'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF057438),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'PENGAJUAN SURAT',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF057438),
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _judulBerkas.length,
                                itemBuilder: (context, index) {
                                  Color randomColor = _getRandomColor(); // Dapatkan warna acak
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: IntrinsicHeight(
                                      child: Container(
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 70,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                color: randomColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                Icons.email,
                                                color: Colors.white,
                                                size: 60,
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  _judulBerkas[index],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF057438),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: 1,
        ),
      ),
    ],
  );
}


  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onBottomNavigationBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }
}

final List<Color> _randomColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.purpleAccent,
  Colors.orangeAccent,
  Colors.greenAccent,
  Colors.blueAccent,
  Colors.redAccent,
  // Tambahkan warna lain sesuai kebutuhan
];

Color _getRandomColor() {
  Random random = Random();
  return _randomColors[random.nextInt(_randomColors.length)];
}
