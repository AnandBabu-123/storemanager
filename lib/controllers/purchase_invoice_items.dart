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

  final gstCtrl = TextEditingController(); // not used in calc now
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

  final Map<String, RxBool> fieldErrors = {};

  PurchaseInvoiceItems() {
    for (final key in fields.keys) {
      fieldErrors[key] = false.obs;
    }

    /// 🔹 Calculations
    purchaseRate.addListener(_calculateAfterDiscount);
    discount.addListener(_calculateAfterDiscount);

    looseQty.addListener(_calculateTotalPurchase);
    boxQty.addListener(_calculateTotalPurchase);
    packQty.addListener(_calculateTotalPurchase);
    afterDiscount.addListener(_calculateTotalPurchase);

    igstCtrl.addListener(_calculateTaxAmounts);
  }

  // --------------------------------------------------
  // ✅ VALIDATION
  // --------------------------------------------------
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
  // ✅ AFTER DISCOUNT
  // After Discount = rate - (rate * discount / 100)
  // --------------------------------------------------
  void _calculateAfterDiscount() {
    final rate = double.tryParse(purchaseRate.text) ?? 0;
    final disc = double.tryParse(discount.text) ?? 0;

    final result = rate - (rate * disc / 100);
    afterDiscount.text = result.toStringAsFixed(2);
  }

  // --------------------------------------------------
  // ✅ TOTAL PURCHASE PRICE
  // (looseQty / packQty * afterDiscount) + boxQty * afterDiscount
  // --------------------------------------------------
  void _calculateTotalPurchase() {
    final loose = double.tryParse(looseQty.text) ?? 0;
    final box = double.tryParse(boxQty.text) ?? 0;
    final pack = double.tryParse(packQty.text) ?? 1; // prevent divide-by-zero
    final afterDisc = double.tryParse(afterDiscount.text) ?? 0;

    final total =
        ((loose / pack) * afterDisc) +
            (box * afterDisc);

    totalPurchasePrice.text = total.toStringAsFixed(2);

    _calculateTaxAmounts(); // update tax automatically
  }

  // --------------------------------------------------
  // ✅ TAX CALCULATION
  // IGST = IGST% * total / 100
  // SGST = IGST / 2
  // CGST = IGST / 2
  // --------------------------------------------------
  void _calculateTaxAmounts() {
    final total = double.tryParse(totalPurchasePrice.text) ?? 0;
    final igstPercent = double.tryParse(igstCtrl.text) ?? 0;

    final igstAmount = total * igstPercent / 100;
    final half = igstAmount / 2;

    IGSTAmount.text = igstAmount.toStringAsFixed(2);
    SGSTAmount.text = half.toStringAsFixed(2);
    CGSTAmount.text = half.toStringAsFixed(2);
  }

  // --------------------------------------------------
  // ✅ CLEAR ALL FIELDS
  // --------------------------------------------------
  void clear() {
    for (final c in fields.values) {
      c.clear();
    }
  }
}
