import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/authController.dart';
import '../../controllers/drawerControllerX.dart';
import '../../routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
   AppDrawer({super.key});
   final drawerController = Get.put(DrawerControllerX());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Obx(() => UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage("assets/userLogo.png"),
            ),
            accountName: Text(
              drawerController.name.value.isNotEmpty
                  ? drawerController.name.value
                  : "Guest User", style: TextStyle(color: Colors.black),
            ),
            accountEmail: Text(
              drawerController.email.value.isNotEmpty
                  ? drawerController.email.value
                  : "guest@email.com",style: TextStyle(color: Colors.black)
            ),
          )),


          ExpansionTile(
            leading: const Icon(Icons.store),
            title: const Text(
              "Store Details",
              style: TextStyle(
                fontSize: 14,          // ⬇ reduced from 18
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.edit, size: 12), // ⬇ smaller icon
                title: const Text(
                  "Update Store",
                  style: TextStyle(fontSize: 12),          // ⬇ reduced
                ),
                onTap: () {
                  Get.toNamed(AppRoutes.updateStoreDetails);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, size: 12),
                title: const Text(
                  "Update Store Documents",
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Get.toNamed(AppRoutes.updateStoreDocuments);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, size: 12),
                title: const Text(
                  "Add Store User",
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Get.toNamed(AppRoutes.userStoreDetails);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, size: 12),
                title: const Text(
                  "Get User Store",
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Get.toNamed(AppRoutes.getStoreUser);
                },
              ),
              ListTile(
                leading: const Icon(Icons.list, size: 12),
                title: const Text(
                  "Store List",
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Get.toNamed(AppRoutes.storeList);
                },
              ),
            ],
          ),


    /// PHARMACY MANAGEMENT
          ExpansionTile(
            leading: const Icon(Icons.local_pharmacy),
            title: const Text(
              "Pharmacy Management",
                style: TextStyle(
                  fontSize: 14,          // ⬇ reduced from 18
                  fontWeight: FontWeight.w600,
                ),
            ),
            children: [

              /// 🔹 Item Management
              ExpansionTile(
                leading: const Icon(Icons.inventory_2),
                title: const Text("Item Management",style: TextStyle(
                  fontSize: 14,          // ⬇ reduced from 18
                  fontWeight: FontWeight.w600,
                ),),
                children: [
                  ListTile(
                    leading: const Icon(Icons.add_box),
                    title: const Text("Add Item",style: TextStyle(
                      fontSize: 12,          // ⬇ reduced from 18

                    ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.addPharmacy);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text("Get Item",style: TextStyle(
                      fontSize: 12,          // ⬇ reduced from 18

                    ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.searchPharmacyUser);
                    },
                  ),
                ],
              ),

              /// 🔹 Rack Management
              ExpansionTile(
                leading: const Icon(Icons.view_in_ar),
                title: const Text("Rack Management",style: TextStyle(
                  fontSize: 14,          // ⬇ reduced from 18
                  fontWeight: FontWeight.w600,
                ),),
                children: [
                  ListTile(
                    leading: const Icon(Icons.add_circle_outline),
                    title: const Text("Add Rack",style: TextStyle(
                      fontSize: 12,          // ⬇ reduced from 18

                    ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.addRackManagement);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.list_alt),
                    title: const Text("View Racks",style: TextStyle(
                      fontSize: 12,          // ⬇ reduced from 18
                    ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.getRackManagement);
                    },
                  ),
                ],
              ),

              /// 🔹 Purchase Invoice
              ExpansionTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text("Purchase Invoice",style: TextStyle(
                  fontSize: 14,          // ⬇ reduced from 18
                  fontWeight: FontWeight.w600,
                ),),
                children: [
                  ListTile(
                    leading: const Icon(Icons.receipt),
                    title: const Text("Purchase Invoice",style: TextStyle(
                      fontSize: 12,          // ⬇ reduced from 18

                    ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.purchaseScreen);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.analytics),
                    title: const Text("Purchase Report",style: TextStyle(
                      fontSize: 12,          // ⬇ reduced from 18
                    ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.getPurchaseReport);
                    },
                  ),
                ],
              ),

              /// 🔹 Sales Invoice
              ExpansionTile(
                leading: const Icon(Icons.point_of_sale),
                title: const Text("Sales Invoice",style: TextStyle(
                  fontSize: 14,          // ⬇ reduced from 18
                  fontWeight: FontWeight.w600,
                ),),
                children: [
                  ListTile(
                    leading: const Icon(Icons.request_quote),
                    title: const Text("Sales Invoice",style: TextStyle(
                      fontSize: 12,          // ⬇ reduced from 18

                    ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.salesInVoice);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.request_quote),
                    title: const Text("Sales Report",style: TextStyle(
                      fontSize: 12,          // ⬇ reduced from 18

                    ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.salesInvoiceReport);
                    },
                  ),
                ],
              ),

              /// 🔹 Price Management
              ExpansionTile(
                leading: const Icon(Icons.price_change),
                title: const Text("Price Management",style: TextStyle(
                  fontSize: 14,          // ⬇ reduced from 18
                  fontWeight: FontWeight.w600,
                ),),
                children: [
                  ListTile(
                    leading: const Icon(Icons.tune),
                    title: const Text("Price Manage",style: TextStyle(
                      fontSize: 12,          // ⬇ reduced from 18
                    ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.priceManage);
                    },
                  ),
                ],
              ),

              /// 🔹 Stock Management
              ExpansionTile(
                leading: const Icon(Icons.warehouse),
                title: const Text("Stock Management",style: TextStyle(
                  fontSize: 14,          // ⬇ reduced from 18
                  fontWeight: FontWeight.w600,
                ),),
                children: [
                  ListTile(
                    leading: const Icon(Icons.assessment),
                    title: const Text("Stock Report",style: TextStyle(
                      fontSize: 12,          // ⬇ reduced from 18

                    ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.stockReport);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.playlist_add_check),
                    title: const Text("Manual Stock",
                      style: TextStyle(
                        fontSize: 12,          // ⬇ reduced from 18
                      ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.manualStock);
                    },
                  ),
                ],
              ),

              /// 🔹 GST Report
              ExpansionTile(
                leading: const Icon(Icons.account_balance),
                title: const Text("GST Report",style: TextStyle(
                  fontSize: 14,          // ⬇ reduced from 18
                  fontWeight: FontWeight.w600,
                ),),
                children: [
                  ListTile(
                    leading: const Icon(Icons.summarize),
                    title: const Text("GST Report",style: TextStyle(
                      fontSize: 12,          // ⬇ reduced from 18
                    ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.gstReport);
                    },
                  ),
                ],
              ),

              ExpansionTile(
                leading: const Icon(Icons.people_alt),
                title: const Text("Supplier Management",style: TextStyle(
                  fontSize: 14,          // ⬇ reduced from 18
                  fontWeight: FontWeight.w600,
                ),),
                children: [
                  ListTile(
                    leading: const Icon(Icons.manage_accounts),
                    title: const Text("Search Supplier",style: TextStyle(
                      fontSize: 12,          // ⬇ reduced from 18

                    ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.retailerPurchaseView);
                    },
                  ),
                  //
                  // ListTile(
                  //   leading: const Icon(Icons.manage_accounts),
                  //   title: const Text("Customer Order",style: TextStyle(
                  //     fontSize: 14,          // ⬇ reduced from 18
                  //
                  //   ),),
                  //   onTap: () {
                  //     Get.toNamed(AppRoutes.customerOrderView);
                  //   },
                  // ),
                ],
              ),

              /// 🔹 Customer Management
              ExpansionTile(
                leading: const Icon(Icons.people_alt),
                title: const Text("Customer Management",style: TextStyle(
                  fontSize: 14,          // ⬇ reduced from 18
                  fontWeight: FontWeight.w600,
                ),),
                children: [
                  ListTile(
                    leading: const Icon(Icons.manage_accounts),
                    title: const Text("Customer Management",style: TextStyle(
                      fontSize: 12,          // ⬇ reduced from 18

                    ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.customerManagement);
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.manage_accounts),
                    title: const Text("Customer Order",style: TextStyle(
                      fontSize: 12,          // ⬇ reduced from 18

                    ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.customerOrderView);
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.manage_accounts),
                    title: const Text("Online Order",style: TextStyle(
                      fontSize: 12,          // ⬇ reduced from 18

                    ),),
                    onTap: () {
                      Get.toNamed(AppRoutes.onlineOrder);
                    },
                  ),
                ],
              ),
            ],
          ),


          const Divider(),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Get.toNamed(AppRoutes.settings);
            },
          ),


          // ListTile(
          //   leading: const Icon(Icons.lock),
          //   title: const Text("Change Password"),
          //   onTap: () {},
          // ),
          //
          // ListTile(
          //   leading: const Icon(Icons.logout),
          //   title: const Text("Logout"),
          //   onTap: () async {
          //     final auth = Get.find<AuthController>();
          //     await auth.logout();
          //     Get.offAllNamed(AppRoutes.loginView);
          //   },
          // ),
        ],
      ),
    );
  }
}
