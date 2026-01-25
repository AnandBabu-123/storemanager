import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../controllers/customer_managemnt_controller.dart';

class CustomerManagement extends StatelessWidget {
  CustomerManagement({super.key});

  final CustomerManagementController controller =
  Get.put(CustomerManagementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Management"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF90EE90), Color(0xFF87CEFA)],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            _inputField("Name*", controller.nameController),
            const SizedBox(height: 12),

            _inputField("Location*", controller.locationController),
            const SizedBox(height: 12),


            _inputField("Contact*", controller.contactController,
                keyboard: TextInputType.phone),
            const SizedBox(height: 12),

            _inputField("Email Id*", controller.emailController,
                keyboard: TextInputType.emailAddress),

            const Spacer(),

            /// 🔹 SAVE BUTTON
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.loading.value
                      ? null
                      : () => controller.postCustomer(),
                  child: controller.loading.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text("Save"),
                ),
              );
            }),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }

  /// 🔹 COMMON TEXTFIELD
  Widget _inputField(
      String label,
      TextEditingController controller, {
        TextInputType keyboard = TextInputType.text,
      }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
