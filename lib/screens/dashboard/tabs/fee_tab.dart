import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class FeeTab extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const FeeTab({super.key, this.onOpenDrawer});

  @override
  State<FeeTab> createState() => _FeeTabState();
}

class _FeeTabState extends State<FeeTab> {
  int _activeSubTab = 0; // 0: Overview, 1: Fees Structure, 2: Transactions, 3: Receipts
  String _selectedAcademicYear = "2026 - 2027";
  String _selectedSchool = "Ecstasy School 1";

  // Dropdown options
  final List<String> _academicYears = ["2026 - 2027", "2025 - 2026", "2024 - 2025"];
  final List<String> _schools = ["Ecstasy School 1", "Ecstasy School 2", "Ecstasy School 3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          _buildSubTabBar(),
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00145A), Color(0xFF00228C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 12,
        right: 12,
        bottom: 20,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 26),
            onPressed: widget.onOpenDrawer,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Fee",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // School selector dropdown represented as PopupMenuButton
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _selectedSchool = value;
              });
            },
            offset: const Offset(0, 40),
            itemBuilder: (BuildContext context) {
              return _schools.map((String school) {
                return PopupMenuItem<String>(
                  value: school,
                  child: Text(school, style: const TextStyle(fontSize: 13)),
                );
              }).toList();
            },
            child: Container(
              constraints: const BoxConstraints(maxWidth: 120),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.school, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      _selectedSchool,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Notification indicator
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white, size: 26),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No new notifications")),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: const Center(
                    child: Text(
                      "5",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Student Profile Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 1.5),
            ),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/images/student_profile.png",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
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
    final Color color = isActive ? AppColors.primary : const Color(0xFF6B7280);
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
            const SizedBox(height: 12),
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
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
            const SizedBox(height: 10),
            Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: const BorderRadius.only(
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
          const SizedBox(height: 12),
          Text(
            "$title Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 4),
          Text(
            "This tab is under development.",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTotalAnnualFeesCard(),
          const SizedBox(height: 24),
          _buildFeeStatusSection(),
          const SizedBox(height: 24),
          _buildQuickActionsSection(),
          const SizedBox(height: 24),
          _buildRecentPaymentsSection(),
          const SizedBox(height: 24),
          _buildImportantNotesCard(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTotalAnnualFeesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  Text(
                    "Total Annual Fees",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "₹ 45,000",
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
                offset: const Offset(0, 30),
                itemBuilder: (BuildContext context) {
                  return _academicYears.map((String year) {
                    return PopupMenuItem<String>(
                      value: year,
                      child: Text(year, style: const TextStyle(fontSize: 13)),
                    );
                  }).toList();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                          Text(
                            "Academic Year",
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
                      const SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.grey.shade600),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem("Total Paid", "₹ 20,000", const Color(0xFF10B981)),
              _buildSummaryItem("Due Amount", "₹ 25,000", const Color(0xFFEF4444)),
              _buildSummaryItemWithIcon(
                "Due Date",
                "30 Jun 2026",
                const Color(0xFFEA580C),
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
        const SizedBox(height: 2),
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
        const SizedBox(height: 2),
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
            const SizedBox(width: 4),
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
            const Text(
              "Fee Status",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Downloading Fee Statement...")),
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.download, size: 14, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    "Download Statement",
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
        const SizedBox(height: 12),
        // Fee table column headers
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Particulars",
                  style: TextStyle(fontSize: 10, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Due Date",
                  style: TextStyle(fontSize: 10, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Amount (₹)",
                  style: TextStyle(fontSize: 10, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Status",
                  style: TextStyle(fontSize: 10, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 16), // space to match right chevron
            ],
          ),
        ),
        const SizedBox(height: 6),
        // Items list
        _buildFeeItem("Tuition Fee", "Term 1", "30 Apr 2026", "15,000", true),
        _buildFeeItem("Tuition Fee", "Term 2", "30 Jun 2026", "15,000", true),
        _buildFeeItem("Tuition Fee", "Term 3", "30 Sep 2026", "15,000", false),
        const SizedBox(height: 16),
        // Totals and Pay Now Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Paid",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w500),
                ),
                const Text(
                  "₹ 20,000",
                  style: TextStyle(color: Color(0xFF10B981), fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Due",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w500),
                ),
                const Text(
                  "₹ 25,000",
                  style: TextStyle(color: Color(0xFFEF4444), fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(width: 8),
            // Pay Now Button
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Redirecting to payment gateway...")),
                );
              },
              icon: const Icon(Icons.payment, size: 14, color: Colors.white),
              label: const Text(
                "Pay Now",
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
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
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
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
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                if (isPaid)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6FDF4),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFBCF6E1)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 8, color: Color(0xFF10B981)),
                        SizedBox(width: 2),
                        Text(
                          "Paid",
                          style: TextStyle(fontSize: 8, color: Color(0xFF10B981), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                else
                  const Text(
                    "Unpaid",
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
        const Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2875),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickActionItem("Pay Fee", Icons.credit_card, const Color(0xFFEEF2FF), const Color(0xFF4F46E5)),
            _buildQuickActionItem("View Receipts", Icons.receipt, const Color(0xFFF5F3FF), const Color(0xFF7C3AED)),
            _buildQuickActionItem("Fee Structure", Icons.list_alt, const Color(0xFFFFF7ED), const Color(0xFFEA580C)),
            _buildQuickActionItem("Download Statement", Icons.download, const Color(0xFFECFDF5), const Color(0xFF059669)),
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
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
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
            const Text(
              "Recent Payments",
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
              child: const Text(
                "View All",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildRecentPaymentItem("Tuition Fee - Term 2", "Receipt #FEE-2026-0021", "₹ 15,000", "UPI", "15 Apr 2026"),
        _buildRecentPaymentItem("Tuition Fee - Term 1", "Receipt #FEE-2026-0015", "₹ 15,000", "Credit Card", "15 Jan 2026"),
        _buildRecentPaymentItem("Admission Fee", "Receipt #FEE-2025-0098", "₹ 10,000", "Net Banking", "10 Apr 2025"),
      ],
    );
  }

  Widget _buildRecentPaymentItem(String title, String receipt, String amount, String method, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
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
            decoration: const BoxDecoration(
              color: Color(0xFFE6FDF4),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF10B981)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
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
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
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
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNotesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
                    const Icon(Icons.info, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      "Important Notes",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildBulletPoint("Please ensure timely payment of fees to avoid late fee charges."),
                const SizedBox(height: 6),
                _buildBulletPoint("Late fee of ₹100 per day will be applicable after the due date."),
                const SizedBox(height: 6),
                _buildBulletPoint("For any fee related queries, contact the school office."),
              ],
            ),
          ),
          const SizedBox(width: 8),
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
                          child: const Icon(Icons.spa, size: 30, color: Color(0xFF0038FF)),
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
                          child: const Icon(Icons.spa, size: 30, color: Color(0xFF0038FF)),
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
                        border: Border.all(color: const Color(0xFF0038FF), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "FEE",
                            style: TextStyle(
                              color: Color(0xFF0038FF),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Lines representing clipboard lines
                          Container(height: 1.5, width: 32, color: Colors.grey.shade200),
                          const SizedBox(height: 3),
                          Container(height: 1.5, width: 32, color: Colors.grey.shade200),
                          const SizedBox(height: 3),
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
                          color: const Color(0xFF0038FF),
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
                        decoration: const BoxDecoration(
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
                        child: const Center(
                          child: Text(
                            "₹",
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
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(Icons.fiber_manual_record, size: 5, color: Colors.black54),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
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
