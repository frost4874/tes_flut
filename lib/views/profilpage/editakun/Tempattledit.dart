import 'package:flutter/material.dart';

class TtlEditPage extends StatefulWidget {
  final String tempatLahir;
  final String tanggalLahir;

  TtlEditPage({required this.tempatLahir, required this.tanggalLahir});

  @override
  _TtlEditPageState createState() => _TtlEditPageState();
}

class _TtlEditPageState extends State<TtlEditPage> {
  TextEditingController _tempatController = TextEditingController();
  TextEditingController _tanggalController = TextEditingController();
  bool _isAnyFieldNotEmpty = false;
  DateTime? selectedDate;
  String? tempatLahir;

  @override
  void initState() {
    super.initState();
    _tempatController.text = widget.tempatLahir;
    _tanggalController.text = widget.tanggalLahir;
    _tempatController.addListener(_checkTextField);
    _tanggalController.addListener(_checkTextField);
  }

  @override
  void dispose() {
    _tempatController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  void _checkTextField() {
    setState(() {
      _isAnyFieldNotEmpty = _tempatController.text.isNotEmpty || selectedDate != null;
      tempatLahir = _tempatController.text;
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: Color(0xFF057438),
              onPrimary: Colors.white,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        _checkTextField();
      });
    }
  }

  void _save() {
    String? tempatLahir = _tempatController.text;
    String? formattedDate = selectedDate != null
        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
        : null;

    Navigator.pop(context, {'tempatLahir': tempatLahir, 'tanggalLahir': formattedDate});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Ubah Tempat Tanggal Lahir',
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
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: TextFormField(
                      controller: _tempatController,
                      style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                      maxLength: 100,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Masukkan Tempat Lahir Anda',
                        hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        counterText: '',
                        suffixIcon: _tempatController.text.isEmpty
                            ? null
                            : GestureDetector(
                          onTap: () {
                            _tempatController.clear();
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _tanggalController,
                              style: TextStyle(color: Color(0xFF057438), fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                hintText: selectedDate != null
                                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                    : 'Pilih Tanggal Lahir Anda',
                                hintStyle: TextStyle(color: Color(0xFF057438), fontSize: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            onPressed: () => _selectDate(context),
                            icon: Icon(
                              Icons.calendar_today,
                              color: Color(0xFF057438),
                            ),
                          ),
                        ),
                      ],
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
