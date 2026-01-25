
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesData {
  static const String accessToken = "accessToken";
  static const String userId = "userId";
  static const String loginStatus = "loginStatus";
  static const String name ="name";
  static const String email ="email";
  static const String mobile ="mobile";
  static const String secondaryMobile ="secondaryMobile";
  static const String address ="address";
  static const String companyName ="companyName";
  static const String website ="website";
  static const String position ="position";
  static const String note ="notes";
  static const String fromMenu ="fromMenu";
  static const String tutorialShown = "tutorialShown";
  static const String hasSeenTutorial = "hasSeenTutorial";
  static const String userType = "userType";
  static const String dashboardRole = "dashboardRole";
  static const String storedUserIdKey = "stored_user_id";

  Future<void> saveAccessToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(accessToken, token);
  }

  Future<void> removeFromSharedPreference(String key) async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(key);
  }


  Future<void> clearAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Clear all stored keys
    await prefs.remove(SharedPreferencesData.accessToken);
    await prefs.remove(SharedPreferencesData.loginStatus);
    await prefs.remove(SharedPreferencesData.userId);
    await prefs.remove(SharedPreferencesData.email);           // ✅ Clear email
    await prefs.remove(SharedPreferencesData.fromMenu);        // ✅ Clear fromMenu
    // await prefs.remove(SharedPreferencesData.hasSeenTutorial); // ✅ Clear tutorial status
  }

  Future<String> getAccessToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(accessToken) ?? "";
  }

  Future<void> saveUserId(String usersId) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(userId, usersId);
  }
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String> getUserId() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userId) ?? "";
  }

  Future<void> saveStoredUserId(String userIdStoreId) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(storedUserIdKey, userIdStoreId);
  }

  Future<String> getStoredUserId() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(storedUserIdKey) ?? "";
  }

  Future<void> saveLoginStatus(bool logInStatus) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(loginStatus, logInStatus);
  }
  Future<void> saveLoginTime(int time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("login_time", time);
  }

  Future<int?> getLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("login_time");
  }


  Future<bool> getLoginStatus() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(loginStatus) ?? false;
  }
  Future<void> saveName(String username) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(name, username);
  }

  Future<String> getName() async {
    final pref = await SharedPreferences.getInstance();
   return pref.getString(name) ?? "";
  }
  Future<void> saveEmail(String emailid) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(email, emailid);
  }

  Future<String> getEmail() async {
    final pref = await SharedPreferences.getInstance();
   return pref.getString(email) ?? "";
  }
  Future<void> saveMobile(String mobileno) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(mobile, mobileno);
  }

  Future<String> getMobile() async {
    final pref = await SharedPreferences.getInstance();
   return pref.getString(mobile) ?? "";
  }

  Future<void> saveUserType(String type) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(userType, type);
  }

  Future<String> getUserType() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userType) ?? "";
  }

  Future<void> saveDashboardRole(String role) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(dashboardRole, role);
  }

  Future<String> getDashboardRole() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(dashboardRole) ?? "";
  }

  Future<void> saveSecondaryMobile(List<String> secondaryMobile) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setStringList("secondary_mobile_numbers", secondaryMobile);
  }

  Future<List<String>> getSecondaryMobile() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getStringList("secondary_mobile_numbers") ?? [];
  }



  Future<void> saveSecondaryEmail(List<String> secondaryEmail) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setStringList("secondary_email_addresses", secondaryEmail);
  }

  Future<List<String>> getSecondaryEmail() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getStringList("secondary_email_addresses") ?? [];
  }



  // Future<void> saveAddress(String addres) async {
  //   final pref = await SharedPreferences.getInstance();
  //   await pref.setString(address, addres);
  // }
  //
  // Future<String> getAddress() async {
  //   final pref = await SharedPreferences.getInstance();
  //  return pref.getString(address) ?? "";
  // }
  Future<void> saveAddress(List<String> addresses) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setStringList("addresses", addresses);
  }

  Future<List<String>> getAddress() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getStringList("addresses") ?? [];
  }

  Future<void> saveCompanyNames(List<String> companyNames) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setStringList("company_names", companyNames);
  }


  Future<List<String>> getCompanyNames() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getStringList("company_names") ?? [];
  }

  Future<void> saveWebsite(List<String> web) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setStringList(website, web);
  }
  Future<List<String>> getWebsite() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getStringList(website) ?? [];
  }

  Future<void> savePosition(String role) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(position, role);
  }

  Future<String> getPosition() async {
    final pref = await SharedPreferences.getInstance();
   return pref.getString(position) ?? "";
  }
  Future<void> saveNote(String notes) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(note, notes);
  }

  Future<String> getNote() async {
    final pref = await SharedPreferences.getInstance();
   return pref.getString(note) ?? "";
  }

  // String email, String Mobile,String address,
  //     String companyName, String website, String position, String notes

  Future<void> saveFromMenu(bool isFromMenu) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(fromMenu, isFromMenu);
  }

  Future<bool> getFromMenu() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(fromMenu) ?? false;
  }
  Future<bool> getTutorialShown() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(tutorialShown) ?? false;
  }

  Future<void> saveTutorialShown(bool isTutorialShown) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(tutorialShown, isTutorialShown);
  }
  // Future<void> showFeatureDiscoveryIfFirstTime() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final hasSeenTutorial = prefs.getBool(SharedPreferencesData.hasSeenTutorial) ?? false;
  //   saveTutorialShown(false);
  //   if (!hasSeenTutorial) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       FeatureDiscovery.discoverFeatures(
  //         Get.context!,
  //         [
  //           Constants.scanFeatureId,
  //           Constants.profileFeatureId,
  //           Constants.searchFeatureId,
  //           Constants.sortFeatureId,
  //           Constants.cardsTabFeatureId,
  //           Constants.groupsTabFeatureId,
  //         ],
  //       );
  //     });
  //     prefs.setBool(SharedPreferencesData.hasSeenTutorial, true);
  //     saveTutorialShown(true);
  //   }
  // }

}
