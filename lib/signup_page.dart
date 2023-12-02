import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/components/textFieldComponent.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

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
              'Sign Up',
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
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: textFieldComponent(
                      "Name", "./assets/icons/person_icon.png"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: textFieldComponent(
                      "Username", "./assets/icons/person_icon.png"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: textFieldComponent(
                      "Email", "./assets/icons/mail_icon.png"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: textFieldComponent(
                      "Phone Number", "./assets/icons/phone.png"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: textFieldComponent(
                      "Password", "./assets/icons/pwd_icon.png"),
                ),
                // ignore: prefer_const_constructors
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: textFieldComponent(
                      "Password Again", "./assets/icons/pwd_icon.png"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(32, 171, 125, 1),
                      fixedSize: const Size(300, 50),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
