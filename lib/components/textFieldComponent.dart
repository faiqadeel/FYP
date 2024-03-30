import 'package:flutter/material.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/iconComponents.dart';

TextField textFieldComponent(String text, String path) {
  return TextField(
    style: const TextStyle(
      color: Colors.white,
    ),
    decoration: textFieldDecoration(path, text),
  );
}

ButtonStyle buttonStyle() {
  return ButtonStyle(
    fixedSize: MaterialStateProperty.all<Size>(const Size(455, 50.0)),
    backgroundColor: MaterialStateProperty.all<Color>(button1()),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10.0), // Adjust the radius as needed
        side: const BorderSide(
            color: Color.fromRGBO(48, 55, 72, 1.00)), // Set the border color
      ),
    ),
  );
}

TextStyle buttonTextStyle() {
  return const TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22);
}

TextStyle AppBarTextStyle() {
  return TextStyle(color: button1(), fontSize: 25, fontWeight: FontWeight.bold);
}

TextStyle LabelTextStyle() => const TextStyle(
    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black);

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
        color: Colors.white,
        fontSize: 18,
      ),
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: const Color.fromRGBO(67, 99, 114, 1.0));
}

InputDecoration textFieldDecorationforHome(String path, String text) {
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
        color: Colors.white,
        fontSize: 18,
      ),
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: const Color.fromRGBO(197, 208, 211, 1.0));
}

InputDecoration tripTextfielddecor(String text) {
  return InputDecoration(
      filled: true,
      fillColor: TextFieldBackground(),
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
