import 'package:car_rental_customerPanel/Portal/Vendor/Payment/PaymentController.dart';
import 'package:car_rental_customerPanel/Portal/Vendor/Payment/ReusableWidget/HeaderWebPaymentWidget.dart';
import 'package:car_rental_customerPanel/Resources/AppSizes.dart';
import 'package:car_rental_customerPanel/Resources/Color.dart';
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
                  ),
                const SizedBox(height: 20),

                // Main Payment Details Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSizes.padding(context)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Payment Details", style: TTextTheme.h2Style(context)),
                      Text("Below are the instruction how to pay",
                          style: TTextTheme.bodyRegular14(context).copyWith(color: Colors.grey)),
                      const SizedBox(height: 24),

                      // Custom Tab Switcher
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xffF2F2F2),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Obx(() => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTabButton(
                                  "Payment by Bank Account",
                                  isActive: controller.selectedTab2.value == 0,
                                  onTap: () => controller.selectedTab2.value = 0,
                                ),
                                const SizedBox(width: 8),
                                _buildTabButton(
                                  "Payment by Pay ID",
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
                        spacing: 20,
                        runSpacing: 20,
                        children: controller.selectedTab2.value == 0
                            ? [
                          _buildCopyField("Account Name", "Soft Snip", context),
                          _buildCopyField("BSB", "123456", context),
                          _buildCopyField("Account Number", "XXXXXXXXX", context),
                        ]
                            : [
                          _buildCopyField("Email address", "Soft Snip@gmail.com", context),
                        ],
                      )),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Instruction Section (Responsive Row/Column)
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isMobile = AppSizes.isMobile(context);
                    return Flex(
                      direction: isMobile ? Axis.vertical : Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: isMobile ? 0 : 1,
                          child: _instructionBox(context, "Payment Instruction for bank", _bankSteps, Colors.redAccent),
                        ),
                        SizedBox(width: isMobile ? 0 : 20, height: isMobile ? 20 : 0),
                        Expanded(
                          flex: isMobile ? 0 : 1,
                          child: _instructionBox(context, "How to Upload your Payment receipt", _uploadSteps, Colors.redAccent),
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

  Widget _buildTabButton(String text, {required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.redAccent : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xff8E98A8),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildCopyField(String label, String value, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - (AppSizes.horizontalPadding(context) * 2);
    double width;

    if (AppSizes.isMobile(context)) {
      width = double.infinity;
    } else {
      width = controller.selectedTab2.value == 1
          ? screenWidth - (AppSizes.padding(context) * 2)
          : (screenWidth / 3) - 30;
    }

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TTextTheme.bodyRegular14(context).copyWith(color: Colors.grey[600])),
          const SizedBox(height: 8),
          Container(
            // Field ki padding thori barhayi hai taake andar ka content khul kar aaye
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
                ]
            ),
            child: Row(
              children: [
                Expanded(child: Text(value, style: TTextTheme.bodyRegular16black(context))),
                const SizedBox(width: 10),

                // Refined Copy Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                      Get.rawSnackbar(
                        message: "$label copied!",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.black87,
                      );
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      // Yahan height aur padding set ki hai taake button bada dikhe
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Text(
                        "Copy",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13, // Font thora bada kiya
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _instructionBox(BuildContext context, String title, List<String> steps, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TTextTheme.h2Style(context).copyWith(color: color, fontSize: 18)),
          const SizedBox(height: 6),
          Text("Below are details for instruction", style: TTextTheme.bodyRegular12(context).copyWith(color: Colors.grey)),
          const SizedBox(height: 20),
          ...steps.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${entry.key + 1}. ", style: TTextTheme.bodyRegular14(context)),
                Expanded(child: Text(entry.value, style: TTextTheme.bodyRegular14(context))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  final List<String> _bankSteps = [
    "Open your banking app and select PayID Transfer.",
    "Enter the PayID email provided by the rental company.",
    "Confirm the account name.",
    "Enter the payment amount.",
    "Send the payment.",
  ];
  final List<String> _uploadSteps = [
    "Make the payment using the bank details above.",
    "Upload the payment receipt or transaction screenshot.",
    "Ensure the transaction ID and amount are clearly visible.",
    "Your payment will be verified by the admin.",
  ];
}
