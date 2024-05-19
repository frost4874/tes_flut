import 'package:flutter/material.dart';

class EmailEditPage extends StatefulWidget {
  final String? email;

  EmailEditPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _EmailEditPageState createState() => _EmailEditPageState();
}

class _EmailEditPageState extends State<EmailEditPage> {
  TextEditingController _emailcontroller = TextEditingController();
  bool _isAnyFieldNotEmpty = false;
  final _formKey = GlobalKey<FormState>();
  String? _initialEmail;

  @override
  void initState() {
    super.initState();
    _initialEmail = widget.email;
    _emailcontroller = TextEditingController(text: widget.email);
    _emailcontroller.addListener(_checkTextField);
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    super.dispose();
  }

  void _checkTextField() {
    setState(() {
      _isAnyFieldNotEmpty = _emailcontroller.text != _initialEmail && _emailcontroller.text.isNotEmpty;
    });
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _emailcontroller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Ubah Email',
          style: TextStyle(
            color: Color(0xFF057438),
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF057438)),
        actions: [
          TextButton(
            onPressed: _isAnyFieldNotEmpty
                ? () {
                    if (_formKey.currentState!.validate()) {
                      _save();
                    }
                  }
                : null,
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
                        controller: _emailcontroller,
                        style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        maxLength: 50,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Harap isi bidang ini';
                          } else if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Masukkan email dengan format yang valid';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                          hintText: 'Masukkan Email',
                          hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          errorStyle: TextStyle(color: Colors.red),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          counterText: '',
                          suffixIcon: _isAnyFieldNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _emailcontroller.clear();
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
