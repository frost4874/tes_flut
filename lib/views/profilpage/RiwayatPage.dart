import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RiwayatPage extends StatefulWidget {
  final String nik;

  RiwayatPage({required this.nik});

  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<Map<String, dynamic>> riwayatList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = Uri.parse('http://localhost:8000/api/riwayat/${widget.nik}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          riwayatList = json.decode(response.body).cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }

    // Check for empty data here
    if (riwayatList.isEmpty) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF057438),
      ),
      body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : riwayatList.isEmpty
                  ? Text('Tidak ada riwayat')
                  : ListView.builder(
                      itemCount: riwayatList.length,
                      itemBuilder: (context, index) {
                        final id_berkas =
                            riwayatList[index]['berkas']['judul_berkas'];
                        final date = riwayatList[index]['tanggal_request'];
                        final status = riwayatList[index]['status'];

                        // Check if the status is 4, if not, return an empty container
                        if (status != 4) {
                          return Container();
                        }

                        // If the status is 4, then display the entry
                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Berkas: $id_berkas',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tanggal Request: $date',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Status: ${getStatusText(status)}',
                                style: TextStyle(
                                  color: getStatusTextColor(status),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
    );
  }

  String getStatusText(int statusCode) {
    switch (statusCode) {
      case 4:
        return 'Selesai';
      default:
        return 'Status tidak diketahui';
    }
  }

  Color getStatusTextColor(int statusCode) {
    switch (statusCode) {
      case 4:
        return Color(0xFF057438);
      default:
        return Colors.red;
    }
  }
}
