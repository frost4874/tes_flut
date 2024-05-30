import 'package:flutter/material.dart';
import 'package:tes_flut/auth/LoginPage.dart';
import 'package:tes_flut/views/profilpage/EditakunPage.dart';
import 'package:tes_flut/views/profilpage/EditbiodataPage.dart';
import 'package:tes_flut/views/profilpage/RiwayatPage.dart';

class ProfilPage extends StatefulWidget {
  final String name;
  final String email;
  final String nik;
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

  ProfilPage({
    required this.name,
    required this.email,
    required this.nik,
    required this.kecamatan,
    required this.desa,
    required this.kota,
    required this.alamat,
    required this.telepon,
    required this.tgl_lahir,
    required this.jekel,
    required this.tempatlahir,
    required this.agama,
    required this.statusWarga,
    required this.warganegara,
    required this.statusNikah,
    required this.rt,
    required this.rw,
  });

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Mengatur nilai awal controller dengan nama dari login
    _nameController.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset(
                    'assets/images/jj1.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Color(0xFF057438).withOpacity(0.9),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 100, 40, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 70,
                        height: 65,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 50,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.email,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20), // Atur padding sesuai kebutuhan Anda
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF057438), width: 2.0),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Warna shadow
                      spreadRadius: 2, // Seberapa jauh shadow tersebar
                      blurRadius: 5, // Seberapa blur shadow
                      offset: Offset(0, 3), // Perubahan posisi shadow
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Widget Edit
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.edit_document,
                          color: Color(0xFF057438),
                        ),
                        title: Text(
                          'Edit Biodata',
                          style: TextStyle(
                            color: Color(0xFF057438),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditbiodataPage(
                                      nik: widget.nik,
                                      name: widget.name,
                                      email: widget.email,
                                      kecamatan: widget.kecamatan,
                                      desa: widget.desa,
                                      kota: widget.kota,
                                      alamat: widget.alamat,
                                      tgl_lahir: widget.tgl_lahir,
                                      telepon: widget.telepon,
                                      jekel: widget.jekel,
                                      tempatlahir: widget.tempatlahir,
                                      agama: widget.agama,
                                      statusWarga: widget.statusWarga,
                                      warganegara: widget.warganegara,
                                      statusNikah: widget.statusNikah,
                                      rt: widget.rt,
                                      rw: widget.rw,
                                    )),
                          );
                        },
                      ),
                    ),
                    Divider(
                      // Garis pembatas di sini
                      color: Color(0xFF057438),
                      height: 0,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.history_rounded,
                          color: Color(0xFF057438),
                        ),
                        title: Text(
                          'Riwayat',
                          style: TextStyle(
                            color: Color(0xFF057438),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RiwayatPage(nik: widget.nik)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "Konfirmasi Logout",
                            style: TextStyle(
                              color: Color(0xFF057438),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text(
                            "Apakah Anda yakin ingin logout?",
                            style: TextStyle(
                              color: Color(0xFF057438),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Tutup dialog
                              },
                              child: Text(
                                "Batal",
                                style: TextStyle(
                                  color: Color(0xFF057438),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Tambahkan logika logout di sini
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFF057438), width: 3.0),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    color: Colors.red,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 100),
                                    child: Text(
                                      'LOGOUT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      softWrap: false,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2.0),
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        color: Colors.red,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 80),
                        child: Text(
                          'LOGOUT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
