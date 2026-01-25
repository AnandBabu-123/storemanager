class OrderResponse {
  OrderHdr? orderHdr;
  Customer? customer;
  Store? store;

  OrderResponse({this.orderHdr, this.customer, this.store});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    orderHdr = json['orderHdr'] != null
        ? new OrderHdr.fromJson(json['orderHdr'])
        : null;
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderHdr != null) {
      data['orderHdr'] = this.orderHdr!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    return data;
  }
}

class OrderHdr {
  String? orderId;
  String? customerCartOrderId;
  String? customerId;
  String? retailerId;
  String? orderUpdatedBy;
  String? orderStatus;
  String? orderDate;
  String? orderUpdatedDate;
  String? deliveryMethod;
  String? paymentStatus;
  List<CustomerRetailerOrderDetailsList>? customerRetailerOrderDetailsList;

  OrderHdr(
      {this.orderId,
        this.customerCartOrderId,
        this.customerId,
        this.retailerId,
        this.orderUpdatedBy,
        this.orderStatus,
        this.orderDate,
        this.orderUpdatedDate,
        this.deliveryMethod,
        this.paymentStatus,
        this.customerRetailerOrderDetailsList});

  OrderHdr.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    customerCartOrderId = json['customerCartOrderId'];
    customerId = json['customerId'];
    retailerId = json['retailerId'];
    orderUpdatedBy = json['orderUpdatedBy'];
    orderStatus = json['orderStatus'];
    orderDate = json['orderDate'];
    orderUpdatedDate = json['orderUpdatedDate'];
    deliveryMethod = json['deliveryMethod'];
    paymentStatus = json['paymentStatus'];
    if (json['customerRetailerOrderDetailsList'] != null) {
      customerRetailerOrderDetailsList = <CustomerRetailerOrderDetailsList>[];
      json['customerRetailerOrderDetailsList'].forEach((v) {
        customerRetailerOrderDetailsList!
            .add(new CustomerRetailerOrderDetailsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['customerCartOrderId'] = this.customerCartOrderId;
    data['customerId'] = this.customerId;
    data['retailerId'] = this.retailerId;
    data['orderUpdatedBy'] = this.orderUpdatedBy;
    data['orderStatus'] = this.orderStatus;
    data['orderDate'] = this.orderDate;
    data['orderUpdatedDate'] = this.orderUpdatedDate;
    data['deliveryMethod'] = this.deliveryMethod;
    data['paymentStatus'] = this.paymentStatus;
    if (this.customerRetailerOrderDetailsList != null) {
      data['customerRetailerOrderDetailsList'] = this
          .customerRetailerOrderDetailsList!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class CustomerRetailerOrderDetailsList {
  String? lineItemId;
  String? customerCartOrderLineId;
  String? itemName;
  int? orderQty;
  double? mrp;
  double? discount;
  double? gst;
  double? totalAmount;
  String? manufactureName;
  String? itemCode;

  CustomerRetailerOrderDetailsList(
      {this.lineItemId,
        this.customerCartOrderLineId,
        this.itemName,
        this.orderQty,
        this.mrp,
        this.discount,
        this.gst,
        this.totalAmount,
        this.manufactureName,
        this.itemCode});

  CustomerRetailerOrderDetailsList.fromJson(Map<String, dynamic> json) {
    lineItemId = json['lineItemId'];
    customerCartOrderLineId = json['customerCartOrderLineId'];
    itemName = json['itemName'];
    orderQty = json['orderQty'];
    mrp = json['mrp'];
    discount = json['discount'];
    gst = json['gst'];
    totalAmount = json['totalAmount'];
    manufactureName = json['manufactureName'];
    itemCode = json['itemCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lineItemId'] = this.lineItemId;
    data['customerCartOrderLineId'] = this.customerCartOrderLineId;
    data['itemName'] = this.itemName;
    data['orderQty'] = this.orderQty;
    data['mrp'] = this.mrp;
    data['discount'] = this.discount;
    data['gst'] = this.gst;
    data['totalAmount'] = this.totalAmount;
    data['manufactureName'] = this.manufactureName;
    data['itemCode'] = this.itemCode;
    return data;
  }
}

class Customer {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? emailOtp;
  String? userType;
  String? emailVerify;
  String? mobileOtp;
  String? mobileVerify;
  String? customerStatus;
  String? password;
  String? location;
  String? registeredDate;
  String? updatedDate;
  String? address;
  String? registerMode;
  String? updatedBy;
  String? cid;

  Customer(
      {this.id,
        this.name,
        this.email,
        this.phoneNumber,
        this.emailOtp,
        this.userType,
        this.emailVerify,
        this.mobileOtp,
        this.mobileVerify,
        this.customerStatus,
        this.password,
        this.location,
        this.registeredDate,
        this.updatedDate,
        this.address,
        this.registerMode,
        this.updatedBy,
        this.cid});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    emailOtp = json['emailOtp'];
    userType = json['userType'];
    emailVerify = json['emailVerify'];
    mobileOtp = json['mobileOtp'];
    mobileVerify = json['mobileVerify'];
    customerStatus = json['customerStatus'];
    password = json['password'];
    location = json['location'];
    registeredDate = json['registeredDate'];
    updatedDate = json['updatedDate'];
    address = json['address'];
    registerMode = json['registerMode'];
    updatedBy = json['updatedBy'];
    cid = json['cid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['emailOtp'] = this.emailOtp;
    data['userType'] = this.userType;
    data['emailVerify'] = this.emailVerify;
    data['mobileOtp'] = this.mobileOtp;
    data['mobileVerify'] = this.mobileVerify;
    data['customerStatus'] = this.customerStatus;
    data['password'] = this.password;
    data['location'] = this.location;
    data['registeredDate'] = this.registeredDate;
    data['updatedDate'] = this.updatedDate;
    data['address'] = this.address;
    data['registerMode'] = this.registerMode;
    data['updatedBy'] = this.updatedBy;
    data['cid'] = this.cid;
    return data;
  }
}

class Store {
  String? type;
  String? userIdStoreId;
  String? id;
  String? name;
  String? pincode;
  String? district;
  String? state;
  String? location;
  String? owner;
  String? ownerContact;
  String? secondaryContact;
  String? ownerEmail;
  String? registrationDate;
  String? creationTimeStamp;
  String? role;
  String? addedBy;
  String? modifiedBy;
  String? modifiedDate;
  String? modifiedTimeStamp;
  String? status;
  String? storeVerifiedStatus;
  String? expiryDate;
  String? currentPlan;
  String? storeBusinessType;
  String? userId;
  String? gstNumber;

  Store(
      {this.type,
        this.userIdStoreId,
        this.id,
        this.name,
        this.pincode,
        this.district,
        this.state,
        this.location,
        this.owner,
        this.ownerContact,
        this.secondaryContact,
        this.ownerEmail,
        this.registrationDate,
        this.creationTimeStamp,
        this.role,
        this.addedBy,
        this.modifiedBy,
        this.modifiedDate,
        this.modifiedTimeStamp,
        this.status,
        this.storeVerifiedStatus,
        this.expiryDate,
        this.currentPlan,
        this.storeBusinessType,
        this.userId,
        this.gstNumber});

  Store.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    userIdStoreId = json['userIdStoreId'];
    id = json['id'];
    name = json['name'];
    pincode = json['pincode'];
    district = json['district'];
    state = json['state'];
    location = json['location'];
    owner = json['owner'];
    ownerContact = json['ownerContact'];
    secondaryContact = json['secondaryContact'];
    ownerEmail = json['ownerEmail'];
    registrationDate = json['registrationDate'];
    creationTimeStamp = json['creationTimeStamp'];
    role = json['role'];
    addedBy = json['addedBy'];
    modifiedBy = json['modifiedBy'];
    modifiedDate = json['modifiedDate'];
    modifiedTimeStamp = json['modifiedTimeStamp'];
    status = json['status'];
    storeVerifiedStatus = json['storeVerifiedStatus'];
    expiryDate = json['expiryDate'];
    currentPlan = json['currentPlan'];
    storeBusinessType = json['storeBusinessType'];
    userId = json['userId'];
    gstNumber = json['gstNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['userIdStoreId'] = this.userIdStoreId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['pincode'] = this.pincode;
    data['district'] = this.district;
    data['state'] = this.state;
    data['location'] = this.location;
    data['owner'] = this.owner;
    data['ownerContact'] = this.ownerContact;
    data['secondaryContact'] = this.secondaryContact;
    data['ownerEmail'] = this.ownerEmail;
    data['registrationDate'] = this.registrationDate;
    data['creationTimeStamp'] = this.creationTimeStamp;
    data['role'] = this.role;
    data['addedBy'] = this.addedBy;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedDate'] = this.modifiedDate;
    data['modifiedTimeStamp'] = this.modifiedTimeStamp;
    data['status'] = this.status;
    data['storeVerifiedStatus'] = this.storeVerifiedStatus;
    data['expiryDate'] = this.expiryDate;
    data['currentPlan'] = this.currentPlan;
    data['storeBusinessType'] = this.storeBusinessType;
    data['userId'] = this.userId;
    data['gstNumber'] = this.gstNumber;
    return data;
  }
}
