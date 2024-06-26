import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tes_flut/views/profilpage/editakun/AlamateditPage.dart';
import 'package:tes_flut/views/profilpage/editakun/EmaileditPage.dart';
import 'package:tes_flut/views/profilpage/editakun/NameeditPage.dart';
import 'package:tes_flut/views/profilpage/editakun/NohpeditPage.dart';
import 'package:tes_flut/views/profilpage/editakun/PasswordeditPage.dart';
import 'package:tes_flut/views/profilpage/editakun/StatusdirieditPage.dart';
import 'package:tes_flut/views/profilpage/editakun/Tempattledit.dart';

class EditakunPage extends StatefulWidget {
  final String nik;
  final String name;
  final String email;
  final String kecamatan;
  final String desa;
  final String kota;
  final String alamat;
  final String tgl_lahir;
  final String telepon;
  final String jekel;
  final String tempatlahir;
  final String agama;
  final String statusWarga;
  final String warganegara;
  final String statusNikah;
  final String rt;
  final String rw;

  EditakunPage({
    Key? key,
    required this.nik,
    required this.name,
    required this.email,
    required this.kecamatan,
    required this.desa,
    required this.kota,
    required this.alamat,
    required this.tgl_lahir,
    required this.telepon,
    required this.jekel,
    required this.tempatlahir,
    required this.agama,
    required this.statusWarga,
    required this.warganegara,
    required this.statusNikah,
    required this.rt,
    required this.rw,
  }) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditakunPage> {
  bool _isAnyFieldNotEmpty = false;
  Color _checkIconColor = Colors.grey[200]!;
  String? name;
  String? email;
  String? telepon;
  String? kota = '';
  String? tempatlahir = '';
  String? tgl_lahir = '';
  String formattedNohp = '';
  String? displayedNohp = '';
  String? desa = '';
  String? _tempatLahirSementara;
  String? _tanggalLahirSementara;
  String? _selectedpilihjenis;

  @override
  void initState() {
    super.initState();
    email = widget.email;
    name = widget.name;
    telepon = widget.telepon;
    tgl_lahir = widget.tgl_lahir;
    kota = widget.kota;
    tempatlahir = widget.tempatlahir;
    formattedNohp = formatPhoneNumber(telepon) ?? '';
    displayedNohp = formattedNohp.isNotEmpty ? formattedNohp : telepon;

    if (widget.jekel == 'Laki-Laki') {
      _selectedpilihjenis = 'Laki-Laki';
    } else if (widget.jekel == 'Perempuan') {
      _selectedpilihjenis = 'Perempuan';
    } else if (widget.jekel == 'Lainnya') {
      _selectedpilihjenis = 'Lainnya';
    }

    _checkIconColor =
        _isAnyFieldNotEmpty ? Color(0xFF057438) : Colors.grey[200]!;
  }

  void _navigateToNameEditPage() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NameEditPage(name: widget.name)),
    );
    if (result != null) {
      setState(() {
        name = result;
      });
    }
  }

  void _navigateToTtlEditPage() async {
    // Simpan nilai tempat lahir dan tanggal lahir saat ini ke variabel sementara
    _tempatLahirSementara = widget.tempatlahir;
    _tanggalLahirSementara = widget.tgl_lahir;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              TtlEditPage(tempatlahir: tempatlahir!, tgl_lahir: tgl_lahir!)),
    );

    if (result != null) {
      setState(() {
        // Perbarui nilai tempat lahir dan tanggal lahir dengan nilai yang disimpan
        _tempatLahirSementara = result['tempatLahir'];
        _tanggalLahirSementara = result['tanggalLahir'] != null
            ? result['tanggalLahir']!.toString()
            : '';
      });
    } else {
      setState(() {
        tempatlahir = _tempatLahirSementara;
        tgl_lahir = _tanggalLahirSementara;
      });
    }
  }

  void _navigateToEmailEditPage() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EmailEditPage(
                email: widget.email,
              )),
    );
    if (result != null) {
      setState(() {
        email = result;
      });
    }
  }

  void _navigateToAlamatEditPage() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AlamatEditPage(
                nik: widget.nik,
                kecamatan: widget.kecamatan,
                desa: widget.desa,
                alamat: widget.alamat,
                rt: widget.rt,
                rw: widget.rw,
              )),
    );
    if (result != null) {
      setState(() {
        desa = result;
      });
    }
  }

  void _navigateToNohpEditPage() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NohpEditPage(telepon: widget.telepon)),
    );
    if (result != null) {
      setState(() {
        telepon = result;
        formattedNohp = formatPhoneNumber(telepon) ?? '';
        displayedNohp = formattedNohp.isNotEmpty ? formattedNohp : telepon;
      });
    }
    @override
    void initState() {
      super.initState();
      displayedNohp = formattedNohp.isEmpty ? telepon : formattedNohp;
    }
  }

  String? formatPhoneNumber(String? telepon) {
    if (telepon == null || telepon.length < 3) {
      return telepon;
    }

    String firstChar = telepon.substring(0, 3);
    String lastChar = telepon.substring(telepon.length - 1);
    String middlePart = telepon.substring(1, telepon.length - 1);

    String maskedMiddlePart = middlePart.replaceAll(RegExp(r'\d'), '*');

    return '$firstChar$maskedMiddlePart$lastChar';
  }

  void _showGenderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF057438),
          title: Text(
            'Pilih Jenis Kelamin',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  'Laki-Laki',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: _selectedpilihjenis == 'Laki-Laki'
                    ? null
                    : () {
                        setState(() {
                          _selectedpilihjenis = 'Laki-Laki';
                          _isAnyFieldNotEmpty =
                              _selectedpilihjenis != widget.jekel;
                          _checkIconColor = _isAnyFieldNotEmpty
                              ? Color(0xFF057438)
                              : Colors.grey[200]!;
                          Navigator.of(context).pop();
                        });
                      },
              ),
              ListTile(
                title: Text(
                  'Perempuan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: _selectedpilihjenis == 'Perempuan'
                    ? null
                    : () {
                        setState(() {
                          _selectedpilihjenis = 'Perempuan';
                          _isAnyFieldNotEmpty =
                              _selectedpilihjenis != widget.jekel;
                          _checkIconColor = _isAnyFieldNotEmpty
                              ? Color(0xFF057438)
                              : Colors.grey[200]!;
                          Navigator.of(context).pop();
                        });
                      },
              ),
              ListTile(
                title: Text(
                  'Lainnya',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: _selectedpilihjenis == 'Lainnya'
                    ? null
                    : () {
                        setState(() {
                          _selectedpilihjenis = 'Lainnya';
                          _isAnyFieldNotEmpty =
                              _selectedpilihjenis != widget.jekel;
                          _checkIconColor = _isAnyFieldNotEmpty
                              ? Color(0xFF057438)
                              : Colors.grey[200]!;
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

  String? formatEmail(String? email) {
    if (email == null || email.isEmpty) {
      return email;
    }

    List<String> parts = email.split("@");
    if (parts.length != 2) {
      return email;
    }

    String username = parts[0];
    String domain = parts[1];

    if (username.length < 2) {
      return email;
    }

    String firstChar = username.substring(0, 1);
    String lastChar = username.substring(username.length - 1);

    String middlePart = "*" * (username.length - 2);

    return '$firstChar$middlePart$lastChar@$domain';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Edit Akun',
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
          SizedBox(
            height: 10,
          ),
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
                  SizedBox(
                    height: 10,
                  ),

                  //name
                  TextButton(
                    onPressed: () {
                      _navigateToNameEditPage();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
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
                                name ?? widget.name, //manggil name
                                style: TextStyle(
                                  color: Color(0xFF057438),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
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
                      _navigateToEmailEditPage();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent
                                .withOpacity(0); // Atur warna klikannya di sini
                          }
                          return Colors
                              .transparent; // Kembali ke transparan jika tidak ditekan
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
                                formatEmail(email) ??
                                    formatEmail(widget.email)!,
                                style: TextStyle(
                                  color: Color(0xFF057438),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
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
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent
                                .withOpacity(0); // Atur warna klikannya di sini
                          }
                          return Colors
                              .transparent; // Kembali ke transparan jika tidak ditekan
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
                              SizedBox(
                                width: 10,
                              ),
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
                      _navigateToTtlEditPage();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
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
                                '$tempatlahir, $tgl_lahir',
                                style: TextStyle(
                                  color: Color(0xFF057438),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
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
                      _navigateToNohpEditPage();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
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
                                formatPhoneNumber(telepon) ??
                                    formatPhoneNumber(widget.telepon)!,
                                style: TextStyle(
                                  color: Color(0xFF057438),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DatadiriEditPage(
                                  agama: widget.agama,
                                  statusWarga: widget.statusWarga,
                                  warganegara: widget.warganegara,
                                  statusNikah: widget.statusNikah,
                                )),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
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
                              SizedBox(
                                width: 10,
                              ),
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
                      _navigateToAlamatEditPage();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
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
                                desa ?? '',
                                style: TextStyle(
                                  color: Color(0xFF057438),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
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
                        MaterialPageRoute(
                            builder: (context) => PasswordEditPage()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
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
                  SizedBox(
                    height: 10,
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
