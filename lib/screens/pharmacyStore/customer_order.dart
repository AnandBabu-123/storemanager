
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/sales_invoice_controller.dart';
import '../../model/user_pharmacy_model.dart';

class CustomerOrderView extends StatelessWidget {
  CustomerOrderView({super.key});

  final SalesInVoiceController controller =
  Get.put(SalesInVoiceController());

  final TextEditingController orderIdCtrl = TextEditingController();
  final TextEditingController customerNoCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController statusCtrl = TextEditingController();
  final TextEditingController locationCtrl = TextEditingController();
  final TextEditingController fromDateCtrl = TextEditingController();
  final TextEditingController toDateCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
        appBar: AppBar(title: const Text("Customer Order"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF90EE90), Color(0xFF87CEFA)],
              ),
            ),
          ),),
        body:SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// 🔹 HEADER WITH TOGGLE ICON
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Obx(() {
                    return IconButton(
                      icon: Icon(
                        controller.isFilterExpanded.value
                            ? Icons.expand_less
                            : Icons.expand_more,
                      ),
                      onPressed: () {
                        controller.isFilterExpanded.toggle();
                      },
                    );
                  }),
                ],
              ),

          Obx(() {
            return AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: controller.isFilterExpanded.value
                  ? Column(
                children: [
                  _buildDropdownOnly(
                    label: "Stores",
                    controller: controller,
                  ),

                  const SizedBox(height: 16),
                  _buildOrderIdSearchField("Order ID", orderIdCtrl),
                  const SizedBox(height: 16),

                  _twoFieldRow(
                    _buildTextField("Location", locationCtrl),
                    _buildTextField("Customer Number", customerNoCtrl),
                  ),

                  const SizedBox(height: 12),

                  _twoFieldRow(
                    _buildTextField("Customer Email", emailCtrl),
                    _buildTextField("Order Status", statusCtrl),
                  ),

                  const SizedBox(height: 12),

                  _twoFieldRow(
                    _buildDateField("From Date", fromDateCtrl, context),
                    _buildDateField("To Date", toDateCtrl, context),
                  ),

                  const SizedBox(height: 10),
                  SizedBox(
                      width: double.infinity,
                      child:
                      Obx(() {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(

                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                              controller.findRetailerid(
                                orderId: orderIdCtrl.text.trim(),
                                customerNo: customerNoCtrl.text.trim(),
                                email: emailCtrl.text.trim(),
                                status: statusCtrl.text.trim(),
                                location: locationCtrl.text.trim(),
                                fromDate: fromDateCtrl.text.trim(),
                                toDate: toDateCtrl.text.trim(),
                              );
                            },
                            child: controller.isLoading.value
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : const Text("Search"),
                          ),
                        );
                      })

                  ),
                ],
              )
                  : const SizedBox(), // collapsed
            );
          }),

          SizedBox(height: 10,),
              /// 🔹 SUBMIT BUTTON

              const SizedBox(height: 16),
              /// 🔹 ORDER DETAILS VIEW
              // Obx(() {
              //   final data = controller.orderResponse.value;
              //
              //   if (data == null) {
              //     return const SizedBox(); // nothing before search
              //   }
              //
              //   return Card(
              //     elevation: 2,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(12),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //
              //           /// HEADER
              //           const Text(
              //             "Order Details",
              //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //           ),
              //           const Divider(),
              //
              //           _detailRow("Order ID", data.orderHdr?.orderId),
              //           _detailRow("Date", data.orderHdr?.orderDate),
              //           _detailRow("Status", data.orderHdr?.orderStatus),
              //           _detailRow("Payment", data.orderHdr?.paymentStatus),
              //           _detailRow("Delivery", data.orderHdr?.deliveryMethod),
              //
              //           const SizedBox(height: 12),
              //
              //           /// 🔹 ITEMS LIST
              //           if (data.orderHdr?.customerRetailerOrderDetailsList != null)
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 const Text(
              //                   "Items",
              //                   style:
              //                   TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              //                 ),
              //                 const SizedBox(height: 8),
              //
              //                 ...data.orderHdr!.customerRetailerOrderDetailsList!
              //                     .map(
              //                       (item) => Container(
              //                     margin: const EdgeInsets.only(bottom: 8),
              //                     padding: const EdgeInsets.all(8),
              //                     decoration: BoxDecoration(
              //                       border: Border.all(color: Colors.grey.shade300),
              //                       borderRadius: BorderRadius.circular(8),
              //                     ),
              //                     child: Column(
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: [
              //                         _detailRow("Item", item.itemName),
              //                         _detailRow("Qty", item.orderQty?.toString()),
              //                         _detailRow("MRP", item.mrp?.toString()),
              //                         _detailRow("Discount", item.discount?.toString()),
              //                         _detailRow("GST", item.gst?.toString()),
              //                         _detailRow("Manufacturer", item.manufactureName),
              //                         // _detailRow("Brand", item.br?.toString()),
              //                         _detailRow(
              //                             "Total", item.totalAmount?.toString()),
              //                       ],
              //                     ),
              //                   ),
              //                 )
              //                     .toList(),
              //               ],
              //             ),
              //           SizedBox(height: 10,),
              //           Text("Store Info"),
              //           SizedBox(height: 4,),
              //           _detailRow("Name", data.store?.name),
              //           _detailRow("Location", data.store?.location),
              //           _detailRow("Contact", data.store?.ownerContact),
              //           _detailRow("Email", data.store?.ownerEmail),
              //
              //
              //         ],
              //       ),
              //     ),
              //   );
              // }),

          Obx(() {
            final data = controller.orderResponse.value;

            if (data == null) {
              return const SizedBox();
            }

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// HEADER
                    const Text(
                      "Order Details",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    /// 🔽 DROPDOWNS
                    Obx(
                          () =>
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 48,
                                      child: DropdownButtonFormField<String>(
                                        value: controller.selectedDeliveryStatus.value,
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: "Delivery Status",
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                        ),
                                        items: controller.deliveryStatusList
                                            .map(
                                              (e) => DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(
                                              e,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                            .toList(),
                                        onChanged: (value) {
                                          controller.selectedDeliveryStatus.value = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: SizedBox(
                                      height: 48,
                                      child: DropdownButtonFormField<String>(
                                        value: controller.selectedDeliveryPartner.value,
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: "Delivery Partner",
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                        ),
                                        items: controller.deliveryPartnerList
                                            .map(
                                              (e) => DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(
                                              e,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                            .toList(),
                                        onChanged: (value) {
                                          controller.selectedDeliveryPartner.value = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )

                    ),

                    const Divider(),

                    _detailRow("Order ID", data.orderHdr?.orderId),
                    _detailRow("Date", data.orderHdr?.orderDate),
                    _detailRow("Status", data.orderHdr?.orderStatus),
                    _detailRow("Payment", data.orderHdr?.paymentStatus),
                    _detailRow("Delivery", data.orderHdr?.deliveryMethod),

                    const SizedBox(height: 12),

                    /// ITEMS LIST
                    if (data.orderHdr?.customerRetailerOrderDetailsList != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Items",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...data.orderHdr!.customerRetailerOrderDetailsList!.map(
                                (item) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _detailRow("Item", item.itemName),
                                  _detailRow("Qty", item.orderQty?.toString()),
                                  _detailRow("MRP", item.mrp?.toString()),
                                  _detailRow("Discount", item.discount?.toString()),
                                  _detailRow("GST", item.gst?.toString()),
                                  _detailRow(
                                      "Manufacturer", item.manufactureName),
                                  _detailRow(
                                      "Total", item.totalAmount?.toString()),
                                ],
                              ),
                            ),
                          ).toList(),
                        ],
                      ),

                    const SizedBox(height: 10),

                    /// STORE INFO
                    const Text(
                      "Store Info",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    _detailRow("Name", data.store?.name),
                    _detailRow("Location", data.store?.location),
                    _detailRow("Contact", data.store?.ownerContact),
                    _detailRow("Email", data.store?.ownerEmail),

                    const SizedBox(height: 16),

                    /// SUBMIT BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.submitDeliveryStatus(
                            orderId: data.orderHdr?.orderId ?? "",
                          );
                        },
                        child: const Text("Submit"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          })

          ],
          ),
        ),
      ),
    );
  }
  Widget _detailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value ?? "-"),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderIdSearchField(
      String label,
      TextEditingController controller,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),

        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
          onChanged: (value) {
            this.controller.searchCustomerOrder(value);
          },
        ),

        Obx(() {
          if (this.controller.isSearchingOrder.value) {
            return const Padding(
              padding: EdgeInsets.all(8),
              child: LinearProgressIndicator(),
            );
          }

          if (this.controller.orderSearchResults.isEmpty) {
            return const SizedBox();
          }

          return Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: this.controller.orderSearchResults.length,
              itemBuilder: (context, index) {
                final item =
                this.controller.orderSearchResults[index];
                return ListTile(
                  dense: true,
                  title: Text(item.orderId ?? "-"),
                  subtitle: Text(
                      "Customer: ${item.customerId ?? "-"}"),
                  onTap: () {
                    controller.text = item.orderId ?? "";
                    this.controller.orderSearchResults.clear();
                    FocusScope.of(context).unfocus();
                  },
                );
              },
            ),
          );
        }),
      ],
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
        const SizedBox(height: 6),
        Obx(() {
          return DropdownButtonFormField<Stores>(
            value: controller.selectedStore.value,
            hint: const Text("Select Store"),
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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

  Widget _twoFieldRow(Widget left, Widget right) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
      String label,
      TextEditingController controller,
      BuildContext context,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),

        TextFormField(
          controller: controller,
          readOnly: true,          // 🔒 prevents keyboard
          enableInteractiveSelection: false, // 🔒 no copy/paste
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
          onTap: () async {
            FocusScope.of(context).unfocus(); // 🔒 ensure keyboard never opens

            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              controller.text =
              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
            }
          },
        ),
      ],
    );
  }

}

