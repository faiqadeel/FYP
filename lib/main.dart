import 'package:flutter/material.dart';
import 'package:my_app/login_page.dart';
import 'package:my_app/signup_page.dart';

void main() {
  runApp(const Screen());
}

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Login();
  }
}
