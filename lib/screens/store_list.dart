
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storemanager/model/store_details.dart';
import '../controllers/dashbaoard_controller.dart';
import '../controllers/update_details_controller.dart';
import '../model/store_category.dart';
import '../model/storelist_response.dart';
import 'bottom_navigation_screens/app_drawer.dart';
import 'package:flutter/services.dart';


class StoreList extends StatelessWidget {
  StoreList({super.key});

  final DashboardController controller = Get.put(DashboardController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            "StoreList",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF90EE90),
                  Color(0xFF87cefa),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),

        /// 🌿 BODY BACKGROUND COLOR
        body:
        Container(
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

                        _buildRow("Store ID", store.id),
                        _buildRow("Store Category", store.type),
                        _buildRow("Location", store.location),
                        _buildRow("Owner", store.owner),
                        _buildRow("Current Membership", store.currentPlan),
                        _buildRow("GST Number", store.gstNumber),
                        _buildRow("Status", store.status),
                        Obx(() => _buildRow(
                          "Store Business Type",
                          controller.getBusinessName(store.storeBusinessType),
                        )),

                        _buildRow("Store Verified Status", store.storeVerifiedStatus.toString(),),

                        const SizedBox(height: 12),

                        /// 🔹 UPDATE BUTTON
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text("Update"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              _openUpdateStoreBottomSheet(context, store);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

          }),
        ),


      ),
    );
  }

  void _openUpdateStoreBottomSheet(
      BuildContext context,
      Stores store,
      ) {
    final selected =
    controller.storeList.firstWhereOrNull((s) => s.id == store.id);
    if (selected != null) {
      controller.onStoreSelected(selected);
    }

    final storeNameCtrl = TextEditingController(text: store.name);
    final locationCtrl = TextEditingController(text: store.location);
    final stateCtrl = TextEditingController(text: store.state);
    final districtCtrl = TextEditingController(text: store.district);
    final gstCtrl = TextEditingController(text: store.gstNumber);
    final pincodeCtrl = TextEditingController(text: store.pincode);
    final townCtrl = TextEditingController(text: store.district);
    final ownerCtrl = TextEditingController(text: store.owner);
    final ownerAddressCtrl = TextEditingController(text: store.location);
    final ownerContactCtrl =
    TextEditingController(text: store.ownerContact);
    final alternateContactCtrl =
    TextEditingController(text: store.secondaryContact);
    final emailCtrl = TextEditingController(text: store.ownerEmail);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.6,
            maxChildSize: 0.95,
            expand: false,
            builder: (_, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Obx(() {
                  final bool canEdit = controller.canEdit.value;

                  return Form(
                    key: controller.updateStoreFormKey,
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        const Center(
                          child: Text(
                            "Update Store",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// STORE ID
                        DropdownButtonFormField<Stores>(
                          value: controller.selectedStore.value,
                          validator: (v) =>
                          v == null ? "Store ID required" : null,
                          isExpanded: true,
                          items: controller.storeList.map((s) {
                            return DropdownMenuItem<Stores>(
                              value: s,
                              child: Text("${s.id} - ${s.name}"),
                            );
                          }).toList(),
                          onChanged: canEdit
                              ? (val) => controller.onStoreSelected(val)
                              : null,
                          decoration: const InputDecoration(
                            labelText: "Store ID*",
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 12),

                        _twoFieldRow(
                          left: _labelField("Store Name*", storeNameCtrl,
                              enabled: canEdit),
                          right: _labelField("Location*", locationCtrl,
                              enabled: canEdit),
                        ),

                        _twoFieldRow(
                          left: _labelField("State*", stateCtrl,
                              enabled: canEdit),
                          right: _labelField("District*", districtCtrl,
                              enabled: canEdit),
                        ),

                        _twoFieldRow(
                          left: _labelField("GST Number*", gstCtrl,
                              enabled: canEdit),
                          right: _labelField("PinCode*", pincodeCtrl,
                              enabled: canEdit,
                              keyboardType: TextInputType.number),
                        ),

                        _twoFieldRow(
                          left: _labelField("Town*", townCtrl,
                              enabled: canEdit),
                          right: _labelField("Store Owner*", ownerCtrl,
                              enabled: canEdit),
                        ),

                        _twoFieldRow(
                          left: _labelField(
                            "Owner Address*",
                            ownerAddressCtrl,
                            enabled: canEdit,
                          ),
                          right: _labelField(
                            "Owner Contact*",
                            ownerContactCtrl,
                            enabled: canEdit,
                            keyboardType: TextInputType.phone,
                            isContact: true,   // 🔥 THIS TRIGGERS MOBILE VALIDATION
                          ),
                        ),


                        _twoFieldRow(
                          left: _labelField("Alternate Contact*",
                              alternateContactCtrl,
                              enabled: canEdit,
                              isContact: true,
                              keyboardType: TextInputType.phone),
                          right: _labelField("Email Id*", emailCtrl,
                              enabled: canEdit,
                              keyboardType:
                              TextInputType.emailAddress),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: canEdit
                                    ? () {
                                  if (!controller
                                      .updateStoreFormKey
                                      .currentState!
                                      .validate()) {
                                    Get.snackbar(
                                      "Missing Fields",
                                      "Please fill all required fields",
                                      backgroundColor:
                                      Colors.red.shade100,
                                    );
                                    return;
                                  }

                                  controller.updateStoreDetails();
                                  Navigator.pop(context);
                                }
                                    : null,
                                child: const Text("Update"),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                }),
              );
            },
          ),
        );
      },
    );
  }



  Widget _twoFieldRow({
    required Widget left,
    required Widget right,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: left),
          const SizedBox(width: 12),
          Expanded(child: right),
        ],
      ),
    );
  }

  Widget _labelField(
      String label,
      TextEditingController controller, {
        bool enabled = true,
        TextInputType keyboardType = TextInputType.text,
        bool isContact = false,
        bool isPincode = false,
        bool isGST = false,
        bool isEmail = false,
      }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,

      // 🔥 THIS WAS MISSING
      inputFormatters: isContact
          ? [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ]
          : null,

      validator: (value) {
        if (!enabled) return null;

        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }

        if (isContact && value.trim().length != 10) {
          return "Enter valid 10 digit mobile number";
        }

        if (isPincode && value.trim().length != 6) {
          return "Enter valid 6 digit Pincode";
        }

        if (isGST) {
          final gstRegex = RegExp(r'^[0-9A-Z]+$');
          if (!gstRegex.hasMatch(value.trim())) {
            return "GST must contain only capital letters & numbers";
          }
        }

        if (isEmail && !GetUtils.isEmail(value.trim())) {
          return "Enter valid email";
        }

        return null;
      },

      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        border: const OutlineInputBorder(),
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
            width: 200, // controls left alignment
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
