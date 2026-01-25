class StoreCategory {
  String? storeCategoryId;
  String? storeCategoryName;
  String?storeBusinessType;
   String? businessName;

  StoreCategory({
    this.storeCategoryId,
    this.storeCategoryName,
    this.storeBusinessType,
    this.businessName
  });

  factory StoreCategory.fromJson(Map<String, dynamic> json) {
    return StoreCategory(
      storeCategoryId: json['storeCategoryId'],
      storeCategoryName: json['storeCategoryName'],
      storeBusinessType: json['storeBusinessType'],
      businessName: json['businessName'],
    );
  }
}
