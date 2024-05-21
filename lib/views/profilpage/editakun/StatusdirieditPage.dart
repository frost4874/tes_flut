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
  String? agama;
  String? statusWarga;
  String? statusNikah;
  String? warganegara;
  Color _checkIconColor = Colors.grey[200]!;
  bool _isAnyFieldNotEmpty = false;

  @override
  void initState() {
    super.initState();

    //AGAMA
    if (widget.agama == 'Islam') {
      agama = 'Islam';
    } else if (widget.agama == 'Kristen') {
      agama = 'Kristen';
    } else if (widget.agama == 'Katolik') {
      agama = 'Katolik';
    } else if (widget.agama == 'Hindu') {
      agama = 'Hindu';
    } else if (widget.agama == 'Budha') {
      agama = 'Budha';
    }

    //WARGANEGARAAN
    if (widget.warganegara == 'WNI') {
      warganegara = 'WNI';
    } else if (widget.warganegara == 'WNA') {
      warganegara = 'WNA';
    }

    //STATUS PERNIKAHAN
    if (widget.statusNikah == 'Belum Kawin') {
      statusNikah = 'Belum Kawin';
    } else if (widget.statusNikah == 'Kawin') {
      statusNikah = 'Kawin';
    } else if (widget.statusNikah == 'Cerai Mati') {
      statusNikah = 'Cerai Mati';
    }


    //STATUS PEKERJAAN
    if (widget.statusWarga == 'Sekolah') {
      statusWarga = 'Sekolah';
    } else if (widget.statusWarga == 'Kerja') {
      statusWarga = 'Kerja';
    } else if (widget.statusWarga == 'Bekerja') {
      statusWarga = 'Bekerja';
    }


    _checkIconColor = _isAnyFieldNotEmpty ? Color(0xFF057438) : Colors.grey[200]!;
  }


  void _showAgamaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF057438),
          title: Text(
            'Pilih Agama Anda',
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
                  'Islam',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: agama == 'Islam' ? null : () {
                  setState(() {
                    agama = 'Islami';
                    _isAnyFieldNotEmpty = agama != widget.agama;
                    _checkIconColor = _isAnyFieldNotEmpty ? Color(0xFF057438)  : Colors.grey[200]!;
                    Navigator.of(context).pop();
                  });
                },
              ),
              ListTile(
                title: Text(
                  'Kristen',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: agama == 'Kristen' ? null : () {
                  setState(() {
                    agama = 'Kristen';
                    _isAnyFieldNotEmpty = agama != widget.agama;
                    _checkIconColor = _isAnyFieldNotEmpty ? Color(0xFF057438) : Colors.grey[200]!;
                    Navigator.of(context).pop();
                  });
                },
              ),
              ListTile(
                title: Text(
                  'Katolik',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: agama == 'Katolik' ? null : () {
                  setState(() {
                    agama = 'Katolik';
                    _isAnyFieldNotEmpty = agama != widget.agama;
                    _checkIconColor = _isAnyFieldNotEmpty ? Color(0xFF057438)  : Colors.grey[200]!;
                    Navigator.of(context).pop();
                  });
                },
              ),
              ListTile(
                title: Text(
                  'Hindu',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: agama == 'Hindu' ? null : () {
                  setState(() {
                    agama = 'Hindu';
                    _isAnyFieldNotEmpty = agama != widget.agama;
                    _checkIconColor = _isAnyFieldNotEmpty ? Color(0xFF057438)  : Colors.grey[200]!;
                    Navigator.of(context).pop();
                  });
                },
              ),
              ListTile(
                title: Text(
                  'Budha',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: agama == 'Budha' ? null : () {
                  setState(() {
                    agama = 'Budha';
                    _isAnyFieldNotEmpty = agama != widget.agama;
                    _checkIconColor = _isAnyFieldNotEmpty ? Color(0xFF057438)  : Colors.grey[200]!;
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


  void _showKewarganegaraanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF057438),
          title: Text(
            'Pilih Kewarganegaraan Anda',
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
                  'WNI',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: warganegara == 'WNI' ? null : () {
                  setState(() {
                    warganegara = 'WNI';
                    _isAnyFieldNotEmpty = warganegara != widget.warganegara;
                    _checkIconColor = _isAnyFieldNotEmpty ? Color(0xFF057438)  : Colors.grey[200]!;
                    Navigator.of(context).pop();
                  });
                },
              ),
              ListTile(
                title: Text(
                  'WNA',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: warganegara == 'WNA' ? null : () {
                  setState(() {
                    warganegara = 'WNA';
                    _isAnyFieldNotEmpty = warganegara != widget.warganegara;
                    _checkIconColor = _isAnyFieldNotEmpty ? Color(0xFF057438) : Colors.grey[200]!;
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


  void _showStatusPernikahanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF057438),
          title: Text(
            'Pilih Status Pernikahan Anda',
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
                  'Belum Kawin',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: statusNikah == 'Belum Kawin' ? null : () {
                  setState(() {
                    statusNikah = 'Belum Kawin';
                    _isAnyFieldNotEmpty = statusNikah != widget.statusNikah;
                    _checkIconColor = _isAnyFieldNotEmpty ? Color(0xFF057438)  : Colors.grey[200]!;
                    Navigator.of(context).pop();
                  });
                },
              ),
              ListTile(
                title: Text(
                  'Kawin',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: statusNikah == 'Kawin' ? null : () {
                  setState(() {
                    statusNikah = 'Kawin';
                    _isAnyFieldNotEmpty = statusNikah != widget.statusNikah;
                    _checkIconColor = _isAnyFieldNotEmpty ? Color(0xFF057438) : Colors.grey[200]!;
                    Navigator.of(context).pop();
                  });
                },
              ),
              ListTile(
                title: Text(
                  'Cerai Mati',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: statusNikah == 'Cerai Mati' ? null : () {
                  setState(() {
                    statusNikah = 'Cerai Mati';
                    _isAnyFieldNotEmpty = statusNikah != widget.statusNikah;
                    _checkIconColor = _isAnyFieldNotEmpty ? Color(0xFF057438) : Colors.grey[200]!;
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


  void _showStatusWargaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF057438),
          title: Text(
            'Pilih Status Warga Anda',
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
                  'Sekolah',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: statusWarga == 'Sekolah' ? null : () {
                  setState(() {
                    statusWarga = 'Sekolah';
                    _isAnyFieldNotEmpty = statusWarga != widget.statusWarga;
                    _checkIconColor = _isAnyFieldNotEmpty ? Color(0xFF057438)  : Colors.grey[200]!;
                    Navigator.of(context).pop();
                  });
                },
              ),
              ListTile(
                title: Text(
                  'Kerja',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: statusWarga == 'Kerja' ? null : () {
                  setState(() {
                    statusWarga = 'Kerja';
                    _isAnyFieldNotEmpty = statusWarga != widget.statusWarga;
                    _checkIconColor = _isAnyFieldNotEmpty ? Color(0xFF057438) : Colors.grey[200]!;
                    Navigator.of(context).pop();
                  });
                },
              ),
              ListTile(
                title: Text(
                  'Bekerja',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: statusWarga == 'Bekerja' ? null : () {
                  setState(() {
                    statusWarga = 'Bekerja';
                    _isAnyFieldNotEmpty = statusWarga != widget.statusWarga;
                    _checkIconColor = _isAnyFieldNotEmpty ? Color(0xFF057438) : Colors.grey[200]!;
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


  void _save() {
    
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Status Diri',
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

                  // agaama
                  TextButton(
                    onPressed: () {
                      _showAgamaDialog(context);
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
                          'Pilih Agama Anda',
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
                                agama ?? '',
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
                  SizedBox(height: 10,),

                  // kewarganegaraan
                  TextButton(
                    onPressed: () {
                      _showKewarganegaraanDialog(context);
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
                          'Pilih Warganegaraan Anda',
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
                                warganegara ?? '',
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
                  SizedBox(height: 10,),

                  // statusnikah
                  TextButton(
                    onPressed: () {
                      _showStatusPernikahanDialog(context);
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
                          'Pilih Status Pernikahan Anda',
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
                                statusNikah ?? '',
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
                  SizedBox(height: 10,),

                  // statuspekerjaan
                  TextButton(
                    onPressed: () {
                      _showStatusWargaDialog(context);
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
                          'Pilih Status Warga Anda',
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
                                statusWarga ?? '',
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
