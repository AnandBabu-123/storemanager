class ReportInvoiceData {
  bool? status;
  String? message;
  List<PurchaseInvoice>? purchases;
  int? currentPage;
  int? pageSize;
  int? totalElements;
  int? totalPages;

  ReportInvoiceData({
    this.status,
    this.message,
    this.purchases,
    this.currentPage,
    this.pageSize,
    this.totalElements,
    this.totalPages,
  });

  ReportInvoiceData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['purchases'] != null) {
      purchases = <PurchaseInvoice>[];
      json['purchases'].forEach((v) {
        purchases!.add(PurchaseInvoice.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    if (purchases != null) {
      data['purchases'] = purchases!.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = currentPage;
    data['pageSize'] = pageSize;
    data['totalElements'] = totalElements;
    data['totalPages'] = totalPages;
    return data;
  }
}
class PurchaseInvoice {
  String? billNoLineId;
  String? docNumber;
  String? readableDocNo;
  String? date;
  String? billNo;
  String? billDt;
  String? itemCode;
  String? itemName;
  String? batchNo;
  String? expiryDate;
  String? catCode;
  String? catName;
  String? mfacCode;
  String? mfacName;
  String? brandName;
  String? packing;
  String? dcYear;
  String? dcPrefix;
  String? dcSrno;

  double? qty;
  double? packQty;
  double? looseQty;
  double? schPackQty;
  double? schLooseQty;
  double? schDisc;
  double? purRate;
  double? purValue;
  double? discPer;
  double? margin;

  String? suppCode;
  String? suppName;

  double? discValue;
  double? taxableAmt;

  String? gstCode;
  double? total;
  String? post;
  String? itemCat;

  double? cessPer;
  double? cessAmt;

  String? storeId;
  String? userId;
  String? userIdStoreIdItemCode;
  String? userIdStoreId;

  double? discount;
  double? afterDiscount;
  double? totalPurchasePrice;

  int? igstper;
  double? mrp;
  double? saleRate;

  int? cgstper;
  int? sgstper;

  double? cgstamt;
  double? sgstamt;
  double? igstamt;

  PurchaseInvoice({
    this.billNoLineId,
    this.docNumber,
    this.readableDocNo,
    this.date,
    this.billNo,
    this.billDt,
    this.itemCode,
    this.itemName,
    this.batchNo,
    this.expiryDate,
    this.catCode,
    this.catName,
    this.mfacCode,
    this.mfacName,
    this.brandName,
    this.packing,
    this.dcYear,
    this.dcPrefix,
    this.dcSrno,
    this.qty,
    this.packQty,
    this.looseQty,
    this.schPackQty,
    this.schLooseQty,
    this.schDisc,
    this.purRate,
    this.purValue,
    this.discPer,
    this.margin,
    this.suppCode,
    this.suppName,
    this.discValue,
    this.taxableAmt,
    this.gstCode,
    this.total,
    this.post,
    this.itemCat,
    this.cessPer,
    this.cessAmt,
    this.storeId,
    this.userId,
    this.userIdStoreIdItemCode,
    this.userIdStoreId,
    this.discount,
    this.afterDiscount,
    this.totalPurchasePrice,
    this.igstper,
    this.mrp,
    this.saleRate,
    this.cgstper,
    this.sgstper,
    this.cgstamt,
    this.sgstamt,
    this.igstamt,
  });

  PurchaseInvoice.fromJson(Map<String, dynamic> json) {
    billNoLineId = json['billNoLineId'];
    docNumber = json['doc_Number'];
    readableDocNo = json['readableDocNo'];
    date = json['date'];
    billNo = json['billNo'];
    billDt = json['billDt'];
    itemCode = json['itemCode'];
    itemName = json['itemName'];
    batchNo = json['batchNo'];
    expiryDate = json['expiryDate'];
    catCode = json['catCode'];
    catName = json['catName'];
    mfacCode = json['mfacCode'];
    mfacName = json['mfacName'];
    brandName = json['brandName'];
    packing = json['packing'];
    dcYear = json['dcYear'];
    dcPrefix = json['dcPrefix'];
    dcSrno = json['dcSrno'];

    qty = (json['qty'] as num?)?.toDouble();
    packQty = (json['packQty'] as num?)?.toDouble();
    looseQty = (json['looseQty'] as num?)?.toDouble();
    schPackQty = (json['schPackQty'] as num?)?.toDouble();
    schLooseQty = (json['schLooseQty'] as num?)?.toDouble();
    schDisc = (json['schDisc'] as num?)?.toDouble();
    purRate = (json['purRate'] as num?)?.toDouble();
    purValue = (json['purValue'] as num?)?.toDouble();
    discPer = (json['discPer'] as num?)?.toDouble();
    margin = (json['margin'] as num?)?.toDouble();

    suppCode = json['suppCode'];
    suppName = json['suppName'];

    discValue = (json['discValue'] as num?)?.toDouble();
    taxableAmt = (json['taxableAmt'] as num?)?.toDouble();

    gstCode = json['gstCode'];
    total = (json['total'] as num?)?.toDouble();
    post = json['post'];
    itemCat = json['itemCat'];

    cessPer = (json['cessPer'] as num?)?.toDouble();
    cessAmt = (json['cessAmt'] as num?)?.toDouble();

    storeId = json['storeId'];
    userId = json['userId'];
    userIdStoreIdItemCode = json['userIdStoreIdItemCode'];
    userIdStoreId = json['userIdStoreId'];

    discount = (json['discount'] as num?)?.toDouble();
    afterDiscount = (json['afterDiscount'] as num?)?.toDouble();
    totalPurchasePrice = (json['totalPurchasePrice'] as num?)?.toDouble();

    igstper = json['igstper'];
    mrp = (json['mrp'] as num?)?.toDouble();
    saleRate = (json['saleRate'] as num?)?.toDouble();

    cgstper = json['cgstper'];
    sgstper = json['sgstper'];

    cgstamt = (json['cgstamt'] as num?)?.toDouble();
    sgstamt = (json['sgstamt'] as num?)?.toDouble();
    igstamt = (json['igstamt'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['billNoLineId'] = billNoLineId;
    data['doc_Number'] = docNumber;
    data['readableDocNo'] = readableDocNo;
    data['date'] = date;
    data['billNo'] = billNo;
    data['billDt'] = billDt;
    data['itemCode'] = itemCode;
    data['itemName'] = itemName;
    data['batchNo'] = batchNo;
    data['expiryDate'] = expiryDate;
    data['catCode'] = catCode;
    data['catName'] = catName;
    data['mfacCode'] = mfacCode;
    data['mfacName'] = mfacName;
    data['brandName'] = brandName;
    data['packing'] = packing;
    data['dcYear'] = dcYear;
    data['dcPrefix'] = dcPrefix;
    data['dcSrno'] = dcSrno;
    data['qty'] = qty;
    data['packQty'] = packQty;
    data['looseQty'] = looseQty;
    data['schPackQty'] = schPackQty;
    data['schLooseQty'] = schLooseQty;
    data['schDisc'] = schDisc;
    data['purRate'] = purRate;
    data['purValue'] = purValue;
    data['discPer'] = discPer;
    data['margin'] = margin;
    data['suppCode'] = suppCode;
    data['suppName'] = suppName;
    data['discValue'] = discValue;
    data['taxableAmt'] = taxableAmt;
    data['gstCode'] = gstCode;
    data['total'] = total;
    data['post'] = post;
    data['itemCat'] = itemCat;
    data['cessPer'] = cessPer;
    data['cessAmt'] = cessAmt;
    data['storeId'] = storeId;
    data['userId'] = userId;
    data['userIdStoreIdItemCode'] = userIdStoreIdItemCode;
    data['userIdStoreId'] = userIdStoreId;
    data['discount'] = discount;
    data['afterDiscount'] = afterDiscount;
    data['totalPurchasePrice'] = totalPurchasePrice;
    data['igstper'] = igstper;
    data['mrp'] = mrp;
    data['saleRate'] = saleRate;
    data['cgstper'] = cgstper;
    data['sgstper'] = sgstper;
    data['cgstamt'] = cgstamt;
    data['sgstamt'] = sgstamt;
    data['igstamt'] = igstamt;
    return data;
  }
}
