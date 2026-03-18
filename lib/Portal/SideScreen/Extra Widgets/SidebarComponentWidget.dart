import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:car_rental_customerPanel/Resources/TextTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../SideBarController.dart' show SideBarController;

class SidebarComponents {
  /// Helper: Close drawer for  mobile
  static void closeDrawerIfMobile(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
  }


  /// Menu item
  static Widget menuItem(
      BuildContext context,
      SideBarController controller, {
        required String iconPath,
        required String title,
        Widget? trailing,
        bool? isSelected,
        required Function(String) onTap,
        required GlobalKey<ScaffoldState> scaffoldKey,
      }) {

    Widget buildItemContent(bool active) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.secondaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 20,
              height: 20,
              color: active ? AppColors.primaryColor : AppColors.tertiaryTextColor,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: active ? TTextTheme.medium14black(context)   : TTextTheme.medium14tertiaryColor(context)
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      );
    }

    return InkWell(
      onTap: () {
        controller.selectMenu(title);
        onTap(title);
        closeDrawerIfMobile(context, scaffoldKey);
      },
      child: isSelected != null
          ? buildItemContent(isSelected)
          : Obx(() => buildItemContent(controller.selected.value == title)),
    );
  }

   /// Expandable Menu Item
  static Widget expandableMenuItem(
      BuildContext context,
      SideBarController controller, {
        required String iconPath,
        required String title,
        required String route,
        required List<Map<String, dynamic>> subItems,
        required GlobalKey<ScaffoldState> scaffoldKey,
        Map<String, dynamic>? extra,
      }) {
    return Obx(() {
      bool isExpanded = controller.expandedMenus[title] ?? false;
      bool isMainActive = controller.selected.value == title;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              controller.selectMenu(title);
              context.go(route, extra: extra);
              closeDrawerIfMobile(context, scaffoldKey);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isMainActive ? AppColors.secondaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Image.asset(
                    iconPath,
                    width: 20,
                    height: 20,
                    color: isMainActive ? AppColors.primaryColor : AppColors.tertiaryTextColor,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: (isMainActive
                          ? TTextTheme.medium14black(context)
                          : TTextTheme.medium14tertiaryColor(context)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.toggleExpansion(title),
                    child: Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: AppColors.tertiaryTextColor,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            ...subItems.map((sub) {
              bool isSubSelected = controller.subSelected.value == sub['title'];

              return Padding(
                padding: const EdgeInsets.only(left: 20),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 1.5,
                            color: AppColors.tertiaryTextColor.withOpacity(0.3),
                          ),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.selectSubItem(title, sub['title']!);
                            context.go(sub['route']!, extra: sub['extra']);
                            closeDrawerIfMobile(context, scaffoldKey);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 14, top: 6, bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primaryColor, width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                              color: isSubSelected ? Colors.white : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  sub['icon'] ?? iconPath,
                                  width: 18,
                                  height: 18,
                                  color: AppColors.primaryColor ,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  sub['title']!,
                                  style: TTextTheme.medium14black(context)
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      );
    });
  }
}