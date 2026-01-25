import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../data/shared_preferences_data.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final SharedPreferencesData prefs = SharedPreferencesData();

  Future<String> getInitialRoute() async {
    bool isLoggedIn = await prefs.getLoginStatus();
    if (!isLoggedIn) return AppRoutes.loginView;

    int? loginTime = await prefs.getLoginTime();
    if (loginTime == null) return AppRoutes.loginView;

    final now = DateTime.now().millisecondsSinceEpoch;
    final diff = now - loginTime;

    // 24 HOURS = 24 * 60 * 60 * 1000
    if (diff > 24 * 60 * 60 * 1000) {
      await logout();
      return AppRoutes.loginView;
    }

    return AppRoutes.dashBoardView;
  }

  Future<void> logout() async {
    await prefs.clearAll();
  }
}

