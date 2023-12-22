import 'package:flutter/material.dart';
import 'package:my_app/components/iconComponents.dart';

TextField textFieldComponent(String text, String path) {
  return TextField(
    style: const TextStyle(
      color: Colors.white,
    ),
    decoration: textFieldDecoration(path, text),
  );
}

InputDecoration textFieldDecoration(String path, String text) {
  return InputDecoration(
      // prefixIcon: Icon(Icons),
      prefixIcon: prefixIcon(path),
      disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      labelText: text,
      labelStyle: const TextStyle(
        color: Color.fromRGBO(205, 205, 205, 1.00),
        fontSize: 15,
      ),
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: const Color.fromRGBO(25, 24, 30, 0.6));
}

InputDecoration tripTextfielddecor(String text) {
  return InputDecoration(
      disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 61, 62, 65)),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      enabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(255, 61, 62, 65), width: 0.0),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 61, 62, 65)),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      labelText: text,
      labelStyle: const TextStyle(
        color: Color.fromRGBO(48, 55, 72, 1.00),
        fontSize: 20,
        fontStyle: FontStyle.italic,
      ),
      border: const OutlineInputBorder());
}
