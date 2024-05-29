import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tes_flut/auth/LoginPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nikController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController tlpController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String? _imagektp;
  String? _imagekk;
  String genderValue = 'Laki-Laki';
  DateTime? selectedDate;
  TextEditingController addressController = TextEditingController();
  bool visibility = true;
  bool visibility1 = true;
  final _formKey = GlobalKey<FormState>();

  late Future<List<String>> kecamatanListFuture;
  String? selectedKecamatan;

  late Future<List<String>> desaListFuture;
  String? selectedDesa;
  String? selectedKecamatanId;

  void _openImagektpPicker(BuildContext context) async {
    final pickedImagektp = await ImagePicker().pickImage(
      source: ImageSource
          .gallery, // Ubah menjadi ImageSource.camera jika ingin menggunakan kamera
    );
    if (pickedImagektp != null) {
      setState(() {
        _imagektp = pickedImagektp.path;
      });
    }
  }

  void _openImagekkPicker(BuildContext context) async {
    final pickedImagekk = await ImagePicker().pickImage(
      source: ImageSource
          .gallery, // Ubah menjadi ImageSource.camera jika ingin menggunakan kamera
    );
    if (pickedImagekk != null) {
      setState(() {
        _imagekk = pickedImagekk.path;
      });
    }
  }

