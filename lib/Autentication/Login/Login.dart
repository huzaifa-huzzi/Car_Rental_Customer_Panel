import 'package:car_rental_customerPanel/Autentication/Login/LoginController.dart';
import 'package:car_rental_customerPanel/Autentication/ReusableWidget/PrimaryBtnOfLogin.dart';
import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:car_rental_customerPanel/Resources/IconString.dart';
import 'package:car_rental_customerPanel/Resources/TextTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(child: Container(color: AppColors.secondaryColor)),
              Expanded(child: Container(color: AppColors.backgroundOfPickupsWidget)),
            ],
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (!isMobile)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: _buildLogo(),
                      ),
                    ),
                  if (isMobile) _buildLogo(),
                  if (isMobile) const SizedBox(height: 30),

                  Container(
                    constraints: const BoxConstraints(maxWidth: 450),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text("Welcome Back", style: TTextTheme.h3Style(context),),
                        const SizedBox(height: 10),
                        Text("Enter your Username and Password to access your account",
                            textAlign: TextAlign.center, style:TTextTheme.pSeven(context)),
                        const SizedBox(height: 30),

                        _buildLabel("Username"),
                        _buildTextField(
                          hint: "John Doe",
                          textController: controller.usernameController,
                        ),
                        const SizedBox(height: 20),

                        _buildLabel("Password"),
                        Obx(() => _buildTextField(
                          hint: "5elloStore",
                          isPassword: true,
                          textController: controller.passwordController,
                          obscureText: controller.obscurePassword.value,
                          onSuffixTap: controller.togglePasswordVisibility,
                        )),

                        const SizedBox(height: 15),

                        // Login Button
                        PrimaryBtnOfLogin(
                          text:"Log In",
                          onTap: (){
                            context.go('/dashboard');
                          },
                          width: double.infinity,
                          height: 50,
                          borderRadius: BorderRadius.circular(10),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// -------- Extra Widget --------- ///


  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(IconString.logo),
        const SizedBox(width: 10),
        Text("SoftSnip", style: TTextTheme.logoStyle(context)),
      ],
    );
  }
  Widget _buildTextField({required String hint, TextEditingController? textController, bool isPassword = false, bool obscureText = false, VoidCallback? onSuffixTap}) {
    return TextField(
      cursorColor: AppColors.blackColor,
      controller: textController,
      obscureText: obscureText,
      style: TTextTheme.loginInsideTextField(context),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TTextTheme.loginInsideTextField(context),
        filled: true,
        fillColor: AppColors.secondaryColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: isPassword ? IconButton(icon: Icon(obscureText
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,color: AppColors.tertiaryTextColor ,size: 20), onPressed: onSuffixTap) : null,
      ),
    );
  }
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: TTextTheme.dropdowninsideText(context)),
      ),
    );
  }

}