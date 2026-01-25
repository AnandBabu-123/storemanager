import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controllers/signup_controller.dart';
import '../../utilities/custom_textview.dart';
import 'login_view.dart';


class SignUPView extends StatelessWidget {
  SignUPView({super.key});
  final controller = Get.put(SignupController());
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      
      body: Container(
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF90EE90),
              Color(0xFFBBDEFB),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                        child: SvgPicture.asset("assets/back_arrow.svg",)),

                    Expanded(
                      child: Center(
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 60,),
                _buildLabel("Name", isMandatory: true),
                CustomTextField(
                controller: controller.nameController,
                  keyboardType: TextInputType.name,
                  hintText: "Enter your name",
                  maxLength: 30,
                  onChanged: (value) => controller.validateName(),
                ),
                Obx(() => _buildError(controller.nameError)),

                const SizedBox(height: 20),
                _buildLabel("Phone Number"),
                CustomTextField(
                  controller: controller.phoneController,
                  hintText: "Enter your phone number",
                  keyboardType: TextInputType.phone,
                  maxLength: 15,
                  onChanged: (value) => controller.validatePhoneNumber(),
                ),
                Obx(() => _buildError(controller.phoneError)),

                const SizedBox(height: 20),
                _buildLabel("Email Address", isMandatory: true),
                CustomTextField(
                  controller: controller.emailController,
                  hintText: "Enter your email address",
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 30,
                  onChanged: (value) => controller.validateEmail(),
                ),
                Obx(() => _buildError(controller.emailError)),

                const SizedBox(height: 20),
                _buildLabel("Password", isMandatory: true),
                CustomTextField(
                  controller: controller.passwordController,
                  hintText: "Enter valid password",
                  isPassword: true,
                  onChanged: (value) => controller.validatePassword(),
                ),
                Obx(() => _buildError(controller.passwordError)),

                const SizedBox(height: 20),
                _buildLabel("Confirm Password", isMandatory: true),
                CustomTextField(
                  controller: controller.confirmPasswordController,
                  hintText: "Confirm your password",
                  isPassword: true,
                  onChanged: (value) => controller.validateConfirmPassword(),
                ),
                Obx(() => _buildError(controller.confirmPasswordError)),

                const SizedBox(height: 30),


                Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                    if (controller.isFormValid()) {
                      controller.register();
                    }
                  },
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text("Submit"),
                )),


                const SizedBox(height: 30),

                /// LOGIN REDIRECT AT BOTTOM
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildLoginRedirect(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(RxString errorText) {
    return errorText.value.isNotEmpty
        ? Padding(
      padding: EdgeInsets.only(top: 0, bottom: 10),
      child: Text(errorText.value, style: TextStyle(color: Colors.red, fontSize: 12)),
    )
        : SizedBox.shrink();
  }

  /// LABEL
  Widget _buildLabel(String text, {bool isMandatory = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: RichText(
      text: TextSpan(
        text: "$text ",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: isMandatory
            ? const [
          TextSpan(
            text: "*",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ]
            : [],
      ),
    ),
  );

  /// LOGIN REDIRECT
  Widget _buildLoginRedirect() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Already have an account? ",
          style: const TextStyle(fontSize: 14, color: Colors.black),
          children: [
            TextSpan(
              text: "Login",
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w800,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.offAll(() => LoginView());
                },
            ),
          ],
        ),
      ),
    );
  }
}


