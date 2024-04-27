// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tes_flut/views/profilpage/editakun/AlamateditPage.dart';
import 'package:tes_flut/views/profilpage/editakun/EmaileditPage.dart';
import 'package:tes_flut/views/profilpage/editakun/NameeditPage.dart';
import 'package:tes_flut/views/profilpage/editakun/NohpeditPage.dart';
import 'package:tes_flut/views/profilpage/editakun/PasswordeditPage.dart';


class EditakunPage extends StatefulWidget {
  EditakunPage({super.key}); 

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditakunPage> {
  String? _selectedpilihjenis;
  bool _isAnyFieldNotEmpty = false;
  Color _checkIconColor = Colors.grey[200]!;

  void _showGenderDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Pilih Jenis Kelamin',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF057438),
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                'Laki-laki',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF057438),
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedpilihjenis = 'Laki-laki';
                  _isAnyFieldNotEmpty = _selectedpilihjenis == 'Laki-laki';
                  _checkIconColor = _isAnyFieldNotEmpty ? Color(0xFF057438) : Colors.grey[200]!;
                  Navigator.of(context).pop();
                });
              },
            ),
            ListTile(
              title: Text(
                'Perempuan',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF057438),
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedpilihjenis = 'Perempuan';
                  _isAnyFieldNotEmpty = true;
                  _checkIconColor = Color(0xFF057438);
                  Navigator.of(context).pop();
                });
              },
            ),
            ListTile(
              title: Text(
                'Lainnya',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF057438),
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedpilihjenis = 'Lainnya';
                  _isAnyFieldNotEmpty = true;
                  _checkIconColor = Color(0xFF057438);
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        ),
      );
    },
  );
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Edit Akun',
          style: TextStyle(
            color: Color(0xFF057438),
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFF057438)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 50.0),
            child: IconButton(
              onPressed: _isAnyFieldNotEmpty ? () {} : null,
              icon: Icon(
                Icons.check,
                size: 25.0,
                color: _checkIconColor, 
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
                  SizedBox(height: 10,),
                  //name
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NameEditPage()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent.withOpacity(0); // Atur warna klikannya di sini
                          }
                          return Colors.transparent; // Kembali ke transparan jika tidak ditekan
                        },
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Nama Lengkap',
                          style: TextStyle(
                            color: Color(0xFF057438),
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'data nama',
                                style: TextStyle(
                                  color: Color(0xFF057438),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xFF057438),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //email
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EmailEditPage()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent.withOpacity(0); // Atur warna klikannya di sini
                          }
                          return Colors.transparent; // Kembali ke transparan jika tidak ditekan
                        },
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Email',
                          style: TextStyle(
                            color: Color(0xFF057438),
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'data email',
                                style: TextStyle(
                                  color: Color(0xFF057438),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xFF057438),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //jenis kelamin
                  TextButton(
                    onPressed: () {
                      _showGenderDialog(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent.withOpacity(0); // Atur warna klikannya di sini
                          }
                          return Colors.transparent; // Kembali ke transparan jika tidak ditekan
                        },
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Jenis Kelamin',
                          style: TextStyle(
                            color: Color(0xFF057438),
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                _selectedpilihjenis ?? '',
                                style: TextStyle(
                                  color: Color(0xFF057438),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xFF057438),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //tempat tanggal lahir
                  TextButton(
                    onPressed: () {
                      // Aksi yang ingin dilakukan ketika tombol ditekan
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent.withOpacity(0); 
                          }
                          return Colors.transparent; 
                        },
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Tempat Tanggal Lahir',
                          style: TextStyle(
                            color: Color(0xFF057438),
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'data kota, tanggal lahir',
                                style: TextStyle(
                                  color: Color(0xFF057438),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xFF057438),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //no hp
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NohpEditPage()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent.withOpacity(0); 
                          }
                          return Colors.transparent; 
                        },
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'No.Handphone',
                          style: TextStyle(
                            color: Color(0xFF057438),
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'data no hp',
                                style: TextStyle(
                                  color: Color(0xFF057438),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xFF057438),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //status diri
                  TextButton(
                    onPressed: () {
                      // Aksi yang ingin dilakukan ketika tombol ditekan
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent.withOpacity(0); 
                          }
                          return Colors.transparent; 
                        },
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Status Diri',
                          style: TextStyle(
                            color: Color(0xFF057438),
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(width: 10,),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xFF057438),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //alamat
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AlamatEditPage()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent.withOpacity(0); 
                          }
                          return Colors.transparent; 
                        },
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Alamat',
                          style: TextStyle(
                            color: Color(0xFF057438),
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'data desa',
                                style: TextStyle(
                                  color: Color(0xFF057438),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xFF057438),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //password
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PasswordEditPage()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent.withOpacity(0); 
                          }
                          return Colors.transparent; 
                        },
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Ganti Password',
                          style: TextStyle(
                            color: Color(0xFF057438),
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xFF057438),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}