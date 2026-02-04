
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:storemanager/controllers/sales_item_form.dart';

import '../data/api_calls.dart';
import '../data/route_urls.dart';
import '../data/shared_preferences_data.dart';
import '../model/gst_report_model.dart';
import '../model/item_stock.dart';
import '../model/manual_stock_model.dart';
import '../model/order_response.dart';
import '../model/price_manage_model.dart';
import '../model/search_customer_model.dart';
import '../model/user_pharmacy_model.dart';
import '../screens/pharmacyStore/editable_price_item.dart';
import 'manual_stock_item_form.dart';

class SalesInVoiceController extends GetxController{

  final ApiCalls apiCalls = ApiCalls();
  var storesList = <Stores>[].obs;
  var selectedStore = Rxn<Stores>();
  final RxBool isLoading = false.obs;

  final RxBool isStoreExpanded = false.obs;

  final RxList<EditablePriceItem> priceList =
      <EditablePriceItem>[].obs;

  final TextEditingController fromDateCtrl = TextEditingController();
  final TextEditingController toDateCtrl = TextEditingController();

  final salesFormKey = GlobalKey<FormState>();


  RxList<SaleGst> saleGstList = <SaleGst>[].obs;
  RxList<PurchaseGst> purchaseGstList = <PurchaseGst>[].obs;

  final SharedPreferencesData prefs = SharedPreferencesData();
  var customerNameController = TextEditingController();
  var customerPhoneController = TextEditingController();

  var itemForms = <SalesItemForm>[].obs;

  var itemSearchList = <String>[].obs;
  late Dio dio;

  var manualItemForms = <ManualStockItemForm>[].obs;
  final RxList<String> itemSearchLists = <String>[].obs;
  final Rxn<OrderResponse> orderResponse = Rxn<OrderResponse>();

  late ManualStockItemForm defaultForm;

  final RxList<OrderData> orderSearchResults = <OrderData>[].obs;
  final RxBool isSearchingOrder = false.obs;

  RxString selectedOrderId = "".obs;

  RxBool isFilterExpanded = true.obs;

  final RxSet<int> expandedIndexes = <int>{}.obs;

  void toggleExpanded(int index) {
    if (expandedIndexes.contains(index)) {
      expandedIndexes.remove(index);
    } else {
      expandedIndexes.add(index);
    }
  }




  /// Dropdown values
  final List<String> deliveryStatusList = [
    "All",
    "Completed",
    "Pending",
    "ReadyToDeliver",
  ];

  final List<String> deliveryPartnerList = [
    "Delhivery",
    "Delhivery1",
  ];

  /// Selected values
  final RxString selectedDeliveryStatus = "Completed".obs;
  final RxString selectedDeliveryPartner = "Delhivery".obs;


  @override
  void onInit() {
    super.onInit();
    defaultForm = ManualStockItemForm();
    searchCustomerOrder("");
  }

  void addItem() {
    itemForms.add(SalesItemForm());
  }

  void removeItem(int index) {
    if (index != 0) {
      itemForms.removeAt(index);
    }
  }

  void addItems() {
    manualItemForms.add(ManualStockItemForm());
  }

  void removeItems(int index) {
    if (index != 0) {
      manualItemForms.removeAt(index);
    }
  }


  @override
  void onReady() {
    super.onReady();
    getPharmacyDropDown();
    searchItem();
    addItem();
    addItems();

    searchItemByNames("", defaultForm);
  }

