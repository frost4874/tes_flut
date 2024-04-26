import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NohpEditPage extends StatefulWidget {
  @override
  _NohpEditPageState createState() => _NohpEditPageState();
}

class _NohpEditPageState extends State<NohpEditPage> {
  TextEditingController _nohpcontroller = TextEditingController();
  bool _isAnyFieldNotEmpty = false;

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

  void _saveAddress() {
    // Implementasi logika untuk menyimpan alamat
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
            onPressed: _isAnyFieldNotEmpty ? _saveAddress : null,
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
                    padding: EdgeInsets.fromLTRB(5, 0, 20, 0),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                      controller: _nohpcontroller,
                      style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                      maxLength: 15,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Masukkan No Handphone',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
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
              'Max. 15 Karakter',
              style: TextStyle(
                color: Color(0xFF057438).withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
