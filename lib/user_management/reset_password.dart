// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/dialogBox.dart';
import 'package:my_app/components/textFieldComponent.dart';
import 'package:my_app/user_management/login_page.dart';

// ignore: camel_case_types
class Password_Reset extends StatefulWidget {
  final String verificatId;
  const Password_Reset({
    Key? key,
    required this.verificatId,
  });

  @override
  State<Password_Reset> createState() => _OTP_Screen();
}

// ignore: camel_case_types
class _OTP_Screen extends State<Password_Reset> {
  bool showWidget = true;
  TextEditingController otp_num = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController newPassword = TextEditingController();

  void changePassword() async {
    String pass = password.text.trim();
    String newPass = newPassword.text.trim();
    if (pass == "" || newPass == "") {
      error_dialogue_box(context, "Please fill out all the fileds");
    } else if (pass != newPass) {
      error_dialogue_box(context, "Passwords do not match");
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).*$')
        .hasMatch(pass)) {
      error_dialogue_box(context,
          "Password must contain  at least one uppercase letter, one lowercase letter, one number, and one special character!");
    } else {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        await user?.updatePassword(pass);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('SUCCESS'),
                content: const Text("Password updated successfully"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'))
                ],
              );
            });
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } on FirebaseAuthException catch (e) {
        error_dialogue_box(context, e.code.toString());
      }
    }
  }

  void verify_OTP() async {
    String OTP = otp_num.text.trim();
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificatId, smsCode: OTP);
      await FirebaseAuth.instance.signInWithCredential(credential);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('SUCCESS'),
              content: const Text("Phone Verified Successfully"),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        showWidget = false;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            );
          });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          error_dialogue_box(
              context, "The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          error_dialogue_box(
              context, "The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          error_dialogue_box(
              context,
              "The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        default:
          error_dialogue_box(context, e.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Password Reset',
          style: TextStyle(
            color: Color.fromARGB(187, 255, 255, 255),
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(117, 37, 36, 43),
      ),
      backgroundColor: const Color(0xFF25242B),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showWidget)
              Padding(
                padding: const EdgeInsets.only(
                    top: 40, left: 30, right: 30, bottom: 10),
                child: TextField(
                  maxLength: 6,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  controller: otp_num,
                  decoration: textFieldDecoration(
                      './assets/icons/OTP_icon.png', 'Enter 6-digit OTP'),
                ),
              ),
            if (showWidget)
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      verify_OTP();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(53, 52, 59, 1),
                      fixedSize: const Size(300, 50),
                    ),
                    child: const Text(
                      'Verify OTP',
                      style: TextStyle(
                          color: Color.fromRGBO(209, 209, 209, 1),
                          fontSize: 20),
                    ),
                  )),
            if (!showWidget)
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: password,
                    obscureText: true,
                    decoration: textFieldDecoration(
                        "./assets/icons/pwd_icon.png", "Password"),
                  )),
            // ignore: prefer_const_constructors
            if (!showWidget)
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: newPassword,
                    obscureText: true,
                    decoration: textFieldDecoration(
                        "./assets/icons/pwd_icon.png", "Password Again"),
                  )),
            if (!showWidget)
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      changePassword();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(53, 52, 59, 1),
                      fixedSize: const Size(250, 50),
                    ),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                          color: Color.fromRGBO(209, 209, 209, 1),
                          fontSize: 20),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
