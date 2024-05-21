import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AlamatEditPage extends StatefulWidget {
  final String? kecamatan;
  final String? desa;
  final String? rt;
  final String? rw;
  final String? alamat;

  AlamatEditPage({
    Key? key,
    required this.kecamatan,
    required this.desa,
    required this.rt,
    required this.rw,
    required this.alamat,
  }) : super(key: key);

  @override
  _AlamatEditPageState createState() => _AlamatEditPageState();
}

class _AlamatEditPageState extends State<AlamatEditPage> {
  TextEditingController _alamatcontroller = TextEditingController();
  TextEditingController _rtcontroller = TextEditingController();
  TextEditingController _rwcontroller = TextEditingController();
  bool _isAnyFieldNotEmpty = false;
  String? rt;
  String? rw;
  String? alamat;

  late Future<List<String>> kecamatanListFuture;
  String? selectedKecamatan;
  String? selectedKecamatanId;

  late Future<List<String>> desaListFuture;
  String? selectedDesa;

  @override
  void initState() {
    super.initState();
    _alamatcontroller.addListener(_checkTextField);
    _rtcontroller.addListener(_checkTextField);
    _rwcontroller.addListener(_checkTextField);

    alamat = widget.alamat;
    rt = widget.rt;
    rw = widget.rw;

    _alamatcontroller.text = widget.alamat ?? '';
    _rtcontroller.text = widget.rt ?? '';
    _rwcontroller.text = widget.rw ?? '';

    kecamatanListFuture = fetchKecamatanFromDatabase();
    kecamatanListFuture.then((kecamatanList) {
      setState(() {
        selectedKecamatan = widget.kecamatan;
      });
      if (selectedKecamatan != null) {
        fetchKecamatanId(selectedKecamatan!).then((kecamatanId) {
          setState(() {
            selectedKecamatanId = kecamatanId;
            desaListFuture = fetchDesaFromDatabase(selectedKecamatanId ?? '');
            selectedDesa = widget.desa;
          });
        }).catchError((error) {
          print('Error fetching kecamatan id: $error');
        });
      }
    }).catchError((error) {
      print('Error fetching kecamatan data: $error');
    });
  }

  @override
  void dispose() {
    _alamatcontroller.dispose();
    _rtcontroller.dispose();
    _rwcontroller.dispose();
    super.dispose();
  }

  void _checkTextField() {
    setState(() {
      _isAnyFieldNotEmpty = 
          _alamatcontroller.text != alamat && _alamatcontroller.text.isNotEmpty ||
          _rtcontroller.text != rt && _rtcontroller.text.isNotEmpty ||
          _rwcontroller.text != rw && _rwcontroller.text.isNotEmpty ||
          selectedKecamatan != widget.kecamatan ||
          selectedDesa != widget.desa;
    });
  }

  Future<List<String>> fetchKecamatanFromDatabase() async {
    final response = await http.get(Uri.parse('https://suratdesajember.framework-tif.com/api/kecamatan'));
    if (response.statusCode == 200) {
      List<String> kecamatanList = [];
      final data = json.decode(response.body);
      for (var kecamatan in data) {
        kecamatanList.add(kecamatan['nama']);
      }
      return kecamatanList;
    } else {
      throw Exception('Failed to load kecamatan data');
    }
  }

  void _fetchDesaByKecamatanId(String kecamatanId) async {
    try {
      final response = await http.get(Uri.parse('https://suratdesajember.framework-tif.com/api/desa/$kecamatanId'));
      if (response.statusCode == 200) {
        List<String> desaList = (json.decode(response.body) as List)
            .map((item) => item['nama'] as String)
            .toList();
        setState(() {
          selectedDesa = null;
          desaListFuture = Future.value(desaList);
        });
      } else {
        throw Exception('Failed to load desa data');
      }
    } catch (error) {
      print('Error fetching desa data: $error');
      setState(() {
        desaListFuture = Future.error('Failed to load desa data');
      });
    }
  }

