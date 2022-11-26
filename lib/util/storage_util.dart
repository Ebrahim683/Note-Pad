import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:note_pad/pages/auth/login_page.dart';
import 'package:note_pad/pages/home/home_page.dart';

class StorageUtil {
  static final box = GetStorage();

  static saveId(String uid) {
    box.write('uid', uid);
  }

  static String getUid() {
    var uid = box.read('uid');
    return uid;
  }

  static isLoggedIn() {
    final uid = box.read('uid');
    if (uid == null) {
      Get.off(const LoginPage());
    } else {
      Get.off(const HomePage());
    }
  }

  static logOut() {
    box.remove('uid');
    Get.offAll(const LoginPage());
  }
}
