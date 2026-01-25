
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storemanager/controllers/purchase_invoice_items.dart';
import '../data/api_calls.dart';
import '../data/route_urls.dart';
import '../data/shared_preferences_data.dart';
import '../model/added_pharmacy_model.dart' hide Data;
import '../model/get_rack_mangement.dart';
import '../model/item_searched_model.dart';
import '../model/pharmacy_storemodel.dart';
import '../model/purchase_item_model.dart';
import '../model/report_invoice_data.dart';
import '../model/sales_document_model.dart';
import '../model/sales_report_model.dart';
import '../model/user_pharmacy_model.dart';
import 'package:dio/dio.dart' as d;
import 'dart:core';

class AddPharmacyController extends GetxController {
  final ApiCalls apiCalls = ApiCalls();
  final SharedPreferencesData prefs = SharedPreferencesData();

  final TextEditingController store1Ctrl = TextEditingController();
  final TextEditingController itemCode = TextEditingController();

  final TextEditingController itemName = TextEditingController();
  final TextEditingController itemCategory = TextEditingController();

  final TextEditingController itemSubCategory = TextEditingController();
  final TextEditingController manufacturer = TextEditingController();

  final TextEditingController brand = TextEditingController();
  final TextEditingController gstNumber = TextEditingController();

  final TextEditingController hsnCode = TextEditingController();
  final TextEditingController scheduledCategory = TextEditingController();
  /// Yes / No dropdown value
  var isScheduled = RxnString();
  var isNarcotic = RxnString();

  final RxBool isStoreExpanded = false.obs;



  RxList<PurchaseInvoiceItems> purChaseItemForms =
      <PurchaseInvoiceItems>[].obs;

  RxList<ItemSearchModel> searchedItems =
      <ItemSearchModel>[].obs;


  // var invoiceDetails = Rxn<ReportInvoiceData>(); // response model
  var salesReportDetails = Rxn<SalesDocumentModel>();

  final Dio dio = Dio();


  RxBool isLoadingMore = false.obs;

  final invoiceNoCtrl = TextEditingController();
  final supplierCodeCtrl = TextEditingController();
  final supplierNameCtrl = TextEditingController();
  final purchaseDateCtrl = TextEditingController();

  // Item fields
  var itemNameCtrls = <TextEditingController>[].obs;
  var itemCodeCtrls = <TextEditingController>[].obs;
  var manufacturerCtrls = <TextEditingController>[].obs;
  var brandCtrls = <TextEditingController>[].obs;
  var gstCtrls = <TextEditingController>[].obs;
  var hsnCtrls = <TextEditingController>[].obs;


  // Search results per card

  Timer? _debounce;
  var itemIndexes = <int>[].obs;

  var purchaseList = <PurchaseItem>[].obs;
  var inVoiceList = <Invoice>[].obs;


  var itemSearchLists = <String>[].obs;

  void addItems() {
    purChaseItemForms.add(PurchaseInvoiceItems());
  }

  void removeItems(int index) {
    if (index != 0) {
      purChaseItemForms.removeAt(index);
    }
  }

