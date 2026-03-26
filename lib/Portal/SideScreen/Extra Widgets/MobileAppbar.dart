import 'package:car_rental_customerPanel/Resources/AppSizes.dart';
import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:car_rental_customerPanel/Resources/IconString.dart';
import 'package:car_rental_customerPanel/Resources/TextTheme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileTopBar extends StatelessWidget {
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onSettingsPressed;
  final String profileImageUrl;
  final String userName;
  final String userRole;
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MobileTopBar({
    super.key,
    this.onNotificationPressed,
    this.onSettingsPressed,
    required this.profileImageUrl,
    required this.scaffoldKey,
    this.userName = "Alina Thompson",
    this.userRole = "User",
    this.title = "Payment",
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallMobile = screenWidth < 380;
    final String currentPath = GoRouterState.of(context).uri.toString();
    final bool showBack = currentPath.startsWith('/payment/detail') ||
        currentPath.startsWith('/payment/invoices');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding(context)),
      height: 60,
      color: AppColors.backgroundOfScreenColor,
      child: Row(
        children: [
          /// LEFT SIDE: Back Button or Hamburger
          GestureDetector(
            onTap: () {
              if (showBack) {
                context.pop();
              } else {
                scaffoldKey.currentState?.openDrawer();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)
                ],
              ),
              child: Image.asset(
                showBack ? IconString.backScreenIcon : IconString.hamBurger,
                height: 16,
                width: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: TTextTheme.h1Style(context),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),

          /// RIGHT SIDE: Icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTopBarButton(
                icon: IconString.settingIcon,
                onTap: onSettingsPressed,
              ),
              const SizedBox(width: 8),
              _buildNotificationButton(onNotificationPressed),

              if (!isSmallMobile) ...[
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName, style: TTextTheme.bodyRegular12black(context)),
                    Text(userRole, style: TTextTheme.medium14(context)),
                  ],
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  /// --------- Extra Widgets ----------- ///
  Widget _buildTopBarButton({required String icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(icon, width: 20, height: 20),
      ),
    );
  }

  Widget _buildNotificationButton(VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset(IconString.notificationIcon, width: 20, height: 20),
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}