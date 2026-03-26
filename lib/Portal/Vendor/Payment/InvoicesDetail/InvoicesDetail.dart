import 'dart:io';
import 'package:car_rental_customerPanel/Portal/Vendor/Payment/PaymentController.dart';
import 'package:car_rental_customerPanel/Portal/Vendor/Payment/ReusableWidget/HeaderWebPaymentWidget.dart';
import 'package:car_rental_customerPanel/Portal/Vendor/Payment/ReusableWidget/PrimaryBtnOfPaymentCustomer.dart';
import 'package:car_rental_customerPanel/Resources/AppSizes.dart';
import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:car_rental_customerPanel/Resources/IconString.dart';
import 'package:car_rental_customerPanel/Resources/TextString.dart';
import 'package:car_rental_customerPanel/Resources/TextTheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class InvoicesDetailScreen extends StatelessWidget {
  final Map invoiceData;
  InvoicesDetailScreen({super.key, required this.invoiceData}) {
    controller.clearSelection();
  }

  final controller = Get.put(PaymentController());

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'overdue': return AppColors.overdueColor;
      case 'pending': return AppColors.pendingColor;
      case 'completed': return AppColors.completedColor;
      case 'resubmit': return AppColors.reviewColor;
      case 'processing': return AppColors.textColor;
      default: return  AppColors.tertiaryTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = AppSizes.isWeb(context);
    final String invoiceId = invoiceData["id"] ?? "N/A";
    final String status = (invoiceData["status"] ?? "Pending").toLowerCase();
    final String carName = invoiceData["car"] ?? "Mazada CX-5, City Drive";
    final bool isUploadable = status == 'pending' || status == 'resubmit' || status == 'overdue';

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) controller.clearSelection();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundOfScreenColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isWeb)
                    HeaderWebPaymentWidget(
                      mainTitle: 'Payment Detail',
                      showProfile: true,
                      showNotification: true,
                      showSettings: true,
                      showBack: true,
                    ),

                  const SizedBox(height: 20),
                  _buildInvoiceHeader(invoiceId, carName, invoiceData["status"] ?? "Pending"),
                  const SizedBox(height: 24),

                  if (isWeb)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildCarDetailSection(isWeb,context)),
                        const SizedBox(width: 20),
                        Expanded(child: _buildRentalPeriodSection(isWeb,context)),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildCarDetailSection(isWeb,context),
                        const SizedBox(height: 20),
                        _buildRentalPeriodSection(isWeb,context),
                      ],
                    ),

                  const SizedBox(height: 24),

                  _buildInfoSection(TextString.PaymentInvoicestitle, [
                    _buildPaymentSummary(invoiceData["amount"] ?? "234.00", status),
                    const SizedBox(height: 24),

                    if (isUploadable)
                      Obx(() => controller.selectedImage.value == null
                          ? _buildUploadBox(status,context)
                          : _buildSelectedImagePreview(context)),

                    if (status == 'processing')
                      _buildNoteBox(TextString.processingNote,context),

                  ],context),

                  if (status == 'resubmit')
                    _buildExternalResubmitNote(context),

                  // Submit Button
                  if (isUploadable)
                    Padding(
                      padding: EdgeInsets.only(
                        top: AppSizes.padding(context),
                        bottom: AppSizes.padding(context),
                      ),
                      child: Align(
                        alignment: AppSizes.isMobile(context) ? Alignment.center : Alignment.centerRight,
                        child: PrimaryBtnOfPaymentPanel(
                          text:status == 'resubmit' ? "Resubmit" :  "Submit",
                          height: AppSizes.buttonHeight(context),
                          width: AppSizes.isMobile(context) ? double.infinity : 150,
                          borderRadius: BorderRadius.circular(AppSizes.borderRadius(context)),
                          onTap: () {
                            if (controller.selectedImage.value == null) {
                              Get.snackbar(
                                "Required",
                                "Please upload your payment receipt first.",
                              );
                            } else {
                              print("Submitting receipt for status: $status");
                            }
                          },
                        ),
                      ),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  /// ------------ Extra Widget ------- ///


//  Image Preview Widget
  Widget _buildSelectedImagePreview(BuildContext context) {
    final image = controller.selectedImage.value;
    if (image == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundOfPickupsWidget,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 350,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: (kIsWeb || image.bytes != null)
                            ? Image.memory(image.bytes!, fit: BoxFit.contain)
                            : Image.file(File(image.path!), fit: BoxFit.contain),
                      ),
                    ),
                    Positioned.fill(
                      child: MouseRegion(
                        onEnter: (_) => controller.setHover(true),
                        onExit: (_) => controller.setHover(false),
                        child: InkWell(
                          onTap: () => _showImagePopup(context),
                          child: Obx(() => AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: controller.isImageHovered.value ? 1.0 : 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.zoom_in,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                            ),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.backgroundOfScreenColor),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(IconString.receiptIcon, ),
                        const SizedBox(width: 8),
                        Text(image.name ?? TextString.receiptTitle, style: TTextTheme.bodyRegular12black(context)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => controller.clearSelection(),
                      child:  Text(TextString.cancel, style: TTextTheme.bodyRegular12Primary(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showImagePopup(BuildContext context) {
    final image = controller.selectedImage.value;
    if (image == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.sideBoxesColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 1)
                    ],
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
            ),

            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: kIsWeb
                      ? Image.memory(image.bytes!, fit: BoxFit.contain)
                      : Image.file(File(image.path!), fit: BoxFit.contain),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildUploadBox(String status,BuildContext context) {
    return GestureDetector(
      onTap: () => controller.pickPaymentReceipt(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: AppColors.backgroundOfPickupsWidget,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Image.asset(IconString.invoicesIconIncreased, color:AppColors.primaryColor,),
            const SizedBox(height: 12),
            Text(
                status == 'resubmit' ? TextString.reupload : TextString.uploadinvoices,
                style: TTextTheme.h1Style(context)
            ),

            const SizedBox(height: 4),
            RichText(
              text:  TextSpan(
                style: TTextTheme.bodyRegular16secondary(context),
                children: [
                  TextSpan(text: TextString.jpgandPng),
                  TextSpan(text: TextString.under10, style: TTextTheme.bodyRegular16Primary(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Note Boxes
  Widget _buildNoteBox(String message,BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.backgroundOfScreenColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(TextString.noteTitle, style: TTextTheme.h2PrimaryStyle(context)),
          const SizedBox(height: 12),
          Text(message, style: TTextTheme.bodyRegular16black(context)),
        ],
      ),
    );
  }
  Widget _buildExternalResubmitNote(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
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
           Text(
            TextString.noteTitle,
            style: TTextTheme.h2PrimaryStyle(context)
          ),
          const SizedBox(height: 10),
           Text(
            TextString.noteSubTitle,
            style: TTextTheme.bodyRegular16black(context)
          ),
        ],
      ),
    );
  }

   // Detail Section
  Widget _buildCarDetailSection(bool isWeb,BuildContext context) {
    return _buildInfoSection(TextString.carTitle, [
      _responsiveRow(isWeb, TextString.carSubtitle1, "Mazada CX-5(2017)", "Type", "Sedan",context),
      _responsiveRow(isWeb, TextString.carSubtitle2, "Abc12345", "Transmission", "Automatic",context),
    ],context);
  }
 // Rental Section
  Widget _buildRentalPeriodSection(bool isWeb,BuildContext context) {
    return _buildInfoSection(TextString.rentTitle, [
      _responsiveRow(isWeb,TextString.rentSubtitle1 , "March 7, 2026", TextString.rentSubtitle3, "March 14, 2026",context),
      _buildDetailField(TextString.rentSubtitle2, "7 days",context),
    ],context);
  }

   // Invoice Header
  Widget _buildInvoiceHeader(String id, String subtitle, String status) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 400;

        return Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12)
          ),
          child: isMobile
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderText(id, subtitle,context),
              const SizedBox(height: 16),
              _buildStatusChip(status,context),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _buildHeaderText(id, subtitle,context)),
              const SizedBox(width: 10),
              _buildStatusChip(status,context),
            ],
          ),
        );
      },
    );
  }
  Widget _buildHeaderText(String id, String subtitle,BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Invoice $id",
          style: TTextTheme.h2Style(context),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TTextTheme.bodyRegular16(context),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

   // Info Section
  Widget _buildInfoSection(String title, List<Widget> children,BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TTextTheme.h2Style(context)),
          const SizedBox(height: 4),
          Text("Your $title listed here", style: TTextTheme.bodyRegular16(context)),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
  Widget _responsiveRow(bool isWeb, String l1, String v1, String l2, String v2,BuildContext context) {
    return isWeb
        ? Row(children: [Expanded(child: _buildDetailField(l1, v1,context)), const SizedBox(width: 16), Expanded(child: _buildDetailField(l2, v2,context))])
        : Column(children: [_buildDetailField(l1, v1,context), _buildDetailField(l2, v2,context)]);
  }

   // Detail TextField
  Widget _buildDetailField(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TTextTheme.bodyRegular14(context)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.backgroundOfScreenColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              value,
              style: TTextTheme.bodyRegular16black(context),
            ),
          ),
        ],
      ),
    );
  }

  // Payment Summary
  Widget _buildPaymentSummary(String amount, String status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.backgroundOfScreenColor,),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isNarrow = constraints.maxWidth < 200;

          return isNarrow
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAmountText(amount,context),
              const SizedBox(height: 12),
              _buildStatusChip(status,context),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAmountText(amount,context),
              _buildStatusChip(status,context),
            ],
          );
        },
      ),
    );
  }
  Widget _buildAmountText(String amount,BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(TextString.totalAmount, style: TTextTheme.bodyRegular14(context)),
        const SizedBox(height: 4),
        Text(
            "AUD $amount",
            style: TTextTheme.h1StylePrimary(context)
        ),
      ],
    );
  }

   // Status Chip
  Widget _buildStatusChip(String status,BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: _getStatusColor(status), borderRadius: BorderRadius.circular(20)),
      child: Text(status, style:TTextTheme.bodySemiBold14White(context)),
    );
  }
}