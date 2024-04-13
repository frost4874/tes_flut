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
            : ListView.builder(
                itemCount: dataRequests.length,
                itemBuilder: (context, index) {
                  final judulBerkas =
                      dataRequests[index]['berkas']['judul_berkas'];
                  final status = dataRequests[index]['status'];
                  final keperluan = dataRequests[index]['keperluan'];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Detail Permohonan'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Judul Berkas: $judulBerkas'),
                                  Text('Status: ${getStatusText(status)}'),
                                  if (keperluan != null)
                                    Text('Catatan: $keperluan'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Tutup'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: ListTile(
                        title: Text(
                          judulBerkas.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(getStatusText(status)),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
