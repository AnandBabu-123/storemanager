import 'package:storemanager/model/store_category.dart';

class StoreCategoryDetailsModel {
  List<StoreCategory> storeCategoriesList;

  StoreCategoryDetailsModel({
    required this.storeCategoriesList,
  });

  factory StoreCategoryDetailsModel.fromJson(Map<String, dynamic> json) {
    return StoreCategoryDetailsModel(
      storeCategoriesList:
      (json['storeCategoriesList'] as List<dynamic>? ?? [])
          .map((e) => StoreCategory.fromJson(e))
          .toList(),
    );
  }
}
