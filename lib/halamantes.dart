import 'package:flutter/material.dart';

class AccountSecurityPage extends StatelessWidget {
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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            title: Text('Account Information'),
            subtitle: Text('Update your account details'),
            leading: Icon(Icons.person),
            onTap: () {
              // Navigasi ke halaman informasi akun
            },
          ),
          ListTile(
            title: Text('Security Settings'),
            subtitle: Text('Manage your security settings'),
            leading: Icon(Icons.security),
            onTap: () {
              // Navigasi ke halaman pengaturan keamanan
            },
          ),
          ListTile(
            title: Text('Change Password'),
            subtitle: Text('Change your account password'),
            leading: Icon(Icons.lock),
            onTap: () {
              // Navigasi ke halaman ubah kata sandi
            },
          ),
          ListTile(
            title: Text('Logout'),
            subtitle: Text('Sign out from your account'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              // Tambahkan logika untuk logout di sini
            },
          ),
        ],
      ),
    );
  }
}