class UserData {
  final String nik;
  final String nama;
  final String jekel;
  final String email;
  final String telepon;
  final String kecamatan;
  final String desa;
  final String kota;
  final String alamat;
  final String tanggalLahir;
  final String password;
  final String role;

  UserData({
    required this.nik,
    required this.nama,
    required this.jekel,
    required this.email,
    required this.telepon,
    required this.kecamatan,
    required this.alamat,
    required this.desa,
    required this.tanggalLahir,
    required this.password,
    this.role = 'Pemohon',
    this.kota = 'Jember', // Default role
  });

  Map<String, dynamic> toJson() {
    return {
      'nik': nik,
      'nama': nama,
      'email': email,
      'telepon': telepon,
      'jekel': jekel,
      'kecamatan': kecamatan,
      'desa': desa,
      'kota': kota,
      'alamat': alamat,
      'tgl_lahir': tanggalLahir,
      'password': password,
      'role': role,
    };
  }
}
