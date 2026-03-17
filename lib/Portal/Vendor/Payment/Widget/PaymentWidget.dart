import 'package:car_rental_customerPanel/Portal/Vendor/Payment/PaymentController.dart';
import 'package:car_rental_customerPanel/Portal/Vendor/Payment/ReusableWidget/PaginationBarOfPayment.dart';
import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:car_rental_customerPanel/Resources/IconString.dart';
import 'package:car_rental_customerPanel/Resources/TextTheme.dart';
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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _buildStatsGrid(context),

          const SizedBox(height: 30),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                 // Headings
                 Text(
                  "All Payments",
                  style:TTextTheme.h2Style(context),
                ),
                const SizedBox(height: 4),
                Text(
                  "List of all payments",
                  style: TTextTheme.bodyRegular16(context),
                ),

                const SizedBox(height: 25),

                _buildTabs(),

                const SizedBox(height: 30),

                 // Table Area
                LayoutBuilder(
                  builder: (context, constraints) {

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: constraints.maxWidth < 1000
                            ? 1000
                            : constraints.maxWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: constraints.maxWidth < 1000 ? 1000 : constraints.maxWidth,
                                child: Column(
                                  children: [

                                    _buildTableHeader(controller),
                                    const SizedBox(height: 8),

                                    Obx(() {
                                      if (controller.displayedCarList.isEmpty) {
                                        return const SizedBox(
                                          height: 200,
                                          child: Center(child: Text("No Data Found")),
                                        );
                                      }

                                      return Column(
                                        children: controller.displayedCarList
                                            .map((data) => _buildPaymentRow(data))
                                            .toList(),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            _buildPagination(),
                          ],
                        )
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

   /// -------- Extra Widgets ------- ///

      // Cards
  Widget _buildStatsGrid(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = constraints.maxWidth > 850 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
      double aspectRatio;
      if (constraints.maxWidth > 850) {
        aspectRatio = 2.0;
      } else if (constraints.maxWidth > 400) {
        aspectRatio = 2.4;
      } else {
        aspectRatio = constraints.maxWidth / 130;
      }

      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: aspectRatio,
        children: [
          _statCard("Total Invoices", "8", "3 more invoices generated", IconString.invoicesIcon),
          _statCard("Total payments", "\$ 12345.99", "3 more payment completed", IconString.paymentIcon),
          _statCard("Recent payment", "\$ 1245", "paid last week", IconString.paymentIcon),
          _statCard("Pending payment", "5", "5 more payment left", IconString.pendingPaymentIcon),
          _statCard("Over due", "4", "4 payment date passed", IconString.overDueIcon),
          _statCard("Processing", "4", "5 payments are in processing phase", IconString.processingIcon),
          _statCard("Resubmit", "4", "4 payments require resubmission", IconString.resubmitIcon),
          _statCard("Completed", "5", "5 payments has approved", IconString.completedIcon),
        ],
      );
    });
  }
  Widget _statCard(String title, String value, String sub, String icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(6)),
                child: Image.asset(icon, height: 20,width: 20, ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TTextTheme.bodyRegular12(context),
                ),
              ),
            ],
          ),
          const Spacer(),

          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TTextTheme.h2Style(context)),

          const Spacer(),

          Text(sub,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TTextTheme.bodySecondRegular10(context)),
        ],
      ),
    );
  }


 // Tabs
  Widget _buildTabs() {
    List<String> tabs = [
      "Pending",
      "Overdue",
      "Processing",
      "Resubmit",
      "Completed"
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color:AppColors.signaturePadColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.sideBoxesColor.withOpacity(0.7),width: 1)
        ),
        child: Obx(() => Row(
          mainAxisSize: MainAxisSize.min,
          children: tabs.map((tab) {
            bool isSelected = controller.selectedTab.value == tab;

            return GestureDetector(
              onTap: () => controller.changeTab(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tab,
                  style: isSelected ? TTextTheme.medium14White(context) : TTextTheme.bodyRegular14tertiary(context),
                ),
              ),
            );
          }).toList(),
        )),
      ),
    );
  }


   // Table Widgets
  Widget _buildTableHeader(PaymentController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _headerCell("Invoice Id", controller, 3),
          _headerCell("Duration", controller, 3),
          _headerCell("Car Name", controller, 3),
          _headerCell("Amount", controller, 2),
          _headerCell("Status", controller, 2, isCenter: false, canSort: false),
          _headerCell("Action", controller, 2, isCenter: true, canSort: false),
        ],
      ),
    );
  }
  Widget _headerCell(String title, PaymentController controller, int flex, {bool isCenter = false, bool canSort = true}) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: canSort ? () => controller.toggleSort(title) : null,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            mainAxisAlignment: isCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: TTextTheme.medium14tableHeading(context),
                ),
              ),

              if (canSort) ...[
                const SizedBox(width: 4),
                Obx(() {
                  bool isCurrent = controller.sortColumn.value == title;
                  int order = isCurrent ? controller.sortOrder.value : 0;

                  return SizedBox(
                    width: 12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, 3),
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            size: 12,
                            color: order == 1 ? AppColors.primaryColor : AppColors.textColor,
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -3),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 12,
                            color: order == 2 ? AppColors.primaryColor : AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  );
                })
              ],
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPaymentRow(Map data) {
    String status = (data["status"] ?? "Pending").toLowerCase();
    bool isViewMode = status == 'completed' || status == 'processing';

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.backgroundOfTableContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.sideBoxesColor.withOpacity(0.7), width: 1),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(data["id"] ?? "", softWrap: false, style: TTextTheme.bodySemiBold14black(context))),
          Expanded(flex: 3, child: Text(data["duration"] ?? "", softWrap: false, style: TTextTheme.tableRegular14black(context))),
          Expanded(flex: 3, child: Text(data["car"] ?? "", maxLines: 1, overflow: TextOverflow.ellipsis, style: TTextTheme.tableRegular14black(context))),
          Expanded(
              flex: 1,
              child: Container(
                  constraints: const BoxConstraints(minWidth: 60),
                  child: Text("\$${data["amount"]}", softWrap: false, style: TTextTheme.bodySemiBold16(context))
              )
          ),
          Expanded(
            flex: 2,
            child: Center(child: _buildStatusChip(data["status"] ?? "Pending")),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: SizedBox(
                height: 32,
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (isViewMode) {
                    } else {
                    }
                  },
                  icon: isViewMode
                      ? const Icon(Icons.visibility_outlined, size: 16)
                      : Image.asset(IconString.uploadIcon, height: 16),

                  label: Text(
                    isViewMode ? "View" : "Upload",
                    style: TTextTheme.tableRegular14Primary(context),
                  ),

                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    side: const BorderSide(color: AppColors.primaryColor),
                    overlayColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStatusChip(String status) {
    Color backgroundColor;

    switch (status.toLowerCase()) {
      case 'overdue':
        backgroundColor = AppColors.overdueColor;
        break;
      case 'pending':
        backgroundColor = AppColors.pendingColor;
        break;
      case 'completed':
        backgroundColor = AppColors.completedColor;
        break;
      case 'resubmit':
        backgroundColor = AppColors.reviewColor;
        break;
      case 'processing':
        backgroundColor = AppColors.textColor;
        break;
      default:
        backgroundColor = AppColors.whiteColor;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: TTextTheme.bodySemiBold14White(context),
      ),
    );
  }

   // Pagination
  Widget _buildPagination() {

    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),

      child: PaginationBarOfPayment(
        isMobile: isMobile, tablePadding: 240,
      ),
    );
  }
}