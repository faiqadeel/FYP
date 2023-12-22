import 'package:flutter/material.dart';

class LocalGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guide Page"),
        centerTitle: true,
      ),
      body: const Center(
          child: Text("Guides",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold))),
    );
  }
}
