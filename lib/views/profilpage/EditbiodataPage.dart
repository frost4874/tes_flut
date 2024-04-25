import 'package:flutter/material.dart';
import 'package:tes_flut/auth/DashboardPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class EditbiodataPage extends StatefulWidget {
  final String nik;
  final String name;
  final String email;
  final String kecamatan;
  final String desa;
  final String kota;
  final String alamat;
  final String tgl_lahir;
  final String telepon;
  final String jekel;
  final String tempatLahir;
  final String agama;
  final String statusWarga;
  final String warganegara;
  final String statusNikah;
  final String rt;
  final String rw;

  const EditbiodataPage({
    Key? key,
    required this.nik,
    required this.name,
    required this.email,
    required this.kecamatan,
    required this.desa,
    required this.kota,
    required this.alamat,
    required this.tgl_lahir,
    required this.telepon,
    required this.jekel,
    required this.tempatLahir,
    required this.agama,
    required this.statusWarga,
    required this.warganegara,
    required this.statusNikah,
    required this.rt,
    required this.rw,
  }) : super(key: key);

  @override
  _EditbiodataPageState createState() => _EditbiodataPageState();
}

class _EditbiodataPageState extends State<EditbiodataPage> {
  TextEditingController nikController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController tlpController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pekerjaanController = TextEditingController();
  TextEditingController tempatlahirController = TextEditingController();
  TextEditingController rtController = TextEditingController();
  TextEditingController rwController = TextEditingController();
  String genderValue = '';
  String agamavalue = '';
  String statuspernikahanvalue = '';
  String warganegaraanvalue = '';
  String statuswargavalue = '';
  DateTime? selectedDate;
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
    nikController.text = widget.nik;
    emailController.text = widget.email;
    nameController.text = widget.name;
    tlpController.text = widget.telepon;
    addressController.text = widget.alamat;
    dateController.text = widget.tgl_lahir;
    genderValue = widget.jekel;
    agamavalue = widget.agama;
    statuspernikahanvalue = widget.statusNikah;
    statuswargavalue = widget.statusWarga;
    warganegaraanvalue = widget.warganegara;
    tempatlahirController.text = widget.tempatLahir;
    rtController.text = widget.rt;
    rwController.text = widget.rw;

