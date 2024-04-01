import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/user_management/Service%20Providers/PhoneAuth/Otp.dart';

import '../../../components/Colors.dart';
import '../../../components/textFieldComponent.dart';

class PhoneSignIn extends StatefulWidget {
  final bool isVerified;
  const PhoneSignIn({super.key, required this.isVerified});
  @override
  State<PhoneSignIn> createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {
  TextEditingController phoneController = TextEditingController();

  void sendOTP() async {
    String number = phoneController.text.trim();
    String org_num = number.substring(1);
    String phone = "+92$org_num";

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        codeSent: (verificationId, resendToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyOtpScreen(
                        provider_id: phone,
                        verificationId: verificationId,
                      )));
        },
        verificationCompleted: (credential) {},
        verificationFailed: (ex) {
          print(ex.code.toString());
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Sign In with Phone",
          style: AppBarTextStyle(),
        ),
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
                    controller: phoneController,
                    decoration:
                        const InputDecoration(labelText: "Phone Number"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      sendOTP();
                    },
                    color: button2(),
                    child: const Text(
                      "Sign In",
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
