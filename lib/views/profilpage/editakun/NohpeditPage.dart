import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NohpEditPage extends StatefulWidget {
  final String? telepon;

  NohpEditPage({
    Key? key,
    required this.telepon,
  }) : super(key: key);

  @override
  _NohpEditPageState createState() => _NohpEditPageState();
}

class _NohpEditPageState extends State<NohpEditPage> {
  TextEditingController _nohpcontroller = TextEditingController();
  bool _isAnyFieldNotEmpty = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nohpcontroller.addListener(_checkTextField);
  }

  @override
  void dispose() {
    _nohpcontroller.dispose();
    super.dispose();
  }

  void _checkTextField() {
    setState(() {
      _isAnyFieldNotEmpty = _nohpcontroller.text.isNotEmpty;
    });
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _nohpcontroller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Ubah No Handphone',
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
      body: Form(
        key: _formKey,
        child: ListView(
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
                      padding: EdgeInsets.fromLTRB(5, 0, 20, 5),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: _nohpcontroller,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        maxLength: 20,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Harap isi bidang ini';
                          } else if (!RegExp(r'^[0-9]{10,}$').hasMatch(value)) {
                            return 'Nomor handphone harus terdiri dari minimal 10 digit';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                          hintText: 'Masukkan No Handphone',
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
                          suffixIcon: _nohpcontroller.text.isEmpty
                          ? null
                          : GestureDetector(
                            onTap: () {
                              _nohpcontroller.clear();
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
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Text(
                'Max. 20 Karakter',
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
