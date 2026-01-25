class SalesDocumentModel {
  final bool? status;
  final String? message;
  final List<SaleInvoice>? sales;
  final int? currentPage;
  final int? pageSize;
  final int? totalElements;
  final int? totalPages;

  SalesDocumentModel({
    this.status,
    this.message,
    this.sales,
    this.currentPage,
    this.pageSize,
    this.totalElements,
    this.totalPages,
  });

  factory SalesDocumentModel.fromJson(Map<String, dynamic> json) {
    return SalesDocumentModel(
      status: json['status'],
      message: json['message'],
      sales: json['sales'] != null
          ? (json['sales'] as List)
          .map((e) => SaleInvoice.fromJson(e))
          .toList()
          : [],
      currentPage: json['currentPage'],
      pageSize: json['pageSize'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
    );
  }
}
class SaleInvoice {
  String? docNumberLineId;
  String? docNumber;
  String? readableDocNo;
  String? date;
  String? time;
  String? custCode;
  String? custName;
  String? patientName;
  String? createdUser;
  String? itemCode;
  String? itemName;
  String? batchNo;
  String? expiryDate;
  String? mfacCode;
  String? mfacName;
  String? catCode;
  String? catName;
  String? brandName;
  String? gstCode;
  String? packing;
  String? orderId;
  String? saleType;
  double? qtyBox;
  double? qty;
  double? schQty;
  double? schDisc;
  double? saleRate;
  double? mRP;
  double? saleValue;
  double? discPerct;
  double? discValue;
  double? taxableAmt;
  double? cGSTPer;
  double? sGSTPer;
  double? cGSTAmt;
  double? sGSTAmt;
  double? iGSTPer;
  double? iGSTAmt;
  String? suppCode;
  String? suppName;
  double? total;
  double? cessPer;
  double? cessAmt;
  double? addCessPer;
  double? addCessAmt;
  double? roundOff;
  String? suppBillNo;
  String? professional;
  String? mobile;
  String? lcCode;
  double? purRate;
  double? purRateWithGsT;
  String? storeId;
  String? saleMode;
  String? userId;
  String? userIdStoreIdItemCode;
  double? afterDiscount;
  double? totalPurchasePrice;
  double? profitOrLoss;
  String? userIdStoreId;

  SaleInvoice({
    this.docNumberLineId,
    this.docNumber,
    this.readableDocNo,
    this.date,
    this.time,
    this.custCode,
    this.custName,
    this.patientName,
    this.createdUser,
    this.itemCode,
    this.itemName,
    this.batchNo,
    this.expiryDate,
    this.mfacCode,
    this.mfacName,
    this.catCode,
    this.catName,
    this.brandName,
    this.gstCode,
    this.packing,
    this.orderId,
    this.saleType,
    this.qtyBox,
    this.qty,
    this.schQty,
    this.schDisc,
    this.saleRate,
    this.mRP,
    this.saleValue,
    this.discPerct,
    this.discValue,
    this.taxableAmt,
    this.cGSTPer,
    this.sGSTPer,
    this.cGSTAmt,
    this.sGSTAmt,
    this.iGSTPer,
    this.iGSTAmt,
    this.suppCode,
    this.suppName,
    this.total,
    this.cessPer,
    this.cessAmt,
    this.addCessPer,
    this.addCessAmt,
    this.roundOff,
    this.suppBillNo,
    this.professional,
    this.mobile,
    this.lcCode,
    this.purRate,
    this.purRateWithGsT,
    this.storeId,
    this.saleMode,
    this.userId,
    this.userIdStoreIdItemCode,
    this.afterDiscount,
    this.totalPurchasePrice,
    this.profitOrLoss,
    this.userIdStoreId,
  });

  factory SaleInvoice.fromJson(Map<String, dynamic> json) {
    return SaleInvoice(
      docNumberLineId: json['docNumberLineId'],
      docNumber: json['docNumber'],
      readableDocNo: json['readableDocNo'],
      date: json['date'],
      time: json['time'],
      custCode: json['custCode'],
      custName: json['custName'],
      patientName: json['patientName'],
      createdUser: json['createdUser'],
      itemCode: json['itemCode'],
      itemName: json['itemName'],
      batchNo: json['batchNo'],
      expiryDate: json['expiryDate'],
      mfacCode: json['mfacCode'],
      mfacName: json['mfacName'],
      catCode: json['catCode'],
      catName: json['catName'],
      brandName: json['brandName'],
      gstCode: json['gstCode'],
      packing: json['packing'],
      orderId: json['orderId'],
      saleType: json['saleType'],
      qtyBox: _toDouble(json['qtyBox']),
      qty: _toDouble(json['qty']),
      schQty: _toDouble(json['schQty']),
      schDisc: _toDouble(json['schDisc']),
      saleRate: _toDouble(json['saleRate']),
      mRP: _toDouble(json['mRP']),
      saleValue: _toDouble(json['saleValue']),
      discPerct: _toDouble(json['discPerct']),
      discValue: _toDouble(json['discValue']),
      taxableAmt: _toDouble(json['taxableAmt']),
      cGSTPer: _toDouble(json['cGSTPer']),
      sGSTPer: _toDouble(json['sGSTPer']),
      cGSTAmt: _toDouble(json['cGSTAmt']),
      sGSTAmt: _toDouble(json['sGSTAmt']),
      iGSTPer: _toDouble(json['iGSTPer']),
      iGSTAmt: _toDouble(json['iGSTAmt']),
      suppCode: json['suppCode'],
      suppName: json['suppName'],
      total: _toDouble(json['total']),
      cessPer: _toDouble(json['cessPer']),
      cessAmt: _toDouble(json['cessAmt']),
      addCessPer: _toDouble(json['addCessPer']),
      addCessAmt: _toDouble(json['addCessAmt']),
      roundOff: _toDouble(json['roundOff']),
      suppBillNo: json['suppBillNo'],
      professional: json['professional'],
      mobile: json['mobile'],
      lcCode: json['lcCode'],
      purRate: _toDouble(json['purRate']),
      purRateWithGsT: _toDouble(json['purRateWithGsT']),
      storeId: json['storeId'],
      saleMode: json['saleMode'],
      userId: json['userId'],
      userIdStoreIdItemCode: json['userIdStoreIdItemCode'],
      afterDiscount: _toDouble(json['afterDiscount']),
      totalPurchasePrice: _toDouble(json['totalPurchasePrice']),
      profitOrLoss: _toDouble(json['profitOrLoss']),
      userIdStoreId: json['userIdStoreId'],
    );
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is int) return v.toDouble();
    if (v is double) return v;
    return double.tryParse(v.toString());
  }
}

