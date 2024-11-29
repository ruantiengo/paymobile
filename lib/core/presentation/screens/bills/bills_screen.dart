import 'package:flutter/material.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Boletos",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
