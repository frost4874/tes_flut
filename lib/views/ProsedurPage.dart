import 'package:flutter/material.dart';

class ProsedurLayananPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prosedur Layanan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF057438),
        iconTheme: IconThemeData(
          color: Colors.white, // Mengatur warna tombol kembali menjadi putih
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 24.0,
                  color: Color(0xFF057438)
                ),
                SizedBox(width: 20,),
                Text(
                  'Login dan Register',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF057438)
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Masyarakat dapat melakukan login pada akun yang sudah terdaftar dan register jika belum memiliki akun dengan cara mengisi form pendaftaran yang dibutuhkan.',
              style: TextStyle(
                color: Color(0xFF057438)
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 24.0,
                  color: Color(0xFF057438)
                ),
                SizedBox(width: 20,),
                Text(
                  'Pengajuan Permohonan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF057438)
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Masyarakat dapat mengajukan surat dengan cara memilih surat yang tersedia dan mengisi pengajuan yang diperlukan.',
              style: TextStyle(
                color: Color(0xFF057438)
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 24.0,
                  color: Color(0xFF057438)
                ),
                SizedBox(width: 20,),
                Text(
                  'Status Permohonan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF057438)
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Setelah mengajukan surat, masyarakat dapat memantau proses pengajuan surat secara realtime.',
              style: TextStyle(
                color: Color(0xFF057438)
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 24.0,
                  color: Color(0xFF057438)
                ),
                SizedBox(width: 20,),
                Text(
                  'Kelola Biodata Masyarakat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF057438)
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Selain itu, masyarakat bisa mengelola biodatanya dengan cara edit profil untuk melengkapi data yang kurang lengkap.',
              style: TextStyle(
                color: Color(0xFF057438)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
