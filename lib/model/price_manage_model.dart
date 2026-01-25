class PriceManageModel {
  final bool? status;
  final String? message;
  final List<DataItem>? data;

  PriceManageModel({
    this.status,
    this.message,
    this.data,
  });

  factory PriceManageModel.fromJson(Map<String, dynamic> json) {
    return PriceManageModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DataItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class DataItem {
  final String? manufacturer;
  final String? mfName;
  final String? itemCode;
  final String? itemName;
  final String? supplierName;
  final String? rack;
  final String? batch;
  final DateTime? expiryDate;

  final num? balQuantity;
  final num? balPackQuantity;
  final num? balLooseQuantity;
  final num? total; // changed to num?

  final num? mrpPack;
  final num? mrpValue;
  final num? purRatePerPackAfterGST; // changed to num?

  final String? itemCategory;
  final String? onlineYesNo;
  final String? storeId;
  final num? stockValueMrp; // changed to num?
  final num? stockValuePurrate; // changed to num?

  final String? updatedBy;
  final DateTime? updatedAt;
  final String? userId;
  final String? userIdStoreIdItemCode;
  final String? userIdStoreId;

  final num? igstCode;
  final num? minOrderQty;
  final num? offerQty;
  final num? discount;

  final String? brandName;
  final String? purchaseDate;

  DataItem({
    this.manufacturer,
    this.mfName,
    this.itemCode,
    this.itemName,
    this.supplierName,
    this.rack,
    this.batch,
    this.expiryDate,
    this.balQuantity,
    this.balPackQuantity,
    this.balLooseQuantity,
    this.total,
    this.mrpPack,
    this.mrpValue,
    this.purRatePerPackAfterGST,
    this.itemCategory,
    this.onlineYesNo,
    this.storeId,
    this.stockValueMrp,
    this.stockValuePurrate,
    this.updatedBy,
    this.updatedAt,
    this.userId,
    this.userIdStoreIdItemCode,
    this.userIdStoreId,
    this.igstCode,
    this.minOrderQty,
    this.offerQty,
    this.discount,
    this.brandName,
    this.purchaseDate,
  });

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
      manufacturer: json['manufacturer'],
      mfName: json['mfName'],
      itemCode: json['itemCode'],
      itemName: json['itemName'],
      supplierName: json['supplierName'],
      rack: json['rack'],
      batch: json['batch'],

      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,

      balQuantity: json['balQuantity'] != null ? json['balQuantity'] as num : null,
      balPackQuantity: json['balPackQuantity'] != null ? json['balPackQuantity'] as num : null,
      balLooseQuantity: json['balLooseQuantity'] != null ? json['balLooseQuantity'] as num : null,

      total: json['total'] != null
          ? (json['total'] is num
          ? json['total'] as num
          : num.tryParse(json['total'].toString()))
          : null,

      mrpPack: json['mrpPack'] != null ? json['mrpPack'] as num : null,
      mrpValue: json['mrpValue'] != null ? json['mrpValue'] as num : null,
      purRatePerPackAfterGST: json['purRatePerPackAfterGST'] != null
          ? json['purRatePerPackAfterGST'] as num
          : null,

      itemCategory: json['itemCategory'],
      onlineYesNo: json['onlineYesNo'],
      storeId: json['storeId'],
      stockValueMrp: json['stockValueMrp'] != null ? json['stockValueMrp'] as num : null,
      stockValuePurrate: json['stockValuePurrate'] != null ? json['stockValuePurrate'] as num : null,

      updatedBy: json['updatedBy'],
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,

      userId: json['userId'],
      userIdStoreIdItemCode: json['userIdStoreIdItemCode'],
      userIdStoreId: json['userIdStoreId'],

      igstCode: json['igstCode'] != null ? json['igstCode'] as num : null,
      minOrderQty: json['minOrderQty'] != null ? json['minOrderQty'] as num : null,
      offerQty: json['offerQty'] != null ? json['offerQty'] as num : null,
      discount: json['discount'] != null ? json['discount'] as num : null,

      brandName: json['brandName'],
      purchaseDate: json['purchaseDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'manufacturer': manufacturer,
      'mfName': mfName,
      'itemCode': itemCode,
      'itemName': itemName,
      'supplierName': supplierName,
      'rack': rack,
      'batch': batch,
      'expiryDate': expiryDate?.toIso8601String(),

      'balQuantity': balQuantity,
      'balPackQuantity': balPackQuantity,
      'balLooseQuantity': balLooseQuantity,
      'total': total,

      'mrpPack': mrpPack,
      'mrpValue': mrpValue,
      'purRatePerPackAfterGST': purRatePerPackAfterGST,

      'itemCategory': itemCategory,
      'onlineYesNo': onlineYesNo,
      'storeId': storeId,
      'stockValueMrp': stockValueMrp,
      'stockValuePurrate': stockValuePurrate,

      'updatedBy': updatedBy,
      'updatedAt': updatedAt?.toIso8601String(),

      'userId': userId,
      'userIdStoreIdItemCode': userIdStoreIdItemCode,
      'userIdStoreId': userIdStoreId,

      'igstCode': igstCode,
      'minOrderQty': minOrderQty,
      'offerQty': offerQty,
      'discount': discount,

      'brandName': brandName,
      'purchaseDate': purchaseDate,
    };
  }
}



