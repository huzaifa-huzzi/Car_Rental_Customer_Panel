import 'dart:io';
import 'package:car_rental_customerPanel/Resources/AppSizes.dart';
import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:car_rental_customerPanel/Resources/IconString.dart';
import 'package:car_rental_customerPanel/Resources/TextString.dart';
import 'package:car_rental_customerPanel/Resources/TextTheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:car_rental_customerPanel/Portal/Customer/MyDetails/MeDetailsController.dart';
import 'ReusableWidget/HeaderWebDetailWidget.dart' show HeaderWebDetailWidget;


class AddDetailsScreen extends StatelessWidget {
  const AddDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyDetailController());
    final isMobile = AppSizes.isMobile(context);
    final double spacing = AppSizes.padding(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOfScreenColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWebDetailWidget(
                mainTitle: TextString.myDetailsHeader,
                showBack: true,
                showSettings: true,
                showNotification: true,
                showProfile: true,
                onBackPressed: () {
                  if (Navigator.canPop(context)) {
                    context.go('/MyDetails');
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPadding(context),
                  vertical: 20,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(spacing),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Form(
                    key: MyDetailController.editCustomerFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(TextString.addDetailsTitle, style: TTextTheme.h1Style(context)),
                        const SizedBox(height: 4),
                        Text(TextString.addDetailsSubTitle, style: TTextTheme.titleThree(context)),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: AppColors.sideBoxesColor),
                        const SizedBox(height: 20),

                        _buildNoteBanner(context),
                        const SizedBox(height: 24),

                        _buildProfilePhotoPicker(context, controller),
                        const SizedBox(height: 24),

                        _buildBasicInfoGrid(context, controller),
                        const SizedBox(height: 24),
                        const Divider(height: 1, color: AppColors.sideBoxesColor),
                        const SizedBox(height: 24),

                        _buildLicenseGrid(context, controller),
                        const SizedBox(height: 24),
                        const Divider(height: 1, color: AppColors.sideBoxesColor),
                        const SizedBox(height: 24),

                        Text(TextString.uploadDocTitle, style: TTextTheme.h2Style(context).copyWith(fontSize: 16)),
                        const SizedBox(height: 16),
                        _documentsSection(context, controller),
                        const SizedBox(height: 24),

                        _buildButtonSection(context, controller, isMobile),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   /// --------------- Extra Widget -----------------///

   // Note Banner
  Widget _buildNoteBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TextString.noteTitle, style: TTextTheme.h1StylePrimary(context).copyWith(fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            TextString.addDetailsNoteText,
            style: TTextTheme.h1StylePrimary(context).copyWith(fontSize: 13, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

   // Profile Photo Picker
  Widget _buildProfilePhotoPicker(BuildContext context, MyDetailController controller) {
    return Obx(() {
      final hasImg = controller.profileImage2.value != null;

      return GestureDetector(
        onTap: () => controller.pickProfileImage2(),
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.3), width: 1),
          ),
          child: hasImg
              ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: kIsWeb
                ? Image.memory(controller.profileImage2.value!.bytes!, fit: BoxFit.cover)
                : Image.file(File(controller.profileImage2.value!.path!), fit: BoxFit.cover),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.backgroundOfPickupsWidget,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.upload_outlined, color: AppColors.primaryColor, size: 20),
              ),
              const SizedBox(height: 8),
              Text(TextString.photoText, style: TTextTheme.dropdowninsideText(context)),
              Text(TextString.supportedImageFormats, style: TTextTheme.bodySecondRegular10(context)),
            ],
          ),
        ),
      );
    });
  }

   // Basic Info Grid
  Widget _buildBasicInfoGrid(BuildContext context, MyDetailController controller) {
    return _buildResponsiveGrid(context, [
      _buildTextField(context, TextString.givenNameLabel, controller.givenNameController2, hint: TextString.givenNameHint),
      _buildTextField(context, TextString.surnameLabel, controller.surnameController2, hint: TextString.surnameHint),
      CompositedTransformTarget(
        link: controller.dobLink,
        child: _buildDOBField(
          context,
          TextString.dobLabel,
          controller.dobController2,
          onTap: () => controller.toggleCalendar(context, controller.dobLink, controller.dobController2),
        ),
      ),
      _buildPhoneField(context, TextString.contactNumLabel, controller),
      _buildTextField(context, TextString.emailLabel, controller.emailController2, hint: TextString.emailHint),
      _buildTextField(context, TextString.addressLabel, controller.addressController2, hint: TextString.addressHint),
    ]);
  }

   // License Grid
  Widget _buildLicenseGrid(BuildContext context, MyDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TextString.licenseDetailsTitle, style: TTextTheme.h2Style(context).copyWith(fontSize: 16)),
        const SizedBox(height: 16),
        _buildResponsiveGrid(context, [
          _buildTextField(context, TextString.licenseNameLabel, controller.licenseNameController2, hint: TextString.licenseNameHint),
          _buildTextField(context, TextString.licenseNumLabel, controller.licenseNumberController2, hint: TextString.licenseNumHint),
          CompositedTransformTarget(
            link: controller.expiryLink,
            child: _buildCalendarFieldGeneric(
              context,
              TextString.expiryDateLabel,
              controller.ccExpiryController2,
              onTap: () => controller.toggleCalendar(context, controller.expiryLink, controller.ccExpiryController2),
            ),
          ),
        ]),
        const SizedBox(height: 16),
        _buildTextField(context, TextString.cardNumberDetail, controller.licenseCardNumberController2, hint: TextString.cardNumHint),
      ],
    );
  }

   // Button Section
  Widget _buildButtonSection(BuildContext context, MyDetailController controller, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(color: AppColors.sideBoxesColor, thickness: 1),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            bool isSmall = constraints.maxWidth < 400;

            return Align(
              alignment: isMobile ? Alignment.center : Alignment.centerRight,
              child: Wrap(
                alignment: isMobile ? WrapAlignment.center : WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: isSmall ? double.infinity : null,
                    child: OutlinedButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        side: const BorderSide(color: AppColors.sideBoxesColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(TextString.cancelBtn, style: TTextTheme.btnTwo(context).copyWith(fontWeight: FontWeight.w600, color: AppColors.textColor)),
                    ),
                  ),
                  SizedBox(
                    width: isSmall ? double.infinity : null,
                    child: ElevatedButton.icon(
                      onPressed: () => controller.updateCustomerData(context),
                      icon: Image.asset(IconString.uploadIcon, color: Colors.white, width: 18),
                      label: Text(TextString.saveCustomerBtn, style: TTextTheme.loginButtonText(context)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

   // Responsive Grid
  Widget _buildResponsiveGrid(BuildContext context, List<Widget> children) {
    final isMobile = AppSizes.isMobile(context);
    final double spacing = AppSizes.padding(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;
        int columns = isMobile ? 1 : (totalWidth < 650 ? 2 : 3);
        final double itemWidth = (totalWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: 16,
          children: children.map((widget) => SizedBox(width: itemWidth, child: widget)).toList(),
        );
      },
    );
  }

   // TextField
  Widget _buildTextField(BuildContext context, String label, TextEditingController ctrl, {String hint = ""}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TTextTheme.dropdowninsideText(context)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(color: AppColors.secondaryColor, borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            controller: ctrl,
            cursorColor: AppColors.blackColor,
            style: TTextTheme.loginInsideTextField(context),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TTextTheme.titleThree(context),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

   // Calendar Field Generic
  Widget _buildCalendarFieldGeneric(BuildContext context, String label, TextEditingController textController, {required VoidCallback onTap, String hint = TextString.selectDateHint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TTextTheme.dropdowninsideText(context)),
        const SizedBox(height: 6),
        TextFormField(
          controller: textController,
          readOnly: true,
          onTap: onTap,
          style: TTextTheme.loginInsideTextField(context),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TTextTheme.titleThree(context),
            filled: true,
            fillColor: AppColors.secondaryColor,
            suffixIcon: const Icon(Icons.event, color: AppColors.quadrantalTextColor, size: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

   // Dob Field
  Widget _buildDOBField(BuildContext context, String label, TextEditingController textController, {required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TTextTheme.dropdowninsideText(context)),
        const SizedBox(height: 6),
        TextFormField(
          controller: textController,
          readOnly: true,
          onTap: onTap,
          style: TTextTheme.loginInsideTextField(context),
          decoration: InputDecoration(
            hintText: TextString.dobHint,
            hintStyle: TTextTheme.titleThree(context),
            filled: true,
            fillColor: AppColors.secondaryColor,
            suffixIcon: const Icon(Icons.event, color: AppColors.quadrantalTextColor, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

   // Phone Field
  Widget _buildPhoneField(BuildContext context, String label, MyDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TTextTheme.dropdowninsideText(context)),
        const SizedBox(height: 6),
        Obx(() {
          final rawList = controller.countryList.value;
          final List<Country> countryList = rawList.isNotEmpty ? rawList : countries;

          final Country selectedCountry = countryList.firstWhere(
                (c) => c.name.toLowerCase() == controller.selectedCountryName2.value.toLowerCase(),
            orElse: () => countryList.firstWhere(
                  (c) => c.name.toLowerCase() == "australia",
              orElse: () => countryList.first,
            ),
          );

          return TextFormField(
            controller: controller.phoneController2,
            keyboardType: TextInputType.phone,
            style: TTextTheme.loginInsideTextField(context),
            cursorColor: AppColors.blackColor,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.secondaryColor,
              hintText: TextString.phoneHint,
              hintStyle: TTextTheme.titleThree(context),
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8, right: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<Country>(
                        isExpanded: false,
                        value: selectedCountry,
                        selectedItemBuilder: (context) {
                          return countryList.map((Country country) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildCircleFlag(country.code),
                                const SizedBox(width: 6),
                                Text("+${country.dialCode}", style: TTextTheme.bodyRegular12black(context)),
                                const SizedBox(width: 2),
                              ],
                            );
                          }).toList();
                        },
                        items: countryList.map((Country country) {
                          return DropdownMenuItem<Country>(
                            value: country,
                            child: Row(
                              children: [
                                _buildCircleFlag(country.code),
                                const SizedBox(width: 8),
                                Expanded(child: Text(country.name, style: TTextTheme.bodyRegular12black(context), overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 8),
                                Text("+${country.dialCode}", style: TTextTheme.titleThree(context)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (Country? value) {
                          if (value != null) {
                            controller.selectedCountryName2.value = value.name;
                            controller.selectedCode2.value = "+${value.dialCode}";
                          }
                        },
                        buttonStyleData: const ButtonStyleData(height: 40, padding: EdgeInsets.zero),
                        iconStyleData: const IconStyleData(
                          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Colors.black54),
                          openMenuIcon: Icon(Icons.keyboard_arrow_up_rounded, size: 18, color: Colors.black54),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 280,
                          width: 240,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                          offset: const Offset(0, -4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(height: 20, width: 1, color: AppColors.sideBoxesColor),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCircleFlag(String code) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: Image.network(
          'https://flagcdn.com/w80/${code.toLowerCase()}.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.flag, size: 12),
        ),
      ),
    );
  }

   // Document Section
  Widget _documentsSection(BuildContext context, MyDetailController controller) {
    final isMobile = AppSizes.isMobile(context);
    final double spacing = AppSizes.padding(context);

    return Obx(() {
      final documentCount = controller.selectedDocuments2.length;
      List<Widget> documentWidgets = [];

      for (int i = 0; i < documentCount; i++) {
        documentWidgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _documentNameField(context, i, controller.documentNameControllers2[i]),
              const SizedBox(height: 8),
              _documentBox(context, controller, i, controller.selectedDocuments2[i]),
            ],
          ),
        );
      }

      if (documentCount < controller.maxDocuments2) {
        documentWidgets.add(_addDocumentBox(context, controller));
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          int columns = isMobile ? 1 : (totalWidth < 650 ? 2 : 3);
          final double itemWidth = (totalWidth - (spacing * (columns - 1))) / columns;

          return Wrap(
            spacing: spacing,
            runSpacing: 20,
            children: documentWidgets.map((widget) => SizedBox(width: itemWidth, child: widget)).toList(),
          );
        },
      );
    });
  }
  Widget _documentNameField(BuildContext context, int index, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TextString.documentLabel, style: TTextTheme.dropdowninsideText(context)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(color: AppColors.secondaryColor, borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            controller: ctrl,
            cursorColor: AppColors.blackColor,
            style: TTextTheme.loginInsideTextField(context),
            decoration: InputDecoration(
              hintText: TextString.documentNameHint,
              hintStyle: TTextTheme.titleThree(context),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
  Widget _documentBox(BuildContext context, MyDetailController controller, int index, Rx<DocumentHolder?> selectedDoc) {
    bool isImageFile(String fileName) {
      final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
      return imageExtensions.any((ext) => fileName.toLowerCase().endsWith(ext));
    }

    return Obx(() {
      final docValue = selectedDoc.value;
      final bool isUploaded = docValue != null;
      final bool isImage = isUploaded && isImageFile(docValue.name);

      ImageProvider? imageProvider;
      if (isImage) {
        if (kIsWeb && docValue.bytes != null) {
          imageProvider = MemoryImage(docValue.bytes!);
        } else if (!kIsWeb && docValue.path != null) {
          imageProvider = FileImage(File(docValue.path!));
        }
      }

      return GestureDetector(
        onTap: isUploaded ? null : () => controller.pickDocument2(index),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [8, 6],
              color: isUploaded ? AppColors.primaryColor : AppColors.tertiaryTextColor,
              strokeWidth: isUploaded ? 1.5 : 1,
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  image: isImage && imageProvider != null ? DecorationImage(image: imageProvider, fit: BoxFit.cover) : null,
                ),
                child: Center(
                  child: !isUploaded
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.backgroundOfPickupsWidget, borderRadius: BorderRadius.circular(12)),
                        child: Image.asset(IconString.uploadIcon, color: AppColors.primaryColor, width: 22),
                      ),
                      const SizedBox(height: 8),
                      Text(TextString.documentLabel, style: TTextTheme.dropdowninsideText(context)),
                      const SizedBox(height: 2),
                      Text(TextString.supportedImageFormats, style: TTextTheme.bodySecondRegular10(context)),
                    ],
                  )
                      : isImage
                      ? const SizedBox.shrink()
                      : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.insert_drive_file, size: 36, color: AppColors.primaryColor),
                        const SizedBox(height: 8),
                        Text(
                          docValue.name,
                          textAlign: TextAlign.center,
                          style: TTextTheme.dropdowninsideText(context).copyWith(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isUploaded)
              Positioned(
                top: -8,
                right: -8,
                child: GestureDetector(
                  onTap: () => controller.removeDocumentSlot2(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    child: Image.asset(IconString.deleteIcon, color: AppColors.primaryColor, width: 18),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
  Widget _addDocumentBox(BuildContext context, MyDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TextString.documentLabel, style: TTextTheme.dropdowninsideText(context)),
              const SizedBox(height: 6),
              const SizedBox(height: 42),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => controller.addDocumentSlot2(),
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            dashPattern: const [8, 6],
            color: AppColors.tertiaryTextColor,
            strokeWidth: 1,
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.backgroundOfPickupsWidget, borderRadius: BorderRadius.circular(12)),
                      child: Image.asset(IconString.addIcon, color: AppColors.primaryColor, width: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(TextString.addDocumentBtn, style: TTextTheme.dropdowninsideText(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}