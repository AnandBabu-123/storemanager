import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controllers/add_pharmacy_controller.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../model/user_pharmacy_model.dart';



class PurchaseReport extends StatelessWidget {
  PurchaseReport({super.key});

  final AddPharmacyController pharmacyController =
  Get.put(AddPharmacyController());

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController invoiceController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase Report"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF90EE90), Color(0xFF87CEFA)],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            /// 🔹 ROW 1
            Row(
              children: [
                Expanded(
                  child: _dateField(
                    context,
                    label: "Date From",
                    controller: fromDateController,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _dateField(
                    context,
                    label: "Date To",
                    controller: toDateController,
                  ),
                ),


              ],
            ),

            const SizedBox(height: 12),


            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: invoiceController,
                    decoration: const InputDecoration(
                      labelText: "Invoice Number",
                      border: OutlineInputBorder(),

                      // 🔽 make field smaller
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                  ),

                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: supplierController,
                        decoration: const InputDecoration(
                          labelText: "Supplier Name",
                          border: OutlineInputBorder(),

                          // 🔽 make field smaller
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownOnly(
                    label: "Stores",
                    controller: pharmacyController,
                  ),
                ),
                const SizedBox(width: 8),

                /// Search Button
                SizedBox(
                  height: 48,
                  child:
                  ElevatedButton.icon(
                    onPressed: () {
                      final selectedStore =
                          pharmacyController.selectedStore.value;

                      if (selectedStore?.userIdStoreId == null) {
                        Get.snackbar("Error", "Please select a store");
                        return;
                      }

                      pharmacyController.getPurChaseReport(
                        selectedStore!.userIdStoreId!,
                      );
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
                if (pharmacyController.isLoading.value &&
                    pharmacyController.purchaseList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (pharmacyController.purchaseList.isEmpty) {
                  return const Center(child: Text("No Data Found"));
                }

                return ListView.builder(
                  controller: pharmacyController.purchaseScrollController,
                  itemCount:
                  pharmacyController.purchaseList.length +
                      (pharmacyController.isPurchaseLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // 🔹 Bottom loader
                    if (index == pharmacyController.purchaseList.length) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = pharmacyController.purchaseList[index];

                    return Obx(() {
                      final isExpanded =
                          pharmacyController.expandedIndex.value == index;

                      return GestureDetector(
                        onTap: () async {
                          if (isExpanded) {
                            pharmacyController.expandedIndex.value = -1;
                          } else {
                            pharmacyController.expandedIndex.value = index;

                            await pharmacyController.getInVoiceData(
                              item.invoiceNo ?? "",
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _row("Invoice No", item.invoiceNo ?? "-"),
                              _row(
                                "Date",
                                item.date?.toString().split(' ').first ?? "-",
                              ),
                              _row("Supplier", item.suppName ?? "-"),
                              _row("Store ID", item.storeId ?? "-"),

                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                child: isExpanded
                                    ? _invoiceDetailsView(pharmacyController)
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            ),


          ],
        ),
      ),
    );
  }

  Widget _invoiceDetailsView(AddPharmacyController controller) {
    // 🔹 Loading (initial)
    if (controller.isLoading.value && controller.invoiceDetails.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // 🔹 Empty state
    if (controller.invoiceDetails.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text("No invoice details"),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Invoice Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 6),

          /// 🔹 PAGINATED LIST
          ListView.builder(
            controller: controller.invoiceScrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.invoiceDetails.length +
                (controller.isInvoiceLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              // 🔄 bottom loader
              if (index == controller.invoiceDetails.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final invoice = controller.invoiceDetails[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Divider(),

                  _twoRow("Bill Line ID", invoice.billNoLineId ?? "-",
                      "Document No", invoice.docNumber ?? "-"),

                  _twoRow("Readable Doc No", invoice.readableDocNo ?? "-",
                      "Purchase Date", _fmtDate(invoice.date)),

                  _twoRow("Bill No", invoice.billNo?.toString() ?? "-",
                      "Bill Date", _fmtDate(invoice.billDt)),

                  _twoRow("Item Code", invoice.itemCode ?? "-",
                      "Item Name", invoice.itemName ?? "-"),

                  _twoRow("Batch No", invoice.batchNo ?? "-",
                      "Expiry Date", _fmtDate(invoice.expiryDate)),

                  _twoRow("Category Code", invoice.catCode ?? "-",
                      "Category Name", invoice.catName ?? "-"),

                  _twoRow("Mfg Code", invoice.mfacCode ?? "-",
                      "Mfg Name", invoice.mfacName ?? "-"),

                  _twoRow("Brand", invoice.brandName ?? "-",
                      "Packing", invoice.packing ?? "-"),

                  _twoRow("Qty", _fmtNum(invoice.qty),
                      "Pack Qty", _fmtNum(invoice.packQty)),

                  _twoRow("Loose Qty", _fmtNum(invoice.looseQty),
                      "Total Purchase", _fmtNum(invoice.totalPurchasePrice)),

                  _twoRow("CGST Amt", _fmtNum(invoice.cgstamt),
                      "SGST Amt", _fmtNum(invoice.sgstamt)),

                  _twoRow("IGST Amt", _fmtNum(invoice.igstamt),
                      "Total Amt", _fmtNum(invoice.total)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _twoRow(
      String t1,
      String v1,
      String t2,
      String v2,
      ) {
    const double fontSize = 11;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(
                    "$t1:",
                    style: const TextStyle(
                        fontSize: fontSize, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(v1, style: const TextStyle(fontSize: fontSize)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(
                    "$t2:",
                    style: const TextStyle(
                        fontSize: fontSize, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(v2, style: const TextStyle(fontSize: fontSize)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    const double fontSize = 11;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$title:",
              style: const TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }
  String _fmtDate(String? date) {
    if (date == null || date.isEmpty) return "-";
    return date.split('T').first; // 2026-01-15
  }

  String _fmtNum(num? v) => v == null ? "-" : v.toStringAsFixed(2);



  // Widget _row(String title, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 2), // 🔽 less vertical space
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //           width: 130, // 🔽 reduced label width
  //           child: Text(
  //             "$title:",
  //             style: const TextStyle(
  //               fontWeight: FontWeight.w600,
  //               fontSize: 12, // 🔽 smaller text
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 6), // 🔽 less gap
  //         Expanded(
  //           child: Text(
  //             value,
  //             style: const TextStyle(fontSize: 12), // 🔽 smaller text
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }


  /// 🔹 Date Field Widget
  Widget _dateField(
      BuildContext context, {
        required String label,
        required TextEditingController controller,
      }) {
    return TextFormField(
      controller: controller,
      readOnly: true,

      decoration: InputDecoration(
        labelText: label,

        // 🔽 make field compact
        isDense: true,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 10, horizontal: 12),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      onTap: () async {
        FocusScope.of(context).unfocus();

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          controller.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
        }
      },
    );
  }


  /// 🔹 Store Dropdown
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
              // 🔽 make field smaller
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),

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
}

