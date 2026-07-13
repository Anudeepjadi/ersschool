import 'package:flutter/material.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import '../../../../core/theme/app_colors.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import '../../../../core/data/app_data_store.dart';

class FeeCollectionByDateScreen extends StatefulWidget {
  const FeeCollectionByDateScreen({super.key});

  @override
  State<FeeCollectionByDateScreen> createState() => _FeeCollectionByDateScreenState();
}

class _FeeCollectionByDateScreenState extends State<FeeCollectionByDateScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  String selectedBranch = 'Ecstasy School 1 (ECS001)';
  DateTime startDate = DateTime(2026, 6, 29);
  DateTime endDate = DateTime(2026, 6, 29);

  final List<String> branches = [
    'Ecstasy School 1 (ECS001)',
    'Ecstay School 2 (ECS002)',
    'Ecstasy (ECS003)',
    'Ecstasy (ECS004)',
  ];

  bool _hasFetched = false;

  List<Map<String, dynamic>> get _collectionData {
    if (!_hasFetched) return [];
    
    return AppDataStore.instance.students.map((student) {
      return {
        'name': student['name'],
        'father': student['father'] ?? '',
        'class': student['class'],
        'year': '2025-26',
        'feeType': 'Tuition Fee',
        'feeAmount': '33,333.33',
        'feePaid': '3,333.33',
        'balance': '30,000.00',
        'paidDate': '${startDate.day}/${startDate.month}/${startDate.year}',
        'receiptNo': 'RCPT-${student['admission']}',
        'payType': 'Online',
      };
    }).toList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "Reports",
        subtitle: "Fee Collection By Date",
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            _buildFilters(),
            const SizedBox(height: 16),
            Text(
              "Selected Period: ${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => _exportToExcel(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: const Text("Export to Excel", style: TextStyle(fontSize: 10)),
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryPills(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Scroll table horizontally: ", style: TextStyle(fontSize: 10, color: Colors.grey)),
                IconButton(
                  icon: Icon(Icons.arrow_circle_left_outlined, color: AppColors.primary, size: 20),
                  onPressed: () { if (_scrollController.hasClients) _scrollController.animateTo(_scrollController.offset - 200, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut); },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.arrow_circle_right_outlined, color: AppColors.primary, size: 20),
                  onPressed: () { if (_scrollController.hasClients) _scrollController.animateTo(_scrollController.offset + 200, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut); },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _buildDataTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 160,
            child: _buildBodyDropdown("Branch", selectedBranch, branches, (v) => setState(() => selectedBranch = v!)),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: _buildDatePicker("Start Date", startDate, (d) => setState(() => startDate = d)),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: _buildDatePicker("End Date", endDate, (d) => setState(() => endDate = d)),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _hasFetched = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              minimumSize: const Size(80, 38),
            ),
            child: const Text("Get Data", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
              style: const TextStyle(fontSize: 11, color: Colors.black),
              items: items.map((it) => DropdownMenuItem(value: it, child: Text(it))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime date, Function(DateTime) onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) onSelected(picked);
          },
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${date.day}/${date.month}/${date.year}", style: const TextStyle(fontSize: 10)),
                const Icon(Icons.calendar_today, size: 14, color: Colors.red),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryPills() {
    int count = _collectionData.length;
    double amount = count * 3333.33;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildPill("Total Payments Count: $count", AppColors.primary),
          const SizedBox(width: 8),
          _buildPill("Total Amount Received: ${amount.toStringAsFixed(2)}", AppColors.success),
          const SizedBox(width: 8),
          _buildPill("Total Cash Payment: 0.00", Colors.teal),
          const SizedBox(width: 8),
          _buildPill("Total Credit/Debit Card Payment: 0.00", AppColors.primaryDark),
          const SizedBox(width: 8),
          _buildPill("Total Online Payment: ${amount.toStringAsFixed(2)}", Colors.black),
        ],
      ),
    );
  }

  Widget _buildPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDataTable() {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 6,
      radius: const Radius.circular(8),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: DataTable(
        headingRowColor: WidgetStateProperty.all(AppColors.primary),
        columnSpacing: 20,
        horizontalMargin: 12,
        columns: const [
          DataColumn(label: Text("Full Name", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Father Name", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Class", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Year", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Fee Type", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Fee Amount", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Fee Paid", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Balance", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Paid Date", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Receipt No", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Pay Type", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
        ],
        rows: _collectionData.map((data) => DataRow(
          cells: [
            DataCell(Text(data['name']?.toString() ?? '', style: const TextStyle(fontSize: 10))),
            DataCell(Text(data['father']?.toString() ?? '', style: const TextStyle(fontSize: 10))),
            DataCell(Text(data['class']?.toString() ?? '', style: const TextStyle(fontSize: 10))),
            DataCell(Text(data['year']?.toString() ?? '', style: const TextStyle(fontSize: 10))),
            DataCell(Text(data['feeType']?.toString() ?? '', style: const TextStyle(fontSize: 10))),
            DataCell(Text(data['feeAmount']?.toString() ?? '', style: const TextStyle(fontSize: 10))),
            DataCell(Text(data['feePaid']?.toString() ?? '', style: const TextStyle(fontSize: 10))),
            DataCell(Text(data['balance']?.toString() ?? '', style: const TextStyle(fontSize: 10))),
            DataCell(Text(data['paidDate']?.toString() ?? '', style: const TextStyle(fontSize: 10))),
            DataCell(Text(data['receiptNo']?.toString() ?? '', style: const TextStyle(fontSize: 10))),
            DataCell(Text(data['payType']?.toString() ?? '', style: const TextStyle(fontSize: 10))),
          ]
        )).toList(),
      ),
    ));
  }

  void _exportToExcel() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            const SizedBox(width: 12),
            Text("Generating Collection Excel...".tr),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Collection_Report_${startDate.day}_${startDate.month}_to_${endDate.day}_${endDate.month}.xlsx downloaded.".tr),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
}