  Future<void> pickDate({
    required BuildContext context,
    required TextEditingController controller,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
    );

    if (picked != null) {
      controller.text =
      "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }


  Future<void> gstReport() async {
    try {
      isLoading.value = true;

      final store = selectedStore.value;
      if (store == null) {
        Get.snackbar("Error", "Please select a store");
        return;
      }

      await apiCalls.initializeDio();

      final url =
          "${RouteUrls.gstReport}?userIdStoreId=${store.userIdStoreId}";

      debugPrint("➡ GST API: $url");

      final response = await apiCalls.getMethod(url);

      if (response.statusCode == 200 && response.data != null) {
        final json = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final model = GSTReportModel.fromJson(json);

        /// 🔥 STORE BOTH LISTS
        saleGstList.value = model.saleGst ?? [];
        purchaseGstList.value = model.purchaseGst ?? [];

        debugPrint(" Sale GST: ${saleGstList.length}");
        debugPrint(" Purchase GST: ${purchaseGstList.length}");
      }
    } catch (e, s) {
      debugPrint(" GST Report Error: $e");
      debugPrint("$s");
    } finally {
      isLoading.value = false;
    }
  }



  bool validateAll() {
    if (selectedStore.value == null) {
      Get.snackbar("Error", "Please select store");
      return false;
    }

    if (customerNameController.text.isEmpty ||
        customerPhoneController.text.isEmpty) {
      Get.snackbar("Error", "Enter customer details");
      return false;
    }

    for (var form in itemForms) {
      for (var entry in form.fields.entries) {
        if (entry.value.text.trim().isEmpty) {
          Get.snackbar("Error", "${entry.key} is required");
          return false;
        }
      }
    }
    return true;
  }

  Future<void> postSale() async {
    if (!validateAll()) return;

    try {
      isLoading.value = true;

      final store = selectedStore.value!;
      final accessToken = await prefs.getAccessToken();

      /// 🔹 BUILD ITEMS ARRAY (MATCH API FORMAT)
      final List<Map<String, dynamic>> detailRequests =
      itemForms.map((f) {
        return {
          "catName": "BRAND", // or f.brand.text if backend accepts dynamic
          "itemSubCategory": "TAB",
          "itemCode": f.itemCode.text,
          "itemName": f.itemName.text,
          "mfacName": f.manufacturer.text,
          "brandName": f.brand.text,
          "batchNo": f.batch.text,
          "expiryDate": f.expiryDate.text, // "" allowed

          // ---- NUMBERS AS INT ----
          "mrp": int.tryParse(f.mrp.text) ?? 0,

          // ---- STRING ----
          "discPerct": f.discount.text, // API wants string

          // ---- NUMBERS AS INT ----
          "afterDiscount": int.tryParse(f.afterDiscount.text) ?? 0,
          "igstper": int.tryParse(f.IGST.text) ?? 0,
          "sgstper": int.tryParse(f.SGST.text) ?? 0,
          "cgstper": int.tryParse(f.CGST.text) ?? 0,

          "igstamt": int.tryParse(f.IGSTAmount.text) ?? 0,
          "sgstamt": int.tryParse(f.SGSTAmount.text) ?? 0,
          "cgstamt": int.tryParse(f.CGSTAmount.text) ?? 0,

          "total": int.tryParse(f.FinalSalePrice.text) ?? 0,
          "totalPurchasePrice":
          int.tryParse(f.TotalPurchasePrice.text) ?? 0,
          "profitOrLoss":
          int.tryParse(f.ProfitOrLoss.text) ?? 0,

          // ---- STRING ----
          "qtyBox": f.BoxQuantity.text,
        };
      }).toList();

      /// 🔹 FINAL BODY (MATCH API)
      final Map<String, dynamic> body = {
        "storeId": store.id,
        "custCode":
        int.tryParse(customerPhoneController.text) ?? 0,
        "custName": customerNameController.text,
        "detailRequests": detailRequests,
      };

      debugPrint("➡ SALE REQUEST BODY: $body");

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

      final response = await dio.post("sale/add", data: body);

      debugPrint("➡ STATUS: ${response.statusCode}");
      debugPrint("➡ RESPONSE: ${response.data}");

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Sale invoice saved");

        /// 🔹 RESET FORM
        itemForms.clear();
        addItem();
        customerNameController.clear();
        customerPhoneController.clear();
      } else {
        Get.snackbar("Error", "Save failed");
      }
    } on DioException catch (e) {
      debugPrint(" STATUS: ${e.response?.statusCode}");
      debugPrint(" DATA: ${e.response?.data}");
      debugPrint(" MESSAGE: ${e.message}");
      Get.snackbar("Error", "API Error");
    } catch (e, s) {
      debugPrint(" ERROR: $e");
      debugPrint("STACK: $s");
      Get.snackbar("Error", "Unexpected Error");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> submitOffers() async {
    final selectedItems =
    priceList.where((e) => e.isSelected.value).toList();

    if (selectedItems.isEmpty) {
      Get.snackbar("Error", "Please select at least one item");
      return;
    }

    final store = selectedStore.value;
    if (store == null) {
      Get.snackbar("Error", "Store not selected");
      return;
    }

    try {
      isLoading.value = true;

      /// 🔹 GET ACCESS TOKEN
      String accessToken = await prefs.getAccessToken();
      debugPrint("➡ ACCESS TOKEN: $accessToken");

      /// 🔹 CORRECT JSON BODY (NO OUTER ARRAY )
      final Map<String, dynamic> body = {
        "storeId": store.id,
        "userId": store.userId,
        "userIdStoreId": store.userIdStoreId,
        "itemOffers": selectedItems.map((item) {
          return {
            "userIdStoreId_itemCode": item.data.userIdStoreIdItemCode,
            "batchNumber": item.data.batch,
            "discount": int.tryParse(item.discountCtrl.text) ?? 0,
            "offerQty": int.tryParse(item.offerQtyCtrl.text) ?? 0,
            "minOrderQty": int.tryParse(item.minOrderQtyCtrl.text) ?? 0,
          };
        }).toList(),
      };

      debugPrint("➡ REQUEST BODY: $body");

      /// 🔹 DIO INSTANCE
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

      /// 🔹 POST API (MATCHES POSTMAN)
      final response = await dio.post(
        "api/item-offer/add",
        data: body,
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Item offers saved successfully");

        /// Clear selection after success
        for (var item in priceList) {
          item.isSelected.value = false;
        }
      } else {
        Get.snackbar("Error", "Something went wrong");
      }
    } catch (e) {
      debugPrint("Submit Offer Error: $e");
      Get.snackbar("Error", "Failed to submit offers");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> getPriceMange() async {
    try {
      isLoading.value = true;
      await apiCalls.initializeDio();
      final store = selectedStore.value;
      if (store == null) return;

      await apiCalls.initializeDio();

      final response = await apiCalls.getMethod(
        "${RouteUrls.getPriceMange}"
            "?storeId=${store.id}"
            "&userIdStoreId=${store.userIdStoreId}"
            "&userId=${store.userId}",
      );
      if (response.statusCode == 200 && response.data != null) {
        final json = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final model = PriceManageModel.fromJson(json);

        /// 🔥 CONVERT DataItem → EditablePriceItem
        priceList.value = model.data
            ?.map((e) => EditablePriceItem(e))
            .toList() ??
            [];
      }
    } catch (e) {
      debugPrint("PriceManage Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchItem() async {
    try {
      await apiCalls.initializeDio();

      final userId = await prefs.getUserId();
      if (userId.isEmpty) return;

      final response =
      await apiCalls.getMethod(RouteUrls.searchInVoiceItem);

      if (response.statusCode == 200 && response.data != null) {
        final json = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        itemSearchList.value = List<String>.from(json);
      }
    } catch (e, s) {
      debugPrint("Item Search Error: $e");
      debugPrint("$s");
    }
  }

  /// 🔹 Call API using selected item name
  Future<void> searchItemByName(
      String itemName,
      SalesItemForm form,

      ) async
  {
    try {
      await apiCalls.initializeDio();


      final response = await apiCalls.getMethod(
        "${RouteUrls.searchInVoiceByName}=$itemName",
      );

      if (response.statusCode == 200 && response.data != null) {
        final json = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final List list = json['data'] ?? [];
        if (list.isEmpty) return;

        final item = ItemStock.fromJson(list.first);

        ///  AUTO-FILL FIELDS
        form.itemCode.text = item.itemCode ?? "";
        form.manufacturer.text = item.manufacturer ?? "";
        form.brand.text = item.brand ?? "";
        form.batch.text = item.batch ?? "";
        form.mrp.text = item.mRP?.toString() ?? "";
        form.gst.text = item.gst?.toString() ?? "";
        form.hsn.text = item.hsnGroup ?? "";
        form.TotalPurchasePrice.text = item.purRate?.toString() ?? "";

        if (item.expiryDate != null) {
          form.expiryDate.text =
              item.expiryDate!.toIso8601String().split('T').first;
        }
      }
    } catch (e, s) {
      debugPrint(" Item Search Error: $e");
      debugPrint("$s");
    }
  }


  Future<void> searchItemByNames(String itemName, ManualStockItemForm form) async {
    try {
      await apiCalls.initializeDio();

      final response = await apiCalls.getMethod(
        "${RouteUrls.searchManualStockByName}?itemName=$itemName",
      );

      debugPrint(" Status Code: ${response.statusCode}");
      debugPrint(" Response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        /// 🔹 1. Fill autocomplete list
        itemSearchLists.clear();
        itemSearchLists.addAll(
          list.map((e) => (e['itemName'] ?? "").toString().trim()).toList(),
        );

        /// 🔹 2. If user just typing → don't auto fill yet
        if (form.itemName.text != itemName) return;

        /// 🔹 3. If nothing returned
        if (list.isEmpty) {
          form.clear();
          form.itemName.text = itemName;
          return;
        }

        /// 🔹 4. Autofill using first result
        final item = ManualStockModel.fromJson(list.first);

        form.itemName.text = item.itemName?.trim() ?? itemName;
        form.itemCode.text = item.itemCode ?? "";
        form.manufacturer.text = item.manufacturer ?? "";
        // form.brand.text = item.brand ?? "";
        // form.gst.text = item.gst?.toString() ?? "";
        // form.hsn.text = item.hsnGroup ?? "";
      }
    } catch (e, s) {
      debugPrint(" Item Search Error: $e");
      debugPrint(" $s");

      form.clear();
      form.itemName.text = itemName;
    }
  }


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

        ///  FILTER VERIFIED STORES ONLY
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
      print(" Dropdown API error: $e");
      print("$s");
    }
  }

  Future<void> searchCustomerOrder(String orderId) async {
    if (orderId.isEmpty) {
      orderSearchResults.clear();
      return;
    }

    try {
      isSearchingOrder.value = true;

      await apiCalls.initializeDio();
      String userId = await prefs.getUserId();

      final response = await apiCalls.getMethod(
        "${RouteUrls.searchCustomerOrder}"
            "orderId=$orderId&retailer=$userId",
      );

      if (response.statusCode == 200 && response.data != null) {
        final model = SearchCustomerModel.fromJson(response.data);

        if (model.status == true && model.data != null) {
          orderSearchResults.assignAll(model.data!);
        } else {
          orderSearchResults.clear();
        }
      }
    } catch (e) {
      print("searchCustomerOrder error: $e");
    } finally {
      isSearchingOrder.value = false;
    }
  }

  /// observable


  Future<void> findRetailerid({
    required String orderId,
    required String customerNo,
    required String email,
    required String status,
    required String location,
    required String fromDate,
    required String toDate,
  }) async {
    orderResponse.value = null;
    try {
      isLoading.value = true;

      final String accessToken = await prefs.getAccessToken();

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

      final selectedStore = this.selectedStore.value;

      if (selectedStore == null) {
        Get.snackbar("Error", "Please select store");
        return;
      }

      /// 🔹 REQUIRED STORE ID
      if (selectedStore.userIdStoreId == null ||
          selectedStore.userIdStoreId!.isEmpty) {
        Get.snackbar("Error", "Store mapping not found");
        return;
      }

      /// 🔹 PARAM MAPPING
      final String retailerIdParam = selectedStore.userIdStoreId!;
      final String orderIdParam = orderId;

      final Map<String, String> queryParams = {
        "orderId": orderIdParam,
        "retailerId": retailerIdParam,
        "location": location,
        "fromDate": fromDate,
        "toDate": toDate,
        "orderStatus": status,
        "customerNumber": customerNo,
        "customerEmail": email,
      };

      /// 🔹 REMOVE EMPTY VALUES
      queryParams.removeWhere((k, v) => v.isEmpty);

      debugPrint("➡ API PARAMS: $queryParams");

      final response = await dio.get(
        "/order/details",
        queryParameters: queryParams,
      );

      debugPrint("➡ STATUS CODE: ${response.statusCode}");
      debugPrint("➡ RESPONSE: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        /// 🔥 API RETURNS LIST
        if (data is List && data.isNotEmpty) {
          orderResponse.value = OrderResponse.fromJson(data[0]);

          debugPrint(
              " Order ID: ${orderResponse.value?.orderHdr?.orderId}");
          debugPrint(
              " Customer ID: ${orderResponse.value?.orderHdr?.customerId}");
          debugPrint(
              " Retailer ID: ${orderResponse.value?.orderHdr?.retailerId}");
          debugPrint(
              " Order Status: ${orderResponse.value?.orderHdr?.orderStatus}");

          Get.snackbar("Success", "Order details fetched successfully");
        } else {
          Get.snackbar("Error", "There is no data ");
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } on DioException catch (e) {
      debugPrint(" DIO ERROR: ${e.message}");
      debugPrint(" RESPONSE: ${e.response?.data}");
      Get.snackbar("Error", "Network error occurred");
    } catch (e, s) {
      debugPrint(" UNEXPECTED ERROR: $e");
      debugPrint(" STACKTRACE: $s");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> addSalesInvoice() async {
    try {
      final accessToken = await prefs.getAccessToken();

      final dio = Dio(
        BaseOptions(
          baseUrl: "http://3.111.125.81/",
          headers: {
            "Authorization": "Bearer $accessToken",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );

      final body = {
        "storeId": selectedStore.value?.id,

        // 🔹 HEADER
        "custCode": int.tryParse(customerPhoneController.text) ?? 0,
        "custName": customerNameController.text,

        // 🔹 ITEMS
        "detailRequests": List.generate(itemForms.length, (index) {
          final f = itemForms[index];

          return {
            "catName": "BRAND",                       // static / if API needs
            "itemSubCategory": "TAB",                // static / from dropdown

            "itemCode": f.itemCode.text,
            "itemName": f.itemName.text,
            "mfacName": f.manufacturer.text,
            "brandName": f.brand.text,
            "batchNo": f.batch.text,
            "expiryDate": f.expiryDate.text,

            "mrp": double.tryParse(f.mrp.text) ?? 0,
            "discPerct": double.tryParse(f.discount.text) ?? 0,
            "afterDiscount":
            double.tryParse(f.afterDiscount.text) ?? 0,

            "igstper": double.tryParse(f.IGST.text) ?? 12,
            "sgstper": double.tryParse(f.SGST.text) ?? 6,
            "cgstper": double.tryParse(f.CGST.text) ?? 6,

            "igstamt":
            double.tryParse(f.IGSTAmount.text) ?? 0,
            "sgstamt":
            double.tryParse(f.SGSTAmount.text) ?? 0,
            "cgstamt":
            double.tryParse(f.CGSTAmount.text) ?? 0,

            "total":
            double.tryParse(f.FinalSalePrice.text) ?? 0,

            "totalPurchasePrice":
            double.tryParse(f.TotalPurchasePrice.text) ?? 0,

            "profitOrLoss":
            double.tryParse(f.ProfitOrLoss.text) ?? 0,

            "qtyBox":
            int.tryParse(f.BoxQuantity.text) ?? 0,
          };
        }),
      };

      debugPrint(" REQUEST BODY: $body");

      final response = await dio.post(
        "sale/add",
        data: body,
      );

      debugPrint(" Upload Response: ${response.data}");

      Get.snackbar(
        "Success",
        "Sales Invoice Added",
        backgroundColor: Colors.green.shade100,
      );
    } catch (e, s) {
      debugPrint(" API ERROR: $e");
      debugPrint("$s");

      Get.snackbar(
        "Error",
        "Failed to save invoice",
        backgroundColor: Colors.red.shade100,
      );
    }
  }


  Future<void> addManualInvoice() async {
    try {
      final accessToken = await prefs.getAccessToken();

      final dio = Dio(
        BaseOptions(
          baseUrl: "http://3.111.125.81/",
          headers: {
            "Authorization": "Bearer $accessToken",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );

      // 🔹 Prepare request body
      final body = {
        "storeId": selectedStore.value?.id ?? "",
        "items":manualItemForms.map((f) {
          return {
            "manufacturer": f.manufacturer.text,
            "mfName": f.manufacturerName.text,
            "itemCode": f.itemCode.text,
            "itemName": f.itemName.text,
            "supplierName": f.supplier.text,
            "rack": f.rack.text,
            "batch": f.batch.text,
            "expiryDate": f.expiryDate.text,
            "balQuantity": int.tryParse(f.balQty.text) ?? 0,
            "balPackQuantity": int.tryParse(f.balPackQty.text) ?? 0,
            "balLooseQuantity": int.tryParse(f.balLoose.text) ?? 0,
            "total": f.qtyTotal.text,
            "mrpPack": double.tryParse(f.mrpPack.text) ?? 0,
            "purRatePerPackAfterGST": double.tryParse(f.purRate.text) ?? 0,
            "mrpValue": double.tryParse(f.mrpValue.text) ?? 0,
            "itemCategory": f.category.text,
            "onlineYesNo": f.online.text.isNotEmpty ? f.online.text : "No",
            "stockValueMrp": double.tryParse(f.stockValueMRP.text) ?? 0,
            "stockValuePurrate": double.tryParse(f.stockValuePurRate.text) ?? 0,
          };
        }).toList(),
      };

      debugPrint(" REQUEST BODY: $body");

      final response = await dio.post(
        "stock/add-stock-manually",
        data: body,
      );

      debugPrint(" Upload Response: ${response.data}");

      Get.snackbar(
        "Success",
        "Manual Stock Added",
        backgroundColor: Colors.green.shade100,
      );
    } catch (e, s) {
      debugPrint(" API ERROR: $e");
      debugPrint("$s");

      Get.snackbar(
        "Error",
        "Failed to save invoice",
        backgroundColor: Colors.red.shade100,
      );
    }
  }

  Future<void> submitDeliveryStatus({required String orderId}) async {
    try {
      isLoading.value = true;
      await apiCalls.initializeDio();

      final body = {
        "orderId": orderId,
        "deliveryStatus": selectedDeliveryStatus.value,
        "deliveryPartner": selectedDeliveryPartner.value,
      };

      final Response response = await apiCalls.postMethod(
        RouteUrls.postDeliveryStatus,
        body,
      );

      /// ✅ FIX HERE
      final responseData = response.data;

      if (responseData != null && responseData["message"] != null) {
        Get.snackbar(
          "Info",
          responseData["message"].toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Submit Delivery Status Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

}