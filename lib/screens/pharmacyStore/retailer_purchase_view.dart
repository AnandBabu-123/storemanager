import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/retailer_controller.dart';
import '../../model/retailers_dropdown_model.dart';

class RetailerPurchaseView extends StatelessWidget {
  RetailerPurchaseView({super.key});

  final controller = Get.put(RetailerPurchaseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retailer PurChase"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF90EE90), Color(0xFF87CEFA)],
            ),
          ),
        ),
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(12),
        child:
        Column(
          children: [

            /// 🔹 FILTER SECTION (with padding)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [

                  /// 🔹 Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Search Filters",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Obx(() => IconButton(
                        icon: Icon(
                          controller.isFilterExpanded.value
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                        onPressed: controller.isFilterExpanded.toggle,
                      )),
                    ],
                  ),

                  /// 🔹 Collapsible Filters
                  Obx(() {
                    return AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: controller.isFilterExpanded.value
                          ? Column(
                        children: [

                          /// Location
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: Autocomplete<String>(
                                    optionsBuilder: (textEditingValue) {
                                      if (textEditingValue.text.isEmpty) {
                                        return controller.locationList;
                                      }
                                      return controller.locationList.where(
                                            (option) => option
                                            .toLowerCase()
                                            .contains(textEditingValue.text.toLowerCase()),
                                      );
                                    },
                                    onSelected: (selection) {
                                      controller.locationCtrl.text = selection;
                                    },
                                    fieldViewBuilder:
                                        (context, textEditingController, focusNode, _) {
                                      return TextField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        onTap: () async {
                                          if (controller.locationList.isEmpty) {
                                            await controller.fetchLocations();
                                          }
                                        },
                                        decoration: const InputDecoration(
                                          labelText: "Location",
                                          border: OutlineInputBorder(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// Business Type
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: Obx(() {
                                    return DropdownButtonFormField<String>(
                                      value: controller.selectedBusinessType.value,
                                      items: controller.businessTypes.map((e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            controller.businessTypeLabel(e),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        controller.selectedBusinessType.value = val;
                                        controller.selectedStore.value = null;
                                        controller.storeList.clear();
                                        controller.loadStores();
                                      },
                                      decoration: const InputDecoration(
                                        labelText: "Business Type",
                                        border: OutlineInputBorder(),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// Store Name
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: Obx(() {
                                    final enabled =
                                        controller.selectedBusinessType.value != null &&
                                            controller.locationCtrl.text.isNotEmpty;

                                    return DropdownButtonFormField<RetailerStoreDropdown>(
                                      value: controller.selectedStore.value,
                                      items: controller.storeList.map((e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(e.displayName),
                                        );
                                      }).toList(),
                                      onChanged: enabled
                                          ? (v) => controller.selectedStore.value = v
                                          : null,
                                      decoration: const InputDecoration(
                                        labelText: "Store Name",
                                        border: OutlineInputBorder(),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// Medicine
                          TextField(
                            controller: controller.medicineCtrl,
                            decoration: const InputDecoration(
                              labelText: "Medicine Name",
                              border: OutlineInputBorder(),
                              isDense: true
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// Manufacturer + Search
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controller.manufacturerCtrl,
                                  decoration: const InputDecoration(
                                    labelText: "Manufacturer",
                                    border: OutlineInputBorder(),
                                    isDense: true
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                height: 48,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (!controller.validateMandatoryFilters()) return;

                                    controller.searchMedicine();
                                    controller.isFilterExpanded.value = false; // optional UX
                                  },
                                  icon: const Icon(Icons.search),
                                  label: const Text("Search"),
                                ),
                              ),

                            ],
                          ),

                          const SizedBox(height: 12),
                        ],
                      )
                          : const SizedBox.shrink(),
                    );
                  }),
                ],
              ),
            ),

            /// 🔹 RESULT LIST (IMPORTANT: OUTSIDE FILTER SECTION)
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.stockResults.isEmpty) {
                  return const Center(child: Text("No Stock Found"));
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.stockResults.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= controller.stockResults.length) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = controller.stockResults[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.medicineName ?? "-",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _row("Manufacturer", item.mfName),
                            _row("MRP", item.mrp?.toString()),
                            _row("Batch", item.batch),
                            _row("Expiry", item.expiryDate?.split('T').first),
                            _row("Discount", item.discount?.toString()),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        )

      ),
    );
  }
  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const Text(": "),
          Expanded(
            child: Text(
              value?.isNotEmpty == true ? value! : "-",
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }


}
