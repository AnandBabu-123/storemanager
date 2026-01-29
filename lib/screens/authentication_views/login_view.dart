import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controllers/login_controller.dart';
import '../../routes/app_routes.dart';
import '../../utilities/custom_textview.dart';
import '../../utilities/styles.dart';
class LoginView extends StatelessWidget {
  LoginView({super.key});

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height,
        width: double.infinity,

        /// 🌈 BACKGROUND COLOR / GRADIENT
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF90EE90), // very light blue
              Color(0xFFBBDEFB), // light blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SingleChildScrollView(
          child: SizedBox(
            height: height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// 🏥 APP NAME
                    const Text(
                      "RXwala Pharmacy",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1), // deep blue
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Welcome back! Please login",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// 🔲 LOGIN CARD
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          /// Login Text
                          const Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 24),

                          _buildLabel("Email"),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: controller.emailController,
                            hintText: "Enter your email",
                            onChanged: (value) => controller.validateEmail(),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          Obx(() => Align(alignment: Alignment.centerLeft, child: _buildError(controller.emailError))),

                          const SizedBox(height: 16),

                          _buildLabel("Password"),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: controller.passwordController,
                            hintText: "Enter a valid password",
                            onChanged: (value) => controller.validatePassword(),
                            isPassword: true,
                          ),
                          Obx(() => Align(alignment: Alignment.centerLeft, child: _buildError(controller.passwordError))),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.forgotPassword);
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// 🔵 LOGIN BUTTON
                        Obx(() => ElevatedButton(
                          onPressed: controller.loading.value
                              ? null // disables button while loading
                              : () {
                            if (controller.isFormValid()) {
                              controller.login();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xFF1976D2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: controller.loading.value
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        )),


                        const SizedBox(height: 20),

                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.signupView);
                            },
                            child: Center(
                              child: RichText(
                                text: const TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Sign Up",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildError(RxString errorText) {
  return errorText.value.isNotEmpty
      ? Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(errorText.value, style: const TextStyle(color: Colors.red, fontSize: 12)),
  )
      : const SizedBox.shrink();
}

Widget _buildLabel(String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: RichText(
      text: TextSpan(
        text: "$text ",
        style: Styles.textStyle14(Styles.primaryColor, Styles.fontFamilyRobotoBold),
        children: [
          TextSpan(
            text: "*",
            style: Styles.textStyle14(Colors.red, Styles.fontFamilyRobotoBold),
          ),
        ],
      ),
    ),
  );
}
