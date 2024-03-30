// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/dialogBox.dart';
import 'package:my_app/components/iconComponents.dart';
import 'package:my_app/components/textFieldComponent.dart';
import 'package:my_app/user_management/Home_Page.dart';
import 'package:my_app/user_management/forgot_password.dart';
import 'package:my_app/user_management/signup_page.dart';

class H_T_LoginPage extends StatefulWidget {
  const H_T_LoginPage({super.key});

  @override
  State<H_T_LoginPage> createState() => Login();
}

class Login extends State<H_T_LoginPage> {
  final _Loginformfield = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _obscureText = true;

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
            color: Color.fromRGBO(244, 241, 222, 1.0),
            fontSize: 30,
          ),
        ),
        // ignore: prefer_const_constructors
        backgroundColor: Color.fromRGBO(67, 99, 114, 1.0),
      ),
      backgroundColor: const Color.fromRGBO(36, 63, 77, 1.0),
      body: Center(
        child: Form(
          key: _Loginformfield,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              //   child: Image.file(
              //     AssetImage("assets/icons/loginPage/cover.png"),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: passController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                        // prefixIcon: Icon(Icons),
                        prefixIcon: prefixIcon("./assets/icons/pwd_icon.png"),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off)),
                        disabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        labelText: 'password',
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: const Color.fromRGBO(67, 99, 114, 1.0)),
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 160, right: 20, top: 5, bottom: 10),
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
                        'Forgot Password?',
                        style: TextStyle(
                            color: Color.fromRGBO(244, 241, 222, 1.0),
                            fontSize: 17),
                      ))),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 40, right: 40, bottom: 5),
                child: ElevatedButton(
                  onPressed: () {
                    process_login();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(238, 30, 30, 1),
                      fixedSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        color: Color.fromRGBO(244, 241, 222, 1.0),
                        fontSize: 30),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 80),
                child: Row(children: [
                  const Text(
                    'New Here?',
                    style: TextStyle(
                        color: Color.fromRGBO(244, 241, 222, 1.0),
                        fontSize: 18),
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
                            color: Color.fromRGBO(244, 241, 222, 1.0),
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
