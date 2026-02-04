import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

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

  /// ✅ GLOBAL FIELDS MAP (FIXED)
  late final Map<String, TextEditingController> fields;

  final Map<String, RxBool> fieldErrors = {};

  bool _isUpdatingTax = false;

  // --------------------------------------------------
  // 🏗 CONSTRUCTOR
  // --------------------------------------------------
  PurchaseInvoiceItems() {
    fields = {
      "Item Name": itemName,
      "Item Code": itemCode,
      "Manufacturer": manufacturer,
      "Brand": brand,
      "Batch No": batchNo,
      "Rack": rack,
      "Expiry Date": expiryDate,
      "MRP Purchase": mrpPurchase,
      "Purchase Rate": purchaseRate,
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

    for (final key in fields.keys) {
      fieldErrors[key] = false.obs;
    }

    /// 🔹 LISTENERS
    purchaseRate.addListener(_calculateAfterDiscount);
    discount.addListener(_calculateAfterDiscount);

    looseQty.addListener(_calculateTotalPurchase);
    boxQty.addListener(_calculateTotalPurchase);
    packQty.addListener(_calculateTotalPurchase);
    afterDiscount.addListener(_calculateTotalPurchase);

    igstCtrl.addListener(_onIGSTChanged);
  }

  // --------------------------------------------------
  // ✅ VALIDATION
  // --------------------------------------------------
  bool validate() {
    bool isValid = true;

    fields.forEach((key, controller) {
      final value = controller.text.trim();

      // Skip auto-calculated fields
      if (key == "After Discount" ||
          key == "IGST %" ||
          key == "SGST %" ||
          key == "CGST %" ||
          key == "IGST Amount" ||
          key == "SGST Amount" ||
          key == "CGST Amount" ||
          key == "Total Purchase Price") {
        return;
      }

      if (value.isEmpty) {
        fieldErrors[key]!.value = true;
        isValid = false;
      } else {
        fieldErrors[key]!.value = false;
      }
    });

    return isValid;
  }

  // --------------------------------------------------
  // ✅ IGST → SGST & CGST SPLIT
  // --------------------------------------------------
  void _onIGSTChanged() {
    if (_isUpdatingTax) return;

    final igstPercent = double.tryParse(igstCtrl.text) ?? 0;
    final half = igstPercent / 2;

    _isUpdatingTax = true;
    sgstCtrl.text = half.toStringAsFixed(2);
    cgstCtrl.text = half.toStringAsFixed(2);
    _isUpdatingTax = false;

    _calculateTaxAmounts();
  }

  // --------------------------------------------------
  // ✅ AFTER DISCOUNT
  // --------------------------------------------------
  void _calculateAfterDiscount() {
    final rate = double.tryParse(purchaseRate.text) ?? 0;
    final disc = double.tryParse(discount.text) ?? 0;

    final result = rate - (rate * disc / 100);

    if (afterDiscount.text != result.toStringAsFixed(2)) {
      afterDiscount.text = result.toStringAsFixed(2);
    }
  }

  // --------------------------------------------------
  // ✅ TOTAL PURCHASE PRICE
  // --------------------------------------------------
  void _calculateTotalPurchase() {
    final loose = double.tryParse(looseQty.text) ?? 0;
    final box = double.tryParse(boxQty.text) ?? 0;
    final pack = (double.tryParse(packQty.text) ?? 1).clamp(1, double.infinity);
    final afterDisc = double.tryParse(afterDiscount.text) ?? 0;

    final total = ((loose / pack) * afterDisc) + (box * afterDisc);

    if (totalPurchasePrice.text != total.toStringAsFixed(2)) {
      totalPurchasePrice.text = total.toStringAsFixed(2);
    }

    _calculateTaxAmounts();
  }

  // --------------------------------------------------
  // ✅ TAX CALCULATION
  // --------------------------------------------------
  void _calculateTaxAmounts() {
    final total = double.tryParse(totalPurchasePrice.text) ?? 0;

    final igstPercent = double.tryParse(igstCtrl.text) ?? 0;
    final sgstPercent = double.tryParse(sgstCtrl.text) ?? 0;
    final cgstPercent = double.tryParse(cgstCtrl.text) ?? 0;

    IGSTAmount.text = (total * igstPercent / 100).toStringAsFixed(2);
    SGSTAmount.text = (total * sgstPercent / 100).toStringAsFixed(2);
    CGSTAmount.text = (total * cgstPercent / 100).toStringAsFixed(2);
  }

  // --------------------------------------------------
  // ✅ CLEAR
  // --------------------------------------------------
  void clear() {
    for (final c in fields.values) {
      c.clear();
    }
  }
}


