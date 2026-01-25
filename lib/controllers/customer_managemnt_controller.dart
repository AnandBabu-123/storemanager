import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/api_calls.dart';
import '../data/route_urls.dart';
import '../utilities/snack_bar_view.dart';

class CustomerManagementController extends GetxController {

  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final addressController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();

  final ApiCalls apiCalls = ApiCalls();
  var loading = false.obs;

  /// 🔹 VALIDATION
  bool validate() {
    if (nameController.text.trim().isEmpty) {
      SnackBarView.showErrorMessage("Name is required");
      return false;
    }
    if (locationController.text.trim().isEmpty) {
      SnackBarView.showErrorMessage("Location is required");
      return false;
    }

    if (contactController.text.trim().isEmpty) {
      SnackBarView.showErrorMessage("Contact is required");
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      SnackBarView.showErrorMessage("Email is required");
      return false;
    }
    return true;
  }

  /// 🔹 API CALL
  Future<void> postCustomer() async {
    if (!validate()) return;

    loading.value = true;

    try {
      final data = {
        "name": nameController.text.trim(),
        "location": locationController.text.trim(),
        "address": addressController.text.trim(),
        "phoneNumber": contactController.text.trim(),
        "email": emailController.text.trim(),
      };

      final response =
      await apiCalls.postMethod(RouteUrls.customerManagement, data);

      if (response == null) {
        SnackBarView.showErrorMessage("No response from server");
        return;
      }

      debugPrint("Customer API Response: ${response.data}");

      // 🔹 Read values from API response
      final bool status = response.data["status"] ?? false;
      final String message =
          response.data["message"] ?? "Something went wrong";

      if (response.statusCode == 200) {
        if (status) {
          // ✅ SUCCESS CASE
          SnackBarView.showSuccessMessage(message);
          clearForm();
        } else {
          // ❌ FAILURE FROM SERVER (like: profile already exists)
          SnackBarView.showErrorMessage(message);
        }
      } else {
        SnackBarView.showErrorMessage("Server error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Customer save error: $e");
      SnackBarView.showErrorMessage("Something went wrong");
    } finally {
      loading.value = false;
    }
  }



  void clearForm() {
    nameController.clear();
    locationController.clear();
    addressController.clear();
    contactController.clear();
    emailController.clear();
  }
}
