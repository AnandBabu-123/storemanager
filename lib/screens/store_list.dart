
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storemanager/model/store_details.dart';
import '../controllers/dashbaoard_controller.dart';
import '../controllers/update_details_controller.dart';
import '../model/store_category.dart';
import '../model/storelist_response.dart';
import 'bottom_navigation_screens/app_drawer.dart';

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
    // 🔹 Ensure the store list is available
    final selected = controller.storeList.firstWhereOrNull((s) => s.id == store.id);
    if (selected != null) {
      controller.onStoreSelected(selected);
    }

    // 🔹 Preselect store category if list is loaded
    // final preselectedCategory = controller.storeCategories.firstWhereOrNull(
    //       (c) => c.storeCategoryId == store.type,
    // );
    // controller.selectedStoreCategory.value = preselectedCategory;

    // 🔹 Preselect business type from store data
    final preselectedBusinessType =
    controller.allBusinessTypes.firstWhereOrNull(
          (b) => b.businessTypeId == store.storeBusinessType,
    );

    controller.selectedBusinessType.value = preselectedBusinessType;



    // 🔹 Local controllers
    final storeNameCtrl = TextEditingController(text: store.name);
    final locationCtrl = TextEditingController(text: store.location);
    final stateCtrl = TextEditingController(text: store.state);
    final districtCtrl = TextEditingController(text: store.district);
    final gstCtrl = TextEditingController(text: store.gstNumber);
    final pincodeCtrl = TextEditingController(text: store.pincode);
    final townCtrl = TextEditingController(text: store.district);
    final ownerCtrl = TextEditingController(text: store.owner);
    final ownerAddressCtrl = TextEditingController(text: store.location);
    final ownerContactCtrl = TextEditingController(text: store.ownerContact);
    final alternateContactCtrl = TextEditingController(text: store.secondaryContact);
    final emailCtrl = TextEditingController(text: store.ownerEmail);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Obx(() {
              final bool canEdit = controller.canEdit.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 TITLE
                  const Center(
                    child: Text(
                      "Update Store",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// 🔹 STORE ID DROPDOWN
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Store ID*", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<Stores>(
                        value: controller.selectedStore.value,
                        isExpanded: true,
                        items: controller.storeList.map((s) {
                          return DropdownMenuItem<Stores>(
                            value: s,
                            child: Text("${s.id} - ${s.name}"),
                          );
                        }).toList(),
                        onChanged: canEdit
                            ? (val) {
                          controller.onStoreSelected(val);
                          if (val != null) {
                            storeNameCtrl.text = val.name ?? "";
                            locationCtrl.text = val.location ?? "";
                            stateCtrl.text = val.state ?? "";
                            districtCtrl.text = val.district ?? "";
                            gstCtrl.text = val.gstNumber ?? "";
                            pincodeCtrl.text = val.pincode ?? "";
                            townCtrl.text = val.district ?? "";
                            ownerCtrl.text = val.owner ?? "";
                            ownerAddressCtrl.text = val.location ?? "";
                            ownerContactCtrl.text = val.ownerContact ?? "";
                            alternateContactCtrl.text = val.secondaryContact ?? "";
                            emailCtrl.text = val.ownerEmail ?? "";
                          }
                        }
                            : null,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),

                  /// 🔹 STORE CATEGORY DROPDOWN
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Store Category*", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<StoreCategory>(
                        value: controller.selectedStoreCategory.value,
                        hint: const Text("Select Store Category"),
                        isExpanded: true,
                        items: controller.storeCategories.map((c) {
                          return DropdownMenuItem<StoreCategory>(
                            value: c,
                            child: Text(c.storeCategoryName ?? ""),
                          );
                        }).toList(),
                        onChanged: canEdit ? controller.onStoreCategoryChanged : null,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),

                  /// 🔹 STORE NAME + LOCATION
                  _twoFieldRow(
                    left: _labelField("Store Name*", storeNameCtrl, enabled: canEdit),
                    right: _labelField("Location*", locationCtrl, enabled: canEdit),
                  ),

                  /// 🔹 STATE + DISTRICT
                  _twoFieldRow(
                    left: _labelField("State*", stateCtrl, enabled: canEdit),
                    right: _labelField("District*", districtCtrl, enabled: canEdit),
                  ),

                  /// 🔹 GST + PINCODE
                  _twoFieldRow(
                    left: _labelField("GST Number*", gstCtrl, enabled: canEdit),
                    right: _labelField(
                      "PinCode*",
                      pincodeCtrl,
                      enabled: canEdit,
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  /// 🔹 TOWN + OWNER
                  _twoFieldRow(
                    left: _labelField("Town*", townCtrl, enabled: canEdit),
                    right: _labelField("Store Owner*", ownerCtrl, enabled: canEdit),
                  ),

                  /// 🔹 OWNER ADDRESS + OWNER CONTACT
                  _twoFieldRow(
                    left: _labelField("Owner Address*", ownerAddressCtrl, enabled: canEdit),
                    right: _labelField(
                      "Owner Contact*",
                      ownerContactCtrl,
                      enabled: canEdit,
                      keyboardType: TextInputType.phone,
                    ),
                  ),

                  /// 🔹 ALT CONTACT + EMAIL
                  _twoFieldRow(
                    left: _labelField("Alternate Contact*", alternateContactCtrl, enabled: canEdit, keyboardType: TextInputType.phone),
                    right: _labelField("Email Id*", emailCtrl, enabled: canEdit, keyboardType: TextInputType.emailAddress),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 ACTION BUTTONS
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
                            controller.updateStoreDetails();
                            Navigator.pop(context);
                          }
                              : null,
                          child: const Text("Update"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  // void _openUpdateStoreBottomSheet(
  //     BuildContext context,
  //     Stores store,
  //     )
  // {
  //   // 🔹 preselect store from controller list
  //   final selected = controller.storeList.firstWhereOrNull(
  //         (s) => s.id == store.id,
  //   );
  //
  //   if (selected != null) {
  //     controller.onStoreSelected(selected);
  //   }
  //
  //   controller.selectedStoreCategory.value =
  //       controller.storeCategories.firstWhereOrNull(
  //             (c) => c.storeCategoryId == store.type,
  //       );
  //
  //   // 🔹 Local controllers
  //   final storeNameCtrl = TextEditingController(text: store.name);
  //   final locationCtrl = TextEditingController(text: store.location);
  //   final stateCtrl = TextEditingController(text: store.state);
  //   final districtCtrl = TextEditingController(text: store.district);
  //   final gstCtrl = TextEditingController(text: store.gstNumber);
  //   final pincodeCtrl = TextEditingController(text: store.pincode);
  //   final townCtrl = TextEditingController(text: store.district);
  //   final ownerCtrl = TextEditingController(text: store.owner);
  //   final ownerAddressCtrl = TextEditingController(text: store.location);
  //   final ownerContactCtrl = TextEditingController(text: store.ownerContact);
  //   final alternateContactCtrl =
  //   TextEditingController(text: store.secondaryContact);
  //   final emailCtrl = TextEditingController(text: store.ownerEmail);
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (_) {
  //       return Padding(
  //         padding: EdgeInsets.only(
  //           left: 16,
  //           right: 16,
  //           top: 16,
  //           bottom: MediaQuery.of(context).viewInsets.bottom + 16,
  //         ),
  //         child: SingleChildScrollView(
  //           child:
  //           Obx(() {
  //             // ✅ FIX: RxBool → bool
  //             final bool canEdit = controller.canEdit.value;
  //
  //             return Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 /// 🔹 TITLE
  //                 const Center(
  //                   child: Text(
  //                     "Update Store",
  //                     style: TextStyle(
  //                         fontSize: 18, fontWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 16),
  //
  //                 /// 🔹 STORE ID
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Text("Store ID*",
  //                         style: TextStyle(
  //                             fontSize: 13,
  //                             fontWeight: FontWeight.w600)),
  //                     const SizedBox(height: 4),
  //
  //                     DropdownButtonFormField<Stores>(
  //                       value: controller.selectedStore.value,
  //                       isExpanded: true,
  //
  //                       items: controller.storeList.map((s) {
  //                         return DropdownMenuItem<Stores>(
  //                           value: s,
  //                           child: Text("${s.id} - ${s.name}"),
  //                         );
  //                       }).toList(),
  //
  //                       onChanged: controller.canEdit.value
  //                           ? (val) {
  //                         controller.onStoreSelected(val);
  //
  //                         if (val != null) {
  //                           storeNameCtrl.text = val.name ?? "";
  //                           locationCtrl.text = val.location ?? "";
  //                           stateCtrl.text = val.state ?? "";
  //                           districtCtrl.text = val.district ?? "";
  //                           gstCtrl.text = val.gstNumber ?? "";
  //                           pincodeCtrl.text = val.pincode ?? "";
  //                           townCtrl.text = val.district ?? "";
  //                           ownerCtrl.text = val.owner ?? "";
  //                           ownerAddressCtrl.text = val.location ?? "";
  //                           ownerContactCtrl.text = val.ownerContact ?? "";
  //                           alternateContactCtrl.text = val.secondaryContact ?? "";
  //                           emailCtrl.text = val.ownerEmail ?? "";
  //                         }
  //                       }
  //                           : null,
  //
  //                       decoration: const InputDecoration(
  //                         isDense: true,
  //                         border: OutlineInputBorder(),
  //                       ),
  //                     ),
  //
  //                     const SizedBox(height: 12),
  //                   ],
  //                 ),
  //
  //                 /// 🔹 STORE CATEGORY
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Text("Store Category*",
  //                         style: TextStyle(
  //                             fontSize: 13,
  //                             fontWeight: FontWeight.w600)),
  //                     const SizedBox(height: 4),
  //
  //                     DropdownButtonFormField<StoreCategory>(
  //                       value:
  //                       controller.selectedStoreCategory.value,
  //                       isExpanded: true,
  //                       items: controller.storeCategories.map((c) {
  //                         return DropdownMenuItem(
  //                           value: c,
  //                           child:
  //                           Text(c.storeCategoryName ?? ""),
  //                         );
  //                       }).toList(),
  //                       onChanged: canEdit
  //                           ? controller.onStoreCategoryChanged
  //                           : null,
  //                       decoration: const InputDecoration(
  //                         isDense: true,
  //                         border: OutlineInputBorder(),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 12),
  //                   ],
  //                 ),
  //
  //                 /// 🔹 STORE NAME + LOCATION
  //                 _twoFieldRow(
  //                   left: _labelField("Store Name*",
  //                       storeNameCtrl,
  //                       enabled: canEdit),
  //                   right: _labelField("Location*",
  //                       locationCtrl,
  //                       enabled: canEdit),
  //                 ),
  //
  //                 /// 🔹 STATE + DISTRICT
  //                 _twoFieldRow(
  //                   left: _labelField("State*",
  //                       stateCtrl,
  //                       enabled: canEdit),
  //                   right: _labelField("District*",
  //                       districtCtrl,
  //                       enabled: canEdit),
  //                 ),
  //
  //                 /// 🔹 GST + PINCODE
  //                 _twoFieldRow(
  //                   left: _labelField("GST Number*",
  //                       gstCtrl,
  //                       enabled: canEdit),
  //                   right: _labelField(
  //                     "PinCode*",
  //                     pincodeCtrl,
  //                     enabled: canEdit,
  //                     keyboardType:
  //                     TextInputType.number,
  //                   ),
  //                 ),
  //
  //                 /// 🔹 TOWN + OWNER
  //                 _twoFieldRow(
  //                   left: _labelField("Town*",
  //                       townCtrl,
  //                       enabled: canEdit),
  //                   right: _labelField("Store Owner*",
  //                       ownerCtrl,
  //                       enabled: canEdit),
  //                 ),
  //
  //                 /// 🔹 OWNER ADDRESS + OWNER CONTACT
  //                 _twoFieldRow(
  //                   left: _labelField("Owner Address*",
  //                       ownerAddressCtrl,
  //                       enabled: canEdit),
  //                   right: _labelField(
  //                     "Owner Contact*",
  //                     ownerContactCtrl,
  //                     enabled: canEdit,
  //                     keyboardType:
  //                     TextInputType.phone,
  //                   ),
  //                 ),
  //
  //                 /// 🔹 ALT CONTACT + EMAIL
  //                 _twoFieldRow(
  //                   left: _labelField(
  //                     "Alternate Contact*",
  //                     alternateContactCtrl,
  //                     enabled: canEdit,
  //                     keyboardType:
  //                     TextInputType.phone,
  //                   ),
  //                   right: _labelField(
  //                     "Email Id*",
  //                     emailCtrl,
  //                     enabled: canEdit,
  //                     keyboardType:
  //                     TextInputType.emailAddress,
  //                   ),
  //                 ),
  //
  //                 const SizedBox(height: 20),
  //
  //                 /// 🔹 ACTION BUTTONS
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: OutlinedButton(
  //                         onPressed: () =>
  //                             Navigator.pop(context),
  //                         child: const Text("Cancel"),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 12),
  //                     Expanded(
  //                       child: ElevatedButton(
  //                         onPressed: canEdit
  //                             ? () {
  //                           controller
  //                               .updateStoreDetails();
  //                           Navigator.pop(context);
  //                         }
  //                             : null,
  //                         child: const Text("Update"),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 60),
  //               ],
  //             );
  //           }),
  //         ),
  //       );
  //     },
  //   );
  // }


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
        TextInputType keyboardType = TextInputType.text,
        bool enabled = true,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
          ),
        ),
      ],
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
