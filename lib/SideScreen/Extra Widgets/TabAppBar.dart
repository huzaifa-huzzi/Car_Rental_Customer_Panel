import 'package:car_rental_customerPanel/Resources/AppSizes.dart';
import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:car_rental_customerPanel/Resources/IconString.dart';
import 'package:car_rental_customerPanel/Resources/ImageString.dart';
import 'package:car_rental_customerPanel/Resources/TextTheme.dart';
import 'package:flutter/material.dart';

class TabAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onSettingsPressed;
  final String userName;
  final String userRole;
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const TabAppBar({
    super.key,
    this.onNotificationPressed,
    this.onSettingsPressed,
    required this.scaffoldKey,
    this.userName = "Alina Thompson",
    this.userRole = "User",
    this.title = "Payment",
  });

  @override
  State<TabAppBar> createState() => _TabAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _TabAppBarState extends State<TabAppBar> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool showUserInfo = screenWidth > 450;

    return Container(
      decoration:  BoxDecoration(
        color:AppColors.backgroundOfScreenColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding(context)),
      child: SafeArea(
        child: Row(
          children: [
            GestureDetector(
              onTap: () => widget.scaffoldKey.currentState?.openDrawer(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child:  Image.asset(
                  IconString.hamBurger
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                widget.title,
                style: TTextTheme.h1Style(context),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIconContainer(
                  icon: IconString.settingIcon,
                  onTap: widget.onSettingsPressed,
                ),

                const SizedBox(width: 8),

                _buildNotificationIcon(),

                const SizedBox(width: 12),

                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                      image: AssetImage(ImageString.userImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (showUserInfo) ...[
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: TTextTheme.bodyRegular12black(context),
                      ),
                      Text(
                        widget.userRole,
                        style: TTextTheme.medium14(context),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// --------- Extra Widgets-------- ///

   // Settings Icon
  Widget _buildIconContainer({required String icon, VoidCallback? onTap}) {
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

   // NotificationIcon
  Widget _buildNotificationIcon() {
    return GestureDetector(
      onTap: widget.onNotificationPressed,
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
              right: -1,
              top: -1,
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