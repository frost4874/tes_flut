import 'package:flutter/material.dart';

class EmailEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Alamat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFF057438),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(height: 10,),
          Card(
            elevation: 5.0,
            margin: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Color(0xFF057438),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //name


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}