class StoreBusinessType {
  int? id;
  String? businessTypeId;
  String? businessName;

  StoreBusinessType({
    this.id,
    this.businessTypeId,
    this.businessName,
  });

  factory StoreBusinessType.fromJson(Map<String, dynamic> json) {
    return StoreBusinessType(
      id: json['id'],
      businessTypeId: json['businessTypeId'],
      businessName: json['businessName'],
    );
  }
}
