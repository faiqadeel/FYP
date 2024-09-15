// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Service%20Providers/Screens/HotelOwner.dart';
import 'package:my_app/Service%20Providers/Screens/TourGuide.dart';
import 'package:my_app/Service%20Providers/Screens/TransportOwner.dart';
import 'package:my_app/components/dialogBox.dart';
import 'package:my_app/components/iconComponents.dart';
import 'package:my_app/components/textFieldComponent.dart';
import 'package:my_app/user_management/forgot_password.dart';

class LoginSP extends StatefulWidget {
  const LoginSP({super.key});

  @override
  State<LoginSP> createState() => Login();
}

class Login extends State<LoginSP> {
  final _Loginformfield = GlobalKey<FormState>();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _obscureText = true;

  void process_login() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      error_dialogue_box(context,
          "Your phone is not connected to the internet. Please check you connection and try again!!");
    } else {
      String phone = phoneNumber.text.trim();
      String org_num = phone.substring(1);
      String num = "+92$org_num";
      String password = passController.text.trim();

      if (phone == "" || password == "") {
        error_dialogue_box(context, 'Please fill out all the fields!');
      } else {
        try {
          QuerySnapshot serviceProvier = await FirebaseFirestore.instance
              .collection("Service Providers")
              .where('Phone Number', isEqualTo: num)
              .get();
          if (serviceProvier.docs.isNotEmpty) {
            DocumentSnapshot sp = serviceProvier.docs.first;
            String servicetype =
                (sp.data() as Map<String, dynamic>)['Service Type'];
            if (password == (sp.data() as Map<String, dynamic>)['Password']) {
              if (servicetype == "HotelOwner") {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HotelOwner(
                              provider_id: num,
                            )));
              } else if (servicetype == "TransportOwner") {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TransportOwner(provider_id: num)));
              } else {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TourGuide(provider_id: num)));
              }
            } else {
              error_dialogue_box(context, "Incorrect Password");
            }
          }
        } catch (ex) {
          error_dialogue_box(context, ex.toString());
        }
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
      resizeToAvoidBottomInset: true,
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
                    controller: phoneNumber,
                    keyboardType: TextInputType.text,
                    decoration: textFieldDecoration(
                        './assets/icons/phone.png', 'Enter your Phone Number'),
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
            ],
          ),
        ),
      ),
    );
  }
}
