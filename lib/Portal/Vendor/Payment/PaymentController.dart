import 'package:get/get.dart';

class PaymentController extends GetxController {
  // Current selected tab index
  var paymentData = <Map<String, dynamic>>[].obs;
  var selectedTab = "Pending".obs;

  // Stats Data
  var totalInvoices = 8.obs;
  var totalPayments = 12345.99.obs;
  var pendingPaymentsCount = 5.obs;

  void changeTab(String tabName) {
    selectedTab.value = tabName;
  }

}