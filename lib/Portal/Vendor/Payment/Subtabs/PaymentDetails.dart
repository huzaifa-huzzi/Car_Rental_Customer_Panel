import 'package:car_rental_customerPanel/Portal/Vendor/Payment/PaymentController.dart';
import 'package:car_rental_customerPanel/Portal/Vendor/Payment/ReusableWidget/HeaderWebPaymentWidget.dart';
import 'package:car_rental_customerPanel/Resources/AppSizes.dart';
import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:car_rental_customerPanel/Resources/TextString.dart';
import 'package:car_rental_customerPanel/Resources/TextTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class PaymentDetail extends StatelessWidget {
  PaymentDetail({super.key});

  final controller = Get.put(PaymentController());


  @override
  Widget build(BuildContext context) {
    final isWeb = AppSizes.isWeb(context);
    final isTab = AppSizes.isTablet(context);
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
                   HeaderWebPaymentWidget(
                    mainTitle: 'Payment',
                    showProfile:isWeb || isTab ? true : false,
                    showNotification: true,
                    showSettings: true,
                     showBack: true,
                  ),
                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSizes.padding(context)),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TextString.PaymentDetailtitle, style: TTextTheme.h2Style(context)),
                      Text(TextString.paymentDetailSubTitle,
                          style: TTextTheme.bodyRegular16(context)),
                      const SizedBox(height: 24),

                      //  Tab Switcher
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundOfScreenColor,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Obx(() => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTabButton(
                                    TextString.PaymentByBankId,
                                  context,
                                  isActive: controller.selectedTab2.value == 0,
                                  onTap: () => controller.selectedTab2.value = 0,
                                ),
                                const SizedBox(width: 8),
                                _buildTabButton(
                                  TextString.PaymentByPayId,
                                  context,
                                  isActive: controller.selectedTab2.value == 1,
                                  onTap: () => controller.selectedTab2.value = 1,
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      Obx(() => Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.selectedTab2.value == 0
                            ? [
                          _buildCopyField(TextString.accName, "Soft Snip", context),
                          _buildCopyField(TextString.bsbNo, "123456", context),
                          _buildCopyField(TextString.accNo, "XXXXXXXXX", context),
                        ]
                            : [
                          _buildCopyField(TextString.email, "Soft Snip@gmail.com", context),
                        ],
                      )),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Instruction Section
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isMobile = AppSizes.isMobile(context);
                    return Flex(
                      direction: isMobile ? Axis.vertical : Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: isMobile ? 0 : 1,
                          child: _instructionBox(context, TextString.insOne, _bankSteps, AppColors.primaryColor),
                        ),
                        SizedBox(width: isMobile ? 0 : 20, height: isMobile ? 20 : 0),
                        Expanded(
                          flex: isMobile ? 0 : 1,
                          child: _instructionBox(context, TextString.insTwo, _uploadSteps, AppColors.primaryColor),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

 /// ------------- Extra Widgets ----------- ///

   // Tab Button
  Widget _buildTabButton(String text,BuildContext context,{required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: isActive ? TTextTheme.medium14White(context) : TTextTheme.medium14tableHeading(context),
      ),
      ),
    );
  }

   // Copy Field
  Widget _buildCopyField(String label, String value, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - (AppSizes.horizontalPadding(context) * 2);
    double width;

    if (AppSizes.isMobile(context)) {
      width = double.infinity;
    } else {
      if (controller.selectedTab2.value == 1) {
        width = screenWidth - (AppSizes.padding(context) * 2);
      } else {
        width = (screenWidth / 3) - 30;
      }
    }

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TTextTheme.bodyRegular14(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border.all(color: AppColors.backgroundOfScreenColor),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
                ]
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TTextTheme.bodyRegular16black(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                      Get.rawSnackbar(message: "$label copied!");
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child:  Text(
                        "Copy",
                        style:TTextTheme.medium12White(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

   // Instruction Box
  Widget _instructionBox(BuildContext context, String title, List<String> steps, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TTextTheme.h2PrimaryStyle(context)),
          const SizedBox(height: 6),
          Text(TextString.insSubtitle, style: TTextTheme.bodyRegular16secondary(context)),
          const SizedBox(height: 20),
          ...steps.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${entry.key + 1}. ", style: TTextTheme.bodyRegular16black(context)),
                Expanded(child: Text(entry.value, style: TTextTheme.bodyRegular16black(context))),
              ],
            ),
          )),
        ],
      ),
    );
  }

   // Content Written
  final List<String> _bankSteps = [
    TextString.bankStep1,
    TextString.bankStep2,
    TextString.bankStep3,
    TextString.bankStep4,
    TextString.bankStep5,
  ];
  final List<String> _uploadSteps = [
    TextString.uploadStep1,
    TextString.uploadStep2,
    TextString.uploadStep3,
    TextString.uploadStep4,
  ];
}
