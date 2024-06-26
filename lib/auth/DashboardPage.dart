import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tes_flut/views/ProsedurPage.dart';
import 'package:tes_flut/views/StatusPage.dart';
import 'package:tes_flut/views/ProfilPage.dart';
import 'package:tes_flut/views/DetailBerkasPage.dart';

class DashboardPage extends StatefulWidget {
  final String Biodata;

  DashboardPage({required this.Biodata});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late String _nik = '';
  late String _name = '';
  late String _kecamatan = '';
  late String _desa = '';
  late String _email = '';
  late String _alamat = '';
  late String _jekel = '';
  late String _tglLahir = '';
  late String _kota = '';
  late String _telepon = '';
  late String _rt = '';
  late String _rw = '';
  late String _tempatlahir = '';
  late String _agama = '';
  late String _statusWarga = '';
  late String _warganegara = '';
  late String _statusNikah = '';
  late int _selectedIndex = 0;
  late PageController _pageController;
  late List<String>? _judulBerkas = [];
  late List<String>? _idBerkas = [];
  late List<String>? _formTambahan = [];
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
      Uri.parse(
          'https://suratdesajember.framework-tif.com/api/profile/${widget.Biodata}'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        _nik = responseData['nik'] ?? '';
        _name = responseData['name'] ?? '';
        _email = responseData['email'] ?? '';
        _jekel = responseData['jekel'] ?? '';
        _kecamatan = responseData['kecamatan'] ?? '';
        _desa = responseData['desa'] ?? '';
        _kota = responseData['kota'] ?? '';
        _tempatlahir = responseData['tempat_lahir'] ?? '';
        _tglLahir = responseData['tgl_lahir'] ?? '';
        _agama = responseData['agama'] ?? '';
        _alamat = responseData['alamat'] ?? '';
        _telepon = responseData['telepon'] ?? '';
        _statusWarga = responseData['status_warga'] ?? '';
        _warganegara = responseData['warganegara'] ?? '';
        _statusNikah = responseData['status_nikah'] ?? '';
        _rt = responseData['rt'] ?? '';
        _rw = responseData['rw'] ?? '';
      });
      print(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _fetchBerkas() async {
    final response = await http.get(
      Uri.parse('https://suratdesajember.framework-tif.com/api/berkas'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      List<Map<String, dynamic>>? berkasList =
          responseData['berkas']?.cast<Map<String, dynamic>>();

      if (berkasList != null) {
        List<String> judulBerkas = [];
        List<String> idBerkas = [];
        List<String> formTambahan = [];
        for (var berkas in berkasList) {
          judulBerkas.add(berkas['judul_berkas']);
          idBerkas.add(berkas['id_berkas'].toString());
          formTambahan.add(berkas['form_tambahan']);
        }
        setState(() {
          _judulBerkas = judulBerkas;
          _idBerkas = idBerkas;
          _formTambahan = formTambahan;
          _searchResults = _judulBerkas!;
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showBerkasDetail(String judulBerkas, String idBerkas,
      String formTambahanText, String nik, String kecamatan, String desa) {
    List<String> formTambahanList = formTambahanText.split(',');
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailBerkasPage(
            nik: widget.Biodata,
            desa: _desa,
            kecamatan: _kecamatan,
            judul: judulBerkas,
            formTambahan: formTambahanList,
            idBerkas: idBerkas,
          ),
        ),
      );
    } catch (e) {
      print('Error decoding JSON: $e');
    }
  }

  void _searchBerkas(String query) {
    List<String> results = [];
    if (query.isNotEmpty) {
      for (String berkas in _judulBerkas ?? []) {
        if (berkas.toLowerCase().contains(query.toLowerCase())) {
          results.add(berkas);
        }
      }
    } else {
      results.addAll(_judulBerkas ?? []);
    }
    setState(() {
      _searchResults =
          results.isNotEmpty ? results : ['Tidak ada hasil yang ditemukan'];
    });
  }

  Widget _buildHelloCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      margin: EdgeInsets.only(
          top: 20, bottom: 20), // Menambahkan jarak di bagian atas dan bawah
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
            _name.toUpperCase(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF057438),
            ),
          ),
        ],
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF057438), Color(0xFF0B8043)],
            ),
          ),
          child: Column(
            children: <Widget>[
              if (_selectedIndex == 0) ...[
                Container(
                  padding: EdgeInsets.fromLTRB(40, 30, 40, 0),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Cari...',
                      hintStyle: TextStyle(color: Color(0xFF057438)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF057438)),
                    ),
                    onChanged: (String query) {
                      _searchBerkas(query);
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(width: 20),
                    IconButton(
                      icon: Icon(
                        Icons.help_outline,
                        size: 24.0,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProsedurLayananPage(),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProsedurLayananPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Petunjuk',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: [
                    _buildBiodataList(),
                    StatusPage(Biodata: widget.Biodata),
                    ProfilPage(
                      name: _name,
                      email: _email,
                      nik: _nik,
                      kecamatan: _kecamatan,
                      desa: _desa,
                      telepon: _telepon,
                      tgl_lahir: _tglLahir,
                      alamat: _alamat,
                      kota: _kota,
                      jekel: _jekel,
                      tempatlahir: _tempatlahir,
                      agama: _agama,
                      statusWarga: _statusWarga,
                      warganegara: _warganegara,
                      statusNikah: _statusNikah,
                      rt: _rt,
                      rw: _rw,
                    ),
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
            backgroundColor: Colors.white, // Mengatur warna latar belakang
            onTap: _onBottomNavigationBarItemTapped,
            showSelectedLabels: true, // Menampilkan label yang dipilih
            showUnselectedLabels: true, // Menampilkan label yang tidak dipilih
            type: BottomNavigationBarType.fixed, // Menyesuaikan jenis BottomNavigationBar
            elevation: 0, // Menghilangkan bayangan atau garis pembatas
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
              if (_searchResults.isEmpty ||
                  _searchResults.contains('Tidak ada hasil yang ditemukan')) {
                return _buildHelloCard();
              }
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
                        Icon(Icons.more_horiz, color: Colors.white),
                        Text('Lihat Semua Berkas',
                            style: TextStyle(color: Colors.white)),
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
                        Icon(Icons.more_horiz_rounded, color: Colors.white),
                        Text('Tampilkan Kurang',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                );
              } else if (_showAllFiles && index == _searchResults.length - 1) {
                return SizedBox(height: 60);
              }
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: _showAllFiles ? (_judulBerkas?.length ?? 0) : ((_searchResults?.length ?? 0) < 10 ? (_searchResults?.length ?? 0) : 10),
                                itemBuilder: (context, index) {
                                  if (!_showAllFiles && index >= 9 && _searchResults.length > 9) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _showAllFiles = true;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                Icons.window,
                                                color: Colors.white,
                                                size: 30,
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
                                  Color randomColor = _getRandomColor(index);
                                  String judulBerkas = _searchResults[index];
                                  String idBerkas = _idBerkas![index];
                                  String formTambahan = _formTambahan![index];
                                  return Container(
                                    width: 60,
                                    height: 100,
                                    child: Column(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            print('Berkas $judulBerkas dengan ID $idBerkas diklik! dengan form tambahan $formTambahan');
                                            _showBerkasDetail(judulBerkas, idBerkas, formTambahan, widget.Biodata, _kecamatan, _desa);
                                          },
                                          icon: Container(
                                            width: 43,
                                            height: 43,
                                            decoration: BoxDecoration(
                                              color: randomColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.email,
                                                color: Colors.white,
                                                size: 35,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            judulBerkas,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF057438),
                                            ),
                                          ),
                                        ),
                                      ],
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
        duration: Duration(milliseconds: 800),
        curve: Curves.decelerate,
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
  ];

  Color _getRandomColor(int index) {
    return _randomColors[index % _randomColors.length];
  }
}
