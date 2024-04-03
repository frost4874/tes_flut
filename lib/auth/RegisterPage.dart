import 'package:flutter/material.dart';
import 'package:tes_flut/auth/LoginPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:tes_flut/views/UserData.dart';

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
  String genderValue = 'Laki-Laki';
  DateTime? selectedDate;
  TextEditingController addressController = TextEditingController();
  bool visibility = true;
  final _formKey = GlobalKey<FormState>();

  late Future<List<String>> kecamatanListFuture;
  String? selectedKecamatan;

  late Future<List<String>> desaListFuture;
  String? selectedDesa;
  String? selectedKecamatanId;

//nyoba nyoba doang ini
  Future<List<String>> fetchKecamatanFromDatabase() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/api/kecamatan'));
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
      final response = await http
          .get(Uri.parse('http://localhost:8000/api/desa/$kecamatanId'));
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
    final response = await http
        .get(Uri.parse('http://localhost:8000/api/desa/$kecamatanId'));
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
    final response =
        await http.get(Uri.parse('http://localhost:8000/api/kecamatan'));
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
        // Format tanggal yang dipilih tanpa informasi jam
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
        // Assign formattedDate ke TextFormField
        dateController.text = formattedDate;
      });
    }
  }

  Future<void> _showRegistrationSuccessDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registrasi Berhasil'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Registrasi Anda berhasil.'),
                Text('Klik Ok untuk melanjutkan ke Login.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  // Ganti halaman dan hapus halaman sebelumnya dari tumpukan
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
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);

      UserData userData = UserData(
        nik: nikController.text,
        nama: nameController.text,
        jekel: genderValue,
        kecamatan: selectedKecamatan ?? '',
        desa: selectedDesa ?? '',
        kota: 'Jember', // Ganti dengan nama kota yang sesuai
        tanggalLahir: formattedDate,
        password: passwordController.text,
      );

      // Cetak data pengguna ke terminal
      print('Data Registrasi:');
      print('NIK: ${userData.nik}');
      print('Nama: ${userData.nama}');
      print('Gender: ${userData.jekel}');
      print('Kecamatan: ${userData.kecamatan}');
      print('Desa: ${userData.desa}');
      print('Kota: ${userData.kota}');
      print('Tanggal Lahir: ${userData.tanggalLahir}');
      print('Password: ${userData.password}');
      print('Role: ${userData.role}');

      final response = await http.post(
        Uri.parse(
            'http://localhost:8000/api/register_flutter'), // Ganti dengan URL endpoint API Anda
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData.toJson()),
      );

      if (response.statusCode == 200) {
        // Registrasi berhasil, tampilkan dialog sukses
        _showRegistrationSuccessDialog(context);
      } else {
        // Registrasi gagal, tampilkan pesan kesalahan
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registrasi Gagal'),
              content: Text('Regstrasi Gagal'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Icon(Icons.person, size: 50),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  controller: nikController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText: "NIK",
                    hintText: "Masukkan NIK",
                    prefixIcon: Icon(Icons.person),
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
                  keyboardType: TextInputType.name,
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText: "Nama",
                    hintText: "Masukkan Nama Anda",
                    prefixIcon: Icon(Icons.person_2_sharp),
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
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  controller: tlpController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText: "No Telepon",
                    hintText: "Masukkan No Telepon Anda",
                    prefixIcon: Icon(Icons.call),
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
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText: "Email",
                    hintText: "Masukkan Email Anda",
                    prefixIcon: Icon(Icons.email_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harap isi bidang ini';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
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
                  keyboardType: TextInputType.multiline,
                  controller: passwordController,
                  obscureText: visibility,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: visibility
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
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
                    hintText: "Masukkan Password Anda",
                    prefixIcon: Icon(Icons.lock_rounded),
                    errorMaxLines: 3,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harap isi bidang ini';
                    } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9]).{8,}$')
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
                  keyboardType: TextInputType.multiline,
                  controller: confirmpasswordController,
                  obscureText: visibility,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: visibility
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          visibility = !visibility;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText: "Konfirmasi Password",
                    hintText: "Masukkan Password Anda",
                    prefixIcon: Icon(Icons.lock_rounded),
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
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText: "Gender",
                    prefixIcon: genderValue == 'Laki-Laki'
                        ? Icon(Icons.male_rounded)
                        : Icon(Icons.female_rounded),
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
                      controller:
                          dateController, // Menggunakan TextEditingController
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Tanggal Lahir",
                        prefixIcon: Icon(Icons.calendar_today),
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return DropdownButtonFormField<String>(
                        value: selectedKecamatan,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedKecamatan = newValue!;
                            _fetchDesaByKecamatanId(selectedKecamatanId!);
                            fetchKecamatanId(selectedKecamatan!)
                                .then((kecamatanId) {
                              setState(() {
                                selectedKecamatanId = kecamatanId;
                              });
                              // Panggil fungsi untuk memperbarui daftar desa
                              _fetchDesaByKecamatanId(selectedKecamatanId!);
                            }).catchError((error) {
                              print('Error fetching kecamatan id: $error');
                            });
                          });
                        },
                        items: snapshot.data!
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelText: "Kecamatan",
                          prefixIcon: Icon(Icons.location_on),
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelText: "Desa",
                          prefixIcon: Icon(Icons.location_city),
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
                  keyboardType: TextInputType.emailAddress,
                  controller: addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText: "Alamat Lengkap",
                    hintText: "Masukkan Alamat Lengkap Anda",
                    prefixIcon: Icon(Icons.maps_home_work),
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
                padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Sudah punya akun? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Login disini',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
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
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blueAccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 200.0),
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
