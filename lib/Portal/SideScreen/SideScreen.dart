import 'package:car_rental_customerPanel/Portal/SideScreen/Extra%20Widgets/SidebarComponentWidget.dart';
import 'package:car_rental_customerPanel/Portal/SideScreen/Extra%20Widgets/TabAppBar.dart';
import 'package:car_rental_customerPanel/Portal/SideScreen/SideBarController.dart';
import 'package:car_rental_customerPanel/Resources/AppSizes.dart';
import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:car_rental_customerPanel/Resources/IconString.dart';
import 'package:car_rental_customerPanel/Resources/ImageString.dart';
import 'package:car_rental_customerPanel/Resources/TextTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'Extra Widgets/MobileAppbar.dart' show MobileTopBar;


class SidebarScreen extends StatelessWidget {
  final Function(String) onTap;
  final Widget? child;
  final bool hideMobileAppBar;

  SidebarScreen({
    super.key,
    required this.onTap,
    this.child,
    this.hideMobileAppBar = false,
  }) {
    Get.lazyPut<SideBarController>(() => SideBarController(), fenix: true);
  }

  final SideBarController controller = Get.find<SideBarController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppSizes.isMobile(context);
    final bool isTab = AppSizes.isTablet(context);
    final bool isWeb = AppSizes.isWeb(context);
    final double sidebarWidth = isWeb ? 240 : 180;

    final String currentRoute = GoRouterState.of(context).uri.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activeRoute = (currentRoute.isEmpty || currentRoute == '/')
          ? '/MyDetails'
          : currentRoute;
      controller.syncWithRoute(activeRoute);
    });

    /// Sidebar content
    Widget sidebarContent({bool showLogo = true}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLogo)
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: isMobile ? 40 : 25,
                bottom: AppSizes.verticalPadding(context) / 2,
                right: AppSizes.horizontalPadding(context),
              ),
              child: Row(
                children: [
                  Image.asset(IconString.logo, width: isMobile ? 30 : 36, height: isMobile ? 32 : 38),
                  SizedBox(width: AppSizes.horizontalPadding(context) / 2),
                  Text("Softsnip", style: TTextTheme.logoStyle(context)),
                ],
              ),
            ),
          SizedBox(height: AppSizes.verticalPadding(context) / 4),

          Padding(
            padding: EdgeInsets.only(bottom: AppSizes.verticalPadding(context) * 0.7),
            child: SidebarComponents.menuItem(
              context,
              controller,
              iconPath: IconString.myDetail,
              title: "MyDetails",
              route: '/MyDetails',
              onTap: (val) => context.go('/MyDetails'),
              scaffoldKey: _scaffoldKey,
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                SidebarComponents.expandableMenuItem(
                  context,
                  controller,
                  iconPath: IconString.paymentIcon,
                  title: "Payment",
                  route: '/payment',
                  subItems: [
                    {
                      'title': 'Payment Detail',
                      'route': '/payment/detail',
                      'icon': IconString.paymentDetailIcon,
                      'extra': {'hideMobileAppBar': true},
                    },
                  ],
                  scaffoldKey: _scaffoldKey,
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: AppSizes.verticalPadding(context) * 0.7),
            child: SidebarComponents.menuItem(
              context,
              controller,
              iconPath: IconString.logoutIcon,
              title: "Logout",
              route: '/login',
              onTap: (val) => context.go('/login'),
              scaffoldKey: _scaffoldKey,
            ),
          ),
        ],
      );
    }

    /// Sidebar Controlling
    if (isMobile || isTab) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        key: _scaffoldKey,
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: sidebarContent(showLogo: true),
        ),
        appBar: hideMobileAppBar ? null : AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.backgroundOfScreenColor,
          title: Obx(() {
            final String titleText = controller.selected.value.contains('payment')
                ? "Payment"
                : "My Details";

            return isMobile
                ? MobileTopBar(
              scaffoldKey: _scaffoldKey,
              profileImageUrl: ImageString.userImage,
              title: titleText,
            )
                : TabAppBar(
              scaffoldKey: _scaffoldKey,
              title: titleText,
            );
          }),
        ),
        body: SafeArea(child: child ?? const SizedBox.shrink()),
      );
    }
    else {
      return Scaffold(
        backgroundColor: AppColors.backgroundOfScreenColor,
        body: SafeArea(
          child: Row(
            children: [
              Container(
                width: sidebarWidth,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: sidebarContent(showLogo: true),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: child ?? const SizedBox.shrink()),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  /// -------- Extra Widget -------- ///
  // Sidebar
  static Widget wrapWithSidebarIfNeeded({
    required Widget child,
    bool hideMobileAppBar = false,
  }) {
    return SidebarScreen(
      onTap: (value) {},
      hideMobileAppBar: hideMobileAppBar,
      child: child,
    );
  }
}
