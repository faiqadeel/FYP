import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/dialogBox.dart';
import 'package:my_app/components/iconComponents.dart';
import 'package:my_app/components/textFieldComponent.dart';

import 'PhoneAuth/Login.dart';

class Main_Page extends StatefulWidget {
  final String provider_id;
  @override
  const Main_Page({super.key, required this.provider_id});

  @override
  State<Main_Page> createState() => MyScreen();
}

class MyScreen extends State<Main_Page> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText1 = true;

  void createAccount(String choice) async {
    String password = passwordController.text.trim();
    String cpassword = passwordAgainController.text.trim();
    String name = nameController.text.trim();
    if (password == "" || cpassword == '' || name == '') {
      error_dialogue_box(context, "Please fill out all the fields");
    } else if (password != cpassword) {
      error_dialogue_box(context, 'Passwords do not match');
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).*$')
        .hasMatch(password)) {
      error_dialogue_box(context,
          "Password must contain  at least one uppercase letter, one lowercase letter, one number, and one special character!");
    } else {
      try {
        CollectionReference collection =
            FirebaseFirestore.instance.collection('Service Providers');
        DocumentReference myDoc = await collection.add({
          'Phone Number': widget.provider_id,
          'Password': password,
          'Service Type': choice,
          'Owner Name': name,
        });
        myDoc.collection("Booking Requests");
        myDoc.collection("Accepted Requests");
        if (choice == "TransportOwner") {
          myDoc.collection("Vehicles");
        } else if (choice == "HotelOwner") {
          myDoc.collection("Rooms");
          myDoc.collection("Dishes");
        }
        success_dialogue_box(context, "Account Created Successfully");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginSP()));
      } catch (e) {
        error_dialogue_box(
            context, "An error occured while creating your account");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Service Provider', style: AppBarTextStyle()),
          centerTitle: true,
          backgroundColor: AppBarBackground(),
        ),
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                      style: const TextStyle(
                          color: Color.fromRGBO(244, 241, 222, 1.0)),
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          // prefixIcon: Icon(Icons),
                          prefixIcon:
                              prefixIcon("./assets/icons/person_icon.png"),
                          disabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: 'Enter You Name',
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: const Color.fromRGBO(67, 99, 114, 1.0)))),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                      style: const TextStyle(
                          color: Color.fromRGBO(244, 241, 222, 1.0)),
                      controller: passwordController,
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
                          fillColor: const Color.fromRGBO(67, 99, 114, 1.0)))),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    style: const TextStyle(
                        color: Color.fromRGBO(244, 241, 222, 1.0)),
                    controller: passwordAgainController,
                    obscureText: _obscureText1,
                    decoration: InputDecoration(
                        // prefixIcon: Icon(Icons),
                        prefixIcon: prefixIcon("./assets/icons/pwd_icon.png"),
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
                        fillColor: const Color.fromRGBO(67, 99, 114, 1.0)),
                  )),
              SizedBox(
                height: 20,
              ),
              const Text(
                "Please select a service:",
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  createAccount("HotelOwner");
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: button2(),
                    fixedSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                child: const Text('Hotels',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  createAccount("TransportOwner");
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: button2(),
                    fixedSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                child: const Text(
                  'Transport',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  createAccount("TourGuide");
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: button2(),
                    fixedSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                child: const Text('Tour Guide',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
