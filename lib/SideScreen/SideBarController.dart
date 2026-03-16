import 'package:get/get.dart';

class SideBarController extends GetxController {
  var selected = "Payment".obs;
  var subSelected = "".obs;

  var expandedMenus = <String, bool>{}.obs;

  void toggleExpansion(String title) {
    expandedMenus[title] = !(expandedMenus[title] ?? false);
  }
  void selectMenu(String title) {
    selected.value = title;
  }
  void selectSubItem(String parent, String subTitle) {
    selected.value = parent;
    subSelected.value = subTitle;
    expandedMenus[parent] = true;
  }
  void syncWithRoute(String route) {
    final String path = route.toLowerCase();

    if (path.contains('/payment')) {
      selected.value = "Payment";

      if (path.contains('detail')) {
        subSelected.value = "Payment Detail";
        expandedMenus["Payment"] = true;
      } else {
        subSelected.value = "";
      }
    }
    else if (path.contains('/login')) {
      selected.value = "Logout";
      subSelected.value = "";
      expandedMenus.clear();
    }
    else if (path.contains('/dashboard')) {
      selected.value = "Dashboard";
      subSelected.value = "";
    }
  }
  void logout() {
    selected.value = "Logout";
    subSelected.value = "";
    expandedMenus.clear();
  }
}