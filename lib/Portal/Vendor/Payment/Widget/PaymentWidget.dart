import 'package:car_rental_customerPanel/Portal/Vendor/Payment/PaymentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentWidget extends StatefulWidget {
  const PaymentWidget({super.key});

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  final PaymentController controller = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    // Note: Yahan koi Expanded ya flexible nahi lagana kyunki parent (PaymentScreen) mein SingleChildScrollView hai
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Yeh zaroori hai
      children: [
        // 1. Top Stats Cards
        _buildStatsGrid(context),
        const SizedBox(height: 30),

        // 2. Main Container for Table
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("All Payments", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A202C))),
              const SizedBox(height: 4),
              Text("List of all payments", style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
              const SizedBox(height: 25),

              _buildTabs(),
              const SizedBox(height: 30),

              // Horizontal Scroll sirf Table ke liye
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // Web par sidebar ki jagah chor kar width set karein
                    minWidth: MediaQuery.of(context).size.width > 1200 ? MediaQuery.of(context).size.width - 350 : 1000,
                  ),
                  child: Column(
                    children: [
                      _buildTableHeader(),
                      const SizedBox(height: 10),
                      // Obx sirf rows ke liye taake pura table rebuild na ho
                      Obx(() => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: controller.paymentData.isEmpty
                            ? [const Padding(padding: EdgeInsets.all(20), child: Text("No Data Found"))]
                            : controller.paymentData.map((data) => _buildPaymentRow(data)).toList(),
                      )),
                      const SizedBox(height: 20),
                      _buildPagination(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Grid Fix: Isko shrinkWrap aur NeverScrollablePhysics lazmi dena hai
  Widget _buildStatsGrid(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = constraints.maxWidth > 850 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
      double aspectRatio = constraints.maxWidth > 850 ? 2.0 : 2.4;

      return GridView.count(
        shrinkWrap: true, // Zaroori hai
        physics: const NeverScrollableScrollPhysics(), // Zaroori hai taake SingleChildScrollView control kare
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: aspectRatio,
        children: [
          _statCard("Total Invoices", "8", "3 more invoices generated", Icons.description_outlined),
          _statCard("Total payments", "\$ 12345.99", "3 more payment completed", Icons.account_balance_wallet_outlined),
          _statCard("Recent payment", "\$ 1245", "paid last week", Icons.payment_outlined),
          _statCard("Pending payment", "5", "5 more payment left", Icons.timer_outlined),
          _statCard("Over due", "4", "4 payment date passed", Icons.error_outline),
          _statCard("Processing", "4", "5 payments are in processing phase", Icons.sync),
          _statCard("Resubmit", "4", "4 payments require resubmission", Icons.cached),
          _statCard("Completed", "5", "5 payments has approved", Icons.check_circle_outline),
        ],
      );
    });
  }

  Widget _statCard(String title, String value, String sub, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFFF4F7F9), borderRadius: BorderRadius.circular(6)),
                child: Icon(icon, size: 16, color: const Color(0xFF718096)),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: const TextStyle(color: Color(0xFF718096), fontSize: 11, fontWeight: FontWeight.w500))),
            ],
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 9)),
        ],
      ),
    );
  }

  // --- 2. Custom Tabs ---
  Widget _buildTabs() {
    List<String> tabs = ["Pending", "Overdue", "Processing", "Resubmit", "Completed"];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Obx(() => Row(
        mainAxisSize: MainAxisSize.min,
        children: tabs.map((tab) {
          bool isSelected = controller.selectedTab.value == tab;
          return GestureDetector(
            onTap: () => controller.changeTab(tab),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF3B4E) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(tab,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade500,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      )),
    );
  }

  // --- 3. Custom Table Header ---
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _headerCell("Invoice Id", 1),
          _headerCell("Duration", 2),
          _headerCell("Car Name", 2),
          _headerCell("Amount", 1),
          _headerCell("Status", 1),
          _headerCell("Action", 1, isCenter: true),
        ],
      ),
    );
  }

  Widget _headerCell(String text, int flex, {bool isCenter = false}) {
    return Expanded(
      flex: flex,
      child: Row(
        mainAxisAlignment: isCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Text(text, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF64748B))),
          if (!isCenter) const Icon(Icons.unfold_more, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  // --- 4. Custom Table Row (Ditto Card Look) ---
  Widget _buildPaymentRow(Map data) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4)],
      ),
      child: Row(
        children: [
          Expanded(child: Text(data["id"], style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text(data["duration"], style: const TextStyle(color: Colors.grey))),
          Expanded(flex: 2, child: Text(data["car"])),
          Expanded(child: Text("\$${data["amount"]}", style: const TextStyle(color: Color(0xFFFF3B4E), fontWeight: FontWeight.bold))),
          Expanded(child: _statusChip(data["status"])),
          Expanded(
            child: Center(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.file_upload_outlined, size: 14),
                label: const Text("Upload", style: TextStyle(fontSize: 11)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF3B4E),
                  side: const BorderSide(color: Color(0xFFFF3B4E)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    return UnconstrainedBox(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFD4C100),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- 5. Pagination ---
  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text("Results per page  ", style: TextStyle(color: Colors.grey, fontSize: 12)),
            _dropdownBox("5"),
          ],
        ),
        Row(
          children: [
            _pageNavButton("< Prev", false),
            const SizedBox(width: 8),
            _pageNumber("1", true),
            _pageNumber("2", false),
            _pageNumber("3", false),
            _pageNavButton("Next >", true),
          ],
        ),
      ],
    );
  }

  Widget _dropdownBox(String val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(6)),
      child: Row(children: [Text(val, style: const TextStyle(fontSize: 12)), const Icon(Icons.keyboard_arrow_down, size: 16)]),
    );
  }

  Widget _pageNumber(String n, bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: active ? const Color(0xFFFF3B4E) : Colors.transparent, borderRadius: BorderRadius.circular(6)),
      child: Text(n, style: TextStyle(color: active ? Colors.white : Colors.grey, fontSize: 12)),
    );
  }

  Widget _pageNavButton(String text, bool enabled) {
    return Text(text, style: TextStyle(color: enabled ? Colors.black : Colors.grey, fontSize: 12));
  }
}