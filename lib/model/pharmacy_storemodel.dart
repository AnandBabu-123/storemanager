class PharmacyStoreModel {
  String? message;
  bool? status;
  List<ItemCodeMasters>? itemCodeMasters;
  int? currentPage;
  int? pageSize;
  int? totalElements;
  int? totalPages;

  PharmacyStoreModel(
      {this.message,
        this.status,
        this.itemCodeMasters,
        this.currentPage,
        this.pageSize,
        this.totalElements,
        this.totalPages});

  PharmacyStoreModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['itemCodeMasters'] != null) {
      itemCodeMasters = <ItemCodeMasters>[];
      json['itemCodeMasters'].forEach((v) {
        itemCodeMasters!.add(new ItemCodeMasters.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.itemCodeMasters != null) {
      data['itemCodeMasters'] =
          this.itemCodeMasters!.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = this.currentPage;
    data['pageSize'] = this.pageSize;
    data['totalElements'] = this.totalElements;
    data['totalPages'] = this.totalPages;
    return data;
  }
}

class ItemCodeMasters {
  String? userIdStoreIdItemCode;
  String? storeId;
  String? itemCode;
  String? itemName;
  String? itemCategory;
  String? itemSubCategory;
  String? manufacturer;
  String? brand;
  int? gst;
  String? hsnGroup;
  String? updatedBy;
  String? updatedDate;
  String? userId;
  String? userIdStoreId;
  String? scheduledDrug;
  String? scheduledCategory;
  String? narcotic;
  String? image1;
  String? image2;
  String? image3;

  ItemCodeMasters(
      {this.userIdStoreIdItemCode,
        this.storeId,
        this.itemCode,
        this.itemName,
        this.itemCategory,
        this.itemSubCategory,
        this.manufacturer,
        this.brand,
        this.gst,
        this.hsnGroup,
        this.updatedBy,
        this.updatedDate,
        this.userId,
        this.userIdStoreId,
        this.scheduledDrug,
        this.scheduledCategory,
        this.narcotic,
        this.image1,
        this.image2,
        this.image3});

  ItemCodeMasters.fromJson(Map<String, dynamic> json) {
    userIdStoreIdItemCode = json['userIdStoreIdItemCode'];
    storeId = json['storeId'];
    itemCode = json['itemCode'];
    itemName = json['itemName'];
    itemCategory = json['itemCategory'];
    itemSubCategory = json['itemSubCategory'];
    manufacturer = json['manufacturer'];
    brand = json['brand'];
    gst = json['gst'];
    hsnGroup = json['hsnGroup'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    userId = json['userId'];
    userIdStoreId = json['userIdStoreId'];
    scheduledDrug = json['scheduledDrug'];
    scheduledCategory = json['scheduledCategory'];
    narcotic = json['narcotic'];
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userIdStoreIdItemCode'] = this.userIdStoreIdItemCode;
    data['storeId'] = this.storeId;
    data['itemCode'] = this.itemCode;
    data['itemName'] = this.itemName;
    data['itemCategory'] = this.itemCategory;
    data['itemSubCategory'] = this.itemSubCategory;
    data['manufacturer'] = this.manufacturer;
    data['brand'] = this.brand;
    data['gst'] = this.gst;
    data['hsnGroup'] = this.hsnGroup;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['userId'] = this.userId;
    data['userIdStoreId'] = this.userIdStoreId;
    data['scheduledDrug'] = this.scheduledDrug;
    data['scheduledCategory'] = this.scheduledCategory;
    data['narcotic'] = this.narcotic;
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    data['image3'] = this.image3;
    return data;
  }
}
