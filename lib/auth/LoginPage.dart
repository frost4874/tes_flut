import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tes_flut/auth/DashboardPage.dart';
import 'package:tes_flut/auth/RegisterPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool visibility = true;

  Future<void> _login(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.5:8000/api/login_flutter'),
      body: {
        'nik': _nikController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 'Aktif') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(Biodata: _nikController.text),
          ),
        );
        print('login berhasil');
        // Check if the user status is active
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Akun Belum Aktif'),
              content: Text('Mohon maaf, akun anda dalam proses validasi.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF057438),
            title: Text(
              'Login Gagal',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'NIK atau Password Salah',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: Image.asset(
                      'assets/images/jj1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 300,
                    color: Color(0xFF057438).withOpacity(0.5),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Welcome',
                    style: TextStyle(
                      color: Color(0xFF057438),
                      fontSize: 30,
                      fontFamily: 'Interbold',
                    ),
                  ),
                  Text(
                    'Masyarakat Desa Jember',
                    style: TextStyle(
                      color: Color(0xFF057438),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    style: TextStyle(color: Color(0xFF057438)),
                    keyboardType: TextInputType.name,
                    controller: _nikController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelText: "NIK",
                      labelStyle: TextStyle(color: Color(0xFF057438)),
                      hintText: "Masukkan NIK Anda",
                      hintStyle: TextStyle(color: Color(0xFF057438)),
                      prefixIcon: Icon(
                        Icons.email_rounded,
                        color: Color(0xFF057438),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    style: TextStyle(color: Color(0xFF057438)),
                    keyboardType: TextInputType.multiline,
                    controller: _passwordController,
                    obscureText: visibility,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: visibility
                            ? Icon(
                                Icons.visibility,
                                color: Color(0xFF057438),
                              )
                            : Icon(
                                Icons.visibility_off,
                                color: Color(0xFF057438),
                              ),
                        onPressed: () {
                          setState(() {
                            visibility = !visibility;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(color: Color(0xFF057438)),
                      hintText: "Masukkan Password",
                      hintStyle: TextStyle(color: Color(0xFF057438)),
                      prefixIcon: Icon(
                        Icons.lock_rounded,
                        color: Color(0xFF057438),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Belum punya akun? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        child: Text(
                          'Daftar disini',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF057438),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _login(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF057438),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.30),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height * 0.6,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
