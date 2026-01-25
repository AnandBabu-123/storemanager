class RetailerPurchaseModel {
  bool? status;
  String? message;
  List<RetailerPurchaseData>? data;
  int? currentPage;
  int? pageSize;
  int? totalElements;
  int? totalPages;

  RetailerPurchaseModel({
    this.status,
    this.message,
    this.data,
    this.currentPage,
    this.pageSize,
    this.totalElements,
    this.totalPages,
  });

  RetailerPurchaseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RetailerPurchaseData>[];
      json['data'].forEach((v) {
        data!.add(RetailerPurchaseData.fromJson(v));
      });
    }

    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['status'] = status;
    dataMap['message'] = message;

    if (data != null) {
      dataMap['data'] = data!.map((v) => v.toJson()).toList();
    }

    dataMap['currentPage'] = currentPage;
    dataMap['pageSize'] = pageSize;
    dataMap['totalElements'] = totalElements;
    dataMap['totalPages'] = totalPages;

    return dataMap;
  }
}
class RetailerPurchaseData {
  RetailerStore? store;
  List<RetailerStockItem>? stock;
  List<dynamic>? storeReturnPolicy;

  RetailerPurchaseData({
    this.store,
    this.stock,
    this.storeReturnPolicy,
  });

  RetailerPurchaseData.fromJson(Map<String, dynamic> json) {
    store =
    json['store'] != null ? RetailerStore.fromJson(json['store']) : null;

    if (json['stock'] != null) {
      stock = <RetailerStockItem>[];
      json['stock'].forEach((v) {
        stock!.add(RetailerStockItem.fromJson(v));
      });
    }

    storeReturnPolicy = json['storeReturnPolicy'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    if (store != null) {
      dataMap['store'] = store!.toJson();
    }
    if (stock != null) {
      dataMap['stock'] = stock!.map((v) => v.toJson()).toList();
    }
    dataMap['storeReturnPolicy'] = storeReturnPolicy;
    return dataMap;
  }
}
class RetailerStore {
  String? storeId;
  String? storeName;
  String? location;
  String? type;
  String? storeBusinessType;
  String? ownerContact;
  String? ownerEmail;
  String? userId;
  String? userIdStoreId;

  RetailerStore({
    this.storeId,
    this.storeName,
    this.location,
    this.type,
    this.storeBusinessType,
    this.ownerContact,
    this.ownerEmail,
    this.userId,
    this.userIdStoreId,
  });

  RetailerStore.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'];
    storeName = json['storeName'];
    location = json['location'];
    type = json['type'];
    storeBusinessType = json['storeBusinessType'];
    ownerContact = json['ownerContact'];
    ownerEmail = json['ownerEmail'];
    userId = json['userId'];
    userIdStoreId = json['userIdStoreId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['storeId'] = storeId;
    dataMap['storeName'] = storeName;
    dataMap['location'] = location;
    dataMap['type'] = type;
    dataMap['storeBusinessType'] = storeBusinessType;
    dataMap['ownerContact'] = ownerContact;
    dataMap['ownerEmail'] = ownerEmail;
    dataMap['userId'] = userId;
    dataMap['userIdStoreId'] = userIdStoreId;
    return dataMap;
  }
}
class RetailerStockItem {
  String? medicineName;
  String? mfName;
  double? mrp;
  String? batch;
  String? expiryDate;
  String? userIdStoreIdItemCode;
  double? discount;
  double? offerQty;
  String? batchNumber;
  double? minOrderQty;
  dynamic gst;
  dynamic itemCategory;
  dynamic itemSubCategory;
  dynamic scheduledDrug;
  dynamic scheduledCategory;
  dynamic narcotic;
  dynamic image1;
  dynamic image2;
  dynamic image3;

  RetailerStockItem({
    this.medicineName,
    this.mfName,
    this.mrp,
    this.batch,
    this.expiryDate,
    this.userIdStoreIdItemCode,
    this.discount,
    this.offerQty,
    this.batchNumber,
    this.minOrderQty,
    this.gst,
    this.itemCategory,
    this.itemSubCategory,
    this.scheduledDrug,
    this.scheduledCategory,
    this.narcotic,
    this.image1,
    this.image2,
    this.image3,
  });

  RetailerStockItem.fromJson(Map<String, dynamic> json) {
    medicineName = json['medicineName'];
    mfName = json['mfName'];
    mrp = (json['mrp'] as num?)?.toDouble();
    batch = json['batch'];
    expiryDate = json['expiryDate'];
    userIdStoreIdItemCode = json['userIdStoreIdItemCode'];
    discount = (json['discount'] as num?)?.toDouble();
    offerQty = (json['offerQty'] as num?)?.toDouble();
    batchNumber = json['batchNumber'];
    minOrderQty = (json['minOrderQty'] as num?)?.toDouble();
    gst = json['gst'];
    itemCategory = json['itemCategory'];
    itemSubCategory = json['itemSubCategory'];
    scheduledDrug = json['scheduledDrug'];
    scheduledCategory = json['scheduledCategory'];
    narcotic = json['narcotic'];
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['medicineName'] = medicineName;
    dataMap['mfName'] = mfName;
    dataMap['mrp'] = mrp;
    dataMap['batch'] = batch;
    dataMap['expiryDate'] = expiryDate;
    dataMap['userIdStoreIdItemCode'] = userIdStoreIdItemCode;
    dataMap['discount'] = discount;
    dataMap['offerQty'] = offerQty;
    dataMap['batchNumber'] = batchNumber;
    dataMap['minOrderQty'] = minOrderQty;
    dataMap['gst'] = gst;
    dataMap['itemCategory'] = itemCategory;
    dataMap['itemSubCategory'] = itemSubCategory;
    dataMap['scheduledDrug'] = scheduledDrug;
    dataMap['scheduledCategory'] = scheduledCategory;
    dataMap['narcotic'] = narcotic;
    dataMap['image1'] = image1;
    dataMap['image2'] = image2;
    dataMap['image3'] = image3;
    return dataMap;
  }
}
