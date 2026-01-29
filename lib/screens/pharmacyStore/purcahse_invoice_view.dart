import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../controllers/add_pharmacy_controller.dart';
import '../../model/user_pharmacy_model.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PurcahseInvoiceView extends StatelessWidget {
  PurcahseInvoiceView({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Store Dropdown + Search
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _buildDropdownOnly(
                    label: "Stores",
                    controller: pharmacyController,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                    label: const Text("Search"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Invoice + Items
            _buildInvoiceContainer(),
            SizedBox(height: 120,)
          ],
        ),
      ),
    );
  }

  // -------------------- STORE DROPDOWN --------------------
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

  // -------------------- MAIN CONTAINER --------------------
  Widget _buildInvoiceContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Add Item Button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: pharmacyController.addItem,
              icon: const Icon(Icons.add),
              label: const Text("Add Item"),
            ),
          ),


          // Item Cards
          Obx(() {
            return Column(
              children: pharmacyController.itemIndexes
                  .map((index) => _buildItemCard(index))
                  .toList(),
            );
          }),

        ],
      ),
    );
  }

  // -------------------- SINGLE ITEM CARD --------------------
  Widget _buildItemCard(int index) {
    final c = pharmacyController;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // HEADER FIELDS
          Row(
            children: [
              Expanded(
                child: _rows(
                  "Invoice No",
                  _textFieldControllers(c.invoiceNoCtrl),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _rows(
                  "Supplier Code",
                  _textFieldControllers(c.supplierCodeCtrl),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _rows(
                  "Supplier Name",
                  _textFieldControllers(c.supplierNameCtrl),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _rows(
                  "Purchase Date",
                  _textFieldControllers(c.purchaseDateCtrl),
                ),
              ),
            ],
          ),


          const SizedBox(height: 12),

          // ITEM FIELDS
          _buildItemFields(index),

          const SizedBox(height: 12),

          // ACTION BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Save"),
              ),
              if (index != 0) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => pharmacyController.removeItem(index),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // -------------------- ITEM FIELDS --------------------
  Widget _buildItemFields(int index) {
    final c = pharmacyController;
    return Column(
      children: [
        _row("Item Name", _itemNameSearchField(c, index)),
        _row("Item Code", _textFieldController(c.itemCodeCtrls[index])),
        _row("Manufacturer", _textFieldController(c.manufacturerCtrls[index])),
        _row("Brand", _textFieldController(c.brandCtrls[index])),
        _row("GST %", _textFieldController(c.gstCtrls[index])),
        _row("HSN Code", _textFieldController(c.hsnCtrls[index])),
      ],
    );
  }

  Widget _row(String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12), // 🔥 radius 12
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: field,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rows(String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12), // 🔥 radius 12
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: field,
            ),
          ),
        ],
      ),
    );
  }


  Widget _textFieldControllers(TextEditingController controller) {
    return SizedBox(
      height: 12, // 👈 reduce box height (try 36–44)
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 13), // 👈 smaller text
        decoration: InputDecoration(
          isDense: true, // 👈 VERY IMPORTANT
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 38, // 👈 reduce vertical padding
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }



  Widget _textFieldController(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration:  InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      ),
    );
  }

  // -------------------- ITEM NAME SEARCH --------------------
  Widget _itemNameSearchField(AddPharmacyController c, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: c.itemNameCtrls[index],
          decoration: const InputDecoration(
            hintText: "Search",
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (val) => c.searchItemByName(val),
        ),
        Obx(() {
          if (c.searchedItems.isEmpty) return const SizedBox();

          return Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: c.searchedItems.length,
              itemBuilder: (context, i) {
                final item = c.searchedItems[i];
                return ListTile(
                  title: Text(item.itemName),
                  subtitle: Text(item.itemCode ?? ""),
                  onTap: () => c.selectItem(item, index),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}





