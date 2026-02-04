import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/api_calls.dart';
import '../data/route_urls.dart';
import '../data/shared_preferences_data.dart';
import '../model/store_category.dart';
import '../model/store_details_model.dart';
import '../model/storelist_response.dart';
import 'dart:io';
import 'package:dio/dio.dart' as d;
import 'dart:core';
import 'package:get/get.dart';


class UpdateDetailsController extends GetxController {
  /// STORE LIST
  var stores = <StoreItem>[].obs;
  var selectedStore = Rxn<StoreItem>();

  var isEditable = true.obs;
  var isActiveStore = false.obs;
  RxBool isStoreVerified = false.obs;

  final formKeyUpdateStore = GlobalKey<FormState>();

  /// STORE CATEGORY
  var storeCategories = <StoreCategory>[].obs;
  var selectedStoreCategory = Rxn<StoreCategory>();

  /// STATUS
  final status = "".obs; // "ACTIVE" or "INACTIVE"

  /// LOADING
  var isLoading = false.obs;

  final ApiCalls apiCalls = ApiCalls();
  final SharedPreferencesData prefs = SharedPreferencesData();

  var storeFrontImage = Rxn<File>();
  var tradeLicense = Rxn<File>();
  var drugLicense = Rxn<File>();

  late final businessTypeId = selectedStoreCategory.value?.storeBusinessType;
  late final storeVerificationStatus = selectedStore.value?.storeVerifiedStatus.toString() ?? "false";

  final businessTypes = <StoreCategory>[].obs;
  final selectedBusinessType = Rxn<StoreCategory>();

  /// TEXT CONTROLLERS
  final storeName = TextEditingController();
  final pincodeController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();
  final townController = TextEditingController();
  final userNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final emailController = TextEditingController();
  final gstController = TextEditingController();


  @override
  void onInit() {
    super.onInit();
    fetchStoresFromApi();
    fetchStoreCategory();
    fetchBusinessTypes();
  }


