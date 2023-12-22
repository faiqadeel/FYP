// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/dialogBox.dart';
import 'package:my_app/components/textFieldComponent.dart';
import 'package:my_app/user_management/Home_Page.dart';
import 'package:my_app/user_management/forgot_password.dart';
import 'package:my_app/user_management/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => Login();
}

class Login extends State<LoginPage> {
  final _Loginformfield = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void process_login() async {
    String email = emailController.text.trim();
    String password = passController.text.trim();

    if (email == "" || password == "") {
      dialogue_box(context, 'Please fill out all the fields!');
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(email: email)));
        }
      } on FirebaseAuthException catch (ex) {
        dialogue_box(context, ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
        child: Form(
          key: _Loginformfield,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text(
                  "TrekMates",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    decoration: textFieldDecoration(
                        './assets/icons/mail_icon.png', 'Email'),
                  )),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: passController,
                    obscureText: true,
                    decoration: textFieldDecoration(
                        "./assets/icons/pwd_icon.png", 'Password'),
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 170, right: 20, top: 5, bottom: 10),
                  child: TextButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen()));
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                            color: Color.fromRGBO(97, 219, 178, 1),
                            fontSize: 18),
                      ))),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 40, right: 40, bottom: 5),
                child: ElevatedButton(
                  onPressed: () {
                    process_login();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(53, 52, 59, 1),
                    fixedSize: const Size(250, 50),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 80),
                child: Row(children: [
                  const Text(
                    'New Here?',
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1), fontSize: 18),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                      child: const Text(
                        'Sign Up Now',
                        style: TextStyle(
                            color: Color.fromRGBO(97, 219, 178, 1),
                            fontSize: 18),
                      ))
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
