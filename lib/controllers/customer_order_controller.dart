
import 'package:get/get.dart';

import '../data/api_calls.dart';
import '../data/shared_preferences_data.dart';
import '../model/store_category.dart';
import '../model/storelist_response.dart';

class CustomerOrderController extends GetxController{

  final ApiCalls apiCalls = ApiCalls();
  final SharedPreferencesData prefs = SharedPreferencesData();
  var stores = <StoreItem>[].obs;
  var storeCategories = <StoreCategory>[].obs;
  var selectedStore = Rxn<StoreItem>();
}