  Future<void> fetchBusinessTypes() async {
    try {
      final response = await apiCalls.getMethod(
        "http://3.111.125.81/api/adminStoreBusinessType/get",
      );

      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data;
        businessTypes.value =
            list.map((e) => StoreCategory.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint(" fetchBusinessTypes error: $e");
    }
  }

  Future<void> uploadDocuments() async {
    try {
      if (selectedStore.value == null) {
        Get.snackbar("Error", "Please select a store");
        return;
      }

      final store = selectedStore.value!;
      final userIdStoreId = store.userIdStoreId;

      // Check if at least one file is selected
      if (storeFrontImage.value == null &&
          tradeLicense.value == null &&
          drugLicense.value == null) {
        Get.snackbar("Error", "Please select at least one file to upload");
        return;
      }

      isLoading.value = true;
      // await apiCalls.initializeDio(); // Ensure Dio instance is initialized

      // Prepare FormData
      final formData = d.FormData();

      // Helper to create Dio MultipartFile
      Future<d.MultipartFile> _createMultipartFile(File file) async {
        return await d.MultipartFile.fromFile(
          file.path,
          filename: file.path.split("/").last,
        );
      }

      // Add files if selected
      if (storeFrontImage.value != null) {
        formData.files.add(MapEntry(
          "storeFrontImage",
          await _createMultipartFile(storeFrontImage.value!),
        ));
      }

      if (tradeLicense.value != null) {
        formData.files.add(MapEntry(
          "tradeLicense",
          await _createMultipartFile(tradeLicense.value!),
        ));
      }

      if (drugLicense.value != null) {
        formData.files.add(MapEntry(
          "drugLicense",
          await _createMultipartFile(drugLicense.value!),
        ));
      }

      // Call multipart API
      final response = await apiCalls.multipartPostMethod(
        "${RouteUrls.uploadDocuments}?userIdStoreId=$userIdStoreId",
        formData,
      );

      debugPrint(" Upload Response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['status'] == true) {
          Get.snackbar("Success", "Documents uploaded successfully");
        } else {
          Get.snackbar(
            "Error",
            response.data['responseMessage'] ?? "Upload failed",
          );
        }
      } else {
        Get.snackbar("Error", "Failed to upload documents");
      }
    } catch (e) {
      debugPrint(" uploadDocuments error: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> updateStoreDetails() async {
    try {
      isLoading.value = true;

      // 🔵 SHOW LOADER
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      if (selectedStore.value == null) {
        Get.back(); // close loader
        Get.snackbar("Error", "Please select a store");
        return;
      }

      final store = selectedStore.value!;

      final Map<String, dynamic> data = {
        "storeType": store.type,
        "id": store.id,
        "name": storeName.text.trim(),
        "pincode": pincodeController.text.trim(),
        "district": districtController.text.trim(),
        "location": townController.text.trim(),
        "town": townController.text.trim(),
        "state": stateController.text.trim(),
        "gstNumber": gstController.text.trim(),
        "owner": userNameController.text.trim(),
        "ownerAddress": "hyderabad",
        "ownerContact": mobileNumberController.text.trim(),
        "secondaryContact": store.secondaryContact ?? "",
        "ownerEmail": emailController.text.trim(),
        "storeVerificationStatus": storeVerificationStatus,
        "businessType": selectedBusinessType.value?.businessName ?? "",
      };

      final response = await apiCalls.putMethod(
        RouteUrls.updateStoreDetails,
        data,
      );

      // 🔴 ALWAYS CLOSE LOADER
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Store updated successfully");
      } else {
        Get.snackbar("Error", "Update failed");
      }
    } catch (e) {
      // 🔴 CLOSE LOADER ON ERROR TOO
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }



  /// ---------------- STORE CATEGORY ----------------
  // Future<void> fetchStoreCategory() async {
  //   try {
  //     isLoading.value = true;
  //     await apiCalls.initializeDio();
  //
  //     final response = await apiCalls.getMethod(RouteUrls.storeCategory);
  //
  //     if (response.statusCode == 200 && response.data != null) {
  //       final model = StoreCategoryDetailsModel.fromJson(response.data);
  //       storeCategories.assignAll(model.storeCategoriesList);
  //     }
  //   } catch (e) {
  //     debugPrint("fetchStoreCategory error: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


  Future<void> fetchStoreCategory() async {
    try {
      isLoading.value = true;
      await apiCalls.initializeDio();

      final response = await apiCalls.getMethod(RouteUrls.storeCategory);

      if (response.statusCode == 200 && response.data != null) {
        final model = StoreCategoryDetailsModel.fromJson(response.data);

        /// ✅ Filter only "Pharmacy"
        final pharmacyList = model.storeCategoriesList
            ?.where((e) => e.storeCategoryName == "Pharmacy")
            .toList() ??
            [];

        storeCategories.assignAll(pharmacyList);

        /// ✅ Auto-select Pharmacy
        if (storeCategories.isNotEmpty) {
          selectedStoreCategory.value = storeCategories.first;
        }
      }
    } catch (e) {
      print("fetchStoreCategory error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- STORE LIST ----------------
  Future<void> fetchStoresFromApi() async {
    try {
      isLoading.value = true;

      await apiCalls.initializeDio();
      final userId = await prefs.getUserId();

      final response = await apiCalls.getMethod(
        "${RouteUrls.storeDetails}?userId=$userId",
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final List list = data['stores'] ?? [];

        final storeList =
        list.map((e) => StoreItem.fromJson(e)).toList();

        stores.assignAll(storeList);

        /// ✅ SAVE userIdStoreId IN SHARED PREF
        if (storeList.isNotEmpty) {
          await prefs.saveStoredUserId(
            storeList.first.userIdStoreId,
          );

          debugPrint(
            "💾 Saved userIdStoreId => ${storeList.first.userIdStoreId}",
          );
        }
      }
    } catch (e) {
      debugPrint(" fetchStoresFromApi error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  void onStoredSelected(StoreItem? store) {
    if (store == null) return;

    selectedStore.value = store;

    print("RAW storeVerifiedStatus: ${store.storeVerifiedStatus}");

    isStoreVerified.value =
        store.storeVerifiedStatus.toString().toLowerCase().trim() == 'true' ||
            store.storeVerifiedStatus.toString().trim() == '1';


    print("Selected Store Verifiedsss: ${isStoreVerified.value}");
  }



  void onStoreSelected(StoreItem? store) async {

    if (store == null) return;


    selectedStore.value = store;

    /// find matching business type
    final match = businessTypes.firstWhereOrNull(
          (e) => e.businessName == store.storeBusinessType,
    );

    if (match != null) {
      selectedBusinessType.value = match;
    }

    /// 🔹 Autofill fields
    storeName.text = store.name;
    pincodeController.text = store.pincode;
    districtController.text = store.district;
    stateController.text = store.state;
    townController.text = store.location;
    userNameController.text = store.owner;
    mobileNumberController.text = store.ownerContact;
    emailController.text = store.ownerEmail;
    gstController.text = store.gstNumber;

    /// 🔹 STATUS LOGIC
    if (store?.storeVerifiedStatus == "true") {
      isEditable.value = false;     // 🔒 lock
    } else {
      isEditable.value = true;      // ✏️ allow edit
    }
    /// 🔹 SAVE SELECTED STORE ID
    await prefs.saveStoredUserId(store.userIdStoreId);

    debugPrint(" Stored Selected userIdStoreId => ${store.userIdStoreId}");
  }


  /// ---------------- CLEANUP ----------------
  @override
  void onClose() {
    storeName.dispose();
    pincodeController.dispose();
    districtController.dispose();
    stateController.dispose();
    townController.dispose();
    userNameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    gstController.dispose();
    super.onClose();
  }
}


