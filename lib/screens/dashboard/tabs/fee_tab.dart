import 'package:flutter/material.dart';

class FeeTab extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  const FeeTab({super.key, required this.onOpenDrawer});

  @override
  State<FeeTab> createState() => _FeeTabState();
}

class _FeeTabState extends State<FeeTab> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // 1. Curved Gradient Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF101B54), Color(0xFF0022C4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 20,
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                        onPressed: widget.onOpenDrawer,
                      ),
                      const SizedBox(width: 4),
                      const Expanded(
                        child: Text(
                          "Fee",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Right-side icons row
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // School dropdown badge
                          Container(
                            constraints: const BoxConstraints(maxWidth: 120),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.school_outlined, color: Colors.white, size: 12),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    "Ecstasy School 1",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 12),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Notification bell with badge
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.notifications_none_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              ),
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: const Text(
                                    "5",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 7,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 4),
                          // Profile Pic
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1.0),
                                ),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: Image.asset(
                                      "assets/images/student_profile.png",
                                      width: 28,
                                      height: 28,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.person,
                                          color: Color(0xFF101B54),
                                          size: 16,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 12),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 48, top: 4),
                    child: Text(
                      "View fee details and payment history",
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Tab Bar Section
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF0038FF),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                labelColor: const Color(0xFF0038FF),
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.space_dashboard_outlined, size: 18),
                    text: "Overview",
                  ),
                  Tab(
                    icon: Icon(Icons.assignment_outlined, size: 18),
                    text: "Fees Structure",
                  ),
                  Tab(
                    icon: Icon(Icons.receipt_long_outlined, size: 18),
                    text: "Transactions",
                  ),
                  Tab(
                    icon: Icon(Icons.receipt_outlined, size: 18),
                    text: "Receipts",
                  ),
                ],
              ),
            ),

            // 3. Tab Contents
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildFeesStructureTab(),
                  _buildTransactionsTab(),
                  _buildReceiptsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB BUILDERS ---

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Annual Fees & Stats Card
          _buildAnnualFeesCard(),

          // Fee Status Table Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Fee Status",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_outlined, size: 16, color: Color(0xFF1E2875)),
                  label: const Text(
                    "Download Statement",
                    style: TextStyle(
                      color: Color(0xFF1E2875),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Fee Status Data Grid
          _buildFeeStatusTable(),

          const SizedBox(height: 25),

          // Quick Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickActionItem(Icons.credit_card_outlined, "Pay Fee", Colors.blue),
                    _buildQuickActionItem(Icons.receipt_outlined, "View Receipts", Colors.purple),
                    _buildQuickActionItem(Icons.list_alt_outlined, "Fee Structure", Colors.amber.shade700),
                    _buildQuickActionItem(Icons.file_download_outlined, "Download\nStatement", Colors.green),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Recent Payments Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Payments",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _tabController.animateTo(2); // Jump to Transactions Tab
                  },
                  child: const Text(
                    "View All",
                    style: TextStyle(
                      color: Color(0xFF0038FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Recent Payments List
          _buildRecentPaymentsList(),

          const SizedBox(height: 20),

          // Important Notes Banner
          _buildImportantNotesBanner(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildFeesStructureTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Academic Year Fee Breakdown",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
        ),
        const SizedBox(height: 12),
        _buildStructureCard("Tuition Fees (Term 1, 2, 3)", "Standard curriculum tuition", "₹45,000", Icons.school_outlined, Colors.blue),
        _buildStructureCard("Transport Services", "Annual school bus route charges", "₹12,000", Icons.directions_bus_outlined, Colors.indigo),
        _buildStructureCard("Science Laboratory Deposit", "Non-refundable chemistry & physics labs", "₹3,500", Icons.science_outlined, Colors.orange),
        _buildStructureCard("Library Annual Membership", "Book loans and study room access", "₹2,500", Icons.menu_book_outlined, Colors.green),
        _buildStructureCard("Sports & Co-curricular Clubs", "Sports equipment and training facility", "₹5,000", Icons.sports_basketball_outlined, Colors.purple),
      ],
    );
  }

  Widget _buildTransactionsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Transaction History",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
        ),
        const SizedBox(height: 12),
        _buildFullTransactionCard("Tuition Fee - Term 2", "FEE-2024-0021", "₹15,000", "UPI (PhonePe)", "15 Apr 2024", "Success"),
        _buildFullTransactionCard("Tuition Fee - Term 1", "FEE-2024-0015", "₹15,000", "Credit Card (HDFC)", "15 Jan 2024", "Success"),
        _buildFullTransactionCard("Admission Fee", "FEE-2023-0098", "₹10,000", "Net Banking (SBI)", "10 Apr 2023", "Success"),
        _buildFullTransactionCard("Bus Fees Term 1", "FEE-2023-0044", "₹6,000", "Debit Card (ICICI)", "18 Apr 2023", "Success"),
      ],
    );
  }

  Widget _buildReceiptsTab() {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildReceiptGridCard("Term 2 Tuition", "FEE-2024-0021", "₹15,000", "15 Apr 2024"),
        _buildReceiptGridCard("Term 1 Tuition", "FEE-2024-0015", "₹15,000", "15 Jan 2024"),
        _buildReceiptGridCard("Admission Fee", "FEE-2023-0098", "₹10,000", "10 Apr 2023"),
        _buildReceiptGridCard("Bus Fee Term 1", "FEE-2023-0044", "₹6,000", "18 Apr 2023"),
      ],
    );
  }

  // --- SUB-WIDGET BUILDERS ---

  Widget _buildAnnualFeesCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left portion
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Annual Fees",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
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
                const SizedBox(height: 12),
                // Academic Year Dropdown Lookalike
                const Text(
                  "Academic Year",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "2024 - 2025",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E2875),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 12,
                        color: Color(0xFF1E2875),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Vertical divider
          Container(
            height: 90,
            width: 1,
            color: Colors.grey.shade200,
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),

          // Right portion
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSubMetric("Total Paid", "₹ 20,000", Colors.green),
                    _buildSubMetric("Due Amount", "₹ 25,000", Colors.red),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Due Date",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "30 Jun 2024",
                          style: TextStyle(
                            color: Colors.amber.shade800,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.grey.shade700,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubMetric(String title, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFeeStatusTable() {
    final headerStyle = TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Table Header
          Row(
            children: [
              Expanded(flex: 3, child: Text("Particulars", style: headerStyle)),
              Expanded(flex: 2, child: Text("Due Date", style: headerStyle)),
              Expanded(flex: 2, child: Text("Amount (₹)", style: headerStyle, textAlign: TextAlign.right)),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: Text("Status", style: headerStyle, textAlign: TextAlign.center)),
              const SizedBox(width: 24),
            ],
          ),
          const Divider(height: 20),

          // Row 1
          _buildFeeStatusRow("Tuition Fee", "Term 1", "30 Apr 2024", "15,000", true, Colors.green),
          const Divider(height: 20),

          // Row 2
          _buildFeeStatusRow("Tuition Fee", "Term 2", "30 Jun 2024", "15,000", true, Colors.green),
          const Divider(height: 20),

          // Row 3
          _buildFeeStatusRow("Tuition Fee", "Term 3", "30 Sep 2024", "15,000", false, Colors.orange),

          const Divider(height: 24),

          // Summary & Pay Now Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Paid", style: TextStyle(color: Colors.grey, fontSize: 10)),
                  Text(
                    "₹ 20,000",
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Due", style: TextStyle(color: Colors.grey, fontSize: 10)),
                  Text(
                    "₹ 25,000",
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.payment_outlined, size: 16),
                label: const Text("Pay Now", style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0038FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeeStatusRow(
    String mainText,
    String subText,
    String dueDate,
    String amount,
    bool isPaid,
    Color dotColor,
  ) {
    return Row(
      children: [
        // Particulars
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mainText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2875),
                      ),
                    ),
                    Text(
                      subText,
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Due Date
        Expanded(
          flex: 2,
          child: Text(
            dueDate,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          ),
        ),
        // Amount
        Expanded(
          flex: 2,
          child: Text(
            amount,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2875),
            ),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 8),
        // Status Pill
        Expanded(
          flex: 2,
          child: Center(
            child: isPaid
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade600, size: 10),
                        const SizedBox(width: 3),
                        Text(
                          "Paid",
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Text(
                      "Unpaid",
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ),
        // Arrow button
        SizedBox(
          width: 24,
          child: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey.shade400,
            size: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2875),
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentPaymentsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildRecentPaymentRow("Tuition Fee - Term 2", "Receipt #FEE-2024-0021", "₹ 15,000", "UPI", "15 Apr 2024"),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1),
          ),
          _buildRecentPaymentRow("Tuition Fee - Term 1", "Receipt #FEE-2024-0015", "₹ 15,000", "Credit Card", "15 Jan 2024"),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1),
          ),
          _buildRecentPaymentRow("Admission Fee", "Receipt #FEE-2023-0098", "₹ 10,000", "Net Banking", "10 Apr 2023"),
        ],
      ),
    );
  }

  Widget _buildRecentPaymentRow(
    String title,
    String receiptNo,
    String amount,
    String method,
    String date,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Circular Check icon
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle_outline, color: Colors.green.shade600, size: 18),
          ),
          const SizedBox(width: 10),
          // Particular details
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  receiptNo,
                  style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          // Amount & Method
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  method,
                  style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          // Date
          Text(
            date,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
          const SizedBox(width: 8),
          // Download icon
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.download_outlined,
              color: Colors.grey.shade600,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNotesBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD3E2FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info, color: Color(0xFF0038FF), size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Important Notes",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2875),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildBulletPoint("Please ensure timely payment of fees to avoid late fee charges."),
                const SizedBox(height: 6),
                _buildBulletPoint("Late fee of ₹ 100 per day will be applicable after the due date."),
                const SizedBox(height: 6),
                _buildBulletPoint("For any fee related queries, contact the school office."),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Illustration portion
          Expanded(
            flex: 3,
            child: Image.asset(
              "assets/images/fee_illustration.png",
              height: 70,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback illustration using Flutter widgets in case asset fails
                return Container(
                  height: 70,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 44,
                        height: 54,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0038FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        child: const Text(
                          "FEE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Colors.amber.shade600,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "₹",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
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
        const Text("• ", style: TextStyle(color: Color(0xFF1E2875), fontSize: 14)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF5A629B),
              height: 1.3,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // --- SECONDARY TABS WIDGET BUILDERS ---

  Widget _buildStructureCard(String title, String desc, String value, IconData icon, Color color) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2875),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullTransactionCard(
    String title,
    String txId,
    String amount,
    String method,
    String date,
    String status,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2875),
                      ),
                    ),
                  ],
                ),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Transaction ID", style: TextStyle(color: Colors.grey, fontSize: 9)),
                    const SizedBox(height: 2),
                    Text(txId, style: const TextStyle(color: Color(0xFF1E2875), fontSize: 11, fontWeight: FontWeight.w500)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Method", style: TextStyle(color: Colors.grey, fontSize: 9)),
                    const SizedBox(height: 2),
                    Text(method, style: const TextStyle(color: Color(0xFF1E2875), fontSize: 11, fontWeight: FontWeight.w500)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Date", style: TextStyle(color: Colors.grey, fontSize: 9)),
                    const SizedBox(height: 2),
                    Text(date, style: const TextStyle(color: Color(0xFF1E2875), fontSize: 11, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptGridCard(String title, String receiptNo, String amount, String date) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2875),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            receiptNo,
            style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                ),
              ),
              Text(
                date,
                style: TextStyle(fontSize: 8, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