  Future<void> addPurChaseInvoice() async {
    try {
      final accessToken = await prefs.getAccessToken();

      final dio = Dio(
        BaseOptions(
          baseUrl: "http://3.111.125.81/",
          headers: {
            "Authorization": "Bearer $accessToken",
            "Accept": "application/json",
          },
        ),
      );

      final body = {
        "storeId": selectedStore.value?.id,

        // 🔹 HEADER (only once)
        "invoiceNo": invoiceNoCtrl.text,
        "supplierCode": supplierCodeCtrl.text,
        "supplierName": supplierNameCtrl.text,
        "purchaseDate": purchaseDateCtrl.text,

        // 🔹 ITEM LIST
        "detailRequests": List.generate(purChaseItemForms.length, (index) {
          final f = purChaseItemForms[index];

          return {
            "itemCode": f.itemCode.text,
            "itemName": f.itemName.text,
            "mfacName": f.manufacturer.text,
            "brandName": f.brand.text,
            "batchNo": f.batchNo.text,
            "expiryDate": f.expiryDate.text,

            "mrp": double.tryParse(f.mrpPurchase.text) ?? 0,
            "purRate": double.tryParse(f.purchaseRate.text) ?? 0,
            "discount": double.tryParse(f.discount.text) ?? 0,
            "afterDiscount": double.tryParse(f.afterDiscount.text) ?? 0,

            "igstPer": double.tryParse(f.igstCtrl.text) ?? 0,
            "sgstPer": double.tryParse(f.sgstCtrl.text) ?? 0,
            "cgstPer": double.tryParse(f.cgstCtrl.text) ?? 0,

            "igstAmount": double.tryParse(f.IGSTAmount.text) ?? 0,
            "sgstAmount": double.tryParse(f.SGSTAmount.text) ?? 0,
            "cgstAmount": double.tryParse(f.CGSTAmount.text) ?? 0,

            "totalPurchasePrice":
            double.tryParse(f.totalPurchasePrice.text) ?? 0,

            "looseQty": int.tryParse(f.looseQty.text) ?? 0,
            "qtyOrBox": int.tryParse(f.boxQty.text) ?? 0,
            "packQty": int.tryParse(f.packQty.text) ?? 0,
          };
        }),
      };


      final response = await dio.post(
        "purchase/add",
        data: body,
      );
      debugPrint("📤 REQUEST BODY: $body");

      debugPrint("📥 Upload Response: ${response.data}");

      Get.snackbar("Success", "Purchase Invoice Added",
          backgroundColor: Colors.green.shade100);
    } catch (e) {
      debugPrint("❌ API ERROR: $e");
      Get.snackbar("Error", "Failed to save invoice",
          backgroundColor: Colors.red.shade100);
    }
  }


  void searchItemByName(String text) {
    debugPrint(" Typing: $text");

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (text.isEmpty) {
        searchedItems.clear();
        debugPrint(" Search cleared");
        return;
      }

      try {

        final accessToken = await prefs.getAccessToken();
        final dio = d.Dio(
          d.BaseOptions(
            baseUrl: "http://3.111.125.81/",
            headers: {
              "Authorization": "Bearer $accessToken",
              "Accept": "application/json",
            },
          ),
        );

        final response = await dio.get(
          "http://3.111.125.81/api/item/search-by-itemname?",
          queryParameters: {"itemName": text},

        );

        debugPrint("📥 Upload Response: ${response.data}");


        final List list = response.data;

        searchedItems.value =
            list.map((e) => ItemSearchModel.fromJson(e)).toList();

        debugPrint(
            "✅ Items found: ${searchedItems.length}");
      } catch (e) {
        debugPrint("❌ API ERROR: $e");
        searchedItems.clear();
      }
    });
  }

  void selectItem(ItemSearchModel item, int index) {
    debugPrint("🎯 Selected Item: ${item.itemName}");

    if (index >= purChaseItemForms.length) {
      debugPrint(" Invalid index: $index");
      return;
    }

    final form = purChaseItemForms[index];

    form.itemName.text = item.itemName;
    form.itemCode.text = item.itemCode ?? "";
    form.manufacturer.text = item.manufacturer ?? "";
    form.brand.text = item.brand ?? "";
    // form.manufacturer.text = item.manufacturer ?? "";
    // form.rack.text = item.manufacturer ?? "";
    form.gstCtrl.text = item.gst.toString() ?? "";
    form.hSNCode.text = item.hsnGroup ?? "";
    form.igstCtrl.text = item.gst.toString() ?? "";
    // form.expiryDate.text = item.manufacturer ?? "";
    // form.manufacturer.text = item.itemCode?.toString() ?? "";
    // form.manufacturer.text = item.itemCode?.toString() ?? "";
    // form.manufacturer.text = item.itemCode?.toString() ?? "";
    // form.manufacturer.text = item.itemCode?.toString() ?? "";
    // form.manufacturer.text =
    //     item.itemCode?.toString() ?? "";

    searchedItems.clear();
  }

  void addItem() {
    final index = itemIndexes.length;
    itemIndexes.add(index);



    itemNameCtrls.add(TextEditingController());
    itemCodeCtrls.add(TextEditingController());
    manufacturerCtrls.add(TextEditingController());
    brandCtrls.add(TextEditingController());
    gstCtrls.add(TextEditingController());
    hsnCtrls.add(TextEditingController());
  }

  void removeItem(int index) {
    itemIndexes.remove(index);


    itemNameCtrls.removeAt(index);
    itemCodeCtrls.removeAt(index);
    manufacturerCtrls.removeAt(index);
    brandCtrls.removeAt(index);
    gstCtrls.removeAt(index);
    hsnCtrls.removeAt(index);
  }

  var searchResults = <ItemCodeMasters>[].obs;

  var selectedFiles = <File>[].obs;
  var isUploading = false.obs;

  var storesList = <Stores>[].obs;
  var selectedStore = Rxn<Stores>();

  var rackList = <Data>[].obs;
  var isLoadingRack = false.obs;
  var isLoading = false.obs;
  var pharmacyList = <ItemCodeMasters>[].obs;

  ///  Paginations

  var currentPage = 0.obs;
  var pageSize = 10.obs;
  var totalPages = 1.obs;
  var isFetchingMore = false.obs;

  var purchaseCurrentPage = 0.obs;
  var purchaseTotalPages = 1.obs;
  var purchasePageSize = 10.obs;
  var isPurchaseLoadingMore = false.obs;

  // 🔹 Invoice pagination state
  var invoiceCurrentPage = 0.obs;
  var invoiceTotalPages = 1.obs;
  var invoicePageSize = 10.obs;
  var isInvoiceLoadingMore = false.obs;
  final lastInvoiceNo = ''.obs;
