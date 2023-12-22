// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/dialogBox.dart';
import 'package:my_app/components/textFieldComponent.dart';
import 'package:my_app/user_management/login_page.dart';
import 'package:my_app/user_management/otp_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUp();
}

class SignUp extends State<SignUpPage> {
  final _Signupformfield = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  void createAccount(BuildContext context) async {
    String name = nameController.text.trim();
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cpassword = passwordAgainController.text.trim();
    String number = numberController.text.trim();

    void send_OTP() async {
      bool verified = false;
      String org_num = number.substring(1);
      String phone = "+92$org_num";
      FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          codeSent: (verificationId, forceResendingToken) {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => OTP_Screen(
                          verificatId: verificationId,
                          name: name,
                          email: email,
                          phone: number,
                          password: password,
                        )));
          },
          verificationCompleted: (credential) {
            print('verified');
          },
          verificationFailed: (ex) {
            dialogue_box(context, 'Verification Failed');
            print('not verified');
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    }

    if (name == "" ||
        username == "" ||
        email == "" ||
        password == "" ||
        cpassword == "" ||
        number == "") {
      dialogue_box(context, "Please fill out all the fields!!");
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).*$')
        .hasMatch(password)) {
      dialogue_box(context,
          "Password must contain  at least one uppercase letter, one lowercase letter, one number, and one special character!");
    } else if (password != cpassword) {
      dialogue_box(context, 'Passwords do not match');
    } else if (!RegExp(r'^[a-zA-Z0-9]+@gmail\.com$').hasMatch(email)) {
      dialogue_box(context, "Enter a valid email address");
    } else if (number[0] != "0" || number[1] != "3" || number.length != 11) {
      dialogue_box(context, "Please enter a valid mobile number!");
    } else {
      send_OTP();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
        child: Form(
          key: _Signupformfield,
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
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: nameController,
                    decoration: textFieldDecoration(
                        './assets/icons/person_icon.png', 'Name'),
                  )),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: usernameController,
                    decoration: textFieldDecoration(
                        "./assets/icons/person_icon.png", "Username"),
                  )),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: textFieldDecoration(
                        './assets/icons/mail_icon.png', "Email"),
                  )),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    controller: numberController,
                    decoration: textFieldDecoration(
                        './assets/icons/phone.png', "Phone Number"),
                  )),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: passwordController,
                    obscureText: true,
                    decoration: textFieldDecoration(
                        "./assets/icons/pwd_icon.png", "Password"),
                  )),
              // ignore: prefer_const_constructors
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: passwordAgainController,
                    obscureText: true,
                    decoration: textFieldDecoration(
                        "./assets/icons/pwd_icon.png", "Password Again"),
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    createAccount(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(32, 171, 125, 1),
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
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                          onPressed: () => {
                                Navigator.popUntil(
                                    context, (route) => route.isFirst),
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()))
                              },
                          child: Text(
                            'LOGIN',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ))
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
