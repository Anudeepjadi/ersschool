import 'package:flutter/material.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/admin_bottom_nav_bar.dart';

class FeeStructureReportScreen extends StatefulWidget {
  const FeeStructureReportScreen({super.key});

  @override
  State<FeeStructureReportScreen> createState() => _FeeStructureReportScreenState();
}

class _FeeStructureReportScreenState extends State<FeeStructureReportScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedBranch = 'Ecstasy School 1 (ECS001)';
  String selectedYear = '2025-26';
  String selectedClass = 'Grade 1';

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

  final List<String> classes = [
    'Grade 1',
    'Grade 2',
    'Grade 3',
    'Grade 4',
    'batch1',
    'Grade 5',
    'Grade 6',
    'grade 7',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "Reports",
        subtitle: "Fee Structure",
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Fee Structure for Class",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            _buildFilters(),
            const SizedBox(height: 20),
            
            _buildMainFeeTable(),
            const SizedBox(height: 32),
            
            const Text(
              "Term Fee Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTermFeeTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildDropdown("Branch", selectedBranch, branches, (v) => setState(() => selectedBranch = v!))),
            const SizedBox(width: 8),
            Expanded(child: _buildDropdown("Academic Year", selectedYear, years, (v) => setState(() => selectedYear = v!))),
            const SizedBox(width: 8),
            Expanded(child: _buildDropdown("Class", selectedClass, classes, (v) => setState(() => selectedClass = v!))),
          ],
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBC5314),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              minimumSize: const Size(120, 44),
            ),
            child: const Text("Get Fee Details", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
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

  Widget _buildMainFeeTable() {
    final List<Map<String, String>> data = [
      {'branch': 'Ecstasy School 1 (ECS001)', 'year': '2025-26', 'class': 'Grade 1', 'type': 'Registration Fee', 'amount': '3,000.00'},
      {'branch': 'Ecstasy School 1 (ECS001)', 'year': '2025-26', 'class': 'Grade 1', 'type': 'Activity Fee', 'amount': '6,000.00'},
      {'branch': 'Ecstasy School 1 (ECS001)', 'year': '2025-26', 'class': 'Grade 1', 'type': 'Tuition Fee', 'amount': '38,000.00'},
      {'branch': 'Ecstasy School 1 (ECS001)', 'year': '2025-26', 'class': 'Grade 1', 'type': 'books fee', 'amount': '11,000.00'},
      {'branch': 'Ecstasy School 1 (ECS001)', 'year': '2025-26', 'class': 'Grade 1', 'type': 'residential', 'amount': '4,000.00'},
      {'branch': 'Ecstasy School 1 (ECS001)', 'year': '2025-26', 'class': 'Grade 1', 'type': 'hostel', 'amount': '5,000.00'},
    ];

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFF001A40)),
          children: [
            _buildHeaderCell("Branch"),
            _buildHeaderCell("Academic Year"),
            _buildHeaderCell("Class"),
            _buildHeaderCell("Fee Type"),
            _buildHeaderCell("Fee Amount"),
          ],
        ),
        ...data.map((it) => TableRow(
          children: [
            _buildDataCell(it['branch']!),
            _buildDataCell(it['year']!),
            _buildDataCell(it['class']!),
            _buildDataCell(it['type']!),
            _buildDataCell(it['amount']!, textAlign: TextAlign.right),
          ],
        )),
        TableRow(
          decoration: BoxDecoration(color: Colors.orange.shade50),
          children: [
            const SizedBox(),
            const SizedBox(),
            const SizedBox(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Total Fee", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            ),
            _buildDataCell("71,000.00", textAlign: TextAlign.right, isBold: true),
          ],
        )
      ],
    );
  }

  Widget _buildTermFeeTable() {
    return SizedBox(
      width: 300,
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFF001A40)),
            children: [
              _buildHeaderCell("Term"),
              _buildHeaderCell("Amount"),
              _buildHeaderCell("Due Date"),
            ],
          ),
          _buildTermRow("Term 1", "13,000.00", "12/6/2025"),
          _buildTermRow("Term 2", "13,000.00", "1/9/2025"),
          _buildTermRow("Term 3", "12,000.00", "1/12/2025"),
        ],
      ),
    );
  }

  TableRow _buildTermRow(String t, String a, String d) {
    return TableRow(
      children: [
        _buildDataCell(t),
        _buildDataCell(a, textAlign: TextAlign.right),
        _buildDataCell(d),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))),
    );
  }

  Widget _buildDataCell(String text, {TextAlign textAlign = TextAlign.left, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(fontSize: 10, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
