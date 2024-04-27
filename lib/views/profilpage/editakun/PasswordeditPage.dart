import 'package:flutter/material.dart';

class PasswordEditPage extends StatefulWidget {
  @override
  _PasswordEditPageState createState() => _PasswordEditPageState();
}

class _PasswordEditPageState extends State<PasswordEditPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool _isAnyFieldNotEmpty = false;
  bool visibility = true;
  bool visibility1 = false;
  bool visibility2 = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_checkTextField);
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void _checkTextField() {
    setState(() {
      _isAnyFieldNotEmpty = passwordController.text.isNotEmpty;
      if (!_isAnyFieldNotEmpty) {
        visibility1 = false; 
      }
    });
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data berhasil disimpan'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Ubah Password',
          style: TextStyle(
            color: Color(0xFF057438),
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF057438)),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _save();
              }
            },
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
      body: Form(
        key: _formKey,
        child: ListView(
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
                      padding: EdgeInsets.fromLTRB(5, 0, 20, 0),
                      child: TextFormField(
                        controller: passwordController,
                        style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        maxLength: 50,
                        obscureText: !visibility,
                        onChanged: (value) {
                          setState(() {
                            visibility1 = value.isNotEmpty ? true : false;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Harap isi bidang ini';
                          } else if (!RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[0-9]).{8,}$')
                            .hasMatch(value)) {
                              return 'minimal satu huruf besar, satu angka, dan panjang minimal 8 karakter';
                            }
                            return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                          hintText: 'Masukkan Password',
                          hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                            
                          ),
                          errorStyle: TextStyle(color: Colors.red),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red),
                          ),
                          counterText: '',
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
                        ),
                      ),
                    ),
                    visibility1
                    ? Padding(
                      padding: EdgeInsets.fromLTRB(5, 10, 20, 10),
                      child: TextFormField(
                        controller: confirmpasswordController,
                        style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        maxLength: 50,
                        obscureText: !visibility2,
                        
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                          hintText: 'Konfirmasi Password',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        errorStyle: TextStyle(color: Colors.red),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red),
                        ),
                        counterText: '',
                        suffixIcon: IconButton(
                          icon: visibility2
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
                              visibility2 = !visibility2;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap isi bidang ini';
                        } else if (value != passwordController.text) {
                          return 'Password tidak cocok';
                        }
                        return null;
                      },
                    ),
                  )
                  : Container(),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Text(
              'Max. 50 Karakter',
              style: TextStyle(
                color: Color(0xFF057438).withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
