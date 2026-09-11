import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:car_rental_customerPanel/Resources/ImageString.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'GovIdPdfViewer.dart';

class DocumentHolder {
  final Uint8List? bytes;
  final String? path;
  final String name;

  DocumentHolder({
    this.bytes,
    this.path,
    required this.name,
  });
}

class MyDetailController extends GetxController {
  final userNameController = TextEditingController(text: "johndoe_vendor");
  final passwordController = TextEditingController(text: "Pass@12345");
  RxList<Map<String, dynamic>> documentsList = <Map<String, dynamic>>[
    {
      "title": "Car Rental Agreement",
      "status": "PDF Document",
      "holder": DocumentHolder(
        path: ImageString.registrationForm,
        name: 'carRentalAgreement.pdf',
      ),
    },
    {
      "title": "Government ID",
      "status": "PDF Document",
      "holder": DocumentHolder(
        path: ImageString.registrationForm,
        name: 'Gov_ID.png',
      ),
    },
    {
      "title": "Tax Identification",
      "status": "File Attachment",
      "holder": DocumentHolder(
        path: ImageString.registrationForm,
        name: 'Tax_ID.png',
      ),
    },
  ].obs;

  void handleDynamicView(BuildContext context, Map<String, dynamic> doc) {
    final DocumentHolder? holder = doc["holder"] as DocumentHolder?;
    final String title = doc["title"] ?? "Document Viewer";
    String pdfPath = holder?.path ?? ImageString.carRentalAgreement;
    if (pdfPath.startsWith('/')) {
      pdfPath = pdfPath.substring(1);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GovIdPdfViewer(
          assetPath: pdfPath,
          title: title,
        ),
      ),
    );
  }
  void handleDynamicDownload(Map<String, dynamic> doc) {
    final DocumentHolder? holder = doc["holder"] as DocumentHolder?;
    final String fileName = holder?.name ?? doc["title"] ?? "Document";

    Get.snackbar(
      "Downloading",
      "Downloading $fileName...",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.blackColor,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    userNameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}