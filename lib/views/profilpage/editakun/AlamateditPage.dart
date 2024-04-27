import 'package:flutter/material.dart';

class AlamatEditPage extends StatefulWidget {
  @override
  _AlamatEditPageState createState() => _AlamatEditPageState();
}

class _AlamatEditPageState extends State<AlamatEditPage> {
  TextEditingController _alamatcontroller = TextEditingController();
  TextEditingController _rtcontroller = TextEditingController();
  TextEditingController _rwcontroller = TextEditingController();
  String? _selectedKecamatan;
  String? _selectedDesa;
  bool _isAnyFieldNotEmpty = false;

  @override
  void initState() {
    super.initState();
    _alamatcontroller.addListener(_checkTextField);
    _rtcontroller.addListener(_checkTextField);
    _rwcontroller.addListener(_checkTextField);
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
      _isAnyFieldNotEmpty = _alamatcontroller.text.isNotEmpty ||
          _rtcontroller.text.isNotEmpty ||
          _rwcontroller.text.isNotEmpty ||
          _selectedKecamatan != null ||
          _selectedDesa != null;
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
                    padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: DropdownButtonFormField<String>(
                      value: _selectedKecamatan,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Pilih Kecamatan',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF057438),
                          size: 20,
                        ),
                      ),
                      items: <String>['Kecamatan A', 'Kecamatan B', 'Kecamatan C']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedKecamatan = newValue;
                          _checkTextField();
                        });
                      },
                    ),
                  ),

                  // Dropdown Desa
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: DropdownButtonFormField<String>(
                      value: _selectedDesa,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Pilih Desa',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF057438),
                          size: 20,
                        ),
                      ),
                      items: <String>['Desa X', 'Desa Y', 'Desa Z']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDesa = newValue;
                          _checkTextField(); // Memanggil _checkTextField saat ada perubahan pada Dropdown Desa
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: TextFormField(
                      controller: _rtcontroller,
                      style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Masukkan RT',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: _rtcontroller.text.isEmpty
                            ? null
                            : GestureDetector(
                                onTap: () {
                                  _rtcontroller.clear();
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: Color(0xFF057438),
                                  size: 20,
                                ),
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: TextFormField(
                      controller: _rwcontroller,
                      style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Masukkan RW',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: _rwcontroller.text.isEmpty
                            ? null
                            : GestureDetector(
                                onTap: () {
                                  _rwcontroller.clear();
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: Color(0xFF057438),
                                  size: 20,
                                ),
                              ),
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 10),
                    child: TextFormField(
                      controller: _alamatcontroller,
                      style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Masukkan Alamat',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: _alamatcontroller.text.isEmpty
                            ? null
                            : GestureDetector(
                                onTap: () {
                                  _alamatcontroller.clear();
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: Color(0xFF057438),
                                  size: 20,
                                ),
                              ),
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

  void _saveAddress() {
    // Implementasi logika untuk menyimpan alamat
  }
}
