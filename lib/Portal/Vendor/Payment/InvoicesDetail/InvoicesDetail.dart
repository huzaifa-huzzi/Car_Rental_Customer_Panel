import 'dart:io';
import 'package:car_rental_customerPanel/Portal/Vendor/Payment/PaymentController.dart';
import 'package:car_rental_customerPanel/Portal/Vendor/Payment/ReusableWidget/HeaderWebPaymentWidget.dart';
import 'package:car_rental_customerPanel/Resources/AppSizes.dart';
import 'package:car_rental_customerPanel/Resources/Color.dart';
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
      case 'overdue': return const Color(0xFFE10600);
      case 'pending': return const Color(0xFFD4AF37);
      case 'completed': return Colors.green;
      case 'resubmit': return Colors.orange;
      case 'processing': return const Color(0xFF1E293B);
      default: return const Color(0xFF94A3B8);
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
                        Expanded(child: _buildCarDetailSection(isWeb)),
                        const SizedBox(width: 20),
                        Expanded(child: _buildRentalPeriodSection(isWeb)),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildCarDetailSection(isWeb),
                        const SizedBox(height: 20),
                        _buildRentalPeriodSection(isWeb),
                      ],
                    ),

                  const SizedBox(height: 24),

                  _buildInfoSection("Payment Detail", [
                    _buildPaymentSummary(invoiceData["amount"] ?? "234.00", status),
                    const SizedBox(height: 24),

                    if (isUploadable)
                      Obx(() => controller.selectedImage.value == null
                          ? _buildUploadBox(status)
                          : _buildSelectedImagePreview(context)),

                    if (status == 'processing')
                      _buildNoteBox("Your payment receipt is under review. No further action is required at this time."),

                  ]),

                  if (status == 'resubmit')
                    _buildExternalResubmitNote(),

                  // Submit Button
                  if (isUploadable)
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 40),
                      child: Align(
                        alignment: isWeb ? Alignment.centerRight : Alignment.center,
                        child: SizedBox(
                          width: isWeb ? 150 : double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (controller.selectedImage.value == null) {
                                Get.snackbar(
                                  "Required",
                                  "Please upload your payment receipt first.",
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );
                              } else {
                                print("Submitting receipt for status: $status");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
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
        color: const Color(0xFFFFEBEE).withOpacity(0.5),
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
                        color: Colors.white,
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
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
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
                        const Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 20),
                        const SizedBox(width: 8),
                        Text(image.name ?? "Receipt.png", style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => controller.clearSelection(),
                      child: const Text("Cancel", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
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
                    color: Colors.white,
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
                  color: Colors.white,
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
  Widget _buildUploadBox(String status) {
    return GestureDetector(
      onTap: () => controller.pickPaymentReceipt(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            const Icon(Icons.description_outlined, color: Colors.redAccent, size: 40),
            const SizedBox(height: 12),
            Text(
                status == 'resubmit' ? "Reupload payment receipt" : "Upload payment receipt",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
            ),

            const SizedBox(height: 4),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 12, color: Colors.grey),
                children: [
                  TextSpan(text: "JPEG, PNG "),
                  TextSpan(text: "(Must be under 10 MB)", style: TextStyle(color: Colors.redAccent)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Note Boxes
  Widget _buildNoteBox(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Note", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }
  Widget _buildExternalResubmitNote() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
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
          const Text(
            "Note",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Please upload a clear screenshot or photo of your payment receipt. Make sure the transaction ID, amount, and date are clearly visible. Blurry or unclear receipts may require review or resubmission.",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

   // Detail Section
  Widget _buildCarDetailSection(bool isWeb) {
    return _buildInfoSection("Car Detail", [
      _responsiveRow(isWeb, "Car Name", "Mazada CX-5(2017)", "Type", "Sedan"),
      _responsiveRow(isWeb, "Registration", "Abc12345", "Transmission", "Automatic"),
    ]);
  }
 // Rental Section
  Widget _buildRentalPeriodSection(bool isWeb) {
    return _buildInfoSection("Rental Period", [
      _responsiveRow(isWeb, "From Date", "March 7, 2026", "To Date", "March 14, 2026"),
      _buildDetailField("Duration", "7 days"),
    ]);
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)
          ),
          child: isMobile
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderText(id, subtitle),
              const SizedBox(height: 16),
              _buildStatusChip(status),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _buildHeaderText(id, subtitle)),
              const SizedBox(width: 10),
              _buildStatusChip(status),
            ],
          ),
        );
      },
    );
  }
  Widget _buildHeaderText(String id, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Invoice $id",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

   // Info Section
  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Your $title listed here", style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
  Widget _responsiveRow(bool isWeb, String l1, String v1, String l2, String v2) {
    return isWeb
        ? Row(children: [Expanded(child: _buildDetailField(l1, v1)), const SizedBox(width: 16), Expanded(child: _buildDetailField(l2, v2))])
        : Column(children: [_buildDetailField(l1, v1), _buildDetailField(l2, v2)]);
  }

   // Detail TextField
  Widget _buildDetailField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withOpacity(0.2))),
            child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isNarrow = constraints.maxWidth < 300;

          return isNarrow
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAmountText(amount),
              const SizedBox(height: 12),
              _buildStatusChip(status),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAmountText(amount),
              _buildStatusChip(status),
            ],
          );
        },
      ),
    );
  }
  Widget _buildAmountText(String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Total Amount", style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 4),
        Text(
            "AUD $amount",
            style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 18)
        ),
      ],
    );
  }

   // Status Chip
  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: _getStatusColor(status), borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}