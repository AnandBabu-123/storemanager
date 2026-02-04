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
            "Rxwala Pharmacy",
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
          label: const Text("Add Store "),
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
                  child: Form(
                    key: controller.formKey,
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
                            value: controller.selectedStoreCategory.value, // will be NULL initially
                            validator: (value) => value == null ? "Please select store category" : null,
                            hint: const Text("Select Store"), // 👈 default placeholder
                            items: controller.storeCategories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category.storeCategoryName ?? ""),
                              );
                            }).toList(),
                            onChanged: controller.onStoreCategoryChanged,
                            decoration: InputDecoration(
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
                            validator: (value) => value == null ? "Required" : null,
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
                        _twoFieldRowConatcts(
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
                                child:
                                Obx(() => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF90EE90),
                                  ),
                                  onPressed: controller.isLoading.value
                                      ? null // 🔒 Disable while loading
                                      : () async {
                                    if (!controller.formKey.currentState!.validate()) {
                                      Get.snackbar(
                                        "Missing Fields",
                                        "Please correct errors",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red.shade100,
                                        colorText: Colors.red.shade900,
                                      );
                                      return;
                                    }

                                    controller.isLoading.value = true;   // 🔄 START LOADER
                                    await controller.createStoreDetails();
                                    controller.isLoading.value = false;  // 🛑 STOP LOADER
                                  },
                                  child: controller.isLoading.value
                                      ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                      : const Text("Save"),
                                ))

                            ),
                          ],
                        ),
                        SizedBox(height: 60,)
                      ],
                    ),
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
                child: TextFormField(
                  controller: leftController,
                  readOnly: leftReadOnly,
                  validator: (value) {
                    if (!leftReadOnly && (value == null || value.trim().isEmpty)) {
                      return "Required";
                    }
                    return null;
                  },
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
                child: TextFormField(
                  controller: rightController,
                  readOnly: rightReadOnly,
                  validator: (value) {
                    if (!rightReadOnly && (value == null || value.trim().isEmpty)) {
                      return "Required";
                    }
                    return null;
                  },
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
                child: TextFormField(
                  controller: leftController,
                  readOnly: leftReadOnly,
                  validator: (value) {
                    if (!leftReadOnly && (value == null || value.trim().isEmpty)) {
                      return "Required";
                    }
                    return null;
                  },
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
                child: TextFormField(
                  controller: rightController,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Required";
                    return null;
                  },

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


  Widget _twoFieldRowConatcts({
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
                child: TextFormField(
                  controller: leftController,
                  readOnly: leftReadOnly,
                  validator: (value) {
                    if (!leftReadOnly && (value == null || value.trim().isEmpty)) {
                      return "Required";
                    }
                    return null;
                  },
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
                child: TextFormField(
                  controller: rightController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    hintText: rightHint,
                    counterText: "", // hides 0/10 text
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Required";
                    }

                    if (!RegExp(r'^[0-9]{10}$').hasMatch(v.trim())) {
                      return "Enter valid 10-digit number";
                    }

                    return null;
                  },
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
                child: TextFormField(
                  controller: leftController,
                  readOnly: leftReadOnly,
                  validator: (value) {
                    if (!leftReadOnly && (value == null || value.trim().isEmpty)) {
                      return "Required";
                    }
                    return null;
                  },
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
                child: TextFormField(
                  controller: rightController,
                  readOnly: rightReadOnly,
                  validator: (value) {
                    if (!rightReadOnly && (value == null || value.trim().isEmpty)) {
                      return "Required";
                    }
                    return null;
                  },
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
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      validator: (value) {
        if (!readOnly && (value == null || value.trim().isEmpty)) {
          return "Required";
        }
        return null;
      },
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
