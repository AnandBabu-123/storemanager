import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/otp_controller.dart';


class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  final OtpController controller = Get.put(OtpController());

  Widget otpCard({
    required String title,
    required String subtitle,
    required String hint,
    required VoidCallback onSend,
    required VoidCallback onVerify,
    required Function(String) onChanged,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),

            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: onChanged,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF64B5F6), // blue
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onSend,
                    child: const Text("Send OTP"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF43A047), // green
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onVerify,
                    child: const Text("Verify OTP"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification"),elevation: 0,
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
        ),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            otpCard(
              title: "Verify Email",
              subtitle: controller.email,
              hint: "Enter Email OTP",
              onSend: controller.sendEmailOtp,
              onVerify: controller.verifyEmailOtp,
              onChanged: (v) => controller.emailOtp = v,
            ),
            otpCard(
              title: "Verify Mobile Number",
              subtitle: controller.phoneNumber,
              hint: "Enter Mobile OTP",
              onSend: controller.sendMobileOtp,
              onVerify: controller.verifyMobileOtp,
              onChanged: (v) => controller.mobileOtp = v,
            ),
          ],
        ),
      ),
    );
  }
}

