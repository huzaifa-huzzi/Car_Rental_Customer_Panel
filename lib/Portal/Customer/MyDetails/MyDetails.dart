import 'package:car_rental_customerPanel/Portal/Customer/MyDetails/MeDetailsController.dart';
import 'package:car_rental_customerPanel/Portal/Customer/MyDetails/ReusableWidget/HeaderWebDetailWidget.dart';
import 'package:car_rental_customerPanel/Resources/AppSizes.dart';
import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:car_rental_customerPanel/Resources/IconString.dart';
import 'package:car_rental_customerPanel/Resources/ImageString.dart';
import 'package:car_rental_customerPanel/Resources/TextString.dart';
import 'package:car_rental_customerPanel/Resources/TextTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';


class MyDetails extends StatelessWidget {
  const MyDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyDetailController());

    return Scaffold(
      backgroundColor: AppColors.backgroundOfScreenColor,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWebDetailWidget(
              mainTitle: TextString.myDetailsHeader,
              showBack: true,
              showSettings: true,
              showNotification: true,
              showProfile: true,
              onBackPressed: () {
                if (Navigator.canPop(context)) {
                  context.pop();
                } else {
                  context.go('/customers');
                }
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPadding(context),
                  vertical: 20,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeaderSection(context),
                      const SizedBox(height: 30),
                      _buildPersonalInfoSection(context),
                      const SizedBox(height: 30),
                      _buildCustomerNoteSection(context),
                      const SizedBox(height: 30),
                      _buildLicenseDetailsSection(context),
                      const SizedBox(height: 30),
                      _buildDocumentsSection(context, controller),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// --------- Extra Widget ------------- ///

  // Profile Header Section
  Widget _buildProfileHeaderSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isCompact = constraints.maxWidth < 600;

        Widget profileImage = Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryColor, width: 1),
            image: const DecorationImage(
              image: AssetImage(ImageString.userImage),
              fit: BoxFit.cover,
            ),
          ),
        );

        Widget userDetails = Column(
          crossAxisAlignment: isCompact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              TextString.name,
              style: TTextTheme.h1Style(context).copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              TextString.jobTitle,
              style: TTextTheme.titleDriver(context).copyWith(
                color: AppColors.quadrantalTextColor,
              ),
            ),
          ],
        );

        Widget editButton = OutlinedButton.icon(
          onPressed: () {
            context.go('/editCustomers', extra: {"hideMobileAppBar": true});
          },
          icon: Image.asset(IconString.editIcon, height: 16, width: 16),
          label: Text(TextString.editBtn, style: TTextTheme.btnTwo(context)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            side: BorderSide(color: AppColors.sideBoxesColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        if (isCompact) {
          return Column(
            children: [
              Align(alignment: Alignment.centerRight, child: editButton),
              const SizedBox(height: 10),
              profileImage,
              const SizedBox(height: 15),
              userDetails,
            ],
          );
        }

        return Row(
          children: [
            profileImage,
            const SizedBox(width: 24),
            Expanded(child: userDetails),
            editButton,
          ],
        );
      },
    );
  }

  // Personal Info Section
  Widget _buildPersonalInfoSection(BuildContext context) {
    return _buildBorderedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TextString.personalTitle, style: TTextTheme.titleSix(context)),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;
              int columns = 5;

              if (width < 600) {
                columns = 1;
              } else if (width < 900) {
                columns = 2;
              } else if (width < 1200) {
                columns = 3;
              }

              const double spacing = 16.0;
              final double itemWidth = (width - (spacing * (columns - 1))) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: 20,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _responsiveInfoItem(context, IconString.sms, TextString.emailLabel, TextString.emailVal),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _responsiveInfoItem(context, IconString.call, TextString.contactNumLabel, TextString.contactNumVal),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _responsiveInfoItem(context, IconString.location, TextString.addressLabel, TextString.addressVal),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _responsiveInfoItem(context, IconString.birthIcon, TextString.dobLabel, TextString.dobVal),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _responsiveInfoItem(context, IconString.nidIcon, TextString.nidLabel, TextString.nidVal),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // Customer Note Section
  Widget _buildCustomerNoteSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TextString.customerNoteTitle, style: TTextTheme.titleSix(context)),
        const SizedBox(height: 10),
        Text(
          TextString.customerNoteSubtitleDetail,
          style: TTextTheme.pOne(context).copyWith(
            color: AppColors.quadrantalTextColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // License Detail Section
  Widget _buildLicenseDetailsSection(BuildContext context) {
    return _buildBorderedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TextString.licenseDetailScreen, style: TTextTheme.titleSix(context)),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;
              int columns = 4;

              if (width < 550) {
                columns = 1;
              } else if (width < 900) {
                columns = 2;
              }

              const double spacing = 16.0;
              final double itemWidth = (width - (spacing * (columns - 1))) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: 20,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _responsiveInfoItem(context, IconString.licenseName, TextString.licenseNameLabel, TextString.licenseNameVal),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _responsiveInfoItem(context, IconString.licenseNo, TextString.licenseNumLabel, TextString.licenseNumVal),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _responsiveInfoItem(context, IconString.licenseCard, TextString.cardNumberDetail, TextString.cardNumVal),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _responsiveInfoItem(context, IconString.expiryDate, TextString.expiryDateLabel, TextString.expiryDateVal),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // Document Section
  Widget _buildDocumentsSection(BuildContext context, MyDetailController controller) {
    return _buildBorderedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextString.customerDocumentDetails,
            style: TTextTheme.titleSix(context).copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: AppColors.quadrantalTextColor,
            ),
          ),
          const SizedBox(height: 20),
          Obx(() {
            final List<Map<String, dynamic>> docs = controller.documentsList.value;

            return LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                int columns = 3;

                if (width < 600) {
                  columns = 1;
                } else if (width < 950) {
                  columns = 2;
                }

                const double spacing = 16.0;
                final double itemWidth = (width - (spacing * (columns - 1))) / columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: 16,
                  children: docs.map((doc) {
                    final String title = (doc["title"] ?? "Unknown") as String;
                    final String status = (doc["status"] ?? "FILE") as String;

                    return SizedBox(
                      width: itemWidth,
                      child: _documentCardBox(
                        context,
                        title,
                        status,
                        onView: () => controller.handleDynamicView(context, doc),
                      ),
                    );
                  }).toList(),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // DocumentBox
  Widget _documentCardBox(
      BuildContext context,
      String label,
      String status, {
        required VoidCallback onView,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.insert_drive_file_outlined,
            size: 20,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TTextTheme.titleFour(context).copyWith(
                  color: AppColors.tertiaryTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      status,
                      style: TTextTheme.titleseven(context).copyWith(
                        color: AppColors.quadrantalTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: onView,
                    borderRadius: BorderRadius.circular(12),
                    child: const Icon(
                      Icons.remove_red_eye_outlined,
                      size: 18,
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Bordered Container
  Widget _buildBorderedContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.sideBoxesColor, width: 1),
      ),
      child: child,
    );
  }

  // Responsive Info Item
  Widget _responsiveInfoItem(BuildContext context, String iconPath, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            iconPath,
            width: 20,
            height: 20,
            color: AppColors.blackColor,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.info_outline, size: 20),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TTextTheme.titleFour(context).copyWith(
                  color: AppColors.quadrantalTextColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TTextTheme.titleseven(context).copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
