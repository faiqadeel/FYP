// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/dialogBox.dart';
import 'package:my_app/components/textFieldComponent.dart';
import 'package:my_app/user_management/login_page.dart';

// ignore: camel_case_types
class OTP_Screen extends StatefulWidget {
  final String verificatId;
  final String name;
  final String email;
  final String phone;
  final String password;
  const OTP_Screen(
      {super.key,
      required this.verificatId,
      required this.name,
      required this.email,
      required this.phone,
      required this.password});

  @override
  State<OTP_Screen> createState() => _OTP_Screen();
}

// ignore: camel_case_types
class _OTP_Screen extends State<OTP_Screen> {
  TextEditingController otp_num = TextEditingController();

  void verify_OTP() async {
    String OTP = otp_num.text.trim();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificatId, smsCode: OTP);
    try {
      if (credential != null) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: widget.email, password: widget.password);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: widget.email, password: widget.password);
        await userCredential.user?.linkWithCredential(credential);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('SUCCESS'),
                content: const Text(
                    "Account Created Successfully\nProceed to login"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: const Text('OK'))
                ],
              );
            });
        Map<String, dynamic> userData = {
          "name": widget.name,
          "email": widget.email,
          "mobile number": widget.phone,
          "friends": []
        };
        FirebaseFirestore.instance.collection("tourists").add(userData);
      }
    } on FirebaseAuthException catch (e) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.delete();
        }
      } on FirebaseAuthException catch (ex) {
        dialogue_box(context, ex.code.toString());
      }
      switch (e.code) {
        case "provider-already-linked":
          dialogue_box(
              context, "The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          dialogue_box(context, "The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          dialogue_box(
              context,
              "The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        default:
          dialogue_box(context, 'hello');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify OTP',
          style: TextStyle(
            color: Color.fromARGB(187, 255, 255, 255),
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(117, 37, 36, 43),
      ),
      backgroundColor: const Color(0xFF25242B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                        color: Color.fromRGBO(209, 209, 209, 1), fontSize: 20),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
