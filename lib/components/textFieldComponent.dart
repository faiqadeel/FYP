import 'package:flutter/material.dart';
import 'package:my_app/components/iconComponents.dart';

TextField textFieldComponent(String text, String path) {
  return TextField(
    decoration: InputDecoration(
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
        fillColor: const Color.fromRGBO(25, 24, 30, 0.6)),
  );
}
