// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/textFieldComponent.dart';
import 'package:my_app/user_management/Service%20Providers/main_page.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String provider_id;
  final String verificationId;
  const VerifyOtpScreen(
      {Key? key, required this.verificationId, required this.provider_id})
      : super(key: key);

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController otpController = TextEditingController();

  void verifyOTP() async {
    String otp = otpController.text.trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        Navigator.popUntil(context, (route) => route.isFirst);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Main_Page(provider_id: widget.provider_id)));
      }
    } on FirebaseAuthException catch (ex) {
      log(ex.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Verify OTP", style: AppBarTextStyle()),
        backgroundColor: AppBarBackground(),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    controller: otpController,
                    maxLength: 6,
                    decoration: const InputDecoration(
                        labelText: "6-Digit OTP", counterText: ""),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      verifyOTP();
                    },
                    color: button2(),
                    child: const Text(
                      "Verify",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
