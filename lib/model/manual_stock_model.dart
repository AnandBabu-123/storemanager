class ManualStockModel {
  String? userId;
  String? itemSubCategory;
  String? userIdStoreId;
  String? manufacturer;
  String? itemCategory;
  String? itemCode;
  String? userIdStoreIdItemCode;
  String? itemName;
  int? gst;
  String? storeId;
  String? brand;
  String? hsnGroup;

  ManualStockModel(
      {this.userId,
        this.itemSubCategory,
        this.userIdStoreId,
        this.manufacturer,
        this.itemCategory,
        this.itemCode,
        this.userIdStoreIdItemCode,
        this.itemName,
        this.gst,
        this.storeId,
        this.brand,
        this.hsnGroup});

  ManualStockModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    itemSubCategory = json['itemSubCategory'];
    userIdStoreId = json['userIdStoreId'];
    manufacturer = json['manufacturer'];
    itemCategory = json['itemCategory'];
    itemCode = json['itemCode'];
    userIdStoreIdItemCode = json['userIdStoreIdItemCode'];
    itemName = json['itemName'];
    gst = json['gst'];
    storeId = json['storeId'];
    brand = json['brand'];
    hsnGroup = json['hsnGroup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['itemSubCategory'] = this.itemSubCategory;
    data['userIdStoreId'] = this.userIdStoreId;
    data['manufacturer'] = this.manufacturer;
    data['itemCategory'] = this.itemCategory;
    data['itemCode'] = this.itemCode;
    data['userIdStoreIdItemCode'] = this.userIdStoreIdItemCode;
    data['itemName'] = this.itemName;
    data['gst'] = this.gst;
    data['storeId'] = this.storeId;
    data['brand'] = this.brand;
    data['hsnGroup'] = this.hsnGroup;
    return data;
  }
}
