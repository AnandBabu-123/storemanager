class ItemSearchModel {
  final String itemName;
  final String? itemCode;
  final String? manufacturer;
  final String? brand;
  final int? gst;
  final String? hsnGroup;
  final String? userIdStoreId;
  final String? itemSubCategory;
  final String? userIdStoreIdItemCode;
  final String? itemCategory;
  final String? userId;
  final String? storeId;

  ItemSearchModel({
    required this.itemName,
    this.itemCode,
    this.manufacturer,
    this.brand,
    this.gst,
    this.hsnGroup,
    this.userIdStoreId,
    this.itemSubCategory,
    this.userIdStoreIdItemCode,
    this.itemCategory,
    this.userId,
    this.storeId,
  });

  factory ItemSearchModel.fromJson(Map<String, dynamic> json) {
    return ItemSearchModel(
      itemName: (json['itemName'] ?? '').toString().trim(),
      itemCode: json['itemCode']?.toString(),
      manufacturer: json['manufacturer']?.toString(),
      brand: json['brand']?.toString(),

      gst: json['gst'] is int
          ? json['gst']
          : int.tryParse(json['gst']?.toString() ?? ''),

      hsnGroup: json['hsnGroup']?.toString(),

      // 🔹 Extra mappings
      userIdStoreId: json['userIdStoreId']?.toString(),
      itemSubCategory: json['itemSubCategory']?.toString(),
      userIdStoreIdItemCode:
      json['userIdStoreIdItemCode']?.toString(),
      itemCategory: json['itemCategory']?.toString(),
      userId: json['userId']?.toString(),
      storeId: json['storeId']?.toString(),
    );
  }

  // ✅ Optional: convert back to JSON
  Map<String, dynamic> toJson() {
    return {
      "itemName": itemName,
      "itemCode": itemCode,
      "manufacturer": manufacturer,
      "brand": brand,
      "gst": gst,
      "hsnGroup": hsnGroup,
      "userIdStoreId": userIdStoreId,
      "itemSubCategory": itemSubCategory,
      "userIdStoreIdItemCode": userIdStoreIdItemCode,
      "itemCategory": itemCategory,
      "userId": userId,
      "storeId": storeId,
    };
  }
}
