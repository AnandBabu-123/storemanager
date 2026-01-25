import 'package:flutter/cupertino.dart';

class ManualStockItemForm {
  final itemName = TextEditingController();
  final itemCode = TextEditingController();
  final manufacturer = TextEditingController();
  final manufacturerName = TextEditingController();
  final supplier = TextEditingController();
  final rack = TextEditingController();
  final batch = TextEditingController();
  final expiryDate = TextEditingController();
  final balQty = TextEditingController();
  final balPackQty = TextEditingController();
  final balLoose = TextEditingController();
  final qtyTotal = TextEditingController();
  final mrpPack = TextEditingController();
  final purRate = TextEditingController();
  final mrpValue = TextEditingController();
  final category = TextEditingController();
  final online = TextEditingController();
  final stockValueMRP = TextEditingController();
  final stockValuePurRate = TextEditingController();

  late final Map<String, TextEditingController> fields = {
    "Item Name": itemName,
    "Item Code": itemCode,
    "Manufacturer": manufacturer,
    "MF Name": manufacturerName,
    "Supplier": supplier,
    "Rack": rack,
    "Batch": batch,
    "Expiry Date": expiryDate,
    "Bal Qty": balQty,
    "Bal Pack Qty": balPackQty,
    "Bal Loose": balLoose,
    "Qty Total": qtyTotal,
    "MRP Pack": mrpPack,
    "Pur Rate": purRate,
    "MRP Value": mrpValue,
    "Category": category,
    "Online": online,
    "Stock Value MRP": stockValueMRP,
    "Stock Value Pur Rate": stockValuePurRate,
  };

  /// clear all fields
  void clear() {
    for (final c in fields.values) {
      c.clear();
    }
  }
}
