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
  List<String> _searchResults = [];
  bool _showAllFiles = false;

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
        _searchResults =
            judulBerkas; // Set _searchResults dengan semua judul berkas saat pertama kali
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

  // Fungsi untuk melakukan pencarian
  void _searchBerkas(String query) {
    if (query.isNotEmpty) {
      List<String> results = [];
      for (String berkas in _judulBerkas) {
        if (berkas.toLowerCase().contains(query.toLowerCase())) {
          results.add(berkas);
        }
      }
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = _judulBerkas;
      });
    }
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
            child: Column(
              children: [
                if (_selectedIndex == 0)
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 30, 40, 0), //kanan=3, ats=2, kiri=1, 
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Cari...',
                        hintStyle: TextStyle(color: Color(0xFF057438)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (String query) {
                        _searchBerkas(query);
                      },
                    ),
                  ),
                Expanded(
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
              if (!_showAllFiles && index >= 9) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _showAllFiles = true;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.more_horiz),
                        Text('Lihat Semua Berkas')
                      ],
                    ),
                  ),
                );
              } else if (_showAllFiles && index >= _searchResults.length) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _showAllFiles = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons
                            .more_horiz_rounded), // Tombol untuk kembali ke tampilan semula
                        Text('Tampilkan Kurang')
                      ],
                    ),
                  ),
                );
              } else if (_showAllFiles && index == _searchResults.length - 1) {
                return SizedBox(
                    height:
                        60); // Spacer untuk memastikan tombol berada di bawah
              }
              // Tambahkan fungsi onTap ke setiap berkas di sini
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 30),
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
                              GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: _showAllFiles
                                    ? _searchResults.length
                                    : (_searchResults.length < 10
                                        ? _searchResults.length
                                        : 10),
                                itemBuilder: (context, index) {
                                  if (!_showAllFiles &&
                                      index >= 9 &&
                                      _searchResults.length > 9) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _showAllFiles = true;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0), //kanan=3, ats=2, kiri=1, 
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Ubah warna latar belakang Container menjadi merah
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 45,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                Icons.window,
                                                color: Colors.white,
                                                size: 35,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Lainnya',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF057438),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  Color randomColor = _getRandomColor(
                                      index); // Dapatkan warna acak berdasarkan indeks
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20), // Tambahkan radius di sini
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        // Tambahkan logika untuk menangani ketika card diklik di sini
                                        print(
                                            'Berkas ${_searchResults[index]} diklik!');
                                      },
                                      child : Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Ubah warna latar belakang Container menjadi merah
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 45,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: randomColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                Icons.email,
                                                color: Colors.white,
                                                size: 35,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              _searchResults[index],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF057438),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
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

  // Mengembalikan warna berdasarkan indeks yang diberikan
  Color _getRandomColor(int index) {
    return _randomColors[index % _randomColors.length];
  }
}
