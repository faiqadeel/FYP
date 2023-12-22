import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_app/user_management/landing_page.dart';
import 'package:my_app/user_management/login_page.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();

  @override
  void onReady() {
    screenRedirect();
  }

  void screenRedirect() async {
    deviceStorage.writeIfNull("isFirstTime", true);
    if (deviceStorage.read("isFirstTime")) {
      Get.offAll(const LandingPage());
    } else {
      Get.offAll(const LoginPage());
    }
  }
}
