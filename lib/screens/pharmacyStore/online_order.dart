import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/online_order_controller.dart';

class OnlineOrder extends StatelessWidget {
  OnlineOrder({super.key});

  final OnlineOrderController controller =
  Get.put(OnlineOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Online Order"),
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

            /// 🔹 PHONE + EMAIL ROW
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller.nameCtrl,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// 🔹 NAME + SEARCH
            Row(
              children: [


                Expanded(
                  child: TextField(
                    controller: controller.emailCtrl,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.searchOrders();
                    },
                    child: const Text("Search"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 🔹 LIST + PAGINATION
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.orders.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.orders.isEmpty) {
                  return const Center(child: Text("No Data Found"));
                }

                return ListView.builder(
                  itemCount: controller.orders.length + 1,
                  itemBuilder: (context, index) {
                    if (index < controller.orders.length) {
                      final item = controller.orders[index];
                      return Card(
                        child: ListTile(
                          title: Text(item.storeCategory ?? "-"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Storeid : ${item.storeCategoryStoreId}"),
                              Text("User Store id : ${item.userIdStoreId}"),
                              Text("Location: ${item.location ?? '-'}"),
                              Text("Customer ID: ${item.customerId ?? '-'}"),
                              Text("Updated: ${item.updatedDate ?? '-'}"),
                              Text("Uploaded By: ${item.updatedBy ?? '-'}")
                            ],
                          ),
                        ),
                      );
                    } else {
                      /// LOAD MORE
                      if (controller.hasMore.value) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: controller.loadMore,
                              child: const Text("Load More"),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

