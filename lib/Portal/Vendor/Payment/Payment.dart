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
      // Hum poore content ko ek hi scroll view mein dalenge taake header bhi smooth scroll ho
      // ya agar header fixed chahiye toh Column ka structure change karenge.
      body: Column(
        children: [
          // Header Fixed rahega
          if (AppSizes.isWeb(context))
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding(context)),
              child: const HeaderWebPaymentWidget(
                mainTitle: 'Payment',
                showProfile: true,
                showNotification: true,
                showSettings: true,
              ),
            ),

          // Content Area
          Expanded(
            child: SelectionArea( // Web ke liye text selection enable karta hai
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding(context)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Zaroori hai
                    children: [
                      const SizedBox(height: 10),
                      // PaymentWidget ko ab size conflict nahi hoga
                      const PaymentWidget(),
                      SizedBox(height: AppSizes.verticalPadding(context) * 1.25),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}