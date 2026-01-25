import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/update_details_controller.dart';
import '../model/store_category.dart';
import '../model/storelist_response.dart';


class UpdateDetailsScreen extends StatelessWidget {
  const UpdateDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateDetailsController());

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Update Store Details"),
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
            ),

          ),
          body:
          TabBarView(
            children: [
              SingleChildScrollView(
                child: Obx(() {
                  final isActive = controller.isActiveStore.value;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.grey.shade200 : Colors.white,
                      border: Border.all(
                        color: isActive ? Colors.grey : Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// STORE
                        const Text("Store",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),

                        Obx(() => DropdownButtonFormField<StoreItem>(
                          value: controller.selectedStore.value,
                          items: controller.stores.map((store) {
                            return DropdownMenuItem(
                              value: store,
                              child: Text("${store.id} - ${store.name}"),
                            );
                          }).toList(),
                          onChanged: controller.onStoreSelected,
                          decoration: _inputDecoration("Select Store"),
                        )),

                        const SizedBox(height: 12),

                        /// VERIFIED CHIP
                        // Obx(() {
                        //   final verifiedStatus = controller
                        //       .selectedStore.value?.storeVerifiedStatus;
                        //
                        //   if (verifiedStatus != "true") {
                        //     return const SizedBox.shrink();
                        //   }
                        //
                        //   return Row(
                        //     children: [
                        //       const Text("Verified : "),
                        //       Chip(
                        //         label: const Text("VERIFIED"),
                        //         backgroundColor: Colors.green.shade100,
                        //         labelStyle: const TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.green,
                        //         ),
                        //       ),
                        //     ],
                        //   );
                        // }),

                        const SizedBox(height: 12),

                        /// STATUS CHIP
                        Obx(() {
                          final status =
                              controller.selectedStore.value?.status;
                          if (status == null) return const SizedBox.shrink();

                          return Row(
                            children: [
                              const Text("Status : "),
                              Chip(
                                label: Text(status),
                                backgroundColor: status == "ACTIVE"
                                    ? Colors.green.shade100
                                    : Colors.orange.shade100,
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: status == "ACTIVE"
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          );
                        }),

                        const SizedBox(height: 12),

                        /// STORE CATEGORY
                        const Text("Store Category",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),

                        Obx(() => DropdownButtonFormField<StoreCategory>(
                          value:
                          controller.selectedStoreCategory.value,
                          items: controller.storeCategories.map((c) {
                            return DropdownMenuItem(
                              value: c,
                              child:
                              Text(c.storeCategoryName ?? ""),
                            );
                          }).toList(),
                          onChanged: controller.isEditable.value
                              ? (v) => controller
                              .selectedStoreCategory.value = v
                              : null,
                          decoration:
                          _inputDecoration("Select Store Category"),
                        )),

                        const SizedBox(height: 12),

                        /// STORE NAME & GST
                        Obx(() => _twoFieldRow(
                          "Store Name",
                          controller.storeName,
                          "GST",
                          controller.gstController,
                          readOnly:
                          !controller.isEditable.value,
                        )),

                        const SizedBox(height: 12),

                        /// PINCODE & TOWN
                        Obx(() => _twoFieldRow(
                          "Pincode",
                          controller.pincodeController,
                          "Town",
                          controller.townController,
                          readOnly:
                          !controller.isEditable.value,
                        )),

                        const SizedBox(height: 12),

                        /// STATE & DISTRICT
                        _twoFieldRow(
                          "State",
                          controller.stateController,
                          "District",
                          controller.districtController,
                          readOnly: true,
                        ),

                        const SizedBox(height: 12),

                        /// OWNER & CONTACT
                        _twoFieldRow(
                          "Owner",
                          controller.userNameController,
                          "Owner Contact",
                          controller.mobileNumberController,
                          readOnly: true,
                        ),

                        const SizedBox(height: 12),

                        const Text("Email"),
                        const SizedBox(height: 6),

                        TextField(
                          controller: controller.emailController,
                          readOnly: true,
                          decoration: _inputDecoration("Email"),
                        ),

                        const SizedBox(height: 20),

                        /// SAVE BUTTON
                        Obx(() => ElevatedButton(
                          onPressed:
                          controller.isEditable.value
                              ? () => controller
                              .updateStoreDetails()
                              : null,
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                            const Size.fromHeight(50),
                            backgroundColor:
                            controller.isEditable.value
                                ? const Color(0xFF90EE90)
                                : Colors.grey,
                          ),
                          child: Text(
                            controller.isEditable.value
                                ? "Save"
                                : "Editing Disabled",
                          ),
                        )),
                      ],
                    ),
                  );
                }),
              ),
            ],
          )

        ),
      ),
    );
  }

  static InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  static Widget _twoFieldRow(
      String leftLabel,
      TextEditingController leftController,
      String rightLabel,
      TextEditingController rightController, {
        bool readOnly = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(leftLabel)),
              const SizedBox(width: 12),
              Expanded(child: Text(rightLabel)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: leftController,
                  readOnly: readOnly,
                  decoration: _inputDecoration(leftLabel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: rightController,
                  readOnly: readOnly,
                  decoration: _inputDecoration(rightLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }




}


