class AddedPharmacyModel {
  String? status;
  String? message;
  List<Data>? data;

  AddedPharmacyModel({this.status, this.message, this.data});

  AddedPharmacyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
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
  Null? scheduledCategory;
  String? narcotic;

  Data(
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
        this.narcotic});

  Data.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
