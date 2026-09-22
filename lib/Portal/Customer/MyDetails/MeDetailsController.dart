import 'package:car_rental_customerPanel/Portal/Customer/MyDetails/ReusableWidget/CustomCalendarDetails.dart';
import 'package:car_rental_customerPanel/Portal/Customer/Payment/PaymentController.dart';
import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:car_rental_customerPanel/Resources/ImageString.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
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

class ImageHolder {
  final Uint8List? bytes;
  final String? path;
  final String name;
  ImageHolder({this.bytes, this.path, required this.name});
}


class MyDetailController extends GetxController {
  static final editCustomerFormKey = GlobalKey<FormState>();
  final customerFormKey = GlobalKey<FormState>();

  /// ---------------- STATE CONTROL VARIABLES ---------------- ///
  RxBool isSubmitted = false.obs;
  RxBool isApproved = false.obs;
  RxString adminNote = "".obs;

  /// ---------------- USER CREDENTIALS ---------------- ///
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoadingCountries = false.obs;
  var countryList = <Country>[].obs;
  TextEditingController searchController = TextEditingController();

  var selectedCountryName2 = 'Australia'.obs;
  var selectedCode2 = '+61'.obs;
  final LayerLink expiryLink = LayerLink();
  final licenseExpiryController = TextEditingController();

  /// ---------------- PROFILE PHOTO PICKER ---------------- ///
  Rxn<ImageHolder> profileImage2 = Rxn<ImageHolder>();
  RxBool imageError2 = false.obs;

