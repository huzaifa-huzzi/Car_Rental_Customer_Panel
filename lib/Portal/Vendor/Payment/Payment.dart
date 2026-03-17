import 'package:car_rental_customerPanel/Portal/Vendor/Payment/PaymentController.dart';
import 'package:car_rental_customerPanel/Portal/Vendor/Payment/ReusableWidget/HeaderWebPaymentWidget.dart';
import 'package:car_rental_customerPanel/Portal/Vendor/Payment/Widget/PaymentWidget.dart';
import 'package:car_rental_customerPanel/Resources/AppSizes.dart';
import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});

  final controller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOfScreenColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPadding(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (AppSizes.isWeb(context))
                  const HeaderWebPaymentWidget(
                    mainTitle: 'Payment',
                    showProfile: true,
                    showNotification: true,
                    showSettings: true,
                  ),
                const SizedBox(height: 10),
                const PaymentWidget(),
                SizedBox(height: AppSizes.verticalPadding(context) * 1.25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}