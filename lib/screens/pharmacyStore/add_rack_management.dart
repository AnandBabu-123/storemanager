import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../controllers/add_pharmacy_controller.dart';
import '../../model/user_pharmacy_model.dart' show Stores;

class AddRackManagement extends StatelessWidget {
  AddRackManagement({super.key});

  // ✅ DO NOT CREATE A NEW CONTROLLER
  final AddPharmacyController pharmacyController = Get.put(AddPharmacyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rack Management"),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF90EE90),
                Color(0xFF87cefa),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            /// 🔹 ROW 1: Item | Brand | Manufacturer
            Row(
              children: [
                Expanded(child: _buildTextField("Item", pharmacyController.itemName)),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField("Brand", pharmacyController.brand)),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField("Manufacturer", pharmacyController.manufacturer)),
              ],
            ),

            const SizedBox(height: 12),

            /// 🔹 ROW 2: STORE DROPDOWN + SEARCH BUTTON
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
                    onPressed: () {
                      final store = pharmacyController.selectedStore.value;
                      if (store != null && store.id != null) {
                        pharmacyController.searchPharmacyData(store.id!);
                      } else {
                        Get.snackbar("Warning", "Please select a store");
                      }
                    },
                    icon: const Icon(Icons.search),
                    label: const Text("Search"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF90EE90),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 🔹 LIST VIEW
            Expanded(
              child: Obx(() {
                if (pharmacyController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (pharmacyController.searchResults.isEmpty) {
                  return const Center(child: Text("No data found"));
                }

                return ListView.separated(
                  itemCount: pharmacyController.searchResults.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = pharmacyController.searchResults[index];

                    final rackCtrl = TextEditingController();
                    final boxCtrl = TextEditingController();
                    final isEnabled = ValueNotifier<bool>(false);

                    void validate() {
                      isEnabled.value =
                          rackCtrl.text.isNotEmpty && boxCtrl.text.isNotEmpty;
                    }

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// HEADER
                            Text(
                              item.itemName ?? "-",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            /// DETAILS
                            _infoRow("Item Code", item.itemCode),
                            _infoRow("Item Name", item.itemName),
                            _infoRow("Category", item.itemCategory),
                            _infoRow("Sub Category", item.itemSubCategory),
                            _infoRow("Manufacturer", item.manufacturer),
                            _infoRow("Brand", item.brand),
                            _infoRow("GST", (item.gst ?? 0).toString()),


                            const SizedBox(height: 12),

                            /// RACK NUMBER
                            _rowWithInput(
                              label: "Rack Number",
                              controller: rackCtrl,
                              onChanged: validate,
                            ),

                            const SizedBox(height: 8),

                            /// BOX NUMBER
                            _rowWithInput(
                              label: "Box Number",
                              controller: boxCtrl,
                              onChanged: validate,
                            ),

                            const SizedBox(height: 12),

                            /// ADD BUTTON (ENABLED ONLY WHEN BOTH FILLED)
                            ValueListenableBuilder<bool>(
                              valueListenable: isEnabled,
                              builder: (_, enabled, __) {
                                return SizedBox(
                                  width: double.infinity,
                                  child:
                                  ElevatedButton(
                                    onPressed: enabled
                                        ? () {
                                      pharmacyController.addRackOrder(
                                        storeId: item.storeId!,       // from item
                                        skuId: item.itemCode!,        // itemCode → skuId
                                        rackNumber: rackCtrl.text,    // input
                                        boxNo: boxCtrl.text,           // input
                                      );
                                    }
                                        : null,
                                    child: const Text("Add"),
                                  ),

                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

              }),
            ),

          ],
        ),
      ),
    );
  }

  Widget _rowWithInput({
    required String label,
    required TextEditingController controller,
    required VoidCallback onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: (_) => onChanged(),
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(value ?? "-"),
          ),
        ],
      ),
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
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Obx(() {
          return DropdownButtonFormField<Stores>(
            value: controller.selectedStore.value,
            isExpanded: true,
            hint: const Text("Select Store"),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: controller.storesList.map((store) {
              return DropdownMenuItem<Stores>(
                value: store,
                child: Text(
                  "${store.id ?? ""} - ${store.name ?? ""}",
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) => controller.selectedStore.value = value,
          );
        }),
      ],
    );
  }


  /// 🔹 TEXT FIELD
  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }



}

