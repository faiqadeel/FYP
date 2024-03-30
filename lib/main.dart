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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:my_app/touristDashboard/Profile.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  Future<bool> isFirst() async {
    bool first = await IsFirstRun.isFirstRun();
    return first;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.aBeeZeeTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        // home: HomeScreen(email:"faiq12@gmail.com")
        home: const Profile(
          name: "name",
          friendName: "def",
        )
        // isFirst == false ? const LoginPage() : const SignUpPage()
        // isFirstTime ? const SignUpPage() : const LoginPage(),
        );
  }
}

// Method to check if it's the user's first sign-in
Future<bool> isFirstSignIn() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await user.reload();
    UserMetadata metadata = user.metadata;
    return metadata.creationTime == metadata.lastSignInTime;
  }
  return false; // Return false if user is not signed in
}
