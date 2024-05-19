import 'package:flutter/material.dart';

class NameEditPage extends StatefulWidget {
  final String? name;

  NameEditPage({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  _NameEditPageState createState() => _NameEditPageState();
}

class _NameEditPageState extends State<NameEditPage> {
  TextEditingController _namecontroller = TextEditingController();
  bool _isAnyFieldNotEmpty = false;
  String? _initialName;

  @override
  void initState() {
    super.initState();
    _initialName = widget.name;
    _namecontroller = TextEditingController(text: widget.name);
    _namecontroller.addListener(_checkTextField);
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    super.dispose();
  }

  void _checkTextField() {
    setState(() {
      _isAnyFieldNotEmpty = _namecontroller.text != _initialName && _namecontroller.text.isNotEmpty;
    });
  }

  void _save() {
    Navigator.pop(context, _namecontroller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Ubah Nama Lengkap',
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
                    padding: EdgeInsets.fromLTRB(5, 0, 20, 0),
                    child: TextFormField(
                      controller: _namecontroller,
                      style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                      maxLength: 100,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Masukkan Nama Lengkap',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        counterText: '',
                        suffixIcon: _isAnyFieldNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _namecontroller.clear();
                              },
                              child: Icon(
                                Icons.clear,
                                color: Color(0xFF057438),
                                size: 20,
                              ),
                            )
                          : null,
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
              'Max. 100 Karakter',
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
