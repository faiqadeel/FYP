import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => StartPage();
}

class StartPage extends State<LandingPage> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Welcome Page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        backgroundColor: Color(0xFF25242B),
      ),
      backgroundColor: const Color(0xFF25242B),
      body: Center(
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    context.push("/login");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(53, 52, 59, 1),
                    fixedSize: const Size(300, 50),
                  ),
                  child: const Text(
                    'Login as Tourist',
                    style: TextStyle(
                        color: Color.fromRGBO(209, 209, 209, 1), fontSize: 18),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(53, 52, 59, 1),
                    fixedSize: const Size(300, 50),
                  ),
                  child: const Text(
                    'Login as Hotel Owner',
                    style: TextStyle(
                        color: Color.fromRGBO(209, 209, 209, 1), fontSize: 18),
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
