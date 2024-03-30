import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_app/user_management/login_page.dart';
import 'package:my_app/user_management/signup_page.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  void screenRedirect() async {
    deviceStorage.writeIfNull("isFirstTime", true);
    deviceStorage.read('isFirstTime') != true
        ? Get.offAll(const LoginPage())
        : Get.offAll(const SignUpPage());
  }
}
