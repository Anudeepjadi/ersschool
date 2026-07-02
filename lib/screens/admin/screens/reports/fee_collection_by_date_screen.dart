import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/admin_bottom_nav_bar.dart';

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
                onPressed: () {},
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
            _buildDataTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 4,
          child: _buildBodyDropdown("Branch", selectedBranch, branches, (v) => setState(() => selectedBranch = v!)),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: _buildDatePicker("Start Date", startDate, (d) => setState(() => startDate = d)),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: _buildDatePicker("End Date", endDate, (d) => setState(() => endDate = d)),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            minimumSize: const Size(80, 36),
          ),
          child: const Text("Get Data", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildPill("Total Payments Count: 0", Colors.grey),
          const SizedBox(width: 8),
          _buildPill("Total Amount Received: 0.00", Colors.green.shade700),
          const SizedBox(width: 8),
          _buildPill("Total Cash Payment: 0.00", Colors.teal),
          const SizedBox(width: 8),
          _buildPill("Total Credit/Debit Card Payment: 0.00", Colors.orange),
          const SizedBox(width: 8),
          _buildPill("Total Online Payment: 0.00", Colors.black),
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
        headingRowColor: WidgetStateProperty.all(const Color(0xFF001A40)),
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
        rows: const [],
      ),
    ));
  }
}
