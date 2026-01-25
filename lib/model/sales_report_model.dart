
class SalesReportModel {
  bool? status;
  String? message;
  List<Invoice>? invoices;
  int? currentPage;
  int? pageSize;
  int? totalElements;
  int? totalPages;

  SalesReportModel({
    this.status,
    this.message,
    this.invoices,
    this.currentPage,
    this.pageSize,
    this.totalElements,
    this.totalPages,
  });

  SalesReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    if (json['invoices'] != null) {
      invoices = <Invoice>[];
      json['invoices'].forEach((v) {
        invoices!.add(Invoice.fromJson(v));
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

    if (invoices != null) {
      data['invoices'] = invoices!.map((v) => v.toJson()).toList();
    }

    data['currentPage'] = currentPage;
    data['pageSize'] = pageSize;
    data['totalElements'] = totalElements;
    data['totalPages'] = totalPages;
    return data;
  }
}
class Invoice {
  String? docNumber;
  String? date;
  String? custName;
  String? storeId;
  String? userIdStoreId;

  Invoice({
    this.docNumber,
    this.date,
    this.custName,
    this.storeId,
    this.userIdStoreId,
  });

  Invoice.fromJson(Map<String, dynamic> json) {
    docNumber = json['doc_Number'];   // 👈 exact API key
    date = json['date'];
    custName = json['custName'];
    storeId = json['storeId'];
    userIdStoreId = json['userIdStoreId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['doc_Number'] = docNumber;
    data['date'] = date;
    data['custName'] = custName;
    data['storeId'] = storeId;
    data['userIdStoreId'] = userIdStoreId;
    return data;
  }
}
