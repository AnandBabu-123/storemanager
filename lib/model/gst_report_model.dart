class GSTReportModel {
  List<SaleGst>? saleGst;
  List<PurchaseGst>? purchaseGst;

  GSTReportModel({this.saleGst, this.purchaseGst});

  factory GSTReportModel.fromJson(Map<String, dynamic> json) {
    return GSTReportModel(
      saleGst: (json['saleGst'] as List?)
          ?.map((e) => SaleGst.fromJson(e))
          .toList(),
      purchaseGst: (json['purchaseGst'] as List?)
          ?.map((e) => PurchaseGst.fromJson(e))
          .toList(),
    );
  }
}
class SaleGst {
  double? taxableAmount;
  double? total;
  String? date;
  String? storeId;
  String? userIdStoreId;
  String? userId;
  int? igstper;
  double? cgstamt;
  double? sgstamt;

  SaleGst({
    this.taxableAmount,
    this.total,
    this.date,
    this.storeId,
    this.userIdStoreId,
    this.userId,
    this.igstper,
    this.cgstamt,
    this.sgstamt,
  });

  factory SaleGst.fromJson(Map<String, dynamic> json) {
    return SaleGst(
      taxableAmount: (json['taxableAmount'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      date: json['date'],
      storeId: json['storeId'],
      userIdStoreId: json['userIdStoreId'],
      userId: json['userId'],
      igstper: json['igstper'],
      cgstamt: (json['cgstamt'] as num?)?.toDouble(),
      sgstamt: (json['sgstamt'] as num?)?.toDouble(),
    );
  }
}
class PurchaseGst {
  double? taxableAmount;
  double? total;
  String? date;
  String? storeId;
  String? userIdStoreId;
  String? userId;
  int? igstper;
  double? cgstamt;
  double? sgstamt;

  PurchaseGst({
    this.taxableAmount,
    this.total,
    this.date,
    this.storeId,
    this.userIdStoreId,
    this.userId,
    this.igstper,
    this.cgstamt,
    this.sgstamt,
  });

  factory PurchaseGst.fromJson(Map<String, dynamic> json) {
    return PurchaseGst(
      taxableAmount: (json['taxableAmount'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      date: json['date'],
      storeId: json['storeId'],
      userIdStoreId: json['userIdStoreId'],
      userId: json['userId'],
      igstper: json['igstper'],
      cgstamt: (json['cgstamt'] as num?)?.toDouble(),
      sgstamt: (json['sgstamt'] as num?)?.toDouble(),
    );
  }
}
