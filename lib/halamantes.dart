import 'package:flutter/material.dart';

class IconPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Icon Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.house,
              size: 50,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Icon(
              Icons.other_houses,
              size: 50,
              color: Colors.yellow,
            ),
            SizedBox(height: 20),
            Icon(
              Icons.apartment,
              size: 50,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: IconPage(),
  ));
}
