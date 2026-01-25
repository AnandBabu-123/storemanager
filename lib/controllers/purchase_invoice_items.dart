import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class PurchaseInvoiceItems {
  final itemName = TextEditingController();
  final itemCode = TextEditingController();
  final manufacturer = TextEditingController();
  final brand = TextEditingController();
  final batchNo = TextEditingController();
  final rack = TextEditingController();
  final expiryDate = TextEditingController();
  final mrpPurchase = TextEditingController();
  final purchaseRate = TextEditingController();
  final discount = TextEditingController();
  final afterDiscount = TextEditingController();
  final hSNCode = TextEditingController();

  final gstCtrl = TextEditingController();
  final igstCtrl = TextEditingController();
  final sgstCtrl = TextEditingController();
  final cgstCtrl = TextEditingController();

  final IGSTAmount = TextEditingController();
  final SGSTAmount = TextEditingController();
  final CGSTAmount = TextEditingController();

  final totalPurchasePrice = TextEditingController();
  final looseQty = TextEditingController();
  final boxQty = TextEditingController();
  final packQty = TextEditingController();

  late final Map<String, TextEditingController> fields = {
    "Item Name": itemName,
    "Item Code": itemCode,
    "Manufacturer": manufacturer,
    "Brand": brand,
    "Batch No": batchNo,
    "Rack": rack,
    "Expiry Date": expiryDate,
    "MRP Purchase": mrpPurchase,
    "PurChase Rate": purchaseRate,
    "Discount": discount,
    "After Discount": afterDiscount,
    "Loose Qty": looseQty,
    "Box Qty": boxQty,
    "Pack Qty": packQty,
    "HSN Code": hSNCode,
    "GST Code": gstCtrl,
    "IGST %": igstCtrl,
    "SGST %": sgstCtrl,
    "CGST %": cgstCtrl,
    "IGST Amount": IGSTAmount,
    "SGST Amount": SGSTAmount,
    "CGST Amount": CGSTAmount,
    "Total Purchase Price": totalPurchasePrice,

  };

  /// 🔹 false = intra-state, true = inter-state
  bool isInterState = false;


  void _calculateGSTSplit() {
    final double gst = double.tryParse(gstCtrl.text) ?? 0;

    if (gst <= 0) {
      igstCtrl.clear();
      sgstCtrl.clear();
      cgstCtrl.clear();
      return;
    }

    if (isInterState) {
      // 🌍 Inter-state → IGST only
      igstCtrl.text = gst.toStringAsFixed(2);
      sgstCtrl.text = "0";
      cgstCtrl.text = "0";
    } else {
      // 🏠 Intra-state → SGST + CGST
      final half = gst / 2;
      igstCtrl.text = "0";
      sgstCtrl.text = half.toStringAsFixed(2);
      cgstCtrl.text = half.toStringAsFixed(2);
    }
  }

  final Map<String, RxBool> fieldErrors = {};

  PurchaseInvoiceItems() {
    for (final key in fields.keys) {
      fieldErrors[key] = false.obs;
    }

    mrpPurchase.addListener(_calculateAfterDiscount);
    purchaseRate.addListener(_calculateAfterDiscount);
    discount.addListener(_calculateAfterDiscount);
    gstCtrl.addListener(_calculateGSTSplit);
  }

  bool validate() {
    bool isValid = true;

    fields.forEach((key, controller) {
      if (controller.text.trim().isEmpty) {
        fieldErrors[key]!.value = true;
        isValid = false;
      } else {
        fieldErrors[key]!.value = false;
      }
    });

    return isValid;
  }

  // --------------------------------------------------
  // ✅ After Discount calculation
  // --------------------------------------------------
  void _calculateAfterDiscount() {
    final double rate = double.tryParse(purchaseRate.text) ?? 0;
    final double disc = double.tryParse(discount.text) ?? 0;

    final double discountAmount = rate * (disc / 100);
    final double result = rate - discountAmount;

    afterDiscount.text = result.toStringAsFixed(2);
  }

  // --------------------------------------------------
  // ✅ Clear all fields
  // --------------------------------------------------
  void clear() {
    for (final c in fields.values) {
      c.clear();
    }
  }
}