    kecamatanListFuture = fetchKecamatanFromDatabase();
    kecamatanListFuture.then((kecamatanList) {
      setState(() {
        selectedKecamatan = widget.kecamatan;
      });
      fetchKecamatanId(selectedKecamatan!).then((kecamatanId) {
        setState(() {
          selectedKecamatanId = kecamatanId;
        });
        fetchDesaFromDatabase(selectedKecamatanId ?? '').then((desaList) {
          setState(() {
            desaListFuture = Future.value(desaList);
            selectedDesa = widget.desa;
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
          title: Text(
            'Edit Biodata Berhasil',
            style: TextStyle(
              color: Color(0xFF057438),
              fontFamily: 'Interbold',
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Edit Biodata Anda berhasil.',
                  style: TextStyle(
                    color: Color(0xFF057438),
                  ),
                ),
                Text(
                  'Klik Ok untuk melanjutkann.',
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
                  // Ganti halaman dan hapus halaman sebelumnya dari tumpukan
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardPage(
                      Biodata: widget.nik,
                    ),
                  ),
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
      String formattedDate;
      if (selectedDate != null) {
        formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      } else {
        formattedDate = widget.tgl_lahir;
      }

      Map<String, dynamic> userData = {
        'nik': nikController.text,
        'nama': nameController.text,
        'email': emailController.text,
        'telepon': tlpController.text,
        'jekel': genderValue,
        'kecamatan': selectedKecamatan ?? '',
        'desa': selectedDesa ?? '',
        'kota': 'Jember',
        'tgl_lahir': formattedDate,
        'alamat': addressController.text,
        'agama': agamavalue,
        'rt': rtController.text,
        'rw': rwController.text,
        'status_nikah': statuspernikahanvalue,
        'status_warga': statuswargavalue,
        'warganegara': warganegaraanvalue,
        'tempat_lahir': tempatlahirController.text,
      };
      if (passwordController.text.isNotEmpty) {
        userData['password'] = passwordController.text;
      }

      print('Data yang akan dikirim: $userData');

      final response = await http.put(
        Uri.parse('http://localhost:8000/api/update_biodata'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );
      print('Respons: ${response.body}');
      if (response.statusCode == 200) {
        _showRegistrationSuccessDialog(context);
      } else {
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
                      Icons.edit_note,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Biodata',
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
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Color(0xFF057438),
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
                            readOnly: true,
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
                              prefixIcon: Icon(
                                Icons.call,
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
                              hintText:
                                  "Masukkan Password Jika Ingin Mengubahnya",
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
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            controller: pekerjaanController,
                            decoration: InputDecoration(
                              labelText: "Pekerjaan",
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: "Masukkan Pekerjaan Anda",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              prefixIcon: Icon(
                                Icons.badge,
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
                          child: DropdownButtonFormField<String>(
                            value: agamavalue.isEmpty ? null : agamavalue,
                            hint: Text("Pilih Agama Anda",
                                style: TextStyle(color: Colors.white)),
                            onChanged: (String? newValue) {
                              setState(() {
                                agamavalue = newValue ?? '';
                              });
                            },
                            items: <String>[
                              'Islam',
                              'Kristen',
                              'Katolik',
                              'Hindu',
                              'Budha'
                            ].map<DropdownMenuItem<String>>((String value) {
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
                              labelText: "Agama",
                              labelStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.menu_book,
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
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: DropdownButtonFormField<String>(
                            value: genderValue.isEmpty ? null : genderValue,
                            hint: Text("Pilih Gender",
                                style: TextStyle(color: Colors.white)),
                            onChanged: (String? newValue) {
                              setState(() {
                                genderValue = newValue ?? '';
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
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: DropdownButtonFormField<String>(
                            value: statuspernikahanvalue.isEmpty
                                ? null
                                : statuspernikahanvalue,
                            hint: Text("Pilih Status Pernikahan",
                                style: TextStyle(color: Colors.white)),
                            onChanged: (String? newValue) {
                              setState(() {
                                statuspernikahanvalue = newValue ?? '';
                              });
                            },
                            items: <String>[
                              'Belum Kawin',
                              'Kawin',
                              'Cerai Hidup',
                              'Cerai Mati'
                            ].map<DropdownMenuItem<String>>((String value) {
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
                              labelText: "Status Pernikahan",
                              labelStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.supervisor_account,
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
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: DropdownButtonFormField<String>(
                            value: warganegaraanvalue.isEmpty
                                ? null
                                : warganegaraanvalue,
                            hint: Text("Pilih Kewarganegaraan",
                                style: TextStyle(color: Colors.white)),
                            onChanged: (String? newValue) {
                              setState(() {
                                warganegaraanvalue = newValue ?? '';
                              });
                            },
                            items: <String>['WNI', 'WNA']
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
                              labelText: "Warganegaraan",
                              labelStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.apartment,
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
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: DropdownButtonFormField<String>(
                            value: statuswargavalue.isEmpty
                                ? null
                                : statuswargavalue,
                            hint: Text("Pilih Status Warga",
                                style: TextStyle(color: Colors.white)),
                            onChanged: (String? newValue) {
                              setState(() {
                                statuswargavalue = newValue ?? '';
                              });
                            },
                            items: <String>[
                              'Pelajar',
                              'Mahasiswa',
                              'Bekerja',
                              'Belum Bekerja'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            dropdownColor: Color(0xFF057438),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              labelText: "Status Warga",
                              labelStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.check_circle,
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
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            controller: tempatlahirController,
                            decoration: InputDecoration(
                              labelText: "Tempat Lahir",
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: "Masukkan Tempat Lahir Anda",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              prefixIcon: Icon(
                                Icons.maps_home_work,
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
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Harap isi bidang ini';
                              }
                              return null;
                            },
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
                                controller: dateController,
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
                                    borderSide:
                                        BorderSide(color: Colors.orange),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: Colors.white),
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
                                      value: value == '' ? null : value,
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
                                      value: value == '' ? null : value,
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
                            controller: rtController,
                            decoration: InputDecoration(
                              labelText: "RT",
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: "Masukkan RT Anda",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              prefixIcon: Icon(
                                Icons.house,
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
                            controller: rwController,
                            decoration: InputDecoration(
                              labelText: "RW",
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: "Masukkan RW Anda",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              prefixIcon: Icon(
                                Icons.house,
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
                              'Edit Biodata',
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
