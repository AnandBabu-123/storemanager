import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/sales_invoice_controller.dart';
import '../../model/user_pharmacy_model.dart' show Stores;

class PriceManageView extends StatelessWidget {
  PriceManageView({super.key});

  final SalesInVoiceController controller = Get.put(SalesInVoiceController());

  final TextEditingController itemNameCtrl = TextEditingController();
  final TextEditingController supplierNameCtrl = TextEditingController();
  final TextEditingController fromExpiryCtrl = TextEditingController();
  final TextEditingController toExpiryCtrl = TextEditingController();

  Future<void> _pickDate(
      BuildContext context, TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text =
      "${picked.day.toString().padLeft(2, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Price Manage"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF90EE90), Color(0xFF87CEFA)],
              ),
            ),
          ),
        ),
        /// 🔹 FIXED SUBMIT BUTTON
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12),
          child: Obx(() {
            return SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // ✅ change background here
                  disabledBackgroundColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                controller.isLoading.value ? null : controller.submitOffers,
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.blue)
                    : const Text("Submit",style: TextStyle(color: Colors.white,),),
              ),
            );

          }),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              /// 🔹 FILTER ROW
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: itemNameCtrl,
                      decoration: const InputDecoration(
                        labelText: "Item Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: TextFormField(
                      controller: supplierNameCtrl,
                      decoration: const InputDecoration(
                        labelText: "Supplier Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownOnly(
                      label: "Stores",
                      controller: controller,
                    ),
                  ),
                  const SizedBox(width: 8),

                  /// Search Button
                  SizedBox(
                    height: 48,
                    child:
                    ElevatedButton.icon(
                      onPressed: () {
                        if (controller.selectedStore.value == null) {
                          Get.snackbar("Error", "Please select a store");
                          return;
                        }
                        controller.getPriceMange();
                      },
                      icon: const Icon(Icons.search),
                      label: const Text("Search"),
                    ),

                  ),

                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.priceList.isEmpty) {
                    return const Center(child: Text("No data found"));
                  }

                  return ListView.builder(
                    itemCount: controller.priceList.length,
                    itemBuilder: (context, index) {
                      final item = controller.priceList[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// 🔹 HEADER ROW
                              Row(
                                children: [
                                  Obx(() => Checkbox(
                                    value: item.isSelected.value,
                                    onChanged: (v) => item.isSelected.value = v ?? false,
                                  )),
                                  Expanded(
                                    child: Text(
                                      item.data.itemName ?? "-",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Text("Batch: ${item.data.batch ?? "-"}"),
                                ],
                              ),
                             // Bal Pack Quantity	Bal Loose Quantity	MRP Pack	MRP Value
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text("Store ID: ${item.data.storeId ?? "-"}",style: TextStyle(
                                          fontSize: 12.0, // specify the font size in double
                                          color: Colors.black, // optional: text color
                                        ),),
                                      ),
                                      Expanded(
                                        child: Text("Manufacturer: ${item.data.manufacturer ?? "-"}",style: TextStyle(
                                          fontSize: 12.0, // specify the font size in double
                                          color: Colors.black, // optional: text color
                                        ),),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text("Item Code: ${item.data.itemCode ?? "-"}",style: TextStyle(
                                          fontSize: 12.0, // specify the font size in double
                                          color: Colors.black, // optional: text color
                                        ),),
                                      ),
                                      Expanded(
                                        child: Text("Item Name: ${item.data.itemName ?? "-"}",style: TextStyle(
                                          fontSize: 12.0, // specify the font size in double
                                          color: Colors.black, // optional: text color
                                        ),),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text("Expiry Date: ${formatDate(item.data.expiryDate)}",style: TextStyle(
                                          fontSize: 12.0, // specify the font size in double
                                          color: Colors.black, // optional: text color
                                        ),),
                                      ),
                                      Expanded(
                                        child: Text("Balance Qty: ${item.data.balQuantity ?? "-"}",style: TextStyle(
                                          fontSize: 12.0, // specify the font size in double
                                          color: Colors.black, // optional: text color
                                        ),),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text("Bal Pack Quantity: ${item.data.balPackQuantity ?? "-"}",style: TextStyle(
                                          fontSize: 12.0, // specify the font size in double
                                          color: Colors.black, // optional: text color
                                        ),),
                                      ),
                                      Expanded(
                                        child: Text("Bal Loose Quantity: ${item.data.balLooseQuantity ?? "-"}",style: TextStyle(
                                          fontSize: 12.0, // specify the font size in double
                                          color: Colors.black, // optional: text color
                                        ),),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text("MRP Pack: ${item.data.mrpPack ?? "-"}",style: TextStyle(
                                          fontSize: 12.0, // specify the font size in double
                                          color: Colors.black, // optional: text color
                                        ),),
                                      ),
                                      Expanded(
                                        child: Text("MRP Value: ${item.data.mrpValue ?? "-"}",style: TextStyle(
                                          fontSize: 12.0, // specify the font size in double
                                          color: Colors.black, // optional: text color
                                        ),),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text("Rack: ${item.data.rack ?? "-"}",style: TextStyle(
                                          fontSize: 12.0, // specify the font size in double
                                          color: Colors.black, // optional: text color
                                        ),),
                                      ),
                                      Expanded(
                                        child: Text("Online (Y/N): ${item.data.onlineYesNo ?? "-"}",style: TextStyle(
                                          fontSize: 12.0, // specify the font size in double
                                          color: Colors.black, // optional: text color
                                        ),),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text("Updated At: ${formatDate(item.data.updatedAt)}",style: TextStyle(
                                          fontSize: 12.0, // specify the font size in double
                                          color: Colors.black, // optional: text color
                                        ),),
                                      ),
                                      Expanded(
                                        child: Text("Updated By: ${item.data.updatedBy ?? "-"}",style: TextStyle(
                                          fontSize: 12.0, // specify the font size in double
                                          color: Colors.black, // optional: text color
                                        ),),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                             SizedBox(height: 6,),
                              //Rack	Online (Y/N)	Supplier Name	Updated At	Updated By

                              const Divider(),

                              /// 🔹 EDITABLE FIELDS
                              Obx(() => Row(
                                children: [
                                  _editableField(
                                    label: "Discount",
                                    controller: item.discountCtrl,
                                    enabled: item.isSelected.value,
                                  ),
                                  _editableField(
                                    label: "Offer Qty",
                                    controller: item.offerQtyCtrl,
                                    enabled: item.isSelected.value,
                                  ),
                                  _editableField(
                                    label: "Min Order Qty",
                                    controller: item.minOrderQtyCtrl,
                                    enabled: item.isSelected.value,
                                  ),
                                ],
                              )),

                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              /// 🔹 SEARCH BUTTON

            ],
          ),
        ),
      ),
    );
  }
  Widget _editableField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TextFormField(
          controller: controller,
          readOnly: !enabled, // ✅ FIX
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            isDense: true,
            filled: !enabled,
            fillColor: !enabled ? Colors.grey.shade200 : null,
          ),
        ),
      ),
    );
  }



  Widget _buildDropdownOnly({
    required String label,
    required SalesInVoiceController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Obx(() {
          return DropdownButtonFormField<Stores>(
            value: controller.selectedStore.value,
            hint: const Text("Select Store"),
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: controller.storesList
                .map(
                  (store) => DropdownMenuItem<Stores>(
                value: store,
                child: Text(
                  "${store.id ?? ""} - ${store.name ?? ""}",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
                .toList(),
            onChanged: (value) =>
            controller.selectedStore.value = value,
          );
        }),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  String formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }




}


    