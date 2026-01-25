import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/sales_invoice_controller.dart';
import '../../model/user_pharmacy_model.dart';
class GstReportView extends StatelessWidget {
  GstReportView({super.key});

  final SalesInVoiceController controller =
  Get.put(SalesInVoiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GST Report"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF90EE90), Color(0xFF87CEFA)],
            ),
          ),
        ),),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            /// 🔹 DATE FIELDS
            /// 🔹 DATE FIELDS
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.fromDateCtrl,
                    readOnly: true,
                    onTap: () {
                      controller.pickDate(
                        context: context,
                        controller: controller.fromDateCtrl,
                      );
                    },
                    decoration: const InputDecoration(
                      labelText: "From Date",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller.toDateCtrl,
                    readOnly: true,
                    onTap: () {
                      controller.pickDate(
                        context: context,
                        controller: controller.toDateCtrl,
                      );
                    },
                    decoration: const InputDecoration(
                      labelText: "To Date",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ],
            ),


            const SizedBox(height: 12),

            /// 🔹 STORE + SEARCH ROW
            Row(
              children: [
                Expanded(
                  child: _buildDropdownOnly(
                    label: "Stores",
                    controller: controller,
                  ),
                ),
                const SizedBox(width: 8),

                /// 🔍 SEARCH BUTTON
                Obx(() {
                  return ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                      controller.gstReport(); // 🔥 API CALL
                    },
                    child: controller.isLoading.value
                        ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text("Search"),
                  );
                }),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔹 RESULT LISTS
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final saleList = controller.saleGstList;
                final purchaseList = controller.purchaseGstList;

                if (saleList.isEmpty && purchaseList.isEmpty) {
                  return const Center(child: Text("No GST data found"));
                }

                return ListView(
                  children: [

                    /// 🔸 SALE GST SECTION
                    if (saleList.isNotEmpty) ...[
                      const Text(
                        "Sale GST",
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...saleList.map((e) =>
                          _gstTile(
                            title: "Sale",
                            amount: e.total,
                            date: e.date,
                            cgst: e.cgstamt,
                            sgst: e.sgstamt,
                            igst: e.igstper,
                          )),
                      const SizedBox(height: 16),
                    ],

                    /// 🔸 PURCHASE GST SECTION
                    if (purchaseList.isNotEmpty) ...[
                      const Text(
                        "Purchase GST",
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...purchaseList.map((e) =>
                          _gstTile(
                            title: "Purchase",
                            amount: e.total,
                            date: e.date,
                            cgst: e.cgstamt,
                            sgst: e.sgstamt,
                            igst: e.igstper,
                          )),
                    ],
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
  Widget _gstTile({
    required String title,
    required double? amount,   // 🔥 change here
    required String? date,
    required double? cgst,
    required double? sgst,
    required int? igst,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text("$title - ₹${amount ?? 0}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (date != null) Text("Date: $date"),
            Text("CGST: ${cgst ?? 0}"),
            Text("SGST: ${sgst ?? 0}"),
            Text("IGST: ${igst ?? 0}"),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownOnly({
    required String label,
    required SalesInVoiceController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Obx(() {
          return DropdownButtonFormField<Stores>(
            value: controller.selectedStore.value,
            hint: const Text("Select Store"),
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: controller.storesList
                .map(
                  (store) => DropdownMenuItem<Stores>(
                value: store,
                child: Text("${store.id} - ${store.name}"),
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


