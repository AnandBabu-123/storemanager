import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../controllers/add_pharmacy_controller.dart';
import '../../model/user_pharmacy_model.dart' show Stores;

class GetRackManagement extends StatelessWidget {
  GetRackManagement({super.key});
  final AddPharmacyController pharmacyController =
  Get.put(AddPharmacyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rack Management"),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF90EE90), // Green
                Color(0xFF87cefa), // Teal
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child:
        Column(
          children: [

            /// 🔹 STORE DROPDOWN + SEARCH BUTTON
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
                      pharmacyController.getRackManagement();
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

            /// 🔹 RACK LIST
            Expanded(
              child: Obx(() {
                if (pharmacyController.isLoadingRack.value) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (pharmacyController.rackList.isEmpty) {
                  return const Center(child: Text("No rack data found"));
                }

                return ListView.separated(
                  itemCount: pharmacyController.rackList.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final rack = pharmacyController.rackList[index];

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// HEADER WITH DELETE ICON
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Rack Details",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: rack.rackBoxStoreIdSkuId == null
                                      ? null
                                      : () {
                                    pharmacyController.deleteUser(
                                      rack.rackBoxStoreIdSkuId!,
                                    );
                                  },
                                ),

                              ],
                            ),

                            const SizedBox(height: 8),

                            _infoRow("Store ID", rack.storeId),
                            _infoRow("SKU ID", rack.skuId),
                            _infoRow("Rack Number", rack.rackNumber),
                            _infoRow("Box Number", rack.boxNo),
                            _infoRow(
                              "Rack Box Store Id Sku Id",
                              rack.rackBoxStoreIdSkuId,
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

  /// 🔹 Dropdown Widget
  Widget _buildDropdownOnly({
    required String label,
    required AddPharmacyController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500)),
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

  /// 🔹 Info Row Widget
  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text("$label:",
                style:
                const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 3,
            child: Text(value ?? "-"),
          ),
        ],
      ),
    );
  }
}

