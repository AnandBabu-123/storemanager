import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/add_pharmacy_controller.dart';
import '../../controllers/dashbaoard_controller.dart';
import '../../model/store_business_type.dart';
import '../../model/store_category.dart';
import '../../model/user_pharmacy_model.dart' show Stores;
import '../bottom_navigation_screens/app_drawer.dart';



class AddPharmacy extends StatelessWidget {
  AddPharmacy({super.key});


  final pharmacyController = Get.put(AddPharmacyController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        title: const Text(
          "Pharmacy Management",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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

      /// 🌿 BODY BACKGROUND COLOR
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
                      child: Obx(() {
                        return ListView.separated(
                          controller: pharmacyController.scrollController, // ✅ REQUIRED
                          itemCount: pharmacyController.searchResults.length +
                              (pharmacyController.isLoadingMore.value ? 1 : 0),
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {

                            /// 🔄 Bottom loader
                            if (index == pharmacyController.searchResults.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

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
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    )


                    /// 🔹 PAGINATION BAR

                  ],
                );
              }),
            ),


          ],
        ),
      ),


      /// ➕ FAB
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF90EE90),
        onPressed: () {
          _openAddStoreBottomSheet(context);
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Item"),
      ),
    );
  }

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

  void _openAddStoreBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Important for full height with keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView( // ✅ Make it scrollable when keyboard opens
            child: Form(
              key: pharmacyController.addStoreFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔹 Store & Item Code
                  _buildDropdownWithTextField(
                    leftLabel: "Stores",
                    rightLabel: "Item Code",
                    controller: pharmacyController,
                    rightController: pharmacyController.itemCode,
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 Item Name & Category
                  _buildTwoFieldRow(
                    leftLabel: "Item Name",
                    leftHint: "",
                    leftController: pharmacyController.itemName,
                    rightLabel: "Item Category",
                    rightHint: "",
                    rightController: pharmacyController.itemCategory,
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 Sub-Category & Manufacturer
                  _buildTwoFieldRow(
                    leftLabel: "Item Sub-Category",
                    leftHint: "",
                    leftController: pharmacyController.itemSubCategory,
                    rightLabel: "Manufacturer",
                    rightHint: "",
                    rightController: pharmacyController.manufacturer,
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 Brand & GST
                  _buildTwoFieldRow(
                    leftLabel: "Brand",
                    leftHint: "",
                    leftController: pharmacyController.brand,
                    rightLabel: "GST",
                    rightHint: "",
                    rightController: pharmacyController.gstNumber,
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 HSN Code & Is Scheduled
                  _buildTextAndYesNoDropdown(
                    leftLabel: "HSN Code",
                    leftController: pharmacyController.hsnCode,
                    rightLabel: "Is Scheduled",
                    selectedValue: pharmacyController.isScheduled,
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 Scheduled Category & Is Narcotic
                  _buildTextAndYesNoDropdown(
                    leftLabel: "Scheduled Category",
                    leftController: pharmacyController.scheduledCategory,
                    rightLabel: "Is Narcotic",
                    selectedValue: pharmacyController.isNarcotic,
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!pharmacyController.addStoreFormKey.currentState!.validate()) {
                              Get.snackbar(
                                "Missing Fields",
                                "Please fill all required fields",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red.shade100,
                                colorText: Colors.red.shade900,
                              );
                              return;
                            }

                            final success = await pharmacyController.addPharmacyUser();


                          },

                          child: const Text("Save"),
                        ),
                      ),


                    ],
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildDropdownWithTextField({
    required String leftLabel,
    required String rightLabel,
    required AddPharmacyController controller,
    required TextEditingController rightController,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [

          /// 🔹 LEFT - DROPDOWN
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leftLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),

                Obx(() {
                  return DropdownButtonFormField<Stores>(
                    validator: (value) => value == null ? "Store required" : null,
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
                    onChanged: (value) {
                      controller.selectedStore.value = value;
                    },
                  );
                }),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// 🔹 RIGHT - TEXTFIELD
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rightLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: rightController,
                  validator: (value) =>
                  value == null || value.trim().isEmpty ? "Item Code required" : null,
                  decoration: const InputDecoration(
                    hintText: "Enter item code",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextAndYesNoDropdown({
    required String leftLabel,
    required TextEditingController leftController,
    required String rightLabel,
    required RxnString selectedValue,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [

          /// 🔹 LEFT - TEXTFIELD
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leftLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: leftController,
                  validator: (v) =>
                  v == null || v.trim().isEmpty ? "$leftLabel required" : null,
                  decoration: InputDecoration(
                    labelText: leftLabel,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(width: 12),

          /// 🔹 RIGHT - YES / NO DROPDOWN
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rightLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() {
                  return DropdownButtonFormField<String>(
                    value: selectedValue.value,
                    validator: (v) => v == null ? "$rightLabel required" : null,
                    hint: const Text("Select"),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: "Y", child: Text("Yes")),
                      DropdownMenuItem(value: "N", child: Text("No")),
                    ],
                    onChanged: (val) {
                      selectedValue.value = val;
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildTwoFieldRow({
    required String leftLabel,
    required String leftHint,
    required TextEditingController leftController,
    required String rightLabel,
    required String rightHint,
    required TextEditingController rightController,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: leftController,
              validator: (v) =>
              v == null || v.trim().isEmpty ? "$leftLabel required" : null,
              decoration: InputDecoration(
                labelText: leftLabel,
                hintText: leftHint,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: rightController,
              validator: (v) {
                final value = v?.trim() ?? "";

                if (value.isEmpty) {
                  return "$rightLabel required";
                }

                if (rightLabel == "GST") {
                  final gstRegex = RegExp(r'^[0-9A-Z]+$'); // letters + numbers only
                  if (!gstRegex.hasMatch(value.toUpperCase())) {
                    return "GST must contain only letters and numbers";
                  }
                }

                return null; // ✅ no error
              },

              decoration: InputDecoration(
                labelText: rightLabel,
                hintText: rightHint,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }




}
