import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatusPage extends StatefulWidget {
  final String Biodata;

  StatusPage({required this.Biodata});

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<Map<String, dynamic>> dataRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url =
        Uri.parse('http://localhost:8000/api/data-requests/${widget.Biodata}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          dataRequests =
              json.decode(response.body).cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }

    // Tambahkan pengecekan di sini
    if (dataRequests.isEmpty) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateData(String content, String keterangan, String idRequest) async {
    // Send HTTP PUT request
    try {
      var url = Uri.parse('http://localhost:8000/api/update-data/$idRequest');
      var response = await http.put(
        url,
        body: json.encode({
          'form_tambahan': content,
          'keterangan': keterangan, // Menyertakan keterangan dalam request
        }),
        headers: {'Content-Type': 'application/json'},
      );

      // Check response status
      if (response.statusCode == 200) {
        // Data updated successfully, perform any necessary actions
        fetchData();
      } else {
        throw Exception('Failed to update data');
      }
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  void showEditContent(String content, String idRequest, String keterangan) {
    List<String> formData = content.split(',');
    List<TextEditingController> controllers = [];
    List<String> formTitles = [];
    for (var item in formData) {
      var parts = item.split(':');
      formTitles.add(parts[0]);
      controllers.add(TextEditingController(text: parts[1]));
    }

    TextEditingController keteranganController = TextEditingController(
        text: keterangan); // Menggunakan nilai keterangan dari database

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(0xFF057438),
              title: Text('Edit Form Tambahan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < formData.length; i++)
                      TextField(
                        controller: controllers[i],
                        decoration: InputDecoration(labelText: formTitles[i],
                          labelStyle: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow), // Warna garis kuning
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow), // Warna garis kuning saat fokus
                          ),
                        ),
                        style: TextStyle(color: Colors.white,),
                      ),
                    TextField(
                      controller: keteranganController,
                      decoration: InputDecoration(
                        labelText: 'Keterangan',
                        labelStyle: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow), // Warna garis kuning
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow), // Warna garis kuning saat fokus
                        ),
                      ),
                      style: TextStyle(color: Colors.white,),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Tutup',
                    style: TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold,),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String updatedContent = '';
                    for (int i = 0; i < formData.length; i++) {
                      updatedContent +=
                          '${formTitles[i]}:${controllers[i].text}';
                      if (i != formData.length - 1) {
                        updatedContent += ',';
                      }
                    }
                    updateData(
                      updatedContent,
                      keteranganController
                          .text,
                      idRequest,
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text('Kirim',
                    style: TextStyle(color: Color(0xFF057438),fontWeight: FontWeight.bold,),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Status Permohonan',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF057438),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : dataRequests.isEmpty
                ? Text('Tidak ada data permohonan')
                : ListView.builder(
                    itemCount: dataRequests.length,
                    itemBuilder: (context, index) {
                      final judulBerkas =
                          dataRequests[index]['berkas']['judul_berkas'];
                      final status = dataRequests[index]['status'];
                      final keperluan = dataRequests[index]['keperluan'];
                      final idRequest = dataRequests[index]['id_request'];
                      return Container(
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 17, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    judulBerkas
                                        .toString()
                                        .split(' ')
                                        .map((String word) {
                                      return word[0].toUpperCase() +
                                          word.substring(1);
                                    }).join(' '),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "jomolhari",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    getStatusText(status),
                                    style: TextStyle(
                                      color: getStatusTextColor(status),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Color(0xFF057438),
                                        title: Text('Detail Permohonan',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Judul Berkas: $judulBerkas',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'Status: ${getStatusText(status)}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            if (keperluan != null)
                                              Text('Catatan: $keperluan',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Tutup',
                                              style: TextStyle(
                                                color: Colors.yellow,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Image.asset(
                                  'images/notes.png',
                                  width: 25,
                                  height: 25,
                                  color: Color(0xFF057438),
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  if (status == 0) {
                                    showEditContent(
                                      dataRequests[index]['form_tambahan'],
                                      idRequest.toString(),
                                      dataRequests[index]['keterangan'],
                                    );
                                  }
                                  else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Color(0xFF057438),
                                          title: Text(
                                            'Peringatan',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Text(
                                            'Form tidak dapat diedit karena status telah diubah.',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Tutup',
                                                style: TextStyle(
                                                  color: Colors.yellow,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Image.asset(
                                  'images/edit.png',
                                  width: 25,
                                  height: 25,
                                  color: status == 0
                                      ? Color(0xFF057438)
                                      : Colors
                                          .grey, // Jika status bukan 0, gunakan warna abu-abu
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  String getStatusText(int statusCode) {
    switch (statusCode) {
      case 0:
        return 'Diproses';
      case 1:
        return 'Telah di ACC';
      case 2:
        return 'Telah di Print';
      case 3:
        return 'Selesai';
      default:
        return 'Status tidak diketahui';
    }
  }

  Color getStatusTextColor(int statusCode) {
    switch (statusCode) {
      case 0:
        return Colors.yellow;
      case 1:
        return Colors.green;
      case 2:
        return Colors.green;
      case 3:
        return Color(0xFF057438);
      default:
        return Colors.red;
    }
  }
}
