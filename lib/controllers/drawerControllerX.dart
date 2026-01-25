import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerControllerX extends GetxController {
  var userId = "".obs;
  var storedUserId = "".obs;
  var name = "".obs;
  var email = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final pref = await SharedPreferences.getInstance();

    userId.value = pref.getString("userId") ?? "";
    storedUserId.value = pref.getString("storedUserIdKey") ?? "";
    name.value = pref.getString("name") ?? "";
    email.value = pref.getString("email") ?? "";
  }

  /// Optional: clear on logout
  Future<void> clearUserDetails() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();

    userId.value = "";
    storedUserId.value = "";
    name.value = "";
    email.value = "";
  }
}

