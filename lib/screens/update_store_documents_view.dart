import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/update_details_controller.dart';
import '../model/storelist_response.dart';
import 'package:file_picker/file_picker.dart';

class UpdateStoreDocumentsView extends StatelessWidget {
  UpdateStoreDocumentsView({super.key});

  final UpdateDetailsController controller =
  Get.put(UpdateDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Store Documents"),
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 SELECT STORE
            const Text(
              "Select Store",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),


            Obx(() => DropdownButtonFormField<StoreItem>(
              value: controller.selectedStore.value,
              items: controller.stores.map((store) {
                return DropdownMenuItem<StoreItem>(
                  value: store,
                  child: Text("${store.id} - ${store.name}"),
                );
              }).toList(),
              onChanged: controller.onStoredSelected, // ✅ FIXED NAME
              decoration: _inputDecoration("Select Store"),
            )),


            const SizedBox(height: 20),

            /// 🔹 STORE FRONT IMAGE
            _buildFileUploadField(
              label: "Store Front Image *",
              selectedFile: controller.storeFrontImage,
              onFileSelected: (file) =>
              controller.storeFrontImage.value = file,
            ),

            const SizedBox(height: 12),

            /// 🔹 TRADE LICENSE
            _buildFileUploadField(
              label: "Trade License *",
              selectedFile: controller.tradeLicense,
              onFileSelected: (file) =>
              controller.tradeLicense.value = file,
            ),

            const SizedBox(height: 12),

            /// 🔹 DRUG LICENSE
            _buildFileUploadField(
              label: "Drug License *",
              selectedFile: controller.drugLicense,
              onFileSelected: (file) =>
              controller.drugLicense.value = file,
            ),

            const SizedBox(height: 20),

            /// 🔹 UPLOAD BUTTON
            Obx(() => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isStoreVerified.value
                    ? null
                    : controller.uploadDocuments,


                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isStoreVerified.value
                      ? Colors.grey
                      : const Color(0xFF90EE90),

                ),
                child: Text(
                  controller.isStoreVerified.value
                      ? "Store Already Verified"
                      : "Upload Documents",
                ),

              ),
            )),

          ],
        ),
      ),
    );
  }

  /// 🔹 COMMON INPUT DECORATION
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  /// 🔹 FILE UPLOAD FIELD
  Widget _buildFileUploadField({
    required String label,
    required Rxn<File> selectedFile,
    required Function(File) onFileSelected,
  }) {
    return Obx(() {
      final isEnabled = !controller.isStoreVerified.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isEnabled ? Colors.black : Colors.grey,
              )),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: isEnabled
                ? () => _showPickDialog(onFileSelected: onFileSelected)
                : null,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                    color: isEnabled ? Colors.grey : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
                color: isEnabled ? Colors.white : Colors.grey.shade100,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                selectedFile.value?.path.split("/").last ??
                    (isEnabled
                        ? "Select file"
                        : "Store already verified"),
                style: TextStyle(
                  fontSize: 14,
                  color: isEnabled ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }



  void _showPickDialog({required Function(File) onFileSelected}) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () async {
                Get.back();
                final picker = ImagePicker();
                final picked =
                await picker.pickImage(source: ImageSource.camera);

                if (picked != null) {
                  onFileSelected(File(picked.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text("Files (Drive / Mobile)"),
              onTap: () async {
                Get.back();
                final result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.any,
                );

                if (result != null && result.files.isNotEmpty) {
                  final path = result.files.first.path;
                  if (path != null) {
                    onFileSelected(File(path));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }


}
