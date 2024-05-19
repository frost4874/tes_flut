import 'package:flutter/material.dart';

class DatadiriEditPage extends StatefulWidget {
  final String? agama;
  final String? statusWarga;
  final String? warganegara;
  final String? statusNikah;

    DatadiriEditPage({
    Key? key,
    required this.agama,
    required this.statusWarga,
    required this.warganegara,
    required this.statusNikah,
  }) : super(key: key);


  @override
  _DatadiriEditPageState createState() => _DatadiriEditPageState();
}

class _DatadiriEditPageState extends State<DatadiriEditPage> {
  TextEditingController _Pekerjaancontroller = TextEditingController();
  TextEditingController _statuscontroller = TextEditingController();
  String? _selectedAgama;
  String? _selectedWarganegara;
  String? _selectedPernikahan;
  String? _selectedStatusWarga;
  bool _isAnyFieldNotEmpty = false;

  @override
  void initState() {
    super.initState();
    _Pekerjaancontroller.addListener(_checkTextField);
    _statuscontroller.addListener(_checkTextField);
  }

  @override
  void dispose() {
    _Pekerjaancontroller.dispose();
    _statuscontroller.dispose();
    super.dispose();
  }

  void _checkTextField() {
    setState(() {
       _isAnyFieldNotEmpty = _Pekerjaancontroller.text.isNotEmpty ||
      _statuscontroller.text.isNotEmpty ||
      _selectedAgama != null ||
      _selectedPernikahan != null ||
      _selectedStatusWarga != null ||
      _selectedWarganegara != null;
    });
  }

  void _save() {
    
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Ubah Nama Lengkap',
          style: TextStyle(
            color: Color(0xFF057438),
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF057438)),
        actions: [
          TextButton(
            onPressed: _isAnyFieldNotEmpty ? _save : null,
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
          SizedBox(height: 10,),
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

                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: TextFormField(
                      controller: _Pekerjaancontroller,
                      style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                      maxLength: 100,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Masukkan Pekerjaan Anda',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        counterText: '',
                        suffixIcon: _Pekerjaancontroller.text.isEmpty
                        ? null
                        : GestureDetector(
                          onTap: () {
                            _Pekerjaancontroller.clear();
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

                  // Dropdown agama
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: DropdownButtonFormField<String>(
                      icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF057438)),
                      value: _selectedAgama,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Pilih Agama Anda',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: <String>['Islam', 'Kristen', 'Katolik', 'Hindu', 'Budha']
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
                          _selectedAgama = newValue;
                          _checkTextField();
                        });
                      },
                    ),
                  ),

                  // Dropdown warganegara
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: DropdownButtonFormField<String>(
                      icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF057438)),
                      value: _selectedWarganegara,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Pilih Warganegara Anda',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: <String>['WNI', 'WNA']
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
                          _selectedWarganegara = newValue;
                          _checkTextField();
                        });
                      },
                    ),
                  ),


                  // Dropdown pernikahan
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: DropdownButtonFormField<String>(
                      icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF057438)),
                      value: _selectedPernikahan,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Pilih Status Pernikahan Anda',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: <String>['Belum Kawin', 'Kawin', 'Cerai Mati']
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
                          _selectedPernikahan = newValue;
                          _checkTextField();
                        });
                      },
                    ),
                  ),


                  // Dropdown warga
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: DropdownButtonFormField<String>(
                      icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF057438)),
                      value: _selectedStatusWarga,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Pilih Status Pekerjaan Anda',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: <String>['Pelajar', 'Mahasiswa', 'Bekerja', 'Belum Bekerja']
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
                          _selectedStatusWarga = newValue;
                          _checkTextField();
                        });
                      },
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
