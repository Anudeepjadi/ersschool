import 'package:flutter/material.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import '../../widgets/admin_app_bar.dart';
import 'admin_student_fee_receipt_screen.dart';
import 'admin_student_term_fee_payment_screen.dart';
import '../../widgets/admin_bottom_nav_bar.dart';

class AdminStudentFeeDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? student;
  const AdminStudentFeeDetailsScreen({super.key, this.student});

  @override
  State<AdminStudentFeeDetailsScreen> createState() => _AdminStudentFeeDetailsScreenState();
}

class _AdminStudentFeeDetailsScreenState extends State<AdminStudentFeeDetailsScreen> {
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  String _selectedYear = "2025-26";
  String _selectedClass = "All";

  @override
  void dispose() {
    _scrollController1.dispose();
    _scrollController2.dispose();
    super.dispose();
  }
  final List<Map<String, dynamic>> _feeTypes = [
    {'type': 'Activity Fee', 'amount': '6,000.00', 'discount': '0.00', 'subTotal': '6,000.00', 'paid': '0.00', 'balance': '6,000.00', 'trans': '', 'receipt': '', 'date': ''},
    {'type': 'Tuition Fee', 'amount': '38,000.00', 'discount': '0.00', 'subTotal': '38,000.00', 'paid': '11,000.00', 'balance': '27,000.00', 'trans': '', 'receipt': '', 'date': ''},
    {'type': 'books fee', 'amount': '11,000.00', 'discount': '0.00', 'subTotal': '11,000.00', 'paid': '0.00', 'balance': '11,000.00', 'trans': '', 'receipt': '', 'date': ''},
    {'type': 'residential', 'amount': '4,000.00', 'discount': '0.00', 'subTotal': '4,000.00', 'paid': '0.00', 'balance': '4,000.00', 'trans': '', 'receipt': '', 'date': ''},
    {'type': 'hostel', 'amount': '5,000.00', 'discount': '0.00', 'subTotal': '5,000.00', 'paid': '0.00', 'balance': '5,000.00', 'trans': '', 'receipt': '', 'date': ''},
  ];

