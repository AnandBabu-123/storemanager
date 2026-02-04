import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

class SalesItemForm {
  final formKey = GlobalKey<FormState>();

  // 🔹 USER INPUT CONTROLLERS
  final itemName = TextEditingController();
  final itemCode = TextEditingController();
  final manufacturer = TextEditingController();
  final brand = TextEditingController();
  final batch = TextEditingController();
  final expiryDate = TextEditingController();
  final mrp = TextEditingController();
  final gst = TextEditingController();
  final hsn = TextEditingController();
  final purchaseRate = TextEditingController();
  final discount = TextEditingController();
  final pakQuantity = TextEditingController();
  final looseQuantity = TextEditingController();
  final BoxQuantity = TextEditingController();

  // 🔹 AUTO CALCULATED
  final afterDiscount = TextEditingController();

  final IGST = TextEditingController(text: "12");
  final SGST = TextEditingController(text: "6");
  final CGST = TextEditingController(text: "6");

  final IGSTAmount = TextEditingController();
  final SGSTAmount = TextEditingController();
  final CGSTAmount = TextEditingController();
  final FinalSalePrice = TextEditingController();
  final TotalPurchasePrice = TextEditingController();
  final ProfitOrLoss = TextEditingController();

  /// 🧠 MAP FOR UI BUILDING (THIS FIXES YOUR ERROR)
  late final Map<String, TextEditingController> fields = {
    "Item Name": itemName,
    "Item Code": itemCode,
    "Manufacturer": manufacturer,
    "Brand": brand,
    "Batch No": batch,
    "Expiry Date": expiryDate,
    "Pak Qty": pakQuantity,
    "Loose Qty": looseQuantity,
    "MRP": mrp,
    "Discount %": discount,
    "After Discount": afterDiscount,
    "Box Quantity": BoxQuantity,
    "GST %": gst,
    "HSN": hsn,
    "IGST %": IGST,
    "SGST %": SGST,
    "CGST %": CGST,
    "IGST Amount": IGSTAmount,
    "SGST Amount": SGSTAmount,
    "CGST Amount": CGSTAmount,
    "Final Sale Price": FinalSalePrice,
    "Total Purchase Price": TotalPurchasePrice,
    "Profit Or Loss": ProfitOrLoss,
  };

  /// 🔴 ONLY THESE ARE MANDATORY PER ITEM
  List<TextEditingController> mandatoryFields() => [
    itemName,
    itemCode,
    manufacturer,
    brand,
    batch,
    expiryDate,
    pakQuantity,
    looseQuantity,
    mrp,
    discount,
    gst,
    hsn,
    BoxQuantity,
  ];

  /// ✅ VALIDATE SINGLE ITEM
  bool validateItem() {
    for (var c in mandatoryFields()) {
      if (c.text.trim().isEmpty) return false;
    }
    return true;
  }

  // =========================
  // 🔥 CALCULATIONS
  // =========================
  void calculateAll() {
    double mrpVal = double.tryParse(mrp.text) ?? 0;
    double discountPer = double.tryParse(discount.text) ?? 0;
    double purchasePriceVal =
        double.tryParse(TotalPurchasePrice.text) ?? 0;

    double igstPer = double.tryParse(IGST.text) ?? 12;
    double sgstPer = double.tryParse(SGST.text) ?? 6;
    double cgstPer = double.tryParse(CGST.text) ?? 6;

    /// 1️⃣ After Discount
    double discountAmount = mrpVal * discountPer / 100;
    double afterDiscountVal = mrpVal - discountAmount;
    afterDiscount.text = afterDiscountVal.toStringAsFixed(2);

    /// 2️⃣ Tax Amounts
    double igstAmt = afterDiscountVal * igstPer / 100;
    double sgstAmt = afterDiscountVal * sgstPer / 100;
    double cgstAmt = afterDiscountVal * cgstPer / 100;

    IGSTAmount.text = igstAmt.toStringAsFixed(2);
    SGSTAmount.text = sgstAmt.toStringAsFixed(2);
    CGSTAmount.text = cgstAmt.toStringAsFixed(2);

    /// 3️⃣ Final Sale Price
    double finalSale =
        afterDiscountVal + igstAmt + sgstAmt + cgstAmt;

    FinalSalePrice.text = finalSale.toStringAsFixed(2);

    /// 4️⃣ Profit / Loss
    double profit = finalSale - purchasePriceVal;
    ProfitOrLoss.text = profit.toStringAsFixed(2);
  }
}



