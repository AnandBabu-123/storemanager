class ItemStock {
  double? purRate;
  String? hsnGroup;
  String? itemCode;
  String? batch;
  int? gst;
  double? mRP;
  String? manufacturer;
  DateTime? expiryDate;
  String? itemName;
  String? brand;

  ItemStock({
    this.purRate,
    this.hsnGroup,
    this.itemCode,
    this.batch,
    this.gst,
    this.mRP,
    this.manufacturer,
    this.expiryDate,
    this.itemName,
    this.brand,
  });

  factory ItemStock.fromJson(Map<String, dynamic> json) {
    return ItemStock(
      purRate: json['purRate']?.toDouble(),
      hsnGroup: json['hsnGroup'],
      itemCode: json['itemCode'],
      batch: json['batch'],
      gst: json['gst'],
      mRP: json['mRP']?.toDouble(),
      manufacturer: json['manufacturer'],
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      itemName: json['itemName'],
      brand: json['brand'],
    );
  }
}
