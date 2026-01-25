import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../controllers/add_pharmacy_controller.dart';
import '../../model/pharmacy_storemodel.dart';
import '../../model/user_pharmacy_model.dart' show Stores;

class SearchPharmacyUser extends StatelessWidget {
  SearchPharmacyUser({super.key});

  // ✅ DO NOT CREATE A NEW CONTROLLER
  final AddPharmacyController pharmacyController = Get.put(AddPharmacyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Pharmacy"),
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
      body:
      Padding(
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

                return Column(
                  children: [
                    /// 🔹 LIST
                    Expanded(
                      child: ListView.separated(
                        itemCount: pharmacyController.searchResults.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = pharmacyController.searchResults[index];

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
                                  Text(
                                    item.itemName ?? "-",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  _infoRow("Store ID", item.storeId),
                                  _infoRow("Item Code", item.itemCode),
                                  _infoRow("Category", item.itemCategory),
                                  _infoRow("Sub Category", item.itemSubCategory),
                                  _infoRow("Manufacturer", item.manufacturer),
                                  _infoRow("Brand", item.brand),
                                  _infoRow("GST", item.gst?.toString()),

                                  const Divider(height: 20),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          _openUpdateItemBottomSheet(context, item);
                                        },
                                        child: const Text("Update"),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          _openUploadBottomSheet(context, item);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 10,
                                          ),
                                        ),
                                        child: const Text("Upload"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    /// 🔹 PAGINATION BAR
                    _paginationBar(),
                  ],
                );
              }),
            ),


          ],
        ),
      ),
    );
  }
  Widget _paginationBar() {
    return Obx(() {
      final controller = pharmacyController;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// ◀ PREVIOUS
            ElevatedButton(
              onPressed: controller.currentPage.value > 0
                  ? () {
                final store =
                    controller.selectedStore.value;
                if (store != null) {
                  controller.searchPharmacyData(
                    store.id!,
                    page: controller.currentPage.value - 1,
                    size: controller.pageSize.value,
                  );
                }
              }
                  : null,
              child: const Text("Prev"),
            ),

            /// PAGE INFO
            Text(
              "Page ${controller.currentPage.value + 1} "
                  "of ${controller.totalPages.value}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            /// NEXT ▶
            ElevatedButton(
              onPressed: controller.currentPage.value <
                  controller.totalPages.value - 1
                  ? () {
                final store =
                    controller.selectedStore.value;
                if (store != null) {
                  controller.searchPharmacyData(
                    store.id!,
                    page: controller.currentPage.value + 1,
                    size: controller.pageSize.value,
                  );
                }
              }
                  : null,
              child: const Text("Next"),
            ),
            SizedBox(height: 100,)
          ],
        ),
      );
    });
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

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(value ?? "-", style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  void _openUploadBottomSheet(
      BuildContext context,
      ItemCodeMasters item,
      )
  {
    final controller = Get.find<AddPharmacyController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Obx(() {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔹 TITLE
                const Text(
                  "Upload Documents",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                /// 🔹 PICK FILES BUTTON
                ElevatedButton.icon(
                  onPressed: controller.pickFiles,
                  icon: const Icon(Icons.attach_file),
                  label: const Text("Select Files"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF90EE90),
                  ),
                ),

                const SizedBox(height: 12),

                /// 🔹 FILE LIST
                if (controller.selectedFiles.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.selectedFiles.length,
                    itemBuilder: (_, index) {
                      final file = controller.selectedFiles[index];
                      return ListTile(
                        leading: const Icon(Icons.insert_drive_file),
                        title: Text(file.path.split('/').last),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            controller.selectedFiles.removeAt(index);
                          },
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 16),

                /// 🔹 ACTION BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          controller.selectedFiles.clear();
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.isUploading.value
                            ? null
                            : () async {
                          await controller.uploadItemDocuments(
                            item.userIdStoreIdItemCode!,
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: controller.isUploading.value
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text("Upload"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60,)
              ],
            );
          }),
        );
      },
    );
  }

  void _openUpdateItemBottomSheet(
      BuildContext context,
      ItemCodeMasters item,
      )
  {
    final itemNameCtrl =
    TextEditingController(text: item.itemName);
    final gstCtrl =
    TextEditingController(text: item.gst?.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// 🔹 TITLE
              const Text(
                "Update Item",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              /// 🔹 ROW 1
              _twoFieldRow(
                leftLabel: "Store ID",
                leftValue: item.storeId,
                rightLabel: "Item Code",
                rightValue: item.itemCode,
              ),

              /// 🔹 ROW 2
              _twoFieldRowEditable(
                leftLabel: "Item Name",
                leftController: itemNameCtrl,
                rightLabel: "Item Category",
                rightValue: item.itemCategory,
              ),

              /// 🔹 ROW 3
              _twoFieldRow(
                leftLabel: "Sub Category",
                leftValue: item.itemSubCategory,
                rightLabel: "Manufacturer",
                rightValue: item.manufacturer,
              ),

              /// 🔹 ROW 4
              _twoFieldRowEditable(
                leftLabel: "Brand",
                leftValue: item.brand,
                rightLabel: "GST",
                rightController: gstCtrl,
                rightEditable: true,
              ),

              const SizedBox(height: 20),

              /// 🔹 BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child:
                    ElevatedButton(
                      onPressed: () {
                        pharmacyController.updatePharmacyStore(
                          item: item,
                          updatedItemName: itemNameCtrl.text,
                          updatedGst: gstCtrl.text,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF90EE90),
                      ),
                      child: const Text("Save"),
                    ),

                  ),
                ],
              ),
              SizedBox(height: 60,)
            ],
          ),
        );
      },
    );
  }
  Widget _twoFieldRow({
    required String leftLabel,
    String? leftValue,
    required String rightLabel,
    String? rightValue,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: _disabledField(leftLabel, leftValue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _disabledField(rightLabel, rightValue),
          ),
        ],
      ),
    );
  }
  Widget _twoFieldRowEditable({
    required String leftLabel,
    TextEditingController? leftController,
    String? leftValue,
    required String rightLabel,
    TextEditingController? rightController,
    String? rightValue,
    bool rightEditable = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: leftController != null
                ? _editableField(leftLabel, leftController)
                : _disabledField(leftLabel, leftValue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: rightEditable && rightController != null
                ? _editableField(rightLabel, rightController)
                : _disabledField(rightLabel, rightValue),
          ),
        ],
      ),
    );
  }
  Widget _editableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ],
    );
  }
  Widget _disabledField(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Container(
          height: 48,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Text(
            value ?? "-",
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }


}

