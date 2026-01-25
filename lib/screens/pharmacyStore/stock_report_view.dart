import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controllers/sales_invoice_controller.dart';
import '../../model/user_pharmacy_model.dart';

class StockReportView extends StatelessWidget {
   StockReportView({super.key});
   final SalesInVoiceController controller = Get.put(SalesInVoiceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock Report"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF90EE90), Color(0xFF87CEFA)],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Vendor Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Product Type",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownOnly(
                    label: "Stores",
                    controller: controller,
                  ),
                ),
                const SizedBox(width: 8),

                /// Search Button
                SizedBox(
                  height: 48,
                  child:
                  ElevatedButton.icon(
                    onPressed: () {
                      if (controller.selectedStore.value == null) {
                        Get.snackbar("Error", "Please select a store");
                        return;
                      }
                      controller.getPriceMange();
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
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.priceList.isEmpty) {
                  return const Center(child: Text("No data found"));
                }

                return ListView.builder(
                  itemCount: controller.priceList.length,
                  itemBuilder: (context, index) {
                    final item = controller.priceList[index];

                    /// ✅ EACH ITEM MUST BE REACTIVE
                    return Obx(() {
                      final isExpanded =
                      controller.expandedIndexes.contains(index);

                      return InkWell(
                        onTap: () => controller.toggleExpanded(index),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                /// HEADER
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.data.itemName ?? "-",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      isExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  "Balance Qty: ${item.data.balQuantity ?? "-"}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                                SizedBox(height: 4,),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Bal Pack Qty: ${item.data.balPackQuantity ?? "-"}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Bal Loose Qty: ${item.data.balLooseQuantity ?? "-"}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),
                                /// EXPANDABLE CONTENT
                                AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 250),
                                  crossFadeState: isExpanded
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                                  firstChild: const SizedBox.shrink(),
                                  secondChild: Column(
                                    children: [
                                      const Divider(),

                                      _infoRow("Batch", item.data.batch),
                                      _infoRow("Store ID", item.data.storeId),
                                      _infoRow("Manufacturer", item.data.manufacturer),
                                      _infoRow("Item Code", item.data.itemCode),
                                      _infoRow("Expiry Date",
                                          formatDate(item.data.expiryDate)),
                                      _infoRow("MRP Pack", item.data.mrpPack),
                                      _infoRow("MRP Value", item.data.mrpValue),
                                      _infoRow("Rack", item.data.rack),
                                      _infoRow("Online (Y/N)", item.data.onlineYesNo),
                                      _infoRow("Discount", item.data.discount),
                                      _infoRow("Offer Qty", item.data.offerQty),
                                      _infoRow(
                                          "Min Order Qty", item.data.minOrderQty),
                                      _infoRow("Updated At",
                                          formatDate(item.data.updatedAt)),
                                      _infoRow("Updated By", item.data.updatedBy),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            )



    ],
        ),
      ),
    );
  }

   Widget _infoRow(String label, dynamic value) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 2),
       child: Row(
         children: [
           Expanded(
             child: Text(
               "$label:",
               style: const TextStyle(
                 fontSize: 12,
                 fontWeight: FontWeight.w500,
               ),
             ),
           ),
           Expanded(
             child: Text(
               value?.toString() ?? "-",
               style: const TextStyle(fontSize: 12),
             ),
           ),
         ],
       ),
     );
   }


   Widget _editableField({
     required String label,
     required TextEditingController controller,
     required bool enabled,
   }) {
     return Expanded(
       child: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 4),
         child: TextFormField(
           controller: controller,
           readOnly: !enabled, // ✅ FIX
           keyboardType: TextInputType.number,
           decoration: InputDecoration(
             labelText: label,
             border: const OutlineInputBorder(),
             isDense: true,
             filled: !enabled,
             fillColor: !enabled ? Colors.grey.shade200 : null,
           ),
         ),
       ),
     );
   }
   String formatDate(DateTime? date) {
     if (date == null) return "-";
     return "${date.day.toString().padLeft(2, '0')}-"
         "${date.month.toString().padLeft(2, '0')}-"
         "${date.year}";
   }


   Widget _buildDropdownOnly({
     required String label,
     required SalesInVoiceController controller,
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
             onChanged: (value) =>
             controller.selectedStore.value = value,
           );
         }),
       ],
     );
   }

}
