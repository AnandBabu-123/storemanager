
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../data/api_calls.dart';
import '../data/route_urls.dart';

class SignupController extends GetxController {
  var isLoading = false.obs;

  // Text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ApiCalls apiCalls = ApiCalls();

  var nameError = "".obs;
  var emailError = "".obs;
  var passwordError = "".obs;
  var confirmPasswordError = "".obs;
  var phoneError = "".obs;

  bool isFormValid() {
    validateName();
    validatePhoneNumber();
    validateEmail();
    validatePassword();
    validateConfirmPassword();

    return nameError.value.isEmpty &&
        phoneError.value.isEmpty &&
        emailError.value.isEmpty &&
        passwordError.value.isEmpty &&
        confirmPasswordError.value.isEmpty;
  }

  void validateName() {
    if (nameController.text.trim().isEmpty) {
      nameError.value = "Name is required";
    } else if (!RegExp(r"^[A-Za-z\s]+$").hasMatch(nameController.text.trim())) {
      nameError.value = "Enter a valid name";
    } else {
      nameError.value = "";
    }
  }

  void validatePhoneNumber() {

    // if (phoneController.text.trim().isEmpty) {
    //   phoneError.value = "Name is required";
    // }  else if (phoneController.length < 10 || phoneNumber.length > 15) {
    //   phoneError.value = "Enter a valid phone number (10–15 digits)";
    // } else {
    //   phoneError.value = "";
    // }
    //




    final phoneNumber = phoneController.text.trim();

    // If empty → no error (because it's not mandatory)
    if (phoneNumber.isEmpty) {
      phoneError.value = "phone number required";
    }
    // If not empty → check length 10–15
    else if (phoneNumber.length < 10 || phoneNumber.length > 15) {
      phoneError.value = "Enter a valid phone number (10–15 digits)";
    }
    else {
      phoneError.value = "";
    }
  }

  void validateEmail() {
    if (emailController.text.isEmpty) {
      emailError.value = "Email is required";
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
      emailError.value = "Enter a valid email address";
    } else {
      emailError.value = "";
    }
  }


  void validatePassword() {
    if (passwordController.text.isEmpty) {
      passwordError.value = "Password is required";
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*#?&.,:;])[A-Za-z\d@$!%*#?&.,:;]{8,}$')
        .hasMatch(passwordController.text)) {
      passwordError.value = "Must contain uppercase, lowercase, numbers & special characters";
    } else {
      passwordError.value = "";
    }

    // ✅ Only validate confirm password if it's filled (prevents recursion)
    if (confirmPasswordController.text.isNotEmpty && confirmPasswordError.value.isNotEmpty) {
      validateConfirmPassword();
    }
  }

  void validateConfirmPassword() {
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = "Confirm password is required";
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = "Passwords do not match";
    } else {
      confirmPasswordError.value = "";
    }

    // ✅ Only validate password if there's an error (prevents recursion)
    if (passwordController.text.isNotEmpty && passwordError.value.isNotEmpty) {
      validatePassword();
    }
  }

  Future<void> register() async {
    try {
      isLoading.value = true;

      final data = {
        "userFullName": nameController.text.trim(),
        "userEmail": emailController.text.trim(),
        "userPhoneNumber": phoneController.text.trim(),
        "password": passwordController.text.trim(),
        "role": "STORE_MANAGER",
        "status": "active",
        "storeAdminEmail": "test1234@gmail.com",
        "storeAdminMobile": "456789098",
        "addedBy": "admin",
        "store": "Pharmacy",
        "userType": "SA"
      };

      print("📤 REQUEST: $data");

      final response = await apiCalls
          .postMethod(RouteUrls.signUPUrl, data)
          .timeout(const Duration(seconds: 3000));

      print("📥 CODE: ${response.statusCode}");
      print("📥 BODY: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {

        // ✅ SUCCESS → Go to OTP screen
        Get.toNamed('/otpScreen', arguments: {
          "email": data['userEmail'],
          "phone": data['userPhoneNumber'],
        });

        Get.snackbar(
          "Success",
          response.data['responseMessage'] ??
              "OTP sent successfully",
        );

      }
      else if (response.statusCode == 400) {
        Get.snackbar(
          "Server Error",
          response.data['responseMessage'] ?? "Internal server error",
        );
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ EXCEPTION: $e");
      Get.snackbar("Network Error", "Check internet & try again");
    } finally {
      isLoading.value = false;
    }
  }



  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
