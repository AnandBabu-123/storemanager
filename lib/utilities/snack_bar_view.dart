import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storemanager/utilities/styles.dart';



class SnackBarView {
  static Future<void> showErrorMessage(var msg) async {
    Get.snackbar(
      "", // Empty title, we'll use titleText
      "", // Empty message, we'll use messageText

      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      titleText: KeyedSubtree(
        key: const Key('errorSnackBarMessage'),
        child: Text(
          key: const Key('errorSnackBarMessage2'),
          "Error",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16, // Custom title font size
            fontFamily: Styles.fontFamilyRobotoBold,
          ),
        ),
      ),
      messageText: Text(
        msg ?? "",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14, // Custom message font size
          fontFamily: Styles.fontFamilyRobotoBold,
        ),
      ),
    );
  }

  static Future<void> showSuccessMessage(var msg,{var from}) async {
    Get.snackbar(
      "",
      "",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      snackPosition: from=="login"?SnackPosition.TOP:SnackPosition.BOTTOM,
      titleText: KeyedSubtree(
        key: const Key('successSnackBarMessage'),
        child: Text(
          key: const Key('successSnackBarMessage2'),
          "Success",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: Styles.fontFamilyRobotoBold,
          ),
        ),
      ),
      messageText: Text(
        msg ?? "",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily:Styles.fontFamilyRobotoBold,
        ),
      ),
    );
  }

  static Future<void> showInfoMessage(var msg) async {
    Get.snackbar(
      "",
      "",
      backgroundColor: Colors.orange[700],
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      titleText: KeyedSubtree(
        key: const Key('infoSnackBarMessage'),
        child: Text(
          key: const Key('infoSnackBarMessage2'),
          "Attention!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily:Styles.fontFamilyRobotoBold,
          ),
        ),
      ),
      messageText: Text(
        msg ?? "",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily:Styles.fontFamilyRobotoBold,
        ),
      ),
    );
  }
}