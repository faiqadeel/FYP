import 'package:flutter/material.dart';

class Transport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transport Page"),
        centerTitle: true,
      ),
      body: const Center(
          child: Text("Transport Vehicles",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold))),
    );
  }
}
