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
      Uri.parse('http://localhost:8000/api/login_flutter'),
      body: {
        'nik': _nikController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['success']) {
        print('login berhasil');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(Biodata: _nikController.text),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text(responseData['message']),
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
      // Jika gagal login, tampilkan pesan kesalahan
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Login Gagal',
              style: TextStyle(
                color: Color(0xFF057438),
                fontFamily: 'Interbold',
              ),
            ),
            content: Text(
              'NIK atau Password Salah',
              style: TextStyle(
                color: Color(0xFF057438),
                fontFamily: 'Interbold',
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
                    color: Color(0xFF057438),
                    fontFamily: 'Interbold',
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
                    width: 600,
                    height: 300,
                    child: Image.asset(
                      'images/jj.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 600,
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
                      fontFamily: 'Interbold',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
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
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
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
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(45, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Sudah punya akun? ",
                    style: TextStyle(
                      
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                    },
                    child: Text(
                      'Login disini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF057438),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
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
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 190.0),
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
