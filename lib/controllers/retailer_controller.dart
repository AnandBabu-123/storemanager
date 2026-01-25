import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../data/api_calls.dart';
import '../data/shared_preferences_data.dart';
import '../model/retailer_purchase_model.dart';
import '../model/retailers_dropdown_model.dart';

class RetailerPurchaseController extends GetxController {
  final ApiCalls apiCalls = ApiCalls();
  final SharedPreferencesData prefs = SharedPreferencesData();
  /// 🔹 Controllers

  final TextEditingController locationCtrl = TextEditingController();

  final RxBool isFilterExpanded = true.obs;


  final RxList<String> locationList = <String>[].obs;
  final RxBool isLocationLoading = false.obs;

  /// 🔹 Dropdown values
  var businessTypes = <String>[].obs;
  var selectedBusinessType = RxnString();

  var storeList = <RetailerStoreDropdown>[].obs;
  var selectedStore = Rxn<RetailerStoreDropdown>();

  var isLoadingStore = false.obs;
  /// Result list
  RxList<RetailerStockItem> stockResults = <RetailerStockItem>[].obs;


  final ScrollController scrollController = ScrollController();


  final TextEditingController medicineCtrl = TextEditingController();
  final TextEditingController manufacturerCtrl = TextEditingController();

  bool validateMandatoryFilters() {
    if (locationCtrl.text.trim().isEmpty) {
      Get.snackbar(
        "Required",
        "Please select Location",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }



    return true;
  }


  /// Pagination
  var currentPage = 0.obs;
  var pageSize = 10.obs;
  var totalPages = 1.obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  @override
  void onInit() {
    loadBusinessTypes();
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100 &&
          !isLoadingMore.value) {
        loadMoreStock();
      }
    });
  }
  void loadMoreStock() {
    if (currentPage.value >= totalPages.value - 1) return;

    searchMedicine(
      page: currentPage.value + 1,
      isLoadMore: true,
    );
  }
  String? getStoreBusinessTypeCode() {
    final type = selectedBusinessType.value;
    if (type == null) return null;

    switch (type.toLowerCase()) {
      case 'Distributor':
        return 'DT';
      case 'Retailer':
        return 'RT';
      default:
        return null;
    }
  }


  Future<void> fetchLocations() async {
    try {
      isLocationLoading.value = true;
      await apiCalls.initializeDio();

      final response = await apiCalls.getMethod(
        "http://3.111.125.81/store/getStoreLocation?storeCategory=PH",
      );

      final List data = response.data;
      locationList.value =
          data.where((e) => e != null && e.toString().isNotEmpty)
              .map((e) => e.toString())
              .toList();
    } catch (e) {
      print("Location fetch error: $e");
    } finally {
      isLocationLoading.value = false;
    }
  }


  Future<void> searchMedicine({
    int page = 0,
    bool isLoadMore = false,
  }) async {
    try {
      /// 🔹 LOADING
      if (isLoadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        stockResults.clear();
        currentPage.value = 0;
      }

      await apiCalls.initializeDio();

      /// 🔹 QUERY PARAMS (send only what exists)
      final Map<String, String> queryParams = {
        "location": locationCtrl.text.trim(),
        "page": page.toString(),
        "size": pageSize.value.toString(),
      };

      /// ✅ Business Type (DT / RT)
      final businessTypeCode = getStoreBusinessTypeCode();
      if (businessTypeCode != null) {
        queryParams["storeBusinessType"] = businessTypeCode;
      }


      /// Optional fields
      if (medicineCtrl.text.trim().isNotEmpty) {
        queryParams["medicineName"] = medicineCtrl.text.trim();
      }

      if (manufacturerCtrl.text.trim().isNotEmpty) {
        queryParams["mfName"] = manufacturerCtrl.text.trim();
      }



      /// 🔹 BUILD URI
      final uri = Uri.http(
        "3.111.125.81",
        "/search-medicine-by-distributor",
        queryParams,
      );

      debugPrint("🌐 API URL:");
      debugPrint(uri.toString());

      /// 🔹 API CALL
      final res = await apiCalls.getMethod(uri.toString());

      debugPrint(" Status Code: ${res.statusCode}");

      if (res.statusCode == 200 && res.data != null) {
        final Map<String, dynamic> json =
        res.data is String ? jsonDecode(res.data) : res.data;

        final RetailerPurchaseModel model =
        RetailerPurchaseModel.fromJson(json);

        final List<RetailerStockItem> newItems =
            model.data
                ?.expand((e) => e.stock ?? <RetailerStockItem>[])
                .toList() ??
                [];

        stockResults.addAll(newItems);

        currentPage.value = model.currentPage ?? page;
        totalPages.value = model.totalPages ?? 1;
      }
    } catch (e, stack) {
      debugPrint(" Search Error: $e");
      debugPrint(" StackTrace: $stack");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }


  /// 🔹 Load business types (DT / RT)
  Future<void> loadBusinessTypes() async {
    try {
      await apiCalls.initializeDio();
      final res = await apiCalls.getMethod(
        "http://3.111.125.81/store/distinct-store-business-types",
      );

      if (res.statusCode == 200 && res.data != null) {
        businessTypes.value = List<String>.from(res.data);
      }
    } catch (e) {
      debugPrint(" BusinessType Error: $e");
    }
  }

  /// 🔹 Load stores based on business type + location
  Future<void> loadStores() async {
    if (selectedBusinessType.value == null ||
        locationCtrl.text.isEmpty) {
      return;
    }

    try {
      isLoadingStore.value = true;
      await apiCalls.initializeDio();

      final url =
          "http://3.111.125.81/store/search-supplier-by-store-owner"
          "?storeBusinessType=${selectedBusinessType.value}"
          "&location=${locationCtrl.text}";

      final res = await apiCalls.getMethod(url);

      if (res.statusCode == 200 && res.data != null) {
        final List list = res.data;

        storeList.value = list
            .map((e) => RetailerStoreDropdown.fromJson(e))
            .where((e) => e.storeVerifiedStatus == true)
            .toList();
      }
    } catch (e) {
      debugPrint(" Store API Error: $e");
    } finally {
      isLoadingStore.value = false;
    }
  }


  /// 🔹 Label helper
  String businessTypeLabel(String code) {
    if (code == "DT") return "Distributor";
    if (code == "RT") return "Retailer";
    return code;
  }

}
