import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../data/api_calls.dart';
import '../data/route_urls.dart';
import '../data/shared_preferences_data.dart';
import '../model/store_business_type.dart';
import '../model/store_category.dart';
import '../model/store_details.dart';
import '../model/store_details_model.dart';
import '../model/storelist_response.dart';


class DashboardController extends GetxController {
  final ApiCalls apiCalls = ApiCalls();
  final SharedPreferencesData prefs = SharedPreferencesData();
  var stores = <StoreItem>[].obs;

  RxList<Stores> storeList = <Stores>[].obs;
  Rx<Stores?> selectedStore = Rx<Stores?>(null);
  RxBool canEdit = true.obs;


  var email = "";
  var isLoading = false.obs;

  late final businessTypeId = selectedStoreCategory.value?.storeBusinessType;
  late final storeVerificationStatus = selectedStore.value?.storeVerifiedStatus.toString() ?? "false";

  var storeCategories = <StoreCategory>[].obs;
  var selectedStoreCategory = Rxn<StoreCategory>();


  var allBusinessTypes = <StoreBusinessType>[].obs;
  var filteredBusinessTypes = <StoreBusinessType>[].obs;
  var selectedBusinessType = Rxn<StoreBusinessType>();


  final pincodeController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  final townController = TextEditingController();

  var isPincodeLoading = false.obs;
  var isVerified = false.obs;
  var isActiveStore = false.obs;
  var isVerifiedStore = false.obs;

  final RxBool _canEdit = true.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController alternateContactController = TextEditingController();
  final TextEditingController OwnerAddressContactController = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController storeId = TextEditingController();
  final TextEditingController storeName = TextEditingController();


  final storeNameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final districtCtrl = TextEditingController();
  final gstCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();
  final townCtrl = TextEditingController();
  final ownerCtrl = TextEditingController();
  final ownerAddressCtrl = TextEditingController();
  final ownerContactCtrl = TextEditingController();
  final alternateContactCtrl = TextEditingController();
  final emailCtrl = TextEditingController();


  @override
  void onReady() {
    super.onReady();
    fetchStores();
    fetchStoreCategory();
    fetchStoreBusinessType();
    fetchLocationFromPincode(pincodeController.text);
    loadDetails();
  }

  @override
  void onClose() {
    emailController.dispose();
    userNameController.dispose();
    mobileNumberController.dispose();
    OwnerAddressContactController.dispose();
    super.onClose();
  }
  void setEditPermission(bool value) {
    _canEdit.value = value;
  }

  void onStoreSelected(Stores? store) {
    if (store == null) return;

    selectedStore.value = store;

    // verified
    isVerified.value =
        store.storeVerifiedStatus == true ||
            store.storeVerifiedStatus == "true";

    // fill fields
    storeNameCtrl.text = store.name ?? "";
    locationCtrl.text = store.location ?? "";
    stateCtrl.text = store.state ?? "";
    districtCtrl.text = store.district ?? "";
    gstCtrl.text = store.gstNumber ?? "";
    pincodeCtrl.text = store.pincode ?? "";
    townCtrl.text = store.district ?? "";
    ownerCtrl.text = store.owner ?? "";
    ownerAddressCtrl.text = store.location ?? "";
    ownerContactCtrl.text = store.ownerContact ?? "";
    alternateContactCtrl.text = store.secondaryContact ?? "";
    emailCtrl.text = store.ownerEmail ?? "";

    // edit permission
    canEdit.value = store.status != "ACTIVE";
  }



  Future<void> loadDetails() async {
    String email = await prefs.getEmail();
    String userName = await prefs.getName();
    String mobileNumber = await prefs.getMobile();
    emailController.text = email;
    userNameController.text = userName;
    mobileNumberController.text= mobileNumber;
  }


