class RackManagementModel {
  String? status;
  String? message;
  List<Data>? data;

  RackManagementModel({this.status, this.message, this.data});

  RackManagementModel.fromJson(Map<String, dynamic> json) {
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
  String? rackBoxStoreIdSkuId;
  String? rackNumber;
  String? boxNo;
  String? skuId;
  String? storeId;
  String? updatedBy;
  String? updatedDate;

  Data(
      {this.rackBoxStoreIdSkuId,
        this.rackNumber,
        this.boxNo,
        this.skuId,
        this.storeId,
        this.updatedBy,
        this.updatedDate});

  Data.fromJson(Map<String, dynamic> json) {
    rackBoxStoreIdSkuId = json['rackBoxStoreIdSkuId'];
    rackNumber = json['rackNumber'];
    boxNo = json['boxNo'];
    skuId = json['skuId'];
    storeId = json['storeId'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rackBoxStoreIdSkuId'] = this.rackBoxStoreIdSkuId;
    data['rackNumber'] = this.rackNumber;
    data['boxNo'] = this.boxNo;
    data['skuId'] = this.skuId;
    data['storeId'] = this.storeId;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}
