import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controllers/add_pharmacy_controller.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../model/user_pharmacy_model.dart';



class SalesInvoiceReport extends StatelessWidget {
  SalesInvoiceReport({super.key});

  final AddPharmacyController pharmacyController =
  Get.put(AddPharmacyController());

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController invoiceController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text =
      "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales Report"),
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
                const SizedBox(width: 8),
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
              ],
            ),

            const SizedBox(height: 12),


            Row(
              children: [
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

                /// Store Dropdown
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

                      pharmacyController.fetchSalesReport(
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
                if (pharmacyController.salesIsLoading.value &&
                    pharmacyController.salesInvoiceList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (pharmacyController.salesInvoiceList.isEmpty) {
                  return const Center(child: Text("No Data Found"));
                }

                return ListView.builder(
                  controller: pharmacyController.salesScrollController,
                  itemCount: pharmacyController.salesInvoiceList.length +
                      (pharmacyController.salesIsLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Bottom loader
                    if (index == pharmacyController.salesInvoiceList.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = pharmacyController.salesInvoiceList[index];

                    return Obx(() {
                      final isExpanded =
                          pharmacyController.salesExpandedIndex.value == index;

                      return GestureDetector(
                        onTap: () async {
                          if (isExpanded) {
                            pharmacyController.salesExpandedIndex.value = -1;
                          } else {
                            pharmacyController.salesExpandedIndex.value = index;

                            // Call API to get detailed sales invoice info
                            await pharmacyController.getSalesData(item.docNumber ?? "");
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
                              _row("Document Number", item.docNumber ?? "-"),
                              _row("Date", item.date?.split(' ').first ?? "-"),
                              _row("Customer Name", item.custName ?? "-"),
                              _row("Store ID", item.storeId ?? "-"),

                              // Expandable details
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
    final data = controller.salesReportDetails.value;

    if (controller.isLoading.value) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null || data.sales == null || data.sales!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text("No invoice details"),
      );
    }

    final invoice = data.sales!.first;

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



          _twoRow("Document Line ID", invoice.docNumberLineId ?? "-",
              "Item Code", invoice.itemCode ?? "-"),

          _twoRow("Document Number", invoice.docNumber ?? "-",
              "Item Name", _fmtDate(invoice.itemName)),


          _twoRow("Item Code", invoice.itemCode ?? "-",
              "Item Name", invoice.itemName ?? "-"),

          _twoRow("Time", invoice.time ?? "-",
        "Customer Name", invoice.custName ?? "-"),

          _twoRow("Customer Code", invoice.custCode ?? "-",
              " Date", _fmtDate(invoice.date)),

          _twoRow("Patient Name", invoice.patientName ?? "-",
              "Created By", invoice.createdUser ?? "-"),

          _twoRow("Batch No", invoice.batchNo ?? "-",
              "Expiry Date", _fmtDate(invoice.expiryDate)),

          _twoRow("Category Code", invoice.catCode ?? "-",
              "Category Name", invoice.catName ?? "-"),

          _twoRow("Mfg Code", invoice.mfacCode ?? "-",
              "Mfg Name", invoice.mfacName ?? "-"),

          _twoRow("Brand", invoice.brandName ?? "-",
              "Packing", invoice.packing ?? "-"),


          _twoRow("GST Code", invoice.gstCode ?? "-",
              "Order Id", invoice.orderId ?? "-"),


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

