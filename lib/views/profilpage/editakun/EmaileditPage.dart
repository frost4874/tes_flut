import 'package:flutter/material.dart';

class EmailEditPage extends StatefulWidget {
  @override
  _EmailEditPageState createState() => _EmailEditPageState();
}

class _EmailEditPageState extends State<EmailEditPage> {
  TextEditingController _emailcontroller = TextEditingController();
  bool _isAnyFieldNotEmpty = false;

  @override
  void initState() {
    super.initState();
    _emailcontroller.addListener(_checkTextField);
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    super.dispose();
  }

  void _checkTextField() {
    setState(() {
      _isAnyFieldNotEmpty = _emailcontroller.text.isNotEmpty;
    });
  }

  void _saveAddress() {
    // Implementasi logika untuk menyimpan alamat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ubah Alamat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: Color(0xFF057438),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _isAnyFieldNotEmpty ? _saveAddress : null,
            child: Text(
              'Simpan',
              style: TextStyle(
                color: _isAnyFieldNotEmpty ? Colors.white : Colors.grey,
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
            elevation: 5.0,
            margin: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Color(0xFF057438),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 10, 20, 10),
                    child: TextFormField(
                      controller: _emailcontroller,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Masukkan Alamat',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: _emailcontroller.text.isEmpty
                            ? null
                            : GestureDetector(
                                onTap: () {
                                  _emailcontroller.clear();
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.white,
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
        ],
      ),
    );
  }
}
