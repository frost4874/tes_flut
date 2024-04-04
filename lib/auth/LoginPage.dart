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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(nik: _nikController.text),
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
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/jj.png',
              width: double.infinity,
              fit: BoxFit.cover,
              height: 350,
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME',
                      style: TextStyle(
                        color: Color(0xFF057438),
                        fontSize: 32, 
                        fontFamily: 'Interbold',
                      ),
                    ),
                    Text(
                      ' Masyarakat Desa Jember',
                      style: TextStyle(
                        color: Color(0xFF057438),
                        fontSize: 15,
                        fontFamily: 'Interbold',
                      ),
                    ),
                  ],
                ),
              ),
            ),
              
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: TextFormField(
                style: TextStyle(color: Color(0xFF057438),),
                keyboardType: TextInputType.name,
                controller: _nikController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  labelText: "NIK",
                  labelStyle: TextStyle(color: Color(0xFF057438),),
                  hintText: "Masukkan NIK Anda",
                  hintStyle: TextStyle(color: Color(0xFF057438),),
                  prefixIcon: Icon(Icons.email_rounded, color: Color(0xFF057438),),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
              child: TextFormField(
                style: TextStyle(color: Color(0xFF057438),),
                keyboardType: TextInputType.multiline,
                controller: _passwordController,
                obscureText: visibility,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: visibility
                        ? Icon(Icons.visibility, color: Color(0xFF057438),)
                        : Icon(Icons.visibility_off, color: Color(0xFF057438),),
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
                  labelStyle: TextStyle(color: Color(0xFF057438),),
                  hintText: "Masukkan Password",
                  hintStyle: TextStyle(color: Color(0xFF057438),),
                  prefixIcon: Icon(Icons.lock_rounded, color: Color(0xFF057438),),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Belum punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      'Daftar disini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Color(0xFF057438),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
              child: ElevatedButton(
                onPressed: () async {
                  await _login(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF057438)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 20.0, horizontal: 190.0),
                  ),
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
