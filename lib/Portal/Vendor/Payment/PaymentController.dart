import 'package:get/get.dart';

class PaymentController extends GetxController {
  final RxList<Map<String, dynamic>> baseData = <Map<String, dynamic>>[].obs;
  var selectedTab = "Pending".obs;
  final RxInt currentPage3 = 1.obs;
  final RxInt pageSize3 = 5.obs;

  @override
  void onInit() {
    super.onInit();
    baseData.assignAll([
      {"id": "IN-2026-004", "duration": "Mar 7, 2026 - Mar 14 2026", "car": "Mazda CX-5 (2017)", "amount": "245"},
      {"id": "IN-2026-004", "duration": "Mar 7, 2026 - Mar 14 2026", "car": "Mazda CX-5 (2017)", "amount": "245"},
      {"id": "IN-2026-004", "duration": "Mar 7, 2026 - Mar 14 2026", "car": "Mazda CX-5 (2017)", "amount": "245"},
    ]);
  }
  List<Map<String, dynamic>> get displayedCarList {
    return baseData.map((item) {
      var newItem = Map<String, dynamic>.from(item);
      newItem['status'] = selectedTab.value;
      return newItem;
    }).toList();
  }

  void changeTab(String tabName) {
    selectedTab.value = tabName;
    currentPage3.value = 1;
  }
  int get totalPages => 1;

  void goToPreviousPage() {}
  void goToNextPage() {}
  void goToPage(int page) {}
  void setPageSize(int newSize) {
    pageSize3.value = newSize;
  }

  /// Sorting
  var sortColumn = "".obs;
  var sortOrder = 0.obs;

  void toggleSort(String columnName) {
    if (sortColumn.value == columnName) {
      sortOrder.value = (sortOrder.value + 1) % 3;
      if (sortOrder.value == 0) sortColumn.value = "";
    } else {
      sortColumn.value = columnName;
      sortOrder.value = 1;
    }
  }

}