  Future<void> createStoreDetails() async {
    try {
      isLoading.value = true;
      await apiCalls.initializeDio();

      Map<String, dynamic> data = {
        "storeType": selectedStoreCategory.value?.storeCategoryId ?? "",
        "id": storeId.text.trim(),
        "name": storeName.text.trim(),
        "pincode": pincodeController.text.trim(),
        "district": districtController.text.trim(),
        "gstNumber": gstController.text.trim(),
        "location": locationController.text.trim(),
        "town": townController.text.trim(),
        "state": stateController.text.trim(),
        "owner": userNameController.text.trim(),
        "ownerAddress": OwnerAddressContactController.text.trim(),
        "ownerContact": mobileNumberController.text.trim(),
        "secondaryContact": alternateContactController.text.trim(),
        "ownerEmail": emailController.text.trim(),
        "storeVerificationStatus": "false",
        "businessType": selectedBusinessType.value?.businessName ?? "",
      };

      print("Create Store Request Body: $data");

      var response = await apiCalls.postMethod(
        RouteUrls.createStoreDetails,
        data,
      );

      print("Create Store Response Status: ${response.statusCode}");
      print("Create Store Response Data: ${response.data}");

      // ✅ Check response
      if ((response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        // If responseMessage exists, show it
        if (response.data['responseMessage'] != null && response.data['responseMessage'].toString().isNotEmpty) {
          Get.snackbar("Error", response.data['responseMessage']);
        } else {
          Get.snackbar("Success", "Store created successfully");
          Get.back(); // dismiss bottom sheet
        }
      } else {
        // If API failed, check if message exists
        if (response.data != null && response.data['responseMessage'] != null) {
          Get.snackbar("Error", response.data['responseMessage']);
        } else {
          Get.snackbar("Error", "Failed to create store");
        }
      }

    } catch (e, stack) {
      print("createStoreDetails error: $e");
      print(stack);
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchLocationFromPincode(String pincode) async {
    if (pincode.length != 6) return;

    try {
      final response = await Dio().get(
        "https://api.postalpincode.in/pincode/$pincode",
      );

      if (response.statusCode == 200 &&
          response.data[0]['Status'] == 'Success') {

        final postOffice = response.data[0]['PostOffice'][0];

        stateController.text = postOffice['State'] ?? '';
        districtController.text = postOffice['District'] ?? '';
        townController.text = postOffice['Name'] ?? '';
      }
    } catch (e) {
      print("Pincode lookup error: $e");
    }
  }

  void onStoreCategoryChanged(StoreCategory? category) {
    selectedStoreCategory.value = category;

    // Clear previous selection
    selectedBusinessType.value = null;

    if (category == null) {
      filteredBusinessTypes.clear();
      return;
    }

    /// If Pharmacy → show ALL business types
    if (category.storeCategoryName == "Pharmacy") {
      filteredBusinessTypes.assignAll(allBusinessTypes);
    }
    /// Else → show ONLY Retailer
    else {
      filteredBusinessTypes.assignAll(
        allBusinessTypes.where((e) => e.businessName == "Retailer").toList(),
      );
    }

    // ✅ Automatically select the first available business type
    if (filteredBusinessTypes.isNotEmpty) {
      selectedBusinessType.value = filteredBusinessTypes.first;
    }
  }


  // void onStoreCategoryChanged(StoreCategory? category) {
  //   selectedStoreCategory.value = category;
  //   selectedBusinessType.value = null;
  //
  //   if (category == null) {
  //     filteredBusinessTypes.clear();
  //     return;
  //   }
  //
  //   /// If Pharmacy → show ALL business types
  //   if (category.storeCategoryName == "Pharmacy") {
  //     filteredBusinessTypes.assignAll(allBusinessTypes);
  //   }
  //   /// Else → show ONLY Retailer
  //   else {
  //     filteredBusinessTypes.assignAll(
  //       allBusinessTypes
  //           .where((e) => e.businessName == "Retailer")
  //           .toList(),
  //     );
  //   }
  // }


  Future<void> fetchStoreCategory() async {
    try {
      isLoading.value = true;
      await apiCalls.initializeDio();

      final response = await apiCalls.getMethod(
        RouteUrls.storeCategory,
      );

      if (response.statusCode == 200 && response.data != null) {
        final model = StoreCategoryDetailsModel.fromJson(response.data);
        storeCategories.assignAll(model.storeCategoriesList);
      }
    } catch (e) {
      print("fetchStoreCategory error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String getBusinessName(String? businessTypeId) {
    if (businessTypeId == null || businessTypeId.isEmpty) return "-";

    final match = allBusinessTypes.firstWhereOrNull(
          (e) => e.businessTypeId == businessTypeId,
    );

    return match?.businessName ?? businessTypeId;
    // fallback shows DT/RT if name not found
  }


  Future<void> fetchStoreBusinessType() async {
    try {
      isLoading.value = true;
      await apiCalls.initializeDio();

      final response = await apiCalls.getMethod(
        RouteUrls.storeBusinessType,
      );

      if (response.statusCode == 200 && response.data != null) {
        final list = (response.data as List<dynamic>)
            .map((e) => StoreBusinessType.fromJson(e))
            .toList();

        allBusinessTypes.assignAll(list);
        filteredBusinessTypes.clear(); // initially empty
      }
    } catch (e) {
      print("fetchStoreBusinessType error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchStores() async {
    try {
      print(" Dashboard fetchStores started");
      await apiCalls.initializeDio();
      String userId = await prefs.getUserId();
      String accesstoken = await prefs.getAccessToken();
      print(" UserId: $userId");
      print("accessstoken :$accesstoken");

      if (userId.isEmpty) {
        print(" UserId missing");
        return;
      }

      final response = await apiCalls.getMethod(
        "${RouteUrls.storeDetails}?userId=$userId",
      );

      print(" Status Code: ${response.statusCode}");
      print(" Response Data: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final model = StoreDetailsModel.fromJson(response.data);

        print(" Stores Count: ${model.stores.length}");

        storeList.assignAll(model.stores);
      } else {
        print(" API failed");
      }
    } catch (e, stack) {
      print(" fetchStores error: $e");
      print(" StackTrace: $stack");
    }
  }

  Future<void> updateStoreDetails() async {
    try {
      isLoading.value = true;

      final userId = await prefs.getUserId();
      debugPrint(" USER ID => $userId");

      if (selectedStore.value == null) {
        Get.snackbar("Error", "Please select a store");
        return;
      }

      if (selectedBusinessType.value == null) {
        Get.snackbar("Error", "Please select business type");
        return;
      }

      final store = selectedStore.value!;
      final businessType = selectedBusinessType.value!;

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

        /// ✅ HERE IS THE FIX
        "businessType": businessType.businessName,
      };

      debugPrint("📦 REQUEST BODY:");
      debugPrint(const JsonEncoder.withIndent('  ').convert(data));

      final response = await apiCalls.putMethod(
        RouteUrls.updateStoreDetails,
        data,
      );

      debugPrint("📥 RESPONSE:");
      debugPrint(response.data.toString());

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data;

        final bool isSuccess =
            resData['status'] == true ||
                (resData['message'] != null &&
                    resData['message']
                        .toString()
                        .toLowerCase()
                        .contains("success"));

        if (isSuccess) {
          Get.snackbar(
            "Success",
            resData['message'] ?? "Store updated successfully",
          );
        } else {
          Get.snackbar(
            "Error",
            resData['responseMessage'] ??
                resData['message'] ??
                "Update failed",
          );
        }
      } else {
        Get.snackbar("Error", "Failed to update store");
      }
    } catch (e) {
      debugPrint("❌ updateStoreDetails error: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }


}

