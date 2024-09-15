// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:my_app/firebase_options.dart';
// import 'package:my_app/user_management/login_page.dart';
// import 'package:my_app/user_management/signup_page.dart';

// Future<void> main() async {
// // Adding Widget Bindings
//   WidgetsFlutterBinding.ensureInitialized();

// //GetX Local Storage
//   await GetStorage.init();

//   // FlutterNativeSplash.preserve(widgetsBinding: wb);

// // Initializing FireBase

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   User? user = FirebaseAuth.instance.currentUser;
//   await user!.reload();
//   UserMetadata metadata = user.metadata;

//   runApp(const Screen(
//     user: metadata,
//   ));
// }

// class Screen extends StatelessWidget {
//   final UserMetadata user;
//   const Screen({super.key, required this.user});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         theme: ThemeData(
//           textTheme: GoogleFonts
//               .aBeeZeeTextTheme(), // Apply Poppins font to the entire theme
//         ),
//         debugShowCheckedModeBanner: false,
//         home: isFirstTime ? SignUpPage() : LoginPage());
//   }
// }
//         // home: (FirebaseAuth.instance.currentUser != null)
//         //     ? const LoginPage()
//         //     : const SignUpPage(),
//         // TripScreen(tripName: 'Winter Trip')
//         // const NewTrip(createdBy: "sherry", friends: [
//         //   'friends',
//         //   'hello',
//         //   'lets check',
//         //   "hii",
//         //   'feg',
//         //   'fgfd',
//         //   'sgrsr',
//         //   'grgr',
//         //   'erge'
//         // ])

//         // home: const Scaffold(
//         //     backgroundColor: Colors.blue,
//         //     body: Center(
//         //       child: CircularProgressIndicator(
//         //         color: Colors.white,
//         //       ),
//         //     ))

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:my_app/firebase_options.dart';

import 'user_management/Home_Page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> isFirstRun() async {
    // This function should asynchronously determine if this is the first run of the app.
    // Placeholder logic here, replace it with your actual check.
    return await IsFirstRun.isFirstRun();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.aBeeZeeTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: isFirstRun(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // if (snapshot.data ?? true) {
            //   // If true, navigate to the SignUpPage
            //   return const SignUpPage();
            // } else {
            //   // Otherwise, navigate to the LoginPage
            //   return const LoginPage();
            // }
            // return scrollableGridExample();
            // return HomeScreen(email: "faiq12@gmail.com");
            return const HomeScreen(email: "faiq12@gmail.com");
          } else {
            // While checking, show a loading spinner or similar widget
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
