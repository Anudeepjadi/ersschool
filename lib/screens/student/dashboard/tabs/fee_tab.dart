import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/student_app_bar.dart';
import '../../../../widgets/scrollable_table_wrapper.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class FeeTab extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  final Function(int)? onTabSelected;

  FeeTab({super.key, this.onOpenDrawer, this.onTabSelected});

  @override
  State<FeeTab> createState() => _FeeTabState();
}

class _FeeTabState extends State<FeeTab> {
  int _activeSubTab = 0; // 0: Overview, 1: Fees Structure, 2: Transactions, 3: Receipts
  String _selectedAcademicYear = "2026 - 2027";

  // Dropdown options
  final List<String> _academicYears = ["2026 - 2027", "2025 - 2026", "2024 - 2025"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: StudentAppBar(
        title: "Fee Details",
        subtitle: "View and manage your fee payments",
        onOpenDrawer: widget.onOpenDrawer,
        onProfileTap: widget.onTabSelected != null ? () => widget.onTabSelected!(1) : null,
      ),
      body: Column(
        children: [
          _buildSubTabBar(),
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }


  Widget _buildSubTabBar() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              _buildTabItem(0, Icons.assignment, "Overview"),
              _buildTabItem(1, Icons.table_chart, "Fees Structure"),
              _buildTabItem(2, Icons.receipt_long, "Transactions"),
              _buildTabItem(3, Icons.text_snippet, "Receipts"),
            ],
          ),
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final bool isActive = _activeSubTab == index;
    final Color color = isActive ? AppColors.primary : Color(0xFF6B7280);
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _activeSubTab = index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            Icon(icon, color: color, size: 20),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),
            Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_activeSubTab) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildPlaceholderTab("Fees Structure");
      case 2:
        return _buildPlaceholderTab("Transactions");
      case 3:
        return _buildPlaceholderTab("Receipts");
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildPlaceholderTab(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_open, size: 48, color: Colors.grey.shade400),
          SizedBox(height: 12),
          Text(
            "$title Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
          ),
          SizedBox(height: 4),
          Text("This tab is under development.".tr,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTotalAnnualFeesCard(),
          SizedBox(height: 24),
          _buildFeeStatusSection(),
          SizedBox(height: 24),
          _buildQuickActionsSection(),
          SizedBox(height: 24),
          _buildRecentPaymentsSection(),
          SizedBox(height: 24),
          _buildImportantNotesCard(),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTotalAnnualFeesCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Annual Fees".tr,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text("₹ 45,000".tr,
                    style: TextStyle(
                      color: Color(0xFF1E2875),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              PopupMenuButton<String>(
                onSelected: (String value) {
                  setState(() {
                    _selectedAcademicYear = value;
                  });
                },
                offset: Offset(0, 30),
                itemBuilder: (BuildContext context) {
                  return _academicYears.map((String year) {
                    return PopupMenuItem<String>(
                      value: year,
                      child: Text(year, style: TextStyle(fontSize: 13)),
                    );
                  }).toList();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Academic Year".tr,
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 9,
                            ),
                          ),
                          Text(
                            _selectedAcademicYear,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.grey.shade600),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Divider(color: Colors.grey.shade100, height: 1),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem("Total Paid", "₹ 20,000", Color(0xFF10B981)),
              _buildSummaryItem("Due Amount", "₹ 25,000", Color(0xFFEF4444)),
              _buildSummaryItemWithIcon(
                "Due Date",
                "30 Jun 2026",
                Color(0xFFEA580C),
                Icons.calendar_today_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItemWithIcon(String label, String value, Color valueColor, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 4),
            Icon(icon, color: valueColor, size: 13),
          ],
        ),
      ],
    );
  }

  Widget _buildFeeStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Fee Status".tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Downloading Fee Statement...".tr)),
                );
              },
              child: Row(children: [
                  Icon(Icons.download, size: 14, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text("Download Statement".tr,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ScrollableTableWrapper(
          child: SizedBox(
            width: 550,
            child: Column(
              children: [
                // Fee table column headers
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(children: [
                      Expanded(
                        flex: 2,
                        child: Text("Particulars".tr,
                          style: TextStyle(fontSize: 10, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Due Date".tr,
                          style: TextStyle(fontSize: 10, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Amount (₹)".tr,
                          style: TextStyle(fontSize: 10, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Status".tr,
                          style: TextStyle(fontSize: 10, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 16), // space to match right chevron
                    ],
                  ),
                ),
                SizedBox(height: 6),
                // Items list
                _buildFeeItem("Tuition Fee", "Term 1", "30 Apr 2026", "15,000", true),
                _buildFeeItem("Tuition Fee", "Term 2", "30 Jun 2026", "15,000", true),
                _buildFeeItem("Tuition Fee", "Term 3", "30 Sep 2026", "15,000", false),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        // Totals and Pay Now Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Paid".tr,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w500),
                ),
                Text("₹ 20,000".tr,
                  style: TextStyle(color: Color(0xFF10B981), fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Due".tr,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w500),
                ),
                Text("₹ 25,000".tr,
                  style: TextStyle(color: Color(0xFFEF4444), fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(width: 8),
            // Pay Now Button
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Redirecting to payment gateway...".tr)),
                );
              },
              icon: Icon(Icons.payment, size: 14, color: Colors.white),
              label: Text("Pay Now".tr,
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeeItem(String title, String term, String dueDate, String amount, bool isPaid) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                ),
                Text(
                  term,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dueDate,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              amount,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                if (isPaid)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFFE6FDF4),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Color(0xFFBCF6E1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 8, color: Color(0xFF10B981)),
                        SizedBox(width: 2),
                        Text("Paid".tr,
                          style: TextStyle(fontSize: 8, color: Color(0xFF10B981), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                else
                  Text("Unpaid".tr,
                    style: TextStyle(fontSize: 11, color: Color(0xFFEA580C), fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 16, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Quick Actions".tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2875),
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickActionItem("Pay Fee", Icons.credit_card, Color(0xFFEEF2FF), Color(0xFF4F46E5)),
            _buildQuickActionItem("View Receipts", Icons.receipt, Color(0xFFF5F3FF), Color(0xFF7C3AED)),
            _buildQuickActionItem("Fee Structure", Icons.list_alt, Color(0xFFFFF7ED), Color(0xFFEA580C)),
            _buildQuickActionItem("Download Statement", Icons.download, Color(0xFFECFDF5), Color(0xFF059669)),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(String title, IconData icon, Color bgColor, Color iconColor) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Opening $title...")),
        );
      },
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF1E2875),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPaymentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Recent Payments".tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _activeSubTab = 2; // Switch to Transactions tab
                });
              },
              child: Text("View All".tr,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ScrollableTableWrapper(
          child: SizedBox(
            width: 600,
            child: Column(
              children: [
                _buildRecentPaymentItem("Tuition Fee - Term 2", "Receipt #FEE-2026-0021", "₹ 15,000", "UPI", "15 Apr 2026"),
                _buildRecentPaymentItem("Tuition Fee - Term 1", "Receipt #FEE-2026-0015", "₹ 15,000", "Credit Card", "15 Jan 2026"),
                _buildRecentPaymentItem("Admission Fee", "Receipt #FEE-2025-0098", "₹ 10,000", "Net Banking", "10 Apr 2025"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentPaymentItem(String title, String receipt, String amount, String method, String date) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              color: Color(0xFFE6FDF4),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF10B981)),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  receipt,
                  style: TextStyle(fontSize: 9, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              amount,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              method,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              date,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ),
          IconButton(
            icon: Icon(Icons.download, size: 14, color: Colors.grey.shade500),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Downloading $receipt...")),
              );
            },
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNotesCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, size: 16, color: AppColors.primary),
                    SizedBox(width: 6),
                    Text("Important Notes".tr,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _buildBulletPoint("Please ensure timely payment of fees to avoid late fee charges."),
                SizedBox(height: 6),
                _buildBulletPoint("Late fee of ₹100 per day will be applicable after the due date."),
                SizedBox(height: 6),
                _buildBulletPoint("For any fee related queries, contact the school office."),
              ],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Center(
              child: SizedBox(
                height: 100,
                width: 90,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Background Leaves decoration
                    Positioned(
                      left: -5,
                      bottom: 5,
                      child: Opacity(
                        opacity: 0.15,
                        child: Transform.rotate(
                          angle: -0.5,
                          child: Icon(Icons.spa, size: 30, color: Color(0xFF0038FF)),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -5,
                      top: 15,
                      child: Opacity(
                        opacity: 0.15,
                        child: Transform.rotate(
                          angle: 0.5,
                          child: Icon(Icons.spa, size: 30, color: Color(0xFF0038FF)),
                        ),
                      ),
                    ),
                    // Main Clipboard Card
                    Container(
                      width: 60,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Color(0xFF0038FF), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("FEE".tr,
                            style: TextStyle(
                              color: Color(0xFF0038FF),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          // Lines representing clipboard lines
                          Container(height: 1.5, width: 32, color: Colors.grey.shade200),
                          SizedBox(height: 3),
                          Container(height: 1.5, width: 32, color: Colors.grey.shade200),
                          SizedBox(height: 3),
                          Container(height: 1.5, width: 20, color: Colors.grey.shade200),
                        ],
                      ),
                    ),
                    // Clipboard Clip
                    Positioned(
                      top: 4,
                      child: Container(
                        width: 28,
                        height: 7,
                        decoration: BoxDecoration(
                          color: Color(0xFF0038FF),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Rupee symbol circle at bottom right
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          color: Color(0xFFF97316),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            )
                          ],
                        ),
                        child: Center(child: Text("₹".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(Icons.fiber_manual_record, size: 5, color: Colors.black54),
        ),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: Colors.black54,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
