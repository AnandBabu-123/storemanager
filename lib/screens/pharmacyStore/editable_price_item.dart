import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../model/price_manage_model.dart';

class EditablePriceItem {
  final DataItem data;

  /// EDIT STATE
  final RxBool isSelected = false.obs;

  /// CONTROLLERS
  final TextEditingController discountCtrl;
  final TextEditingController offerQtyCtrl;
  final TextEditingController minOrderQtyCtrl;

  EditablePriceItem(this.data)
      : discountCtrl =
  TextEditingController(text: data.discount?.toString() ?? ""),
        offerQtyCtrl =
        TextEditingController(text: data.offerQty?.toString() ?? ""),
        minOrderQtyCtrl =
        TextEditingController(text: data.minOrderQty?.toString() ?? "");
}


