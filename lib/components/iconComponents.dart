import 'package:flutter/material.dart';

Container prefixIcon(String path) {
  return Container(
    padding: const EdgeInsets.all(5),
    width: 8,
    child: Image(
      image: AssetImage(
        path,
      ),
    ),
  );
}
