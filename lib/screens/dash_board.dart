import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashbaoard_controller.dart';
import '../model/store_business_type.dart';
import '../model/store_category.dart';
import 'bottom_navigation_screens/app_drawer.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final DashboardController controller = Get.put(DashboardController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
        key: _scaffoldKey,
        drawer:  AppDrawer(),

        /// 🌈 GRADIENT APPBAR
        appBar: AppBar(
          title: const Text(
            "RXWala Pharmacy",
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
          leading: IconButton(
            icon: const CircleAvatar(
              backgroundImage: AssetImage("assets/userLogo.png"),
              backgroundColor: Colors.white,
            ),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {},
            ),
          ],
        ),

        /// 🌿 BODY BACKGROUND COLOR
        body: Container(
          color: const Color(0xFFF1F8E9),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.storeList.isEmpty) {
              return const Center(
                child: Text(
                  "No Stores Found",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: controller.storeList.length,
              itemBuilder: (context, index) {
                final store = controller.storeList[index];

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// STORE NAME
                        Text(
                          "Name : ${store.name ?? ""}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 10),

                        _buildRow("Location", store.location),
                        _buildRow("Owner", store.owner),
                        _buildRow("Contact", store.ownerContact),
                        _buildRow("PinCode", store.pincode),
                        _buildRow("District", store.district),
                        _buildRow("State", store.state),
                        _buildRow("Date", store.registrationDate),
                        _buildRow("Role", store.role ?? "-"),
                      ],
                    ),
                  ),
                );

              },
            );
          }),
        ),

        /// ➕ FAB
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF90EE90),
          onPressed: () {
            _openAddStoreBottomSheet();
          },
          icon: const Icon(Icons.add),
          label: const Text("Add Store"),
        ),
      ),
    );
  }

  void _openAddStoreBottomSheet() {
    Get.bottomSheet(

      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(Get.context!).size.height * 0.85, // 👈 CONTROL HEIGHT
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [

              /// DRAG HANDLE
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              /// TITLE (FIXED)
              const Text(
                "Add New Store",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              /// 🔽 SCROLLABLE CONTENT
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Store Category",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 6),

                      Obx(() {
                        return DropdownButtonFormField<StoreCategory>(
                          value: controller.selectedStoreCategory.value,
                          items: controller.storeCategories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category.storeCategoryName ?? ""),
                            );
                          }).toList(),
                          onChanged: controller.onStoreCategoryChanged,
                          decoration: InputDecoration(
                            hintText: "Select Store Category",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 8),

                      const SizedBox(height: 12),

                      Text(
                        "Business Type",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 6),

                      Obx(() {
                        return DropdownButtonFormField<StoreBusinessType>(
                          value: controller.selectedBusinessType.value,
                          items: controller.filteredBusinessTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type.businessName ?? ""),
                            );
                          }).toList(),
                          onChanged: (value) {
                            controller.selectedBusinessType.value = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Select Business Type",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }),


                      const SizedBox(height: 10),

                      _twoFieldRowStore(
                        leftLabel: "Store Id",
                        rightLabel: "Store Name",
                        leftHint: "Enter Store Id",
                        rightHint: "Enter Store Name",
                        leftController: controller.storeId,
                        rightController: controller.storeName,
                        leftKeyboardType: TextInputType.number, // Number keypad
                        rightKeyboardType: TextInputType.text,  // Normal text keypad
                      ),


                      _twoFieldRows(
                        leftLabel: "PinCode",
                        rightLabel: "Location",
                        leftHint: "PinCode",
                        rightHint: "Location",
                        rightController: controller.locationController,
                        leftController: controller.pincodeController,
                        leftKeyboardType: TextInputType.number,
                        leftOnChanged: (value) {
                          if (value.length == 6) {
                            controller.fetchLocationFromPincode(value);
                          }
                        },
                      ),

                      _twoFieldRows(
                        leftLabel: "State",
                        rightLabel: "District",
                        leftHint: "State",
                        rightHint: "District",
                        leftController: controller.stateController,
                        rightController: controller.districtController,
                        leftReadOnly: true,
                        rightReadOnly: true,
                      ),

                      _twoFieldRows(
                        leftLabel: "GST",
                        rightLabel: "Town",
                        leftHint: "GST",
                        rightHint: "Town",
                        leftController: controller.gstController,
                        rightController: controller.townController,
                        rightReadOnly: true,
                      ),

                      _twoFieldRowConatct(
                        leftLabel: "Store Owner",
                        rightLabel: "Owner Address",
                        leftHint: "Owner Name",
                        rightHint: "Address",
                        leftController: controller.userNameController,
                        rightController: controller.OwnerAddressContactController,
                        leftReadOnly: true,
                      ),
                      _twoFieldRowConatct(
                        leftLabel: "Owner Contact",
                        rightLabel: "Alternate Contact",
                        leftHint: "Contact",
                        rightHint: "Alternate",
                        leftController: controller.mobileNumberController,
                        rightController: controller.alternateContactController,
                        leftReadOnly: true,
                      ),


                      const SizedBox(height: 10),

                      Text(
                        "Email",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                      _buildTextField(
                        "Email",
                        controller: controller.emailController,
                        readOnly: true,
                      ),


                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              child: const Text("Cancel"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF90EE90),
                              ),
                              onPressed: () {
                                controller.createStoreDetails();
                              },
                              child: const Text("Save"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60,)
                    ],
                  ),
                ),
              ),

              /// ACTION BUTTONS (FIXED BOTTOM)

            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _twoFieldRowStore({
    required String leftLabel,
    required String rightLabel,
    required String leftHint,
    required String rightHint,
    TextEditingController? leftController,
    TextEditingController? rightController,
    bool leftReadOnly = false,
    bool rightReadOnly = false,
    TextInputType leftKeyboardType = TextInputType.text,
    TextInputType rightKeyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(leftLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(rightLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: leftController,
                  readOnly: leftReadOnly,
                  keyboardType: leftKeyboardType,
                  decoration: InputDecoration(
                    hintText: leftHint,
                    filled: leftReadOnly,
                    fillColor: leftReadOnly ? Colors.grey.shade100 : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: rightController,
                  readOnly: rightReadOnly,
                  keyboardType: rightKeyboardType,
                  decoration: InputDecoration(
                    hintText: rightHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _twoFieldRowConatct({
    required String leftLabel,
    required String rightLabel,
    required String leftHint,
    required String rightHint,
    TextEditingController? leftController,
    TextEditingController? rightController,
    bool leftReadOnly = false,
    bool rightReadOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(leftLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(rightLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: leftController,
                  readOnly: leftReadOnly,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: leftHint,
                    filled: leftReadOnly,
                    fillColor:
                    leftReadOnly ? Colors.grey.shade100 : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: rightController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: rightHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _twoFieldRows({
    required String leftLabel,
    required String rightLabel,
    required String leftHint,
    required String rightHint,
    TextEditingController? leftController,
    TextEditingController? rightController,
    Function(String)? leftOnChanged,
    TextInputType leftKeyboardType = TextInputType.text,
    bool leftReadOnly = false,
    bool rightReadOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(leftLabel, style: const TextStyle(fontWeight: FontWeight.w600))),
              const SizedBox(width: 12),
              Expanded(child: Text(rightLabel, style: const TextStyle(fontWeight: FontWeight.w600))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: leftController,
                  readOnly: leftReadOnly,
                  keyboardType: leftKeyboardType,
                  onChanged: leftOnChanged,
                  decoration: InputDecoration(
                    hintText: leftHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: rightController,
                  readOnly: rightReadOnly,
                  decoration: InputDecoration(
                    hintText: rightHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildTextField(
      String hint, {
        TextEditingController? controller,
        bool readOnly = false,
      }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: readOnly,
        fillColor: readOnly ? Colors.grey.shade100 : null,
      ),
    );
  }


  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT LABEL
          SizedBox(
            width: 90, // controls left alignment
            child: Text(
              "$label :",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          /// RIGHT VALUE
          Expanded(
            child: Text(
              value ?? "-",
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

}
