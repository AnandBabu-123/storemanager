class PurchasePaginationResponse {
  final String? message;
  final bool? status;
  final List<PurchaseItem> purchase;
  final int currentPage;
  final int pageSize;
  final int totalElements;
  final int totalPages;

  PurchasePaginationResponse({
    this.message,
    this.status,
    required this.purchase,
    required this.currentPage,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
  });

  factory PurchasePaginationResponse.fromJson(Map<String, dynamic> json) {
    return PurchasePaginationResponse(
      message: json['message'],
      status: json['status'],
      purchase: (json['purchase'] as List? ?? [])
          .map((e) => PurchaseItem.fromJson(e))
          .toList(),
      currentPage: json['currentPage'] ?? 0,
      pageSize: json['pageSize'] ?? 10,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}


class PurchaseItem {
  String? invoiceNo;
  DateTime? date;
  String? suppName;
  String? storeId;
  String? userIdStoreId;

  PurchaseItem({
    this.invoiceNo,
    this.date,
    this.suppName,
    this.storeId,
    this.userIdStoreId,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      invoiceNo: json['invoiceNo'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      suppName: json['suppName'],
      storeId: json['storeId'],
      userIdStoreId: json['userIdStoreId'],
    );
  }
}
