class OnlineOrderModel {
  String? message;
  bool? status;
  List<Data>? data;
  int? currentPage;
  int? pageSize;
  int? totalElements;
  int? totalPages;

  OnlineOrderModel(
      {this.message,
        this.status,
        this.data,
        this.currentPage,
        this.pageSize,
        this.totalElements,
        this.totalPages});

  OnlineOrderModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = this.currentPage;
    data['pageSize'] = this.pageSize;
    data['totalElements'] = this.totalElements;
    data['totalPages'] = this.totalPages;
    return data;
  }
}

class Data {
  String? storeCategoryStoreId;
  String? storeCategory;
  String? userIdStoreId;
  String? location;
  String? customerId;
  String? updatedDate;
  String? updatedBy;

  Data(
      {this.storeCategoryStoreId,
        this.storeCategory,
        this.userIdStoreId,
        this.location,
        this.customerId,
        this.updatedDate,
        this.updatedBy});

  Data.fromJson(Map<String, dynamic> json) {
    storeCategoryStoreId = json['storeCategoryStoreId'];
    storeCategory = json['storeCategory'];
    userIdStoreId = json['userIdStoreId'];
    location = json['location'];
    customerId = json['customerId'];
    updatedDate = json['updatedDate'];
    updatedBy = json['updatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storeCategoryStoreId'] = this.storeCategoryStoreId;
    data['storeCategory'] = this.storeCategory;
    data['userIdStoreId'] = this.userIdStoreId;
    data['location'] = this.location;
    data['customerId'] = this.customerId;
    data['updatedDate'] = this.updatedDate;
    data['updatedBy'] = this.updatedBy;
    return data;
  }
}
