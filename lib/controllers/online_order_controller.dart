import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/api_calls.dart';
import '../data/route_urls.dart';
import '../data/shared_preferences_data.dart';
import '../model/onlline_order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';



class OnlineOrderController extends GetxController {
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final ApiCalls apiCalls = ApiCalls();
  var isLoading = false.obs;
  var orders = <Data>[].obs;

  int page = 0;
  final int size = 10;
  var hasMore = true.obs;

  final SharedPreferencesData prefs = SharedPreferencesData();
  /// 🔍 SEARCH
  Future<void> searchOrders() async {
    page = 0;
    hasMore.value = true;
    orders.clear();
    await _fetchOrders();
  }

  /// 📄 LOAD MORE
  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;
    page++;
    await _fetchOrders();
  }

  /// 🌐 API CALL
  Future<void> _fetchOrders() async {
    try {
      isLoading.value = true;

      await apiCalls.initializeDio();

      // 🔹 Get access token
      final accessToken = await prefs.getAccessToken();

      // Encode parameters safely
      final email = Uri.encodeQueryComponent(emailCtrl.text.trim());
      final name = Uri.encodeQueryComponent(nameCtrl.text.trim());
      final phone = Uri.encodeQueryComponent(phoneCtrl.text.trim());

      final url =
          "http://3.111.125.81/api/customer-store/customerstoreinfo-by-customer"
          "?email=$email&name=$name&phonenumber=$phone&page=$page&size=$size";

      print("🌐 Fetching orders from URL: $url");

      // 🔹 Dio request with headers
      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );

      print("📩 Response status: ${response.statusCode}");
      print("📩 Response data: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final model = OnlineOrderModel.fromJson(response.data);

        if (model.data != null && model.data!.isNotEmpty) {
          orders.addAll(model.data!);
        }

        hasMore.value = page < (model.totalPages ?? 0) - 1;
      } else {
        print("⚠ API returned non-200 status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ OnlineOrder API error: $e");
    } finally {
      isLoading.value = false;
    }
  }

}


