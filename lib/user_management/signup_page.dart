import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/components/dialogBox.dart';
import 'package:my_app/components/iconComponents.dart';
import 'package:my_app/components/textFieldComponent.dart';
import 'package:my_app/user_management/Service%20Providers/PhoneAuth/PhoneSignIn.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText1 = true;
  bool isLoading = false;

  void createAccount(BuildContext context) async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cpassword = passwordAgainController.text.trim();
    String number = numberController.text.trim();
    RegExp numExp = RegExp(r'\d');
    RegExp alphExp = RegExp(r'[a-zA-Z]');

    void send_OTP() async {
      // bool verified = false;
      String org_num = number.substring(1);
      String phone = "+92$org_num";
      FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          codeSent: (verificationId, forceResendingToken) {
            setState(() {
              isLoading = false;
            });
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
          verificationCompleted: (credential) {},
          verificationFailed: (ex) {
            error_dialogue_box(context, ex.toString());
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    }

    if (name == "" ||
        email == "" ||
        password == "" ||
        cpassword == "" ||
        number == "") {
      error_dialogue_box(context, "Please fill out all the fields!!");
    } else if (numExp.hasMatch(name)) {
      error_dialogue_box(context, "Name cannot contain numbers");
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).*$')
        .hasMatch(password)) {
      error_dialogue_box(context,
          "Password must contain  at least one uppercase letter, one lowercase letter, one number, and one special character!");
    } else if (password != cpassword) {
      error_dialogue_box(context, 'Passwords do not match');
    } else if (!RegExp(r'^[a-zA-Z0-9]+@gmail\.com$').hasMatch(email)) {
      error_dialogue_box(context, "Enter a valid email address");
    } else if (number[0] != "0" || number[1] != "3" || number.length != 11) {
      error_dialogue_box(context, "Please enter a valid mobile number!");
    } else if (alphExp.hasMatch(number)) {
      error_dialogue_box(context, 'Number cannot contain alphabets');
    } else {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        error_dialogue_box(context,
            "Your phone is not connected to the internet. Please check you connection and try again!!");
      } else {
        setState(() {
          isLoading = true;
        });
        send_OTP();
      }
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
            color: Color.fromRGBO(244, 241, 222, 1.0),
            fontSize: 30,
          ),
        ),
        backgroundColor: const Color.fromRGBO(67, 99, 114, 1.0),
      ),
      backgroundColor: const Color.fromRGBO(36, 63, 77, 1.0),
      resizeToAvoidBottomInset: true,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.white,
            ))
          : Center(
              child: Form(
                key: _Signupformfield,
                child: ListView(
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Center(
                        child: Text(
                          "TrekMates",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: TextField(
                          style: const TextStyle(
                            color: Color.fromRGBO(244, 241, 222, 1.0),
                          ),
                          controller: nameController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z]")),
                          ],
                          decoration: textFieldDecoration(
                              './assets/icons/person_icon.png', 'Name'),
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: TextFormField(
                          style: const TextStyle(
                              color: Color.fromRGBO(244, 241, 222, 1.0)),
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: textFieldDecoration(
                              './assets/icons/mail_icon.png', "Email"),
                        )),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: TextFormField(
                          maxLength: 11,
                          style: const TextStyle(
                              color: Color.fromRGBO(244, 241, 222, 1.0)),
                          keyboardType: TextInputType.number,
                          controller: numberController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          decoration: textFieldDecoration(
                              './assets/icons/phone.png', "Phone Number"),
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: TextField(
                            style: const TextStyle(
                                color: Color.fromRGBO(244, 241, 222, 1.0)),
                            controller: passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                                // prefixIcon: Icon(Icons),
                                prefixIcon:
                                    prefixIcon("./assets/icons/pwd_icon.png"),
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
                                fillColor:
                                    const Color.fromRGBO(67, 99, 114, 1.0)))),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: TextField(
                          style: const TextStyle(
                              color: Color.fromRGBO(244, 241, 222, 1.0)),
                          controller: passwordAgainController,
                          obscureText: _obscureText1,
                          decoration: InputDecoration(
                              // prefixIcon: Icon(Icons),
                              prefixIcon:
                                  prefixIcon("./assets/icons/pwd_icon.png"),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText1 = !_obscureText1;
                                    });
                                  },
                                  icon: Icon(_obscureText1
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
                              fillColor:
                                  const Color.fromRGBO(67, 99, 114, 1.0)),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          createAccount(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(238, 30, 30, 1),
                          fixedSize: const Size(100, 50),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(244, 241, 222, 1.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: Color.fromRGBO(244, 241, 222, 1.0),
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
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Color.fromRGBO(244, 241, 222, 1.0),
                                      fontSize: 14),
                                ))
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 1),
                        child: TextButton(
                            onPressed: () {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const PhoneSignIn(
                                            isVerified: false,
                                          )));
                            },
                            child: const Text(
                              'Signup as a Service Provider',
                              style: TextStyle(
                                  color: Color.fromRGBO(244, 241, 222, 1.0),
                                  fontSize: 18),
                            ))),
                  ],
                ),
              ),
            ),
    );
  }
}
