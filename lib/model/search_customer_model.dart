class SearchCustomerModel {
  int? totalCount;
  List<OrderData>? data;
  String? message;
  bool? status;

  SearchCustomerModel({this.totalCount, this.data, this.message, this.status});

  SearchCustomerModel.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['data'] != null) {
      data = <OrderData>[];
      json['data'].forEach((v) {
        data!.add(new OrderData.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class OrderData {
  String? orderId;
  String? customerId;
  String? retailerId;

  OrderData({this.orderId, this.customerId, this.retailerId});

  OrderData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    customerId = json['customerId'];
    retailerId = json['retailerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['customerId'] = this.customerId;
    data['retailerId'] = this.retailerId;
    return data;
  }
}
