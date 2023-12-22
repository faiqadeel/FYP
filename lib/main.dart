import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/firebase_options.dart';
import 'package:my_app/user_management/login_page.dart';
import 'package:my_app/user_management/signup_page.dart';

void main() async {
// Adding Widget Bindings
  WidgetsFlutterBinding.ensureInitialized();

// // // Initializing FireBase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const Screen());
}

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts
            .exoTextTheme(), // Apply Poppins font to the entire theme
      ),
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null)
          ? const LoginPage()
          : const SignUpPage(),
      // home: const HomeScreen(email: "faiq12@gmail.com"),
    );
  }
}