// 🔹 Data
  RxList<PurchaseInvoice> invoiceDetails = <PurchaseInvoice>[].obs;

// 🔹 Expanded row
  var expandedIndex = (-1).obs;

  // Pagination for sales report
  var salesCurrentPage = 0.obs;
  var salesPageSize = 10.obs;
  var salesTotalPages = 1.obs;
  var salesIsLoadingMore = false.obs;

// Invoice list
  RxList<Invoice> salesInvoiceList = <Invoice>[].obs;

// Expanded row index
  var salesExpandedIndex = (-1).obs;

// Loading
  var salesIsLoading = false.obs;

// Scroll controller
  final ScrollController salesScrollController = ScrollController();


// 🔹 Scroll controller
  final ScrollController invoiceScrollController = ScrollController();

  final ScrollController purchaseScrollController = ScrollController();
  final ScrollController scrollController = ScrollController();

  @override
  void onReady() {
    super.onReady();
    fetchStores();
    getPharmacyDropDown();
    addItems();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100 &&
          !isLoadingMore.value) {
        loadMore();
      }
    });

    purchaseScrollController.addListener(() {
      if (purchaseScrollController.position.pixels >=
          purchaseScrollController.position.maxScrollExtent - 100 &&
          !isPurchaseLoadingMore.value) {
        loadMorePurchase();
      }
    });

    invoiceScrollController.addListener(() {
      if (invoiceScrollController.position.pixels >=
          invoiceScrollController.position.maxScrollExtent - 100 &&
          !isInvoiceLoadingMore.value) {
        loadMoreInvoice();
      }
    });

    salesScrollController.addListener(() {
      if (salesScrollController.position.pixels >=
          salesScrollController.position.maxScrollExtent - 100 &&
          !salesIsLoadingMore.value) {
        loadMoreSalesReport();
      }
    });
  }

  void loadMoreSalesReport() {
    if (salesCurrentPage.value >= salesTotalPages.value - 1) return;

    final store = selectedStore.value;
    if (store == null) return;

    fetchSalesReport(
      store.id!,
      page: salesCurrentPage.value + 1,
      size: salesPageSize.value,
      isLoadMore: true,
    );
  }

  void loadMoreInvoice() {
    if (invoiceCurrentPage.value >= invoiceTotalPages.value - 1) return;

    final invoiceNo = lastInvoiceNo.value;
    if (invoiceNo.isEmpty) return;

    getInVoiceData(
      invoiceNo,
      isLoadMore: true,
    );
  }

  void loadMorePurchase() {
    if (purchaseCurrentPage.value >= purchaseTotalPages.value - 1) return;

    getPurChaseReport(
      selectedStore.value?.userIdStoreId ?? "",
      isLoadMore: true,
    );
  }


  Future<void> deleteUser(String rackBoxStoreIdSkuId) async {
    try {
      isLoadingRack.value = true;

      await apiCalls.getMethod(
        "${RouteUrls.deleteUser}delete?rackBoxStoreIdSkuId=$rackBoxStoreIdSkuId",
      );

      // Update UI after successful API call
      rackList.removeWhere(
            (item) => item.rackBoxStoreIdSkuId == rackBoxStoreIdSkuId,
      );

      Get.snackbar("Success", "Rack deleted successfully");

    } catch (e) {
      Get.snackbar("Error", "Failed to delete rack");
      print("Delete error: $e");
    } finally {
      isLoadingRack.value = false;
    }
  }


  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );

    if (result != null) {
      selectedFiles.assignAll(
        result.files
            .where((e) => e.path != null)
            .map((e) => File(e.path!))
            .toList(),
      );
    }
  }


  Future<void> uploadItemDocuments(String userIdStoreIdItemCode) async {
    try {
      if (selectedFiles.isEmpty) {
        Get.snackbar("Error", "Please select files");
        return;
      }

      isUploading.value = true;
      final accessToken = await prefs.getAccessToken();

      final formData = d.FormData();
      int index = 1;

      // Add real files
      for (final file in selectedFiles) {
        formData.files.add(
          MapEntry(
            "image$index",
            await d.MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
        index++;
      }

      // Ensure at least 2 images
      while (index <= 2) {
        // Create a temporary empty file
        final tempFile = File('${Directory.systemTemp.path}/empty_$index.txt');
        if (!tempFile.existsSync()) tempFile.writeAsStringSync("");

        formData.files.add(
          MapEntry(
            "image$index",
            await d.MultipartFile.fromFile(
              tempFile.path,
              filename: 'empty_$index.txt',
            ),
          ),
        );
        index++;
      }

      final dio = d.Dio(
        d.BaseOptions(
          baseUrl: "http://3.111.125.81/",
          headers: {
            "Authorization": "Bearer $accessToken",
            "Accept": "application/json",
          },
          contentType: "multipart/form-data",
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      final response = await dio.post(
        "api/item/item-code-master-image",
        queryParameters: {"userIdStoreIdItemCode": userIdStoreIdItemCode},
        data: formData,
      );

      debugPrint("📥 Upload Response: ${response.statusCode}");
      debugPrint("📥 Upload Body: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Files uploaded successfully");
        selectedFiles.clear();
      } else {
        Get.snackbar(
          "Upload Failed",
          response.data?['message'] ?? "Server error",
        );
      }
    } on d.DioException catch (e) {
      debugPrint("❌ Upload Dio error: ${e.response?.data}");
      Get.snackbar(
        "Upload Failed",
        e.response?.data?['message'] ?? "Server error",
      );
    } catch (e) {
      debugPrint("❌ Upload error: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isUploading.value = false;
    }
  }



  Future<void> updatePharmacyStore({
    required ItemCodeMasters item,
    required String updatedItemName,
    required String updatedGst,
  }) async
  {
    try {
      await apiCalls.initializeDio();

      final accessToken = await prefs.getAccessToken();
      if (accessToken.isEmpty) {
        Get.snackbar("Error", "Token missing");
        return;
      }

      /// ✅ FINAL PAYLOAD (ARRAY)
      final List<Map<String, dynamic>> data = [
        {
          "storeId": item.storeId,
          "itemCode": item.itemCode,
          "itemName": updatedItemName.trim(),
          "itemCategory": item.itemCategory,
          "itemSubCategory": item.itemSubCategory,
          "manufacturer": item.manufacturer,
          "brand": item.brand,
          "gst": int.tryParse(updatedGst) ?? item.gst ?? 0,

          /// ✅ STATIC VALUE
          "userIdStoreIdItemCode": item.userIdStoreIdItemCode,
        }
      ];

      debugPrint("➡ UPDATE PAYLOAD: $data");

      final dio = Dio(
        BaseOptions(
          baseUrl: "http://3.111.125.81/",
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final response = await dio.put(
        "api/item/update",
        data: data,
      );

      debugPrint("✅ UPDATE STATUS: ${response.statusCode}");
      debugPrint("✅ UPDATE RESPONSE: ${response.data}");

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Item updated successfully");
        searchPharmacyData(item.storeId!,); // refresh list
      }
    } catch (e, s) {
      debugPrint("❌ UPDATE ERROR: $e");
      debugPrint("🧵 STACKTRACE:\n$s");
      Get.snackbar("Error", "Update failed");
    }
  }
// . for add item we will pass userId .
  // and search item storeId

  Future<void> searchPharmacyData(
      String storeId, {
        int page = 0,
        int size = 10,
        bool isLoadMore = false,
      }) async
  {
    try {
      if (isLoadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        searchResults.clear(); // ✅ clear only for first page
      }

      await apiCalls.initializeDio();

      final response = await apiCalls.getMethod(
        "${RouteUrls.SearchPharmacyUser}get"
            "?storeId=$storeId&page=$page&size=$size",
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final pharmacyStoreModel =
        PharmacyStoreModel.fromJson(data);

        final newItems =
            pharmacyStoreModel.itemCodeMasters ?? [];

        if (isLoadMore) {
          searchResults.addAll(newItems); // ✅ append
        } else {
          searchResults.assignAll(newItems); // ✅ replace
        }

        // ✅ pagination info
        currentPage.value = pharmacyStoreModel.currentPage ?? page;
        totalPages.value = pharmacyStoreModel.totalPages ?? 1;
        pageSize.value = pharmacyStoreModel.pageSize ?? size;
      }
    } catch (e) {
      debugPrint("❌ ERROR in searchPharmacyData: $e");
      Get.snackbar("Error", "Failed to fetch pharmacy data");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }


  void loadMore() {
    if (currentPage.value >= totalPages.value - 1) return;

    final store = selectedStore.value;
    if (store == null) return;

    searchPharmacyData(
      store.id!,
      page: currentPage.value + 1,
      size: pageSize.value,
      isLoadMore: true,
    );
  }





  // Future<void> searchPharmacyData(
  //     String storeId,
  //     ) async
  // {
  //   try {
  //     isLoading.value = true;
  //     debugPrint("🔹 searchPharmacyData started for storeId: $storeId");
  //
  //     // Initialize Dio
  //     await apiCalls.initializeDio();
  //     debugPrint("🔹 Dio initialized");
  //
  //     // Make GET request
  //     debugPrint("🔹 Callingsss API: ${RouteUrls.SearchPharmacyUser}get?storeId=$storeId");
  //     final response = await apiCalls.getMethod(
  //       "${RouteUrls.SearchPharmacyUser}get?storeId=$storeId",
  //     );
  //
  //     // Log status code
  //     debugPrint("🔹 Response status code: ${response.statusCode}");
  //
  //     // Log full response body (be careful if very large)
  //     debugPrint("🔹 Response datassss: ${response.data}");
  //
  //     if (response.statusCode == 200 && response.data != null) {
  //       final data = response.data is String
  //           ? jsonDecode(response.data)
  //           : response.data;
  //
  //       debugPrint("🔹 JSON parsed successfully");
  //
  //       final pharmacyStoreModel = PharmacyStoreModel.fromJson(data);
  //       searchResults.value = pharmacyStoreModel.itemCodeMasters ?? [];
  //
  //       debugPrint("🔹 Number of stores fetched: ${searchResults.length}");
  //       for (var i = 0; i < searchResults.length; i++) {
  //      //   debugPrint("   🔹 Store[$i]: id=${searchResults[i].id}, name=${searchResults[i].name}, location=${searchResults[i].location}");
  //       }
  //     } else {
  //       debugPrint(
  //           " API call failed or returned null. Status code: ${response.statusCode}");
  //     }
  //   } catch (e, s) {
  //     debugPrint(" ERROR in searchPharmacyData: $e");
  //     debugPrint(" STACKTRACE:\n$s");
  //
  //     // Optional: show a user-friendly message
  //     Get.snackbar("Error", "Failed to fetch pharmacy data");
  //   } finally {
  //     isLoading.value = false;
  //     debugPrint("🔹 searchPharmacyData finished");
  //   }
  // }
  void loadNextPage() {
    if (isFetchingMore.value) return;

    if (currentPage.value + 1 < totalPages.value) {
      isFetchingMore.value = true;
      fetchStores(page: currentPage.value + 1).then((_) {
        isFetchingMore.value = false;
      });
    }
  }


  Future<void> addPharmacyUser() async {
    try {
      await apiCalls.initializeDio();

      final userId = await prefs.getUserId();
      if (userId.isEmpty) return;

      /// ✅ STORE ID (ONLY ID)
      final storeId = selectedStore.value?.id;

      if (storeId == null) {
        Get.snackbar("Error", "Please select a store");
        return;
      }



      // Get access token
      String accesstoken = await prefs.getAccessToken();
      debugPrint("➡ ACCESS TOKEN: $accesstoken");

      // JSON array payload
      final List<Map<String, dynamic>> data = [
        {
          "storeId": storeId,
          "itemCode": itemCode.text.trim(),
          "itemName": itemName.text.trim(),
          "itemCategory": itemCategory.text.trim(),
          "itemSubCategory": itemSubCategory.text.trim(),
          "manufacturer": manufacturer.text.trim(),
          "brand": brand.text.trim(),
          "hsnGroup": hsnCode.text.trim(),
          "gst": int.tryParse(gstNumber.text.trim()) ?? 0,

          /// YES / NO → Y / N
          "scheduledDrug": isScheduled.value?.toLowerCase() ?? "n",
          "narcotic": isNarcotic.value?.toLowerCase() ?? "n",
        }
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
      final response = await dio.post("api/item/add", data: data);



      if (response.statusCode == 200 && response.data != null) {
        final json = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final model = AddedPharmacyModel.fromJson(json);

        /// ✅ SUCCESS MESSAGE
        Get.snackbar(
          "Success",
          model.message ?? "Item added successfully",
        );
      }
    } catch (e, s) {
      debugPrint("❌ Add pharmacy error: $e");
      debugPrint("$s");
      Get.snackbar("Error", "Something went wrong");
    }
  }


  /// 🔹 API CALL
  Future<void> getPharmacyDropDown() async {
    try {
      await apiCalls.initializeDio();

      final userId = await prefs.getUserId();
      if (userId.isEmpty) return;

      final response = await apiCalls.getMethod(
        "${RouteUrls.addpharmacyUser}?userId=$userId",
      );


      if (response.statusCode == 200 && response.data != null) {
        final json = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final model = UserPharmacyModel.fromJson(json);

        /// ✅ FILTER VERIFIED STORES ONLY
        storesList.assignAll(
          model.stores
              ?.where(
                (e) =>
            e.storeVerifiedStatus == "true" &&
                e.type == "PH",
          )
              .toList() ??
              [],
        );

      }
    } catch (e, s) {
      debugPrint("❌ Dropdown API error: $e");
      debugPrint("$s");
    }
  }


  Future<void> fetchStores({int page = 0, int size = 10}) async {
    debugPrint("🔥 fetchStores CALLED");

    try {
      isLoading.value = true;

      await apiCalls.initializeDio();

      final userId = await prefs.getUserId();
      if (userId.isEmpty) return;

      final url =
          "${RouteUrls.getPharmacyStore}?userId=$userId&page=$page&size=$size";

      debugPrint("📡 API: $url");

      final response = await apiCalls.getMethod(url);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final model = PharmacyStoreModel.fromJson(data);

        /// first page → replace, next pages → append
        if (page == 0) {
          pharmacyList.assignAll(model.itemCodeMasters ?? []);
        } else {
          pharmacyList.addAll(model.itemCodeMasters ?? []);
        }

        /// pagination info (from model)
        currentPage.value = model.currentPage ?? page;
        totalPages.value = model.totalPages ?? 0;
      }
    } catch (e, s) {
      debugPrint("❌ ERROR: $e");
      debugPrint("🧵 STACKTRACE: $s");
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> getRackManagement() async {
    try {
      if (selectedStore.value == null) {
        Get.snackbar("Error", "Please select a store");
        return;
      }

      isLoadingRack.value = true;

      await apiCalls.initializeDio();

      String userId = await prefs.getUserId();
      if (userId.isEmpty) return;

      final response = await apiCalls.getMethod(
        "${RouteUrls.getRackManagement}get?userId=$userId",

      );

      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final jsonData = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final model = RackManagementModel.fromJson(jsonData);

        final filteredList = model.data
            ?.where(
              (element) =>
          element.storeId.toString() ==
              selectedStore.value!.id.toString(),
        )
            .toList() ??
            [];

        rackList.assignAll(filteredList); // ✅ IMPORTANT

        print("Rack Items Count: ${rackList.length}");
      } else {
        rackList.clear();
        Get.snackbar("Error", "No data found");
      }
    } catch (e, s) {
      print("getRackManagement error: $e");
      print(s);
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoadingRack.value = false;
    }
  }



  Future<void> addRackOrder({
    required String storeId,
    required String skuId,
    required String rackNumber,
    required String boxNo,
  }) async
  {
    try {
      String accesstoken = await prefs.getAccessToken();

      final dio = Dio(BaseOptions(
        baseUrl: "http://3.111.125.81/",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accesstoken',
        },
      ));



      final List<Map<String, dynamic>> data = [
        {
          "storeId": storeId,
          "skuId": skuId,
          "rackNumber": rackNumber,
          "boxNo": boxNo,
        }
      ];

      debugPrint("➡ REQUEST PAYLOAD: $data");

      final response = await dio.post(
        "api/rack-order/add",
        data: data,
      );

      debugPrint("✅ RESPONSE: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Rack added successfully");
      }
    } on DioException catch (e) {
      debugPrint("❌ STATUS: ${e.response?.statusCode}");
      debugPrint("❌ RESPONSE: ${e.response?.data}");

      Get.snackbar(
        "Error",
        e.response?.data.toString() ?? "Request failed",
      );
    }
  }


  /// 🔹 CALL API WITH SELECTED STORE
  Future<void> getPurChaseReport(
      String userIdStoreId, {
        bool isLoadMore = false,
      }) async {
    try {
      if (isLoadMore) {
        isPurchaseLoadingMore.value = true;
      } else {
        isLoading.value = true;
        purchaseCurrentPage.value = 0;
        purchaseList.clear();
      }

      await apiCalls.initializeDio();

      final response = await apiCalls.getMethod(
        "${RouteUrls.purchaseReport}"
            "?userIdstoreId=$userIdStoreId"
            "&page=${purchaseCurrentPage.value}"
            "&size=${purchasePageSize.value}",
      );

      if (response.statusCode == 200 && response.data != null) {
        final json = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final result =
        PurchasePaginationResponse.fromJson(json);

        if (isLoadMore) {
          purchaseList.addAll(result.purchase);
        } else {
          purchaseList.assignAll(result.purchase);
        }

        purchaseCurrentPage.value = result.currentPage;
        purchaseTotalPages.value = result.totalPages;
        purchasePageSize.value = result.pageSize;
      }
    } catch (e) {
      debugPrint("❌ Purchase Report Error: $e");
    } finally {
      isLoading.value = false;
      isPurchaseLoadingMore.value = false;
    }
  }


  Future<void> getInVoiceData(
      String invoiceNo, {
        bool isLoadMore = false,
      }) async {
    try {
      lastInvoiceNo.value = invoiceNo;

      if (isLoadMore) {
        isInvoiceLoadingMore.value = true;
      } else {
        isLoading.value = true;
        invoiceCurrentPage.value = 0;
        invoiceDetails.clear();
      }

      await apiCalls.initializeDio();

      final response = await apiCalls.getMethod(
        "${RouteUrls.fetchInvoiceData}"
            "?invoiceNo=$invoiceNo"
            "&page=${invoiceCurrentPage.value}"
            "&size=${invoicePageSize.value}",
      );

      if (response.statusCode == 200 && response.data != null) {
        final json = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final result = ReportInvoiceData.fromJson(json);

        if (isLoadMore) {
          invoiceDetails.addAll(result.purchases ?? []);
        } else {
          invoiceDetails.assignAll(result.purchases ?? []);
        }

        invoiceCurrentPage.value = result.currentPage ?? 0;
        invoiceTotalPages.value = result.totalPages ?? 1;
        invoicePageSize.value = result.pageSize ?? 10;
      }
    } catch (e) {
      debugPrint("❌ Invoice Data Error: $e");
    } finally {
      isLoading.value = false;
      isInvoiceLoadingMore.value = false;
    }
  }


  Future<void> fetchSalesReport(
      String userIdStoreId, {
        int page = 0,
        int size = 10,
        bool isLoadMore = false,
      }) async {
    try {
      if (isLoadMore) {
        salesIsLoadingMore.value = true;
      } else {
        salesIsLoading.value = true;
        salesInvoiceList.clear(); // clear only on first page
      }

      await apiCalls.initializeDio();

      final response = await apiCalls.getMethod(
        "${RouteUrls.salesReport}?userIdstoreId=$userIdStoreId&page=$page&size=$size",
      );

      if (response.statusCode == 200 && response.data != null) {
        final jsonData = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final salesReport = SalesReportModel.fromJson(jsonData);

        final newInvoices = salesReport.invoices ?? [];

        if (isLoadMore) {
          salesInvoiceList.addAll(newInvoices);
        } else {
          salesInvoiceList.assignAll(newInvoices);
        }

        // Update pagination info
        salesCurrentPage.value = salesReport.currentPage ?? page;
        salesPageSize.value = salesReport.pageSize ?? size;
        salesTotalPages.value = salesReport.totalPages ?? 1;
      }
    } catch (e, st) {
      debugPrint("❌ Sales Report Error: $e");
      debugPrint("📌 StackTrace: $st");
    } finally {
      salesIsLoading.value = false;
      salesIsLoadingMore.value = false;
    }
  }




  Future<void> getSalesData(String documentNo) async {
    try {
      isLoading.value = true;
      await apiCalls.initializeDio();

      final url = "${RouteUrls.fetchSalesReport}?docNumber=$documentNo";
      debugPrint("➡️ API URL: $url");
      http://3.111.125.81/sale/report/get-sale-invoice-details?docNumber=DOC20260106071242
      final response = await apiCalls.getMethod(url);

      debugPrint("➡️ Status Code: ${response.statusCode}");
      debugPrint("➡️ Raw Response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final jsonData = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        debugPrint("🧾 Parsed JSON Type: ${jsonData.runtimeType}");
        debugPrint("🧾 JSON Keys: ${jsonData.keys}");

        salesReportDetails.value =
            SalesDocumentModel.fromJson(jsonData);

        debugPrint("✅ Sales document parsed successfully");
      } else {
        debugPrint("❌ API failed with status: ${response.statusCode}");
      }
    } catch (e, st) {
      debugPrint("❌ Purchase Report Error: $e");
      debugPrint("📌 StackTrace: $st");
    } finally {
      isLoading.value = false;
    }
  }

}

