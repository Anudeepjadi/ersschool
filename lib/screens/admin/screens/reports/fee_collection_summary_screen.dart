import 'package:flutter/material.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/admin_bottom_nav_bar.dart';

class FeeCollectionSummaryScreen extends StatefulWidget {
  const FeeCollectionSummaryScreen({super.key});

  @override
  State<FeeCollectionSummaryScreen> createState() => _FeeCollectionSummaryScreenState();
}

class _FeeCollectionSummaryScreenState extends State<FeeCollectionSummaryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedBranch = 'Ecstasy School 1 (ECS001)';
  String selectedYear = '2025-26';

  final List<String> branches = [
    'Ecstasy School 1 (ECS001)',
    'Ecstay School 2 (ECS002)',
    'Ecstasy (ECS003)',
    'Ecstasy (ECS004)',
  ];

  final List<String> years = [
    '2027-2028',
    '2026-27',
    '2025-26',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "Reports",
        subtitle: "Fee Collection Report",
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                "Fee Collection Report",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Branch: $selectedBranch", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text("Academic Year: $selectedYear", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(
                  width: 200,
                  child: _buildBodyDropdown("Branch", selectedBranch, branches, (v) => setState(() => selectedBranch = v!)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildSection("Tuition Fee"),
            const SizedBox(height: 32),
            _buildSection("Other Fee"),
            const SizedBox(height: 32),
            _buildSection("Transport Fee"),
          ],
        ),
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
            border: Border.all(color: Colors.blue.shade200),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
              style: const TextStyle(fontSize: 11, color: Colors.black),
              selectedItemBuilder: (BuildContext context) {
                return items.map<Widget>((String item) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(item, style: const TextStyle(color: Colors.black)),
                  );
                }).toList();
              },
              items: items.map((it) => DropdownMenuItem(
                value: it,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  color: it == value ? Colors.blue.shade600 : Colors.transparent,
                  child: Text(
                    it,
                    style: TextStyle(
                      color: it == value ? Colors.white : Colors.black,
                      fontSize: 11,
                    ),
                  ),
                ),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
        const SizedBox(height: 12),
        Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFF001A40)),
              children: [
                _buildHeaderCell("Term"),
                _buildHeaderCell("Total Amount"),
                _buildHeaderCell("Paid Amount"),
                _buildHeaderCell("Balance Amount"),
                const SizedBox(),
                const SizedBox(),
              ],
            ),
            _buildDataRow("Term 1", "550,000.00", "50,000.00", "500,000.00"),
            _buildDataRow("Term 2", "550,000.00", "20,000.00", "530,000.00"),
            _buildDataRow("Term 3", "550,000.00", "25,000.00", "525,000.00"),
            TableRow(
              decoration: BoxDecoration(color: Colors.orange.shade50),
              children: [
                _buildDataCell("Total", isBold: true),
                _buildDataCell("1,650,000.00", isBold: true, textAlign: TextAlign.right),
                _buildDataCell("95,000.00", isBold: true, textAlign: TextAlign.right),
                _buildDataCell("1,555,000.00", isBold: true, textAlign: TextAlign.right),
                const SizedBox(),
                const SizedBox(),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: const Text("Previous year fee due students >>", style: TextStyle(fontSize: 10)),
          ),
        ),
      ],
    );
  }

  TableRow _buildDataRow(String term, String total, String paid, String balance) {
    return TableRow(
      children: [
        _buildDataCell(term),
        _buildDataCell(total, textAlign: TextAlign.right),
        _buildDataCell(paid, textAlign: TextAlign.right),
        _buildDataCell(balance, textAlign: TextAlign.right),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF108A62),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 30),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: const Text("Fee Paid Students", style: TextStyle(fontSize: 8)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF1B434),
              foregroundColor: Colors.black,
              elevation: 0,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 30),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: const Text("Fee Due Students", style: TextStyle(fontSize: 8)),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9))),
    );
  }

  Widget _buildDataCell(String text, {TextAlign textAlign = TextAlign.left, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(fontSize: 9, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
