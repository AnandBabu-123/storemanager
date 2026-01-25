import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/api_calls.dart';
import '../data/route_urls.dart';
import '../data/shared_preferences_data.dart';
import '../model/serach_user_response.dart';
import '../model/store_details.dart';


class UserDetailsController extends GetxController {
  final ApiCalls apiCalls = ApiCalls();
  final SharedPreferencesData prefs = SharedPreferencesData();
  var storeUserResponse = Rxn<SearchUserResponse>();

  var storeList = <Stores>[].obs;
  var selectedStore = Rxn<Stores>();
  var isLoading = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  // var searchedUsers = <StoreInfo>[].obs;
  var searchedUsers = <StoreInfo>[].obs; // ListView based on storeInfo
  var storeAndStoreUsers = <StoreAndStoreUser>[].obs; // storeAndStoreUser list


  @override
  void onInit() {
    super.onInit();
    fetchStores();
  }

  Future<void> addStoreUser() async {
    try {
      isLoading.value = true;
      await apiCalls.initializeDio();

      /// 🔹 VALIDATION
      if (nameController.text.isEmpty ||
          mobileController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          selectedStore.value == null) {
        Get.snackbar("Validation", "Please fill all fields");
        return;
      }

      /// 🔹 REQUEST BODY
      final Map<String, dynamic> data = {
        "userFullName": nameController.text.trim(),
        "userPhoneNumber": mobileController.text.trim(),
        "userEmail": emailController.text.trim(),
        "status": "active",
        "password": passwordController.text.trim(),
        "storeId": selectedStore.value!.id, // 👈 from dropdown
      };

      debugPrint(" ADD USER BODY: $data");

      final response = await apiCalls.postMethod(
        RouteUrls.addStoreUser,
        data,
      );

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint(" RESPONSE: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "User added successfully");

        /// 🔹 CLEAR FORM
        nameController.clear();
        mobileController.clear();
        emailController.clear();
        passwordController.clear();
        selectedStore.value = null;
      } else {
        Get.snackbar(
          "Error",
          response.data?['responseMessage'] ?? "Failed to add user",
        );
      }
    } catch (e, s) {
      debugPrint(" ADD USER ERROR: $e");
      debugPrint(" STACKTRACE:\n$s");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }




  Future<void> updateStoreUser({
    required String suUserId,
    required String username,
  }) async {
    try {
      isLoading.value = true;

      // Get access token
      String accesstoken = await prefs.getAccessToken();
      debugPrint("➡ ACCESS TOKEN: $accesstoken");

      // JSON array payload
      final List<Map<String, dynamic>> data = [
        {"username": username, "userId": suUserId}
      ];

      debugPrint("➡ UPDATE REQUEST PAYLOAD: $data");

      // Dio instance with headers including Authorization
      final dio = Dio(BaseOptions(
        baseUrl: "http://3.111.125.81/", // API host
        headers: {
          'Content-Type': 'application/json', // Use JSON
          'Accept': 'application/json',
          'Authorization': 'Bearer $accesstoken', // Pass access token
        },
      ));

      // Make PUT request
      final response = await dio.put("api/update-storeAndStoreUser", data: data);

      debugPrint("➡ UPDATE RESPONSE STATUS: ${response.statusCode}");
      debugPrint("➡ UPDATE RESPONSE DATA: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        Get.snackbar(
          "Success",
          response.data["message"] ?? "Updated successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          response.data?["message"] ?? "Update failed",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stack) {
      debugPrint(" EXCEPTION: $e");
      debugPrint("STACKTRACE: $stack");
      Get.snackbar(
        "Error",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }




  Future<void> searchUserId(String storeId) async {
    try {
      isLoading.value = true;
      await apiCalls.initializeDio();
      final url = "${RouteUrls.searchUser}?storeId=$storeId";
      final response = await apiCalls.getMethod(url);

      if (response == null || response.statusCode != 200) {
        Get.snackbar("Error", "Server error");
        return;
      }

      final parsed = SearchUserResponse.fromJson(response.data);

      searchedUsers.assignAll(parsed.storeInfo); // ListView
      storeAndStoreUsers.assignAll(parsed.storeAndStoreUser); // suUserId list
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }





  // Future<void> searchUserId(String storeId) async {
  //   try {
  //     isLoading.value = true;
  //
  //     debugPrint(" SEARCH USER API CALLED");
  //     debugPrint("➡ Store ID = $storeId");
  //
  //     await apiCalls.initializeDio();
  //
  //     final String url = "${RouteUrls.searchUser}?storeId=$storeId";
  //     debugPrint("➡ API URL = $url");
  //
  //     final response = await apiCalls.getMethod(url);
  //
  //     //  1. Check response object
  //     if (response == null) {
  //       debugPrint(" Response is NULL");
  //       Get.snackbar("Error", "No response from server");
  //       return;
  //     }
  //
  //     //  2. Log status code
  //     debugPrint(" Status Code = ${response.statusCode}");
  //
  //     //  3. Log raw response
  //     debugPrint(" Raw Response = ${response.data}");
  //
  //     //  4. Handle non-200
  //     if (response.statusCode != 200) {
  //       Get.snackbar(
  //         "Error",
  //         "Server error: ${response.statusCode}",
  //       );
  //       return;
  //     }
  //
  //     // 5. Handle empty body
  //     if (response.data == null || response.data.toString().isEmpty) {
  //       debugPrint(" Empty response body");
  //       Get.snackbar("Error", "Empty response from server");
  //       return;
  //     }
  //
  //     //  6. Parse JSON safely
  //     final SearchUserResponse parsed =
  //     SearchUserResponse.fromJson(response.data);
  //
  //     debugPrint(" API Message = ${parsed.message}");
  //     debugPrint(" Status = ${parsed.status}");
  //     debugPrint(" Users count = ${parsed.storeAndStoreUser.length}");
  //     debugPrint(" Store info count = ${parsed.storeInfo.length}");
  //
  //     //  7. Map response → UI list
  //     searchedUsers.assignAll(parsed.storeInfo);
  //
  //   } catch (e, stack) {
  //     debugPrint(" EXCEPTION: $e");
  //     debugPrint(" STACKTRACE: $stack");
  //     Get.snackbar("Error", "Something went wrong");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }



  /// Fetch stores from API and filter verified ones
  Future<void> fetchStores() async {
    try {
      isLoading(true);
      await apiCalls.initializeDio();
      final String userId = await prefs.getUserId();
      debugPrint("DEBUG: User ID = $userId");

      if (userId.isEmpty) {
        debugPrint("DEBUG: User ID is empty, skipping API call");
        return;
      }

      final response = await apiCalls.getMethod(
        "${RouteUrls.storeDetails}?userId=$userId",
      );

      debugPrint("DEBUG: Response status code = ${response?.statusCode}");
      debugPrint("DEBUG: Raw API response = ${response?.data}");

      if (response == null || response.data == null) {
        debugPrint("DEBUG: Response or response.data is null/empty");
        return;
      }

      /// Parse JSON safely
      final Map<String, dynamic> data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      debugPrint("DEBUG: Parsed JSON keys = ${data.keys}");

      StoreDetailsModel model = StoreDetailsModel.fromJson(data);

      debugPrint("DEBUG: Total stores fetched = ${model.stores.length}");
      for (var s in model.stores) {
        debugPrint("DEBUG: Store ${s.id} - ${s.name} | Verified: ${s.storeVerifiedStatus}");
      }

      // Filter verified stores safely
      var verifiedStores = model.stores.where((s) => isStoreVerified(s.storeVerifiedStatus)).toList();

      debugPrint("DEBUG: Verified stores count = ${verifiedStores.length}");
      for (var s in verifiedStores) {
        debugPrint("DEBUG: Verified Store ${s.id} - ${s.name}");
      }

      storeList.assignAll(verifiedStores);

      if (storeList.isNotEmpty) {
        selectedStore.value = storeList.first;
        debugPrint("DEBUG: Pre-selected store = ${selectedStore.value?.name}");
      } else {
        debugPrint("DEBUG: No verified stores found");
      }
    } catch (e, stacktrace) {
      debugPrint("ERROR fetching stores: $e");
      debugPrint("STACKTRACE: $stacktrace");
    } finally {
      isLoading(false);
    }
  }

  /// Safe helper: handles bool, String ("true"/"false"), null
  bool isStoreVerified(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is String) return v.toLowerCase() == 'true';
    return false;
  }
}
