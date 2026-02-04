import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/sales_invoice_controller.dart';
import '../../controllers/sales_item_form.dart';
import '../../model/user_pharmacy_model.dart';

class SalesInvoiceView extends StatelessWidget {
  SalesInvoiceView({super.key});

  final SalesInVoiceController controller =
  Get.put(SalesInVoiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales Invoice"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF90EE90), Color(0xFF87CEFA)],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: controller.salesFormKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// STORE DROPDOWN
                _buildDropdownOnly(
                  label: "Stores",
                  controller: controller,
                ),

                const SizedBox(height: 8),

                /// STORE DETAILS
                Obx(() {
                  final store = controller.selectedStore.value;
                  if (store == null) return const SizedBox();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () =>
                        controller.isStoreExpanded.value =
                        !controller.isStoreExpanded.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Store Details",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Icon(controller.isStoreExpanded.value
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ),

                      if (controller.isStoreExpanded.value)
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
                            ],
                          ),
                          child: Column(
                            children: [
                              _infoRow("Store ID", store.id),
                              _infoRow("Name", store.name),
                              _infoRow("Type", store.type),
                              _infoRow("Location", store.location),
                              _infoRow("District", store.district),
                              _infoRow("State", store.state),
                              _infoRow("PinCode", store.pincode),
                              _infoRow("Owner", store.owner),
                              _infoRow("Owner Contact", store.ownerContact),
                              _infoRow("GST Number", store.gstNumber),
                            ],
                          ),
                        ),
                    ],
                  );
                }),

                const SizedBox(height: 12),

                /// CUSTOMER ROW
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.customerNameController,
                        decoration: InputDecoration(
                          labelText: "Customer Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) =>
                        v == null || v.trim().isEmpty ? "Customer name required" : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: controller.customerPhoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Customer Phone Number",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Phone number required";
                          if (v.length < 10) return "Invalid phone number";
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// 🔥 ITEMS LIST (IMPORTANT FIX)
                Obx(() {
                  return ListView.builder(
                    itemCount: controller.itemForms.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _itemContainer(
                        context,
                        controller,
                        controller.itemForms[index],
                        index,
                      );
                    },
                  );
                }),

                const SizedBox(height: 12),

                /// ADD ITEM BUTTON
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: controller.addItem,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Item"),
                  ),
                ),

                const SizedBox(height: 20),

                /// SAVE BUTTON



              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value ?? "-"),
          ),
        ],
      ),
    );
  }


  Widget _itemContainer(
      BuildContext context,
      SalesInVoiceController controller,
      SalesItemForm form,
      int index,
      ) {
    bool isReadOnly(String key) {
      return [
        "After Discount",
        "IGST %",
        "SGST %",
        "CGST %",
        "IGST Amount",
        "SGST Amount",
        "CGST Amount",
        "Final Sale Price",
        "Total Purchase Price",
        "Profit Or Loss",
      ].contains(key);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
        ],
      ),
      child: Column(
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Item ${index + 1}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (index != 0)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.removeItem(index),
                ),
            ],
          ),

          const Divider(),

          /// FORM FIELDS
          ...form.fields.entries.map((entry) {
            final isExpiry = entry.key == "Expiry Date";

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 160,
                    child: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                  Expanded(
                    child: entry.key == "Item Name"
                        ? _itemAutoComplete(controller, form, entry.value)

                    /// 🔹 EXPIRY DATE PICKER
                        : isExpiry
                        ? GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();

                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          entry.value.text =
                          "${picked.day.toString().padLeft(2, '0')}-"
                              "${picked.month.toString().padLeft(2, '0')}-"
                              "${picked.year}";
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: entry.value,
                          decoration: InputDecoration(
                            hintText: "Select Expiry Date",
                            suffixIcon: const Icon(Icons.calendar_today),
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Expiry Date required";
                            }
                            return null;
                          },
                        ),
                      ),
                    )

                    /// 🔹 NORMAL TEXT FIELDS
                        : TextFormField(
                      controller: entry.value,
                      readOnly: isReadOnly(entry.key),
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (isReadOnly(entry.key)) return null;

                        if (value == null || value.trim().isEmpty) {
                          return "${entry.key} required";
                        }
                        return null;
                      },
                      onChanged: (_) => form.calculateAll(),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          /// ACTION BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  /// STORE REQUIRED
                  if (controller.selectedStore.value == null) {
                    Get.snackbar("Error", "Please select Store",
                        backgroundColor: Colors.red.shade100);
                    return;
                  }

                  /// CUSTOMER REQUIRED
                  if (controller.customerNameController.text.trim().isEmpty ||
                      controller.customerPhoneController.text.trim().isEmpty) {
                    Get.snackbar("Error", "Customer details required",
                        backgroundColor: Colors.red.shade100);
                    return;
                  }

                  /// AT LEAST ONE ITEM REQUIRED
                  if (controller.itemForms.isEmpty) {
                    Get.snackbar("Error", "Add at least one item",
                        backgroundColor: Colors.red.shade100);
                    return;
                  }

                  /// VALIDATE EACH ITEM
                  for (int i = 0; i < controller.itemForms.length; i++) {
                    final item = controller.itemForms[i];

                    if (!item.validateItem()) {
                      Get.snackbar(
                        "Error",
                        "Please fill all fields in Item ${i + 1}",
                        backgroundColor: Colors.red.shade100,
                      );
                      return;
                    }
                  }

                  /// ALL GOOD
                  await controller.addSalesInvoice();
                },
                child: const Text("Save"),
              )
            ],
          ),
        ],
      ),
    );

  }
  Future<void> _pickExpiryDate(
      BuildContext context,
      TextEditingController controller,
      ) async {
    DateTime now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
    );

    if (picked != null) {
      controller.text =
      "${picked.day.toString().padLeft(2, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.year}";
    }
  }


  Widget _itemAutoComplete(
      SalesInVoiceController controller,
      SalesItemForm form,
      TextEditingController textController,
      ) {
    return Autocomplete<String>(
      optionsBuilder: (value) {
        if (value.text.isEmpty) return const Iterable<String>.empty();
        return controller.itemSearchList.where(
              (e) => e.toLowerCase().contains(value.text.toLowerCase()),
        );
      },
      onSelected: (selection) {
        textController.text = selection;
        controller.searchItemByName(selection, form);
      },
      fieldViewBuilder: (context, fieldController, focusNode, _) {
        fieldController.text = textController.text;

        return TextFormField(
          controller: fieldController,
          focusNode: focusNode,
          decoration: InputDecoration(
            isDense: true,
            hintText: "Search Item",

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          onChanged: (v) => textController.text = v,
        );
      },
    );
  }


  /// 🔹 STORE DROPDOWN
  Widget _buildDropdownOnly({
    required String label,
    required SalesInVoiceController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Obx(() {
          return DropdownButtonFormField<Stores>(
            validator: (value) => value == null ? "Store required" : null,
            value: controller.selectedStore.value,
            hint: const Text("Select Store"),
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: controller.storesList
                .map(
                  (store) => DropdownMenuItem<Stores>(
                value: store,
                child: Text("${store.id} - ${store.name}"),
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
}

