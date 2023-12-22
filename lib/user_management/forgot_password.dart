// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/dialogBox.dart';
import 'package:my_app/components/textFieldComponent.dart';
import 'package:my_app/user_management/reset_password.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  State<ForgotPasswordScreen> createState() => ForgotPassword();
}

class ForgotPassword extends State<ForgotPasswordScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void sendOtp() async {
    String number = phoneController.text.trim();
    String org_num = number.substring(1);
    String phone = "+92$org_num";
    String email = emailController.text.trim();
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: "123334");
      dialogue_box(context, "The provided email does not exists!!");
      User user = userCredential.user!;
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        FirebaseAuth _auth = FirebaseAuth.instance;
        await _auth.verifyPhoneNumber(
            phoneNumber: phone,
            codeSent: (verificationId, forceResendingToken) {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Password_Reset(verificatId: verificationId)));
            },
            verificationCompleted: (credential) {},
            verificationFailed: (ex) {
              dialogue_box(context, 'Verification Failed');
            },
            codeAutoRetrievalTimeout: (String verificationId) {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF25242B),
      ),
      backgroundColor: const Color(0xFF25242B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(right: 40, left: 40, top: 40, bottom: 10),
              child: TextField(
                controller: emailController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: textFieldDecoration(
                    './assets/icons/mail_icon.png', "Enter Registered Email"),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(right: 40, left: 40, top: 10, bottom: 10),
              child: TextField(
                controller: phoneController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: textFieldDecoration(
                    './assets/icons/phone.png', "Phone Number"),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(right: 40, left: 40, top: 10, bottom: 10),
              child: ElevatedButton(
                onPressed: () => sendOtp(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(53, 52, 59, 1),
                  fixedSize: const Size(250, 50),
                ),
                child: const Text(
                  'Get OTP',
                  style: TextStyle(
                      color: Color.fromRGBO(209, 209, 209, 1), fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
