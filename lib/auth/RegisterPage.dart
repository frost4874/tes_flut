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
  bool visibility1 = true;
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
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Masyarakat Desa Jember',
          style: TextStyle(
            color: Color(0xFF057438),
            fontSize: 16,
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
                borderRadius: BorderRadius.circular(40.0), // Adjust the value as needed
               ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0), // Same value as the Card's borderRadius
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
                    prefixIcon: Icon(Icons.person, color: Colors.white,),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder( // To change border color when enabled
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                    ),
                    focusedBorder: OutlineInputBorder( // To change border color when focused
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
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
                    labelText: "Nama",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Masukkan Nama Anda",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    prefixIcon: Icon(Icons.person_2_sharp,color: Colors.white,),
                    enabledBorder: OutlineInputBorder( // To change border color when enabled
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                    ),
                    focusedBorder: OutlineInputBorder( // To change border color when focused
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
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
                    labelText: "No Telepon",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Masukkan No Telepon Anda",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    prefixIcon: Icon(Icons.call,color: Colors.white,),
                    enabledBorder: OutlineInputBorder( // To change border color when enabled
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                    ),
                    focusedBorder: OutlineInputBorder( // To change border color when focused
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
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
                    prefixIcon: Icon(Icons.email_rounded,color: Colors.white,),
                    enabledBorder: OutlineInputBorder( // To change border color when enabled
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                    ),
                    focusedBorder: OutlineInputBorder( // To change border color when focused
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                    ),
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
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  keyboardType: TextInputType.multiline,
                  controller: passwordController,
                  obscureText: visibility,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: visibility
                          ? Icon(Icons.visibility, color: Colors.white,)
                          : Icon(Icons.visibility_off, color: Colors.white,),
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
                    prefixIcon: Icon(Icons.lock_rounded,color: Colors.white,),
                    enabledBorder: OutlineInputBorder( // To change border color when enabled
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                    ),
                    focusedBorder: OutlineInputBorder( // To change border color when focused
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                    ),
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
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  keyboardType: TextInputType.multiline,
                  controller: confirmpasswordController,
                  obscureText: visibility1,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: visibility1
                          ? Icon(Icons.visibility, color: Colors.white,)
                          : Icon(Icons.visibility_off, color: Colors.white,),
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
                    prefixIcon: Icon(Icons.lock_rounded,color: Colors.white,),
                    enabledBorder: OutlineInputBorder( // To change border color when enabled
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                    ),
                    focusedBorder: OutlineInputBorder( // To change border color when focused
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
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
                      child: Text(value,
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
                        ? Icon(Icons.male_rounded, color: Colors.white,)
                        : Icon(Icons.female_rounded, color: Colors.white,),
                    enabledBorder: OutlineInputBorder( // To change border color when enabled
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                    ),
                    focusedBorder: OutlineInputBorder( // To change border color when focused
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
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
                        prefixIcon: Icon(Icons.calendar_today, color: Colors.white,),
                        enabledBorder: OutlineInputBorder( // To change border color when enabled
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                        ),
                        focusedBorder: OutlineInputBorder( // To change border color when focused
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
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
                            child: Text(value,
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
                          prefixIcon: Icon(Icons.location_on, color: Colors.white,),
                          enabledBorder: OutlineInputBorder( // To change border color when enabled
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                          ),
                          focusedBorder: OutlineInputBorder( // To change border color when focused
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
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
                            child: Text(value,
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
                          prefixIcon: Icon(Icons.location_city,color: Colors.white,),
                          enabledBorder: OutlineInputBorder( // To change border color when enabled
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                          ),
                          focusedBorder: OutlineInputBorder( // To change border color when focused
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
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
                  style: TextStyle(color: Colors.white,),
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
                    prefixIcon: Icon(Icons.maps_home_work, color: Colors.white,),
                    enabledBorder: OutlineInputBorder( // To change border color when enabled
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                    ),
                    focusedBorder: OutlineInputBorder( // To change border color when focused
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
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
                padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Sudah punya akun? ",
                      style: TextStyle(
                      color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
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
                      fontSize: 20,
                      color: Color(0xFF057438),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 160.0),
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
