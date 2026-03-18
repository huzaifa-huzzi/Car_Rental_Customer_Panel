import 'package:car_rental_customerPanel/Resources/AppSizes.dart';
import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:car_rental_customerPanel/Resources/IconString.dart';
import 'package:car_rental_customerPanel/Resources/TextTheme.dart';
import 'package:flutter/material.dart';


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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding(context)),
      height: 60,
      color:AppColors.backgroundOfScreenColor,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => scaffoldKey.currentState?.openDrawer(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(IconString.hamBurger,height: 16,width: 16,),
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

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTopBarButton(
                icon: IconString.settingIcon,
                onTap: onSettingsPressed,
              ),
              const SizedBox(width: 8),
              _buildNotificationButton(onNotificationPressed),
              const SizedBox(width: 12),

              if (!isSmallMobile)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TTextTheme.bodyRegular12black(context),
                    ),
                    Text(
                      userRole,
                      style: TTextTheme.medium14(context),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// --------- Extra Widgets ------- ///

  // Settings Icon
  Widget _buildTopBarButton({required String icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(icon),
      ),
    );
  }
   // notification Icon
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
             Image.asset(IconString.notificationIcon),
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