//nyoba nyoba doang ini
  Future<List<String>> fetchKecamatanFromDatabase() async {
    final response = await http.get(
        Uri.parse('https://suratdesajember.framework-tif.com/api/kecamatan'));
    if (response.statusCode == 200) {
      List<String> kecamatanList = [];
      final data = json.decode(response.body);
      for (var kecamatan in data) {
        kecamatanList.add(kecamatan['nama']);
      }
      return kecamatanList;
    } else {
      throw Exception('Failed to load kecamatan data');
    }
  }

  void _fetchDesaByKecamatanId(String kecamatanId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://suratdesajember.framework-tif.com/api/desa/$kecamatanId'));
      if (response.statusCode == 200) {
        List<String> desaList = (json.decode(response.body) as List)
            .map((item) => item['nama'] as String)
            .toList();
        setState(() {
          selectedDesa = null;
          desaListFuture = Future.value(desaList);
        });
      } else {
        throw Exception('Failed to load desa data');
      }
    } catch (error) {
      print('Error fetching desa data: $error');
      setState(() {
        desaListFuture = Future.error('Failed to load desa data');
      });
    }
  }

  Future<List<String>> fetchDesaFromDatabase(String kecamatanId) async {
    final response = await http.get(Uri.parse(
        'https://suratdesajember.framework-tif.com/api/desa/$kecamatanId'));
    if (response.statusCode == 200) {
      List<String> desaList = [];
      final data = json.decode(response.body);
      for (var desa in data) {
        desaList.add(desa['nama']);
      }
      return desaList;
    } else {
      throw Exception('Failed to load desa data');
    }
  }

  Future<String> fetchKecamatanId(String kecamatanName) async {
    final response = await http.get(
        Uri.parse('https://suratdesajember.framework-tif.com/api/kecamatan'));
    if (response.statusCode == 200) {
      final List<dynamic> kecamatans = json.decode(response.body);
      final kecamatan = kecamatans
          .firstWhere((kecamatan) => kecamatan['nama'] == kecamatanName);
      return kecamatan['id'].toString();
    } else {
      throw Exception('Failed to load kecamatan data');
    }
  }

  @override
  void initState() {
    super.initState();
    kecamatanListFuture = fetchKecamatanFromDatabase();
    kecamatanListFuture.then((kecamatanList) {
      setState(() {
        selectedKecamatan = kecamatanList.first;
      });
      fetchKecamatanId(selectedKecamatan!).then((kecamatanId) {
        setState(() {
          selectedKecamatanId = kecamatanId;
        });
        fetchDesaFromDatabase(selectedKecamatanId ?? '').then((desaList) {
          setState(() {
            desaListFuture = Future.value(desaList);
          });
        }).catchError((error) {
          print('Error fetching desa data: $error');
          setState(() {
            desaListFuture = Future.error('Failed to load desa data');
          });
        });
      }).catchError((error) {
        print('Error fetching kecamatan id: $error');
      });
    }).catchError((error) {
      print('Error fetching kecamatan data: $error');
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
        dateController.text = formattedDate;
      });
    }
  }

  Future<void> _showRegistrationSuccessDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Registrasi Berhasil',
            style: TextStyle(
              color: Color(0xFF057438),
              fontFamily: 'Interbold',
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Registrasi Anda berhasil.',
                  style: TextStyle(
                    color: Color(0xFF057438),
                  ),
                ),
                Text(
                  'Akun anda dalam proses validasi.',
                  style: TextStyle(
                    color: Color(0xFF057438),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _saveRegistrationData() async {
    if (_formKey.currentState!.validate()) {
      if (_imagektp == null || _imagekk == null) {
        // Menampilkan pesan untuk meminta pengguna untuk mengunggah gambar
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Harap Unggah Gambar',
                style: TextStyle(
                  color: Color(0xFF057438),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'Anda harus mengunggah gambar KTP dan KK untuk melanjutkan registrasi.',
                style: TextStyle(
                  color: Color(0xFF057438),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.yellow,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return; // Menghentikan eksekusi lebih lanjut jika gambar tidak diunggah
      }

      // Lakukan konversi gambar ke bentuk byte
      File ktpFile = File(_imagektp!);
      File kkFile = File(_imagekk!);

      // Kirim gambar sebagai multipart/form-data
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://suratdesajember.framework-tif.com/api/register_flutter'));
      // Read bytes from the files
      List<int> ktpBytes = await ktpFile.readAsBytes();
      List<int> kkBytes = await kkFile.readAsBytes();
      // Add images to request
      request.files.add(http.MultipartFile.fromBytes(
        'fotoKtp',
        ktpBytes,
        filename: 'ktp_image.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
      request.files.add(http.MultipartFile.fromBytes(
        'fotoKk',
        kkBytes,
        filename: 'kk_image.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);

      // Tambahkan data pengguna lainnya sebagai fields
      request.fields['nik'] = nikController.text;
      request.fields['nama'] = nameController.text;
      request.fields['email'] = emailController.text;
      request.fields['telepon'] = tlpController.text;
      request.fields['jekel'] = genderValue;
      request.fields['kecamatan'] = selectedKecamatan ?? '';
      request.fields['desa'] = selectedDesa ?? '';
      request.fields['kota'] = 'Jember';
      request.fields['tgl_lahir'] = formattedDate;
      request.fields['alamat'] = addressController.text;
      request.fields['password'] = passwordController.text;

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print('Response status code: ${response.statusCode}');
      // Setelah mendapatkan respons 302
      if (response.statusCode == 302) {
        // Periksa header Location
        String? redirectUrl = response.headers['location'];

        if (redirectUrl != null) {
          // Cetak URL yang di-redirect
          print('Redirect URL: $redirectUrl');

          // Lakukan permintaan baru ke URL yang dituju
          final redirectResponse = await http.get(Uri.parse(redirectUrl));

          // Periksa respons dari redirect
          if (redirectResponse.statusCode == 200) {
            // Registrasi berhasil setelah mengikuti redirect
            _showRegistrationSuccessDialog(context);
          } else {
            // Gagal mengikuti redirect
            print('Failed to follow redirect: ${redirectResponse.statusCode}');
            // Tampilkan pesan kesalahan
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Registrasi Gagal'),
                  content: Text('Registrasi Gagal'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          // Header Location tidak tersedia
          print('Redirect URL not found in headers');
          // Tampilkan pesan kesalahan
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Registrasi Gagal'),
                content: Text('Registrasi Gagal'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
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
                      Icons.email,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registrasi',
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
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(40.0), // Adjust the value as needed
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        40.0), // Same value as the Card's borderRadius
                    color: Color(0xFF057438), // Background color set to #057438
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            autofocus: true,
                            controller: nikController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "NIK",
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: "Masukkan NIK",
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                // To change border color when enabled
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                // To change border color when focused
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              errorStyle: TextStyle(color: Colors.orange),
                              errorBorder: OutlineInputBorder(
                                // To change border color when error
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors
                                        .orange), // Set the border color to yellow
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                // To change border color when focused with error
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors
                                        .white), // Set the border color to yellow
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Harap isi bidang ini';
                              } else if (value.length != 16 ||
                                  int.tryParse(value) == null) {
                                return 'NIK harus terdiri dari 16 angka';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            keyboardType: TextInputType.name,
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: "Nama Lengkap",
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: "Masukkan Nama Lengkap Anda",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              prefixIcon: Icon(
                                Icons.person_2_sharp,
                                color: Colors.white,
                              ),
                              enabledBorder: OutlineInputBorder(
                                // To change border color when enabled
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                // To change border color when focused
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              errorStyle: TextStyle(color: Colors.orange),
                              errorBorder: OutlineInputBorder(
                                // To change border color when error
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors
                                        .orange), // Set the border color to yellow
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                // To change border color when focused with error
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors
                                        .white), // Set the border color to yellow
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Harap isi bidang ini';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            keyboardType: TextInputType.phone,
                            autofocus: true,
                            controller: tlpController,
                            decoration: InputDecoration(
                              labelText: "No Handphone",
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: "Masukkan No Handphone Anda",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              prefixIcon: Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                              enabledBorder: OutlineInputBorder(
                                // To change border color when enabled
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                // To change border color when focused
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              errorStyle: TextStyle(color: Colors.orange),
                              errorBorder: OutlineInputBorder(
                                // To change border color when error
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors
                                        .orange), // Set the border color to yellow
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                // To change border color when focused with error
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors
                                        .white), // Set the border color to yellow
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Harap isi bidang ini';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: "Masukkan Email Anda",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              prefixIcon: Icon(
                                Icons.email_rounded,
                                color: Colors.white,
                              ),
                              enabledBorder: OutlineInputBorder(
                                // To change border color when enabled
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                // To change border color when focused
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              errorStyle: TextStyle(color: Colors.orange),
                              errorBorder: OutlineInputBorder(
                                // To change border color when error
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors
                                        .orange), // Set the border color to yellow
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                // To change border color when focused with error
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors
                                        .white), // Set the border color to yellow
                              ),
                            ),
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
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            keyboardType: TextInputType.multiline,
                            controller: passwordController,
                            obscureText: visibility,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: visibility
                                    ? Icon(
                                        Icons.visibility,
                                        color: Colors.white,
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        color: Colors.white,
                                      ),
                                onPressed: () {
                                  setState(() {
                                    visibility = !visibility;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: "Masukkan Password Anda",
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.lock_rounded,
                                color: Colors.white,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              errorStyle: TextStyle(color: Colors.orange),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorMaxLines: 3,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Harap isi bidang ini';
                              } else if (!RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[0-9]).{8,}$')
                                  .hasMatch(value)) {
                                return 'Password harus terdiri dari minimal satu huruf besar, satu angka, dan memiliki panjang minimal 8 karakter';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            keyboardType: TextInputType.multiline,
                            controller: confirmpasswordController,
                            obscureText: visibility1,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: visibility1
                                    ? Icon(
                                        Icons.visibility,
                                        color: Colors.white,
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        color: Colors.white,
                                      ),
                                onPressed: () {
                                  setState(() {
                                    visibility1 = !visibility1;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              labelText: "Konfirmasi Password",
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: "Masukkan Password Anda",
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.lock_rounded,
                                color: Colors.white,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              errorStyle: TextStyle(color: Colors.orange),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorMaxLines: 3,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Harap isi bidang ini';
                              } else if (value != passwordController.text) {
                                return 'Password tidak cocok';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: DropdownButtonFormField<String>(
                            value: genderValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                genderValue = newValue!;
                              });
                            },
                            items: <String>['Laki-Laki', 'Perempuan']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                            dropdownColor: Color(0xFF057438),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              labelText: "Gender",
                              labelStyle: TextStyle(color: Colors.white),
                              prefixIcon: genderValue == 'Laki-Laki'
                                  ? Icon(
                                      Icons.male_rounded,
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.female_rounded,
                                      color: Colors.white,
                                    ),
                              enabledBorder: OutlineInputBorder(
                                // To change border color when enabled
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                // To change border color when focused
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              errorStyle: TextStyle(color: Colors.orange),
                              errorBorder: OutlineInputBorder(
                                // To change border color when error
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors
                                        .orange), // Set the border color to yellow
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                // To change border color when focused with error
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors
                                        .white), // Set the border color to yellow
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                              child: TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                controller:
                                    dateController, // Menggunakan TextEditingController
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  labelText: "Tanggal Lahir",
                                  labelStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(
                                    Icons.calendar_today,
                                    color: Colors.white,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    // To change border color when enabled
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.8)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    // To change border color when focused
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.8)),
                                  ),
                                  errorStyle: TextStyle(color: Colors.orange),
                                  errorBorder: OutlineInputBorder(
                                    // To change border color when error
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        color: Colors
                                            .orange), // Set the border color to yellow
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    // To change border color when focused with error
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        color: Colors
                                            .white), // Set the border color to yellow
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Harap isi bidang ini';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: FutureBuilder<List<String>>(
                            future: kecamatanListFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return DropdownButtonFormField<String>(
                                  value: selectedKecamatan,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedKecamatan = newValue!;
                                      _fetchDesaByKecamatanId(
                                          selectedKecamatanId!);
                                      fetchKecamatanId(selectedKecamatan!)
                                          .then((kecamatanId) {
                                        setState(() {
                                          selectedKecamatanId = kecamatanId;
                                        });
                                        // Panggil fungsi untuk memperbarui daftar desa
                                        _fetchDesaByKecamatanId(
                                            selectedKecamatanId!);
                                      }).catchError((error) {
                                        print(
                                            'Error fetching kecamatan id: $error');
                                      });
                                    });
                                  },
                                  items: snapshot.data!
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  dropdownColor: Color(0xFF057438),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    labelText: "Kecamatan",
                                    labelStyle: TextStyle(color: Colors.white),
                                    prefixIcon: Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      // To change border color when enabled
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // To change border color when focused
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: FutureBuilder<List<String>>(
                            future: fetchDesaFromDatabase(selectedKecamatanId ??
                                ''), // Gunakan id kecamatan yang dipilih
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return DropdownButtonFormField<String>(
                                  value: selectedDesa,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedDesa = newValue!;
                                    });
                                  },
                                  items: snapshot.data!
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  dropdownColor: Color(0xFF057438),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    labelText: "Desa",
                                    labelStyle: TextStyle(color: Colors.white),
                                    prefixIcon: Icon(
                                      Icons.location_city,
                                      color: Colors.white,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      // To change border color when enabled
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // To change border color when focused
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            controller: addressController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              labelText: "Alamat Lengkap",
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: "Masukkan Alamat Lengkap Anda",
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.maps_home_work,
                                color: Colors.white,
                              ),
                              enabledBorder: OutlineInputBorder(
                                // To change border color when enabled
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                // To change border color when focused
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              errorStyle: TextStyle(color: Colors.orange),
                              errorBorder: OutlineInputBorder(
                                // To change border color when error
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors
                                        .orange), // Set the border color to yellow
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                // To change border color when focused with error
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Colors
                                        .white), // Set the border color to yellow
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Harap isi bidang ini';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xFF057438),
                              side: BorderSide(color: Colors.white),
                            ),
                            onPressed: () {
                              _openImagektpPicker(context);
                            },
                            child: Text('Pilih Gambar KTP'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(20),
                          child: _imagektp != null
                              ? Text(
                                  _imagektp!
                                      .split('/')
                                      .last, // Menampilkan nama file dari path
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  'Belum ada gambar KTP',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xFF057438),
                              side: BorderSide(color: Colors.white),
                            ),
                            onPressed: () {
                              _openImagekkPicker(context);
                            },
                            child: Text('Pilih Gambar KK'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(20),
                          child: _imagekk != null
                              ? Text(
                                  _imagekk!
                                      .split('/')
                                      .last, // Menampilkan nama file dari path
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  'Belum ada gambar KK',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Sudah punya akun? ",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Text(
                                  'Login disini',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _saveRegistrationData();
                              }
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF057438),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
