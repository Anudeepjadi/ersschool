import 'package:flutter/material.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_bottom_nav_bar.dart';

class AdminStudentTermFeePaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? student;
  const AdminStudentTermFeePaymentScreen({super.key, this.student});

  @override
  State<AdminStudentTermFeePaymentScreen> createState() => _AdminStudentTermFeePaymentScreenState();
}

class _AdminStudentTermFeePaymentScreenState extends State<AdminStudentTermFeePaymentScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double contentWidth = screenWidth > 482 ? 450 : screenWidth - 32;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
      appBar: AdminAppBar(
        title: "Term Fee Payment".tr,
        subtitle: "Pay student term fees",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Actions previously in AppBar
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  child: Text("Close".tr),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  child: Text("Save".tr),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Top Details Row
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: contentWidth,
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                    child: Column(
                      children: [
                        contentWidth < 400
                            ? Column(
                                children: [
                                  Row(children: [_buildInfoCell("Name:", isHeader: true), _buildInfoCell(widget.student?['name'] ?? "Deepthi")]),
                                  Row(children: [_buildInfoCell("Class:", isHeader: true), _buildInfoCell("${widget.student?['class'] ?? "Grade 1"} - ${widget.student?['section'] ?? "A"}")]),
                                  const Divider(height: 1, color: Colors.grey),
                                  Row(children: [_buildInfoCell("Father Name:", isHeader: true), _buildInfoCell(widget.student?['father'] ?? "Venki")]),
                                  Row(children: [_buildInfoCell("Mobile:", isHeader: true), _buildInfoCell(widget.student?['mobile'] ?? "9376348093")]),
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      _buildInfoCell("Name:", isHeader: true), _buildInfoCell(widget.student?['name'] ?? "Deepthi"),
                                      _buildInfoCell("Class:", isHeader: true), _buildInfoCell("${widget.student?['class'] ?? "Grade 1"} - ${widget.student?['section'] ?? "A"}"),
                                    ],
                                  ),
                                  const Divider(height: 1, color: Colors.grey),
                                  Row(
                                    children: [
                                      _buildInfoCell("Father Name:", isHeader: true), _buildInfoCell(widget.student?['father'] ?? "Venki"),
                                      _buildInfoCell("Mobile:", isHeader: true), _buildInfoCell(widget.student?['mobile'] ?? "9376348093"),
                                    ],
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: contentWidth,
                  child: contentWidth < 400
                      ? Column(
                          children: [
                            Row(children: [Expanded(child: _buildFeeBadge("Total Fee:", "₹ 38,000.00", AppColors.primary))]),
                            const SizedBox(height: 8),
                            Row(children: [Expanded(child: _buildFeeBadge("Fee Paid:", "₹ 11,000.00", AppColors.success))]),
                            const SizedBox(height: 8),
                            Row(children: [Expanded(child: _buildFeeBadge("Fee Balance:", "₹ 27,000.00", AppColors.error))]),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: _buildFeeBadge("Total Fee:", "₹ 38,000.00", AppColors.primary)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildFeeBadge("Fee Paid:", "₹ 11,000.00", AppColors.success)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildFeeBadge("Fee Balance:", "₹ 27,000.00", AppColors.error)),
                          ],
                        ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Term blocks
            Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SizedBox(
                    width: 1200,
                    child: Column(
                      children: [
                        _buildTermBlock("Term 1", "13000", "12/6/2025", "11000", "2000", hasPaymentDetails: true),
                        const SizedBox(height: 16),
                        _buildTermBlock("Term 2", "13000", "1/9/2025", "0", "13000"),
                        const SizedBox(height: 16),
                        _buildTermBlock("Term 3", "12000", "1/12/2025", "0", "12000"),
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
  }

  Widget _buildTermBlock(String title, String amount, String dueDate, String paid, String balance, {bool hasPaymentDetails = false}) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        children: [
          Container(
            color: AppColors.primaryDark,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Summary Column
              Container(
                width: 250,
                color: Colors.grey.shade50,
                child: Column(
                  children: [
                    _buildSummaryRow("Term Amount", amount),
                    const Divider(height: 1),
                    _buildSummaryRow("Due Date", dueDate, isDate: true),
                    const Divider(height: 1),
                    _buildSummaryRow("Late Fee", "0"),
                    const Divider(height: 1),
                    _buildSummaryRow("Term Paid Amount", paid, highlightColor: AppColors.primary.withValues(alpha: 0.1)), // Light brown highlight
                    const Divider(height: 1),
                    _buildSummaryRow("Term Balance Amount", balance),
                  ],
                ),
              ),
              Container(width: 1, color: Colors.grey.shade300),
              // Right Payment Details Column
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // Existing payment row if any
                      if (hasPaymentDetails)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _buildPaymentRow("28/5/2026", "11000", "Cash", "", "1361", isExisting: true),
                        ),
                      // New payment row
                      _buildPaymentRow("", "0", "Cash", "", "", isExisting: false),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isDate = false, Color? highlightColor}) {
    return Container(
      color: highlightColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label.tr, style: const TextStyle(fontSize: 11, color: Colors.black87)),
          isDate
              ? Row(
                  children: [
                    Container(
                      height: 24,
                      width: 80,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), color: Colors.white),
                      child: TextField(
                        controller: TextEditingController(text: value),
                        style: const TextStyle(fontSize: 11),
                        decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 12)),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.calendar_today, size: 16, color: Colors.red),
                  ],
                )
              : Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String date, String amount, String type, String trans, String receipt, {required bool isExisting}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: _buildPaymentField("Paid Date", date, hasCalendar: true)),
        const SizedBox(width: 16),
        Expanded(child: _buildPaymentField("Term Paid Amount", amount)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Payment Type", style: TextStyle(fontSize: 11)),
              const SizedBox(height: 4),
              Container(
                height: 32,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: type,
                    items: [DropdownMenuItem(value: type, child: Padding(padding: const EdgeInsets.only(left: 8), child: Text(type, style: const TextStyle(fontSize: 12))))],
                    onChanged: (v) {},
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: _buildPaymentField("Transaction Number", trans)),
        const SizedBox(width: 16),
        Expanded(child: _buildPaymentField("Receipt Number", receipt)),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: isExisting
              ? Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle),
                  child: Icon(Icons.add,
                      color: Colors.green.shade700, size: 14),
                )
              : Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      shape: BoxShape.circle),
                  child: Icon(Icons.delete_outline,
                      color: Colors.red.shade700, size: 14),
                ),
        ),
      ],
    );
  }

  Widget _buildPaymentField(String label, String initialValue, {bool hasCalendar = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr, style: const TextStyle(fontSize: 11)),
        const SizedBox(height: 4),
        hasCalendar
            ? _DatePickerTextField(initialValue: initialValue.isEmpty ? "dd/mm/yyyy" : initialValue, isSmall: false)
            : Container(
                height: 32,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                child: TextField(
                  controller: TextEditingController(text: initialValue),
                  style: const TextStyle(fontSize: 12),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    isDense: true,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildInfoCell(String text, {bool isHeader = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: isHeader ? AppColors.primary.withValues(alpha: 0.05) : Colors.white, border: Border(right: BorderSide(color: Colors.grey.shade300))),
        child: Text(text.tr, style: TextStyle(fontSize: 12, fontWeight: isHeader ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }

  Widget _buildFeeBadge(String title, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.tr, style: const TextStyle(fontSize: 10)),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
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
            child: const Icon(Icons.calendar_today, size: 14, color: Colors.red),
          ),
        ),
      ),
    );
  }
}

