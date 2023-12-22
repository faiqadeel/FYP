import 'package:flutter/material.dart';

class Hotels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hotel Page"),
        centerTitle: true,
      ),
      body: Center(
          child: Text("Hotels",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold))),
    );
  }
}
