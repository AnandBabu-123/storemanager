import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/add_pharmacy_controller.dart';
import '../../controllers/purchase_invoice_items.dart';
import '../../controllers/sales_invoice_controller.dart';
import '../../model/user_pharmacy_model.dart';

class PurchaseInvoiceScreen extends StatelessWidget {
  PurchaseInvoiceScreen({super.key});

  final SalesInVoiceController controller =
  Get.put(SalesInVoiceController());

  final AddPharmacyController pharmacyController =
  Get.put(AddPharmacyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase Invoice"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF90EE90), Color(0xFF87CEFA)],
            ),
          ),
        ),
      ),
      body:

      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// STORE DROPDOWN
              _buildDropdownOnly(
                label: "Stores",
                controller: pharmacyController,
              ),

              const SizedBox(height: 8),

              /// STORE DETAILS (EXPAND / COLLAPSE)
              Obx(() {
                final store = pharmacyController.selectedStore.value;
                if (store == null) return const SizedBox();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER (CLICK TO TOGGLE)
                    GestureDetector(
                      onTap: () => pharmacyController.isStoreExpanded.value =
                      !pharmacyController.isStoreExpanded.value,
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Store Details",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              pharmacyController.isStoreExpanded.value
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// DETAILS BODY
                    if (pharmacyController.isStoreExpanded.value)
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 4,
                            ),
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
                    child: SizedBox(
                      height: 52,
                      child: TextField(
                        controller: pharmacyController.invoiceNoCtrl,
                        style: const TextStyle(fontSize: 13),
                        decoration:  InputDecoration(
                          labelText: "Invoice No",
                          isDense: true,
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.blue),
                          ),

                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: TextField(
                        controller: pharmacyController.supplierCodeCtrl,
                        style: const TextStyle(fontSize: 13),
                        decoration:  InputDecoration(
                          labelText: "Varchar",
                          isDense: true,
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.blue),
                          ),

                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: TextField(
                        controller: pharmacyController.supplierNameCtrl,
                        style: const TextStyle(fontSize: 13),
                        decoration:  InputDecoration(
                          labelText: "Supplier Name",
                          isDense: true,
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.blue),
                          ),

                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: TextField(
                        controller: pharmacyController.purchaseDateCtrl,
                        style: const TextStyle(fontSize: 13),
                        readOnly: true,
                        decoration:  InputDecoration(
                          labelText: "Purchase Date",
                          isDense: true,
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.blue),
                          ),

                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: Get.context!,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                "${pickedDate.year.toString().padLeft(4, '0')}-"
                                "${pickedDate.month.toString().padLeft(2, '0')}-"
                                "${pickedDate.day.toString().padLeft(2, '0')}";
                            pharmacyController.purchaseDateCtrl.text = formattedDate;
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// ITEMS LIST
              Obx(() {
                return ListView.builder(
                  shrinkWrap: true, // 🔹 important
                  physics: const NeverScrollableScrollPhysics(), // let scrollview handle
                  itemCount: pharmacyController.purChaseItemForms.length,
                  itemBuilder: (context, index) {
                    return _itemContainer(
                      context,
                      pharmacyController,
                      pharmacyController.purChaseItemForms[index],
                      index,
                    );
                  },
                );
              }),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: pharmacyController.addItems,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Item"),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      )

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


  /// 🔹 ITEM CARD
  Widget _itemContainer(
      BuildContext context,
      AddPharmacyController pharmacyController,
      PurchaseInvoiceItems form,
      int index,
      ) {
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
          /// 🔹 HEADER + DELETE
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
                  onPressed: () => pharmacyController.removeItems(index),
                ),
            ],
          ),

          const Divider(),

          /// 🔹 FORM FIELDS
          ...form.fields.entries.map((entry) {
            final bool isAutoField =
                entry.key == "After Discount" ||
                    entry.key == "IGST %" ||
                    entry.key == "SGST %" ||
                    entry.key == "CGST %";

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
                        ? _itemNameSearchField(pharmacyController, form, index)
                        : entry.key == "Expiry Date"
                        ? _expiryDateField(context, entry.value)
                        : Obx(() {
                      final hasError = form.fieldErrors[entry.key]!.value;

                      OutlineInputBorder border(Color color) => OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: color),
                      );

                      return TextFormField(
                        controller: entry.value,
                        readOnly: isAutoField,
                        decoration: InputDecoration(
                          isDense: true,
                          errorText: hasError ? "Required" : null,

                          border: border(Colors.grey),
                          enabledBorder: border(hasError ? Colors.red : Colors.grey),
                          focusedBorder: border(hasError ? Colors.red : Colors.blue),
                          errorBorder: border(Colors.red),
                          focusedErrorBorder: border(Colors.red),
                        ),
                      );
                    }),
                  )


                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 12),

          /// 🔹 ACTION BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  form.clear();
                },
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  // /// ✅ Validate header FIRST
                  // if (!pharmacyController.validateInvoiceHeader()) return;
                  //
                  // /// ✅ Validate ONLY this item
                  // if (!pharmacyController.validateSingleItem(form)) return;

                  /// 🔴 STEP 1 — HEADER VALIDATION (MANDATORY ALWAYS)
                  final headerValid = pharmacyController.validateInvoiceHeader();
                  if (!headerValid) return;   // 🚨 STOP HERE

                  /// 🔴 STEP 2 — ONLY THIS ITEM VALIDATION
                  final itemValid = pharmacyController.validateSingleItem(form);
                  if (!itemValid) return;     // 🚨 STOP HERE


                  await pharmacyController.addPurChaseInvoice();
                },
                child: const Text("Save"),
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _expiryDateField(
      BuildContext context,
      TextEditingController controller,
      ) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color),
    );

    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        isDense: true,
        hintText: "Select date",
        suffixIcon: const Icon(Icons.calendar_today),

        border: border(Colors.grey),
        enabledBorder: border(Colors.grey),
        focusedBorder: border(Colors.blue),
      ),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          controller.text =
          "${picked.year.toString().padLeft(4, '0')}-"
              "${picked.month.toString().padLeft(2, '0')}-"
              "${picked.day.toString().padLeft(2, '0')}";
        }
      },
    );
  }


  Widget _itemNameSearchField(
      AddPharmacyController c,
      PurchaseInvoiceItems form,
      int index,
      ) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔍 SEARCH FIELD
        TextFormField(
          controller: form.fields["Item Name"],
          decoration: InputDecoration(
            hintText: "Search Item",
            isDense: true,
            border: border(Colors.grey),
            enabledBorder: border(Colors.grey),
            focusedBorder: border(Colors.blue),
          ),
          onChanged: (val) {
            if (val.length >= 2) {
              c.searchItemByName(val);
            }
          },
        ),

        /// 🔽 RESULT LIST
        Obx(() {
          if (c.searchedItems.isEmpty) return const SizedBox();

          return Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12), // 🔥 updated
            child: Container(
              margin: const EdgeInsets.only(top: 4),
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12), // 🔥 updated
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: c.searchedItems.length,
                itemBuilder: (context, i) {
                  final item = c.searchedItems[i];
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      c.selectItem(item, index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.itemName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          if (item.itemCode != null)
                            Text(
                              item.itemCode!,
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }


  /// 🔹 STORE DROPDOWN
  Widget _buildDropdownOnly({
    required String label,
    required AddPharmacyController controller,
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
            onChanged: (value) => controller.selectedStore.value = value,
          );
        }),
      ],
    );
  }

}

