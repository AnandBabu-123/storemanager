import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

class SalesItemForm {
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

  final afterDiscount = TextEditingController();
  final IGST = TextEditingController(text: "12"); // static
  final SGST = TextEditingController(text: "6");  // static
  final CGST = TextEditingController(text: "6");  // static

  final IGSTAmount = TextEditingController();
  final SGSTAmount = TextEditingController();
  final CGSTAmount = TextEditingController();
  final FinalSalePrice = TextEditingController();
  final TotalPurchasePrice = TextEditingController();
  final ProfitOrLoss = TextEditingController();
  final BoxQuantity = TextEditingController();

  /// 🔹 LABEL → CONTROLLER MAP
  late final Map<String, TextEditingController> fields = {
    "Item Name": itemName,
    "Item Code": itemCode,
    "Manufacturer": manufacturer,
    "Brand": brand,
    "Batch No": batch,
    "Expiry Date": expiryDate,
    "Pak Qty" :pakQuantity,
    "Loose Qty":looseQuantity,
    "MRP": mrp,
    "Discount": discount,
    "After Discount": afterDiscount,
    "Profit Or Loss": ProfitOrLoss,
    "Box Quantity": BoxQuantity,
    "GST": gst,
    "HSN": hsn,
    "IGST %": IGST,
    "SGST %": SGST,
    "CGST %": CGST,
    "IGST Amount": IGSTAmount,
    "SGST Amount": SGSTAmount,
    "CGST Amount": CGSTAmount,
    "Final Sale Price": FinalSalePrice,
    "Total Purchase Price": TotalPurchasePrice,

  };

  // 🔥 MAIN CALCULATION
  void calculateAll() {
    double mrpVal = double.tryParse(mrp.text) ?? 0;
    double discountPer = double.tryParse(discount.text) ?? 0;

    // 🔹 this comes from API
    double purchasePriceVal =
        double.tryParse(TotalPurchasePrice.text) ?? 0;

    // 🔹 tax % (static)
    double igstPer = double.tryParse(IGST.text) ?? 12;
    double sgstPer = double.tryParse(SGST.text) ?? 6;
    double cgstPer = double.tryParse(CGST.text) ?? 6;

    // =========================
    // 1️⃣ AFTER DISCOUNT
    // =========================
    double discountAmount = mrpVal * discountPer / 100;
    double afterDiscountVal = mrpVal - discountAmount;
    afterDiscount.text = afterDiscountVal.toStringAsFixed(2);

    // =========================
    // 2️⃣ TAX AMOUNTS
    // =========================
    double igstAmt = afterDiscountVal * igstPer / 100;
    double sgstAmt = afterDiscountVal * sgstPer / 100;
    double cgstAmt = afterDiscountVal * cgstPer / 100;

    IGSTAmount.text = igstAmt.toStringAsFixed(2);
    SGSTAmount.text = sgstAmt.toStringAsFixed(2);
    CGSTAmount.text = cgstAmt.toStringAsFixed(2);

    // =========================
    // 3️⃣ FINAL SALE PRICE
    // =========================
    double finalSale =
        afterDiscountVal + igstAmt + sgstAmt + cgstAmt;

    FinalSalePrice.text = finalSale.toStringAsFixed(2);

    // =========================
    // 4️⃣ PROFIT / LOSS
    // =========================
    double profit = finalSale - purchasePriceVal;
    ProfitOrLoss.text = profit.toStringAsFixed(2);
  }

}

