import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import '../controllers/user_details_controller.dart';
import '../model/store_details.dart';

class UserStoreDetails extends StatelessWidget {
   UserStoreDetails({super.key});

  final controller = Get.put(UserDetailsController());
  @override
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(

        appBar: AppBar(
          title: const Text("Add Store User"),
          centerTitle: true,
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

          // Tab bar in AppBar
        ),

        body: SafeArea(
          child: TabBarView(
            children: [
              _buildAddUserTab(),
            //  _buildGetUserTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddUserTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          children: [

            /// ROW 1
            Row(
              children: [
                Expanded(child: _inputField("Name", "", controller: controller.nameController)),
                const SizedBox(width: 6),
                Expanded(child: _inputField("Address", "", controller: controller.addressController)),
              ],
            ),

            const SizedBox(height: 16),

            /// ROW 2
            Row(
              children: [
                Expanded(
                  child: _inputField(
                    "Contact",
                    "",
                    controller: controller.mobileController,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _inputField(
                    "Password",
                    "",
                    controller: controller.passwordController,
                  ),
                ),

              ],
            ),


            SizedBox(height: 8,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _inputField(
                  "Email",
                  "",
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                SizedBox(height: 8,),
                const Text(
                  "Stores",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.storeList.isEmpty) {
                    return TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: "No verified stores available",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    );
                  }

                  return DropdownButtonFormField<Stores>(
                    isExpanded: true,
                    value: controller.selectedStore.value,
                    items: controller.storeList.map((store) {
                      return DropdownMenuItem<Stores>(
                        value: store,
                        child: Text("${store.id} - ${store.name}"),
                      );
                    }).toList(),
                    onChanged: (store) {
                      controller.selectedStore.value = store;
                    },
                    decoration: InputDecoration(
                      hintText: "Select Store",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                  );
                })

              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.addStoreUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87CEFA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Helper Input Field
  Widget _inputField(
      String label,
      String hint, {
        required TextEditingController controller,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
          ),
        ),
      ],
    );
  }


  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }


}
