import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailBerkasPage extends StatefulWidget {
  final String judul;
  final String nik;
  final String kecamatan;
  final String desa;
  final String idBerkas;
  final List<String> formTambahan;

  DetailBerkasPage({
    required this.judul,
    required this.formTambahan,
    required this.nik,
    required this.kecamatan,
    required this.desa,
    required this.idBerkas,
  });

  @override
  _DetailBerkasPageState createState() => _DetailBerkasPageState();
}

class _DetailBerkasPageState extends State<DetailBerkasPage> {
  final TextEditingController keteranganController = TextEditingController();
  List<TextEditingController> tambahanControllers = [];

  @override
  void initState() {
    super.initState();
    tambahanControllers = List.generate(
      widget.formTambahan.length,
      (_) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    keteranganController.dispose();
    tambahanControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void submitDataToServer(
    String idBerkas,
    String nik,
    String kecamatan,
    String desa,
    List<String> formTambahan,
  ) async {
    try {
      var url = Uri.parse('http://localhost:8000/api/send_request');
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      var response = await http.post(
        url,
        body: {
          'id_berkas': idBerkas,
          'nik': nik,
          'form_tambahan': formatFormTambahan(),
          'id_kec': kecamatan,
          'id_desa': desa,
          'status': '0',
          'tanggal_request': formattedDate,
          'keterangan': keteranganController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Data berhasil dikirim ke server');
        // Show Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data berhasil dikirim ke server'),
          ),
        );
      } else {
        print(
            'Gagal mengirim data ke server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  String formatFormTambahan() {
    String formattedData = '';
    for (int i = 0; i < tambahanControllers.length; i++) {
      String value = tambahanControllers[i].text;
      if (value.isNotEmpty) {
        formattedData += '${widget.formTambahan[i]}: $value, ';
      }
    }
    formattedData = formattedData.isNotEmpty
        ? formattedData.substring(0, formattedData.length - 2)
        : formattedData;

    return formattedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Color(0xFF057438),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_document,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pengajuan Surat',
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
                ],
              ),
            SizedBox(height: 20),
            Text(
              '${widget.judul}'.toString()
              .split(' ').map((String word) {
                return word[0].toUpperCase() + word.substring(1);
              }).join(' '),
              style: TextStyle(
                fontSize: 20, 
                fontFamily: "jomolhari",
                fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: keteranganController,
              decoration: InputDecoration(
                labelText: 'Keterangan',
                hintText:
                    'Isi data berikut sesuai dengan form tambahan yang diterima',
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.formTambahan.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      TextField(
                        controller: tambahanControllers[index],
                        decoration: InputDecoration(
                          labelText: '${widget.formTambahan[index]}',
                          hintText: 'Masukkan ${widget.formTambahan[index]}',
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  submitDataToServer(widget.idBerkas, widget.nik,
                      widget.kecamatan, widget.desa, widget.formTambahan);
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