  final List<Map<String, dynamic>> _termFees = [
    {'term': 'Term 1', 'amount': '13,000.00', 'dueDate': '12/6/2025', 'paid': '11,000.00', 'balance': '2,000.00'},
    {'term': 'Term 2', 'amount': '13,000.00', 'dueDate': '1/9/2025', 'paid': '0.00', 'balance': '13,000.00'},
    {'term': 'Term 3', 'amount': '12,000.00', 'dueDate': '1/12/2025', 'paid': '0.00', 'balance': '12,000.00'},
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double contentWidth = screenWidth > 482 ? 450 : screenWidth - 32;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
      appBar: AdminAppBar(
        title: "Fee Details".tr,
        subtitle: "Manage student fees",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters and Actions
            Wrap(
              spacing: 16,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                _buildTopDropdown("Academic Year", _selectedYear, ["All", "2024-25", "2025-26"], (v) => setState(() => _selectedYear = v!)),
                _buildTopDropdown("Class", _selectedClass, ['All', 'LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'], (v) => setState(() => _selectedClass = v!)),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2), // Small offset for alignment with dropdowns
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          elevation: 0,
                        ),
                        child: Text("Get Fee".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade700, // Better contrast
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          elevation: 0,
                        ),
                        child: Text("Close".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Top Section (Student Info + Fee Summary Cards)
            Wrap(
              spacing: 16,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                // Student Info Table
                SizedBox(
                  width: contentWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        contentWidth < 400
                            ? Column(
                                children: [
                                  Row(children: [_buildInfoCell("Name:".tr, isHeader: true), _buildInfoCell(widget.student?['name'] ?? "Deepthi")]),
                                  Row(children: [_buildInfoCell("Class:".tr, isHeader: true), _buildInfoCell("${widget.student?['class'] ?? "Grade 1"} - ${widget.student?['section'] ?? "A"}")]),
                                  const Divider(height: 1, color: Colors.grey),
                                  Row(children: [_buildInfoCell("Father Name:".tr, isHeader: true), _buildInfoCell(widget.student?['father'] ?? "Venki")]),
                                  Row(children: [_buildInfoCell("Mobile:".tr, isHeader: true), _buildInfoCell(widget.student?['mobile'] ?? "9376348093")]),
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      _buildInfoCell("Name:".tr, isHeader: true),
                                      _buildInfoCell(widget.student?['name'] ?? "Deepthi"),
                                      _buildInfoCell("Class:".tr, isHeader: true),
                                      _buildInfoCell("${widget.student?['class'] ?? "Grade 1"} - ${widget.student?['section'] ?? "A"}"),
                                    ],
                                  ),
                                  const Divider(height: 1, color: Colors.grey),
                                  Row(
                                    children: [
                                      _buildInfoCell("Father Name:".tr, isHeader: true),
                                      _buildInfoCell(widget.student?['father'] ?? "Venki"),
                                      _buildInfoCell("Mobile:".tr, isHeader: true),
                                      _buildInfoCell(widget.student?['mobile'] ?? "9376348093"),
                                    ],
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                // Fee Summary Cards
                SizedBox(
                  width: contentWidth,
                  child: contentWidth < 400
                      ? Column(
                          children: [
                            Row(children: [Expanded(child: _buildFeeCard("Total Fee:", "₹ 68,000.00", AppColors.primary))]),
                            const SizedBox(height: 8),
                            Row(children: [Expanded(child: _buildFeeCard("Fee Paid:", "₹ 11,000.00", AppColors.success))]),
                            const SizedBox(height: 8),
                            Row(children: [Expanded(child: _buildFeeCard("Fee Balance:", "₹ 57,000.00", AppColors.error))]),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: _buildFeeCard("Total Fee:", "₹ 68,000.00", AppColors.primary)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildFeeCard("Fee Paid:", "₹ 11,000.00", AppColors.success)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildFeeCard("Fee Balance:", "₹ 57,000.00", AppColors.error)),
                          ],
                        ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Fee Type Data Table
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
              child: Scrollbar(
                controller: _scrollController1,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController1,
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: DataTable(
                      border: TableBorder.all(color: Colors.grey.shade300),
                      headingRowColor: WidgetStateProperty.all(AppColors.primaryDark),
                      headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      dataRowColor: WidgetStateProperty.all(Colors.white),
                  columnSpacing: 30,
                  columns: [
                    DataColumn(label: Text("Fee Type".tr)),
                    DataColumn(label: Text("Fee Amount".tr)),
                    DataColumn(label: Text("Discount".tr)),
                    DataColumn(label: Text("Sub Total".tr)),
                    DataColumn(label: Text("Fee Paid".tr)),
                    DataColumn(label: Text("Fee Balance".tr)),
                    DataColumn(label: Text("Transaction #".tr)),
                    DataColumn(label: Text("Receipt #".tr)),
                    DataColumn(label: Text("Paid Date".tr)),
                    const DataColumn(label: Text("")),
                  ],
                  rows: _feeTypes.map((fee) {
                    return DataRow(
                      cells: [
                        DataCell(Text(fee['type'], style: const TextStyle(fontSize: 13))),
                        DataCell(Text(fee['amount'], style: const TextStyle(fontSize: 13), textAlign: TextAlign.right)),
                        DataCell(Text(fee['discount'], style: const TextStyle(fontSize: 13), textAlign: TextAlign.right)),
                        DataCell(Text(fee['subTotal'], style: const TextStyle(fontSize: 13), textAlign: TextAlign.right)),
                        DataCell(Text(fee['paid'], style: const TextStyle(fontSize: 13, color: Colors.green), textAlign: TextAlign.right)),
                        DataCell(Text(fee['balance'], style: const TextStyle(fontSize: 13, color: Colors.red), textAlign: TextAlign.right)),
                        DataCell(Text(fee['trans'], style: const TextStyle(fontSize: 13))),
                        DataCell(Text(fee['receipt'], style: const TextStyle(fontSize: 13))),
                        DataCell(Text(fee['date'], style: const TextStyle(fontSize: 13))),
                        DataCell(
                          Row(
                            children: [
                              _buildSmallButton("Pay", AppColors.success),
                              const SizedBox(width: 4),
                              _buildSmallButton("SMS", AppColors.absentOrange, textColor: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  ),
                ),
              ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Scroll table horizontally: ".tr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                IconButton(
                  icon: const Icon(Icons.arrow_circle_left_outlined, color: AppColors.primary),
                  onPressed: () { if (_scrollController1.hasClients) _scrollController1.animateTo(_scrollController1.offset - 250, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut); },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_circle_right_outlined, color: AppColors.primary),
                  onPressed: () { if (_scrollController1.hasClients) _scrollController1.animateTo(_scrollController1.offset + 250, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut); },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action Buttons below Table 1
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  child: Text("Consolidated Fee Receipt".tr),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _showSelectFeeDialog(context),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  child: Text("Add Fee".tr),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _showStudentFeeDialog(context),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  child: Text("Pay / Edit Fee".tr),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Transport Fee
            Row(
              children: [
                const Text("* No Transport Fee ", style: TextStyle(fontSize: 12)),
                ElevatedButton(
                  onPressed: () => _showTransportFeeDialog(context),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  child: Text("Add Transport Fee".tr),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("Term Fee Payment Details".tr, style: const TextStyle(fontSize: 24, color: Colors.black87)),
            const SizedBox(height: 16),
            // Term Fee Details
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AdminStudentTermFeePaymentScreen(student: widget.student)));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  child: Text("Pay Fee/Edit Payment".tr),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Online payment coming soon".tr)));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  child: Text("Pay Online".tr),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AdminStudentFeeReceiptScreen(student: widget.student)));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  child: Text("Tuition Fee Receipt".tr),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Term Data Table
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
              child: Scrollbar(
                controller: _scrollController2,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController2,
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: DataTable(
                      border: TableBorder.all(color: Colors.grey.shade300),
                      headingRowColor: WidgetStateProperty.all(AppColors.primary.withValues(alpha: 0.1)),
                      headingTextStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
                      dataRowColor: WidgetStateProperty.all(Colors.white),
                  columnSpacing: 30,
                  dataRowMaxHeight: double.infinity,
                  dataRowMinHeight: 60,
                  columns: [
                    DataColumn(label: Text("Term".tr)),
                    DataColumn(label: Text("Fee Amount".tr)),
                    DataColumn(label: Text("Due Date".tr)),
                    DataColumn(label: Text("Term Paid Amount".tr)),
                    DataColumn(label: Text("Balance Amount".tr)),
                    DataColumn(label: Text("Payment Details".tr)),
                    const DataColumn(label: Text("")),
                  ],
                  rows: _termFees.map((term) {
                    bool isTerm1 = term['term'] == 'Term 1';
                    return DataRow(
                      cells: [
                        DataCell(Text(term['term'], style: const TextStyle(fontSize: 13))),
                        DataCell(Text(term['amount'], style: const TextStyle(fontSize: 13))),
                        DataCell(Text(term['dueDate'], style: const TextStyle(fontSize: 13))),
                        DataCell(Text(term['paid'], style: const TextStyle(fontSize: 13, color: Colors.green))),
                        DataCell(Text(term['balance'], style: const TextStyle(fontSize: 13, color: Colors.red))),
                        DataCell(
                          isTerm1
                              ? Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          _buildDetailCell("Paid Date", isHeader: true),
                                          _buildDetailCell("Paid Amount", isHeader: true),
                                          _buildDetailCell("Pay Type", isHeader: true),
                                          _buildDetailCell("Transaction #", isHeader: true),
                                          _buildDetailCell("Receipt", isHeader: true, width: 140),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          _buildDetailCell("28/5/2026"),
                                          _buildDetailCell("11,000.00", color: AppColors.success),
                                          _buildDetailCell("Cash"),
                                          _buildDetailCell(""),
                                          _buildDetailCell("1361", hasButtons: true, width: 140),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        DataCell(_buildSmallButton("SMS", AppColors.absentOrange, textColor: Colors.black)),
                      ],
                    );
                  }).toList(),
                ),
                  ),
                ),
              ),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Scroll table horizontally: ".tr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                IconButton(
                  icon: const Icon(Icons.arrow_circle_left_outlined, color: AppColors.primary),
                  onPressed: () { if (_scrollController2.hasClients) _scrollController2.animateTo(_scrollController2.offset - 250, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut); },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_circle_right_outlined, color: AppColors.primary),
                  onPressed: () { if (_scrollController2.hasClients) _scrollController2.animateTo(_scrollController2.offset + 250, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut); },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCell(String text, {bool isHeader = false, Color? color, bool hasButtons = false, double width = 100}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
      child: isHeader
          ? Text(text.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))
          : hasButtons
              ? Row(
                  children: [
                    Text(text, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Builder(
                      builder: (context) => _buildSmallButton("Print", AppColors.primaryDark, fontSize: 10, onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminStudentFeeReceiptScreen(student: widget.student)));
                      }),
                    ),
                    const SizedBox(width: 4),
                    _buildSmallButton("SMS", AppColors.success, fontSize: 10, onTap: () {}),
                  ],
                )
              : Text(text.tr, style: TextStyle(color: color, fontSize: 12)),
    );
  }

  Widget _buildTopDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr, style: const TextStyle(fontSize: 10, color: Colors.black54)),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCell(String text, {bool isHeader = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isHeader ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
          border: Border(right: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Text(
          text.tr,
          style: TextStyle(fontSize: 13, fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }

  Widget _buildFeeCard(String title, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          child: Center(child: Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
        ),
      ],
    );
  }

  Widget _buildSmallButton(String text, Color color, {Color textColor = Colors.white, double fontSize = 12, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        child: Text(text.tr, style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showSelectFeeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Container(
            width: 500,
            color: AppColors.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header row with Close button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                        child: Text("Close".tr),
                      ),
                    ],
                  ),
                ),
                // Details Grid
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildInfoCell("Name:", isHeader: true), _buildInfoCell(widget.student?['name'] ?? "Deepthi"),
                        ],
                      ),
                      Row(
                        children: [
                          _buildInfoCell("Class:", isHeader: true), _buildInfoCell("${widget.student?['class'] ?? "Grade 1"} - ${widget.student?['section'] ?? "A"}"),
                        ],
                      ),
                      const Divider(height: 1, color: Colors.grey),
                      Row(
                        children: [
                          _buildInfoCell("Father Name:", isHeader: true), _buildInfoCell(widget.student?['father'] ?? "Venki"),
                        ],
                      ),
                      Row(
                        children: [
                          _buildInfoCell("Mobile:", isHeader: true), _buildInfoCell(widget.student?['mobile'] ?? "9376348093"),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Fee:".tr, style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Container(
                        height: 38,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4), color: Colors.white),
                        child: const TextField(decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 8))),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text("Total Amount:".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(width: 8),
                          const Text("0.00", style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                        child: Text("Pay Now".tr),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showStudentFeeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Container(
            width: 800,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  color: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Student Fee".tr, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Scrollable Table Area (2D scrolling for mobile)
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 850, // Fixed width for horizontal scrolling
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Form Header
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  SizedBox(width: 100, child: Text("Fee Type".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                  SizedBox(width: 100, child: Text("Fee Amount".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                  SizedBox(width: 100, child: Text("Discount Amount".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                  SizedBox(width: 100, child: Text("Sub Total".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                  SizedBox(width: 100, child: Text("Fee Paid".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                  SizedBox(width: 100, child: Text("Balance".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                  SizedBox(width: 100, child: Text("Pay type".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                  const SizedBox(width: 32),
                                ],
                              ),
                            ),
                            const Divider(),
                            // Fees List
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: _feeTypes.map((fee) => _buildFeeEditRow(fee)).toList(),
                              ),
                            ),
                            const Divider(),
                            // Footer Totals & Buttons
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 100, child: Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                                  const SizedBox(width: 100, child: Text("64,000.00", style: TextStyle(fontWeight: FontWeight.bold))),
                                  const SizedBox(width: 100, child: Text("53,000.00", style: TextStyle(fontWeight: FontWeight.bold))),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white),
                                        child: Text("Cancel".tr),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                                        child: Text("Save".tr),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeeEditRow(Map<String, dynamic> fee) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 100, child: Container(padding: const EdgeInsets.all(8), color: AppColors.primary.withValues(alpha: 0.05), child: Text(fee['type'], style: const TextStyle(fontSize: 12)))),
            SizedBox(width: 100, child: Padding(padding: const EdgeInsets.only(left: 8), child: Text(fee['amount'], style: const TextStyle(fontSize: 12)))),
            SizedBox(width: 100, child: Padding(padding: const EdgeInsets.only(left: 8), child: _buildSmallTextField("0"))),
            SizedBox(width: 100, child: Padding(padding: const EdgeInsets.only(left: 8), child: Text(fee['subTotal'], style: const TextStyle(fontSize: 12)))),
            SizedBox(width: 100, child: Padding(padding: const EdgeInsets.only(left: 8), child: _buildSmallTextField("0"))),
            SizedBox(width: 100, child: Padding(padding: const EdgeInsets.only(left: 8), child: Text(fee['balance'], style: const TextStyle(fontSize: 12)))),
            SizedBox(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: "Cash",
                      items: const [DropdownMenuItem(value: "Cash", child: Padding(padding: EdgeInsets.only(left: 8), child: Text("Cash", style: TextStyle(fontSize: 12))))],
                      onChanged: (v) {},
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle),
              child: Icon(Icons.delete_outline,
                  color: Colors.red.shade700, size: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Receipt # ", style: TextStyle(fontSize: 11)),
            SizedBox(width: 80, child: _buildSmallTextField("26105")),
            const SizedBox(width: 16),
            const Text("Transaction # ", style: TextStyle(fontSize: 11)),
            SizedBox(width: 80, child: _buildSmallTextField("")),
            const SizedBox(width: 16),
            const Text("Paid Date ", style: TextStyle(fontSize: 11)),
            const SizedBox(width: 110, child: _DatePickerTextField(initialValue: "25/6/2026", isSmall: true)),
            const SizedBox(width: 24),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }

  Widget _buildSmallTextField(String initialValue, {IconData? suffixIcon}) {
    return Container(
      height: 30,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
      child: TextField(
        controller: TextEditingController(text: initialValue),
        style: const TextStyle(fontSize: 12),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          isDense: true,
          suffixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 14, color: Colors.grey) : null,
        ),
      ),
    );
  }

  void _showTransportFeeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double fieldWidth = screenWidth > 600 ? 200 : screenWidth - 80;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Container(
            width: 700,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  color: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Transport Fee".tr, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(width: fieldWidth, child: _buildLabeledDropdown("Transport Type", "Two Way")),
                          SizedBox(width: fieldWidth, child: _buildLabeledDropdown("Pickup Route", "1 City Road 1 (8:00 AM)")),
                          SizedBox(width: fieldWidth, child: _buildLabeledDropdown("Drop Route", "2 City Road 2 (8:00 AM)")),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(width: fieldWidth, child: _buildLabeledInput("Total Fee")),
                          SizedBox(width: fieldWidth, child: _buildLabeledInput("Discount Amount")),
                          SizedBox(width: fieldWidth, child: _buildLabeledInput("Subtotal Amount")),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(width: fieldWidth, child: _buildLabeledInput("Term 1", initialValue: "0")),
                          SizedBox(width: fieldWidth, child: _buildLabeledInput("Term 2", initialValue: "0")),
                          SizedBox(width: fieldWidth, child: _buildLabeledInput("Term 3", initialValue: "0")),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(width: fieldWidth, child: _buildLabeledInput("Fee Paid")),
                          SizedBox(width: fieldWidth, child: _buildLabeledInput("Fee Balance")),
                          SizedBox(width: fieldWidth, child: _buildLabeledDropdown("Currently using transport", "Yes")),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E2875), foregroundColor: Colors.white),
                            child: Text("Cancel".tr),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                            child: Text("Save".tr),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabeledDropdown(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Container(
          height: 38,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: [DropdownMenuItem(value: value, child: Padding(padding: const EdgeInsets.only(left: 8), child: Text(value, style: const TextStyle(fontSize: 13))))],
              onChanged: (v) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledInput(String label, {String initialValue = ""}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Container(
          height: 38,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
          child: TextField(
            controller: TextEditingController(text: initialValue),
            decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 8)),
          ),
        ),
      ],
    );
  }
}

class _DatePickerTextField extends StatefulWidget {
  final String initialValue;
  final bool isSmall;
  const _DatePickerTextField({required this.initialValue, this.isSmall = true});

  @override
  State<_DatePickerTextField> createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<_DatePickerTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.isSmall ? 30 : 32,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
      child: TextField(
        controller: _controller,
        style: const TextStyle(fontSize: 12),
        readOnly: true,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          isDense: true,
          suffixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          suffixIcon: InkWell(
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() {
                  _controller.text = "${picked.day}/${picked.month}/${picked.year}";
                });
              }
            },
            child: const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