  Future<List<String>> fetchDesaFromDatabase(String kecamatanId) async {
    final response = await http.get(Uri.parse('https://suratdesajember.framework-tif.com/api/desa/$kecamatanId'));
    if (response.statusCode == 200) {
      List<String> desaList = [];
      final data = json.decode(response.body);
      for (var desa in data) {
        desaList.add(desa['nama']);
      }
      return desaList;
    } else {
      throw Exception('Failed to load desa data');
    }
  }

  Future<String> fetchKecamatanId(String kecamatanName) async {
    final response = await http.get(Uri.parse('https://suratdesajember.framework-tif.com/api/kecamatan'));
    if (response.statusCode == 200) {
      final List<dynamic> kecamatans = json.decode(response.body);
      final kecamatan = kecamatans
          .firstWhere((kecamatan) => kecamatan['nama'] == kecamatanName);
      return kecamatan['id'].toString();
    } else {
      throw Exception('Failed to load kecamatan data');
    }
  }

  void _saveAddress() {
    Navigator.pop(context, {
      'kecamatan': selectedKecamatan,
      'desa': selectedDesa,
      'rt': _rtcontroller.text,
      'rw': _rwcontroller.text,
      'alamat': _alamatcontroller.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Ubah Alamat',
          style: TextStyle(
            color: Color(0xFF057438),
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF057438)),
        actions: [
          TextButton(
            onPressed: _isAnyFieldNotEmpty ? _saveAddress : null,
            child: Text(
              'Simpan',
              style: TextStyle(
                color: _isAnyFieldNotEmpty ? Color(0xFF057438) : Colors.grey.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(height: 10),
          Card(
            margin: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  // Dropdown Kecamatan
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: FutureBuilder<List<String>>(
                      future: kecamatanListFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return DropdownButtonFormField<String>(
                            value: selectedKecamatan,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedKecamatan = newValue!;
                                fetchKecamatanId(selectedKecamatan!).then((kecamatanId) {
                                  setState(() {
                                    selectedKecamatanId = kecamatanId;
                                    desaListFuture = fetchDesaFromDatabase(selectedKecamatanId!);
                                    selectedDesa = null;
                                  });
                                });
                              });
                            },
                            items: snapshot.data!.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Color(0xFF057438)),
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                              hintText: 'Pilih Kecamatan',
                              hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  // Dropdown Desa
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: FutureBuilder<List<String>>(
                      future: desaListFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return DropdownButtonFormField<String>(
                            value: selectedDesa,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDesa = newValue;
                              });
                            },
                            items: snapshot.data!.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Color(0xFF057438)),
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                              hintText: 'Pilih Desa',
                              hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
 
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: TextFormField(
                      controller: _rtcontroller,
                      style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Masukkan RT',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: _rtcontroller.text.isEmpty
                            ? GestureDetector(
                              onTap: () {
                                _rtcontroller.clear();
                              },
                              child: Icon(
                                Icons.clear,
                                color: Color(0xFF057438),
                                size: 20,
                              ),
                            )
                          : null,
                      ),
                    ),
                  ),
 
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: TextFormField(
                      controller: _rwcontroller,
                      style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Masukkan RW',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: _rwcontroller.text.isEmpty
                            ? GestureDetector(
                              onTap: () {
                                _rwcontroller.clear();
                              },
                              child: Icon(
                                Icons.clear,
                                color: Color(0xFF057438),
                                size: 20,
                              ),
                            )
                          : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      controller: _alamatcontroller,
                      style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Masukkan Alamat',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: _isAnyFieldNotEmpty
                            ? GestureDetector(
                              onTap: () {
                                _alamatcontroller.clear();
                              },
                              child: Icon(
                                Icons.clear,
                                color: Color(0xFF057438),
                                size: 20,
                              ),
                            )
                          : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
