import 'package:flutter/material.dart';
import 'package:my_app/components/iconComponents.dart';

class PasswordSetup extends StatefulWidget {
  const PasswordSetup({super.key});

  @override
  State<PasswordSetup> createState() => _PasswordSetupState();
}

class _PasswordSetupState extends State<PasswordSetup> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText1 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
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
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'password',
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: const Color.fromRGBO(67, 99, 114, 1.0)),
                )),
          ],
        ),
      ),
    );
  }
}
