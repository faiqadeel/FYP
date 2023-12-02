import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/components/textFieldComponent.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts
            .exoTextTheme(), // Apply Poppins font to the entire theme
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(
              color: Color.fromARGB(187, 255, 255, 255),
              fontSize: 30,
            ),
          ),
          // ignore: prefer_const_constructors
          backgroundColor: Color.fromARGB(117, 37, 36, 43),
        ),
        backgroundColor: const Color(0xFF25242B),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                child: textFieldComponent(
                    "Username", "./assets/icons/person_icon.png"),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 1),
                child: textFieldComponent(
                    'Password', "./assets/icons/pwd_icon.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 40, left: 40, right: 40, bottom: 5),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(53, 52, 59, 1),
                    fixedSize: const Size(300, 50),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        color: Color.fromRGBO(209, 209, 209, 1), fontSize: 20),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 80),
                child: Row(children: [
                  Text(
                    'New Here?',
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1), fontSize: 18),
                  ),
                  Text(
                    '  Sign Up Now',
                    style: TextStyle(
                        color: Color.fromRGBO(97, 219, 178, 1), fontSize: 18),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