  Future<void> pickProfileImage2() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );
    if (result != null) {
      final file = result.files.first;
      profileImage2.value = ImageHolder(
        bytes: kIsWeb ? file.bytes : null,
        path: kIsWeb ? null : file.path,
        name: file.name,
      );
      imageError2.value = false;
    }
  }

  bool validateProfileImage2() {
    if (profileImage2.value == null) {
      imageError2.value = true;
      return false;
    }
    imageError2.value = false;
    return true;
  }

  /// ---------------- BASIC FORM CONTROLLERS (INITIALIZED EMPTY) ---------------- ///
  final givenNameController2 = TextEditingController();
  final surnameController2 = TextEditingController();
  final dobController2 = TextEditingController();
  final phoneController2 = TextEditingController();
  final emailController2 = TextEditingController();
  final addressController2 = TextEditingController();
  final noteController2 = TextEditingController();
  final nidController2 = TextEditingController();

  RxString selectedFlag2 = "🇦🇺".obs;

  /// ---------------- LICENSE CONTROLLERS (INITIALIZED EMPTY) ---------------- ///
  final licenseNameController2 = TextEditingController();
  final licenseNumberController2 = TextEditingController();
  final licenseCardNumberController2 = TextEditingController();
  final ccExpiryController2 = TextEditingController();
  final dobController = TextEditingController();
  final LayerLink dobLink = LayerLink();
  var isDateDropOpen = false.obs;

  OverlayEntry? calendarOverlay;

  void toggleCalendar(
      BuildContext context,
      LayerLink link,
      TextEditingController targetController, {
        bool isYearOnly = false,
      }) {
    if (calendarOverlay != null) {
      removeCalendar();
    } else {
      calendarOverlay = _createCalendarOverlay(context, link, targetController);
      Overlay.of(context).insert(calendarOverlay!);
      isDateDropOpen.value = true;
    }
  }

  void removeCalendar() {
    calendarOverlay?.remove();
    calendarOverlay = null;
    isDateDropOpen.value = false;
  }

  OverlayEntry _createCalendarOverlay(
      BuildContext context,
      LayerLink link,
      TextEditingController targetController,
      ) {
    final screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 600;
    double overlayWidth = screenSize.width < 400 ? screenSize.width * 0.9 : 300;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: removeCalendar,
              behavior: HitTestBehavior.opaque,
              child: Container(color: AppColors.sideBoxesColor.withValues(alpha: 0.05)),
            ),
          ),
          isMobile
              ? Center(
            child: Material(
              elevation: 20,
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: overlayWidth,
                child: _buildCalendarContent(overlayWidth, targetController),
              ),
            ),
          )
              : CompositedTransformFollower(
            link: link,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: const Offset(0, 8),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: overlayWidth,
                child: _buildCalendarContent(overlayWidth, targetController),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarContent(double width, TextEditingController targetController) {
    return CustomCalendarDetail(
      width: width,
      onCancel: () => removeCalendar(),
      onDateSelected: (date) {
        targetController.text = "${date.day}/${date.month}/${date.year}";
        removeCalendar();
      },
    );
  }

  /// ---------------- DYNAMIC DOCUMENTS MANAGEMENT ---------------- ///
  RxList<Rx<DocumentHolder?>> selectedDocuments2 = <Rx<DocumentHolder?>>[].obs;
  RxList<TextEditingController> documentNameControllers2 = <TextEditingController>[].obs;
  final int maxDocuments2 = 6;

  void addDocumentSlot2() {
    if (selectedDocuments2.length < maxDocuments2) {
      documentNameControllers2.add(TextEditingController());
      selectedDocuments2.add(Rx<DocumentHolder?>(null));
    } else {
      Get.snackbar(
        "Limit Reached",
        "Maximum $maxDocuments2 documents allowed.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeDocumentSlot2(int index) {
    if (index >= 0 && index < selectedDocuments2.length) {
      documentNameControllers2[index].dispose();
      documentNameControllers2.removeAt(index);
      selectedDocuments2.removeAt(index);
    }
  }

  Future<void> pickDocument2(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      withData: kIsWeb,
    );
    if (result != null) {
      final file = result.files.first;
      selectedDocuments2[index].value = DocumentHolder(
        bytes: kIsWeb ? file.bytes : null,
        path: kIsWeb ? null : file.path,
        name: file.name,
      );
    }
  }

  /// ---------------- DOCUMENTS LIST (DYNAMICALLY POPULATED) ---------------- ///
  RxList<Map<String, dynamic>> documentsList = <Map<String, dynamic>>[].obs;

  void handleDynamicView(BuildContext context, Map<String, dynamic> doc) {
    final DocumentHolder? holder = doc["holder"] as DocumentHolder?;
    final String title = doc["title"] ?? "Document Viewer";
    String pdfPath = holder?.path ?? "assets/pdf/carRentalAgreement.pdf";

    if (pdfPath.startsWith('/')) pdfPath = pdfPath.substring(1);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GovIdPdfViewer(assetPath: pdfPath, title: title),
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
      backgroundColor: Colors.black,
      colorText: Colors.white,
    );
  }

  /// ---------------- SUBMISSION DIALOGS FLOW ---------------- ///
  void updateCustomerData(BuildContext context) {
    showSubmitConfirmationDialog(context);
  }

  void showSubmitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 440),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 16, color: Colors.black),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7D6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text('🤨', style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Submit Information",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Are you sure you want to submit it once you submit it you are able to edit it for one time only",
                          style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _syncUploadedDocuments();
                        isSubmitted.value = true;
                        showSuccessSubmissionDialog(context);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Request Edit',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSuccessSubmissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 440),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 16, color: Colors.black),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text('🎉', style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Information Submitted Successfully",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Your information has successfully submitted and sent to the admin",
                          style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                      child: const Text(
                        'Request Edit',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _syncUploadedDocuments() {
    List<Map<String, dynamic>> updated = [];
    for (int i = 0; i < selectedDocuments2.length; i++) {
      final doc = selectedDocuments2[i].value;
      final title = documentNameControllers2[i].text.trim().isNotEmpty
          ? documentNameControllers2[i].text.trim()
          : "Document ${i + 1}";
      if (doc != null) {
        updated.add({"title": title, "status": "Uploaded", "holder": doc});
      }
    }
    documentsList.value = updated;
  }

  String? validateRequired2(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return "$fieldName is required";
    return null;
  }

  @override
  void onClose() {
    userNameController.dispose();
    passwordController.dispose();
    givenNameController2.dispose();
    surnameController2.dispose();
    dobController2.dispose();
    phoneController2.dispose();
    emailController2.dispose();
    addressController2.dispose();
    noteController2.dispose();
    nidController2.dispose();
    licenseNameController2.dispose();
    licenseNumberController2.dispose();
    licenseCardNumberController2.dispose();
    ccExpiryController2.dispose();
    licenseExpiryController.dispose();
    searchController.dispose();
    dobController.dispose();

    for (var ctrl in documentNameControllers2) {
      ctrl.dispose();
    }
    super.onClose();
  }
}