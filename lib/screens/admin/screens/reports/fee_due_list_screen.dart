import 'package:flutter/material.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/admin_bottom_nav_bar.dart';

class FeeDueListScreen extends StatefulWidget {
  final String reportTitle;
  const FeeDueListScreen({super.key, required this.reportTitle});

  @override
  State<FeeDueListScreen> createState() => _FeeDueListScreenState();
}

class _FeeDueListScreenState extends State<FeeDueListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedBranch = 'Ecstasy School 1 (ECS001)';
  String selectedYear = '2025-26';
  String selectedClass = 'All';
  String selectedTerm = 'All';

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
    'All',
    'Grade 1',
    'Grade 2',
    'Grade 3',
    'Grade 4',
  ];

  final List<String> terms = [
    'All',
    '1',
    '2',
    '3',
  ];

  final List<Map<String, String>> _studentsData = [
    {'adm': 'T250003', 'name': 'Sahoo Shreyansh', 'father': 'father Gyana Ranjan Sahoo', 'class': 'Grade 4 - A', 'mobile': '1182520372, 1082065778', 'term': '1', 'total': '15,000.00', 'paid': '0.00', 'balance': '15,000.00'},
    {'adm': 'T250003', 'name': 'Sahoo Shreyansh', 'father': 'father Gyana Ranjan Sahoo', 'class': 'Grade 4 - A', 'mobile': '1182520372, 1082065778', 'term': '2', 'total': '15,000.00', 'paid': '0.00', 'balance': '15,000.00'},
    {'adm': 'T250003', 'name': 'Sahoo Shreyansh', 'father': 'father Gyana Ranjan Sahoo', 'class': 'Grade 4 - A', 'mobile': '1182520372, 1082065778', 'term': '3', 'total': '14,000.00', 'paid': '0.00', 'balance': '14,000.00'},
    {'adm': 'T250007', 'name': 'Shanvika Srinidhi Tuluma', 'father': 'father Kramthi Kumar Tuluma', 'class': 'Grade 4 - A', 'mobile': '8886216456, 8217701531', 'term': '1', 'total': '15,000.00', 'paid': '0.00', 'balance': '15,000.00'},
    {'adm': 'T250007', 'name': 'Shanvika Srinidhi Tuluma', 'father': 'father Kramthi Kumar Tuluma', 'class': 'Grade 4 - A', 'mobile': '8886216456, 8217701531', 'term': '2', 'total': '15,000.00', 'paid': '0.00', 'balance': '15,000.00'},
    {'adm': 'T250007', 'name': 'Shanvika Srinidhi Tuluma', 'father': 'father Kramthi Kumar Tuluma', 'class': 'Grade 4 - A', 'mobile': '8886216456, 8217701531', 'term': '3', 'total': '14,000.00', 'paid': '0.00', 'balance': '14,000.00'},
    {'adm': 'T250008', 'name': 'V.Laasyavi', 'father': 'father V J Khanna', 'class': 'Grade 4 - A', 'mobile': '1000141345, 1704113221', 'term': '1', 'total': '15,000.00', 'paid': '0.00', 'balance': '15,000.00'},
    {'adm': 'T250008', 'name': 'V.Laasyavi', 'father': 'father V J Khanna', 'class': 'Grade 4 - A', 'mobile': '1000141345, 1704113221', 'term': '2', 'total': '15,000.00', 'paid': '0.00', 'balance': '15,000.00'},
    {'adm': 'T250008', 'name': 'V.Laasyavi', 'father': 'father V J Khanna', 'class': 'Grade 4 - A', 'mobile': '1000141345, 1704113221', 'term': '3', 'total': '14,000.00', 'paid': '0.00', 'balance': '14,000.00'},
    {'adm': 'T250009', 'name': 'Annaluru Dighvitha', 'father': 'father A.Kesava Ram', 'class': 'Grade 4 - A', 'mobile': '8121531207, 1505773813', 'term': '1', 'total': '15,000.00', 'paid': '0.00', 'balance': '15,000.00'},
    {'adm': 'T250009', 'name': 'Annaluru Dighvitha', 'father': 'father A.Kesava Ram', 'class': 'Grade 4 - A', 'mobile': '8121531207, 1505773813', 'term': '2', 'total': '15,000.00', 'paid': '0.00', 'balance': '15,000.00'},
    {'adm': 'T250009', 'name': 'Annaluru Dighvitha', 'father': 'father A.Kesava Ram', 'class': 'Grade 4 - A', 'mobile': '8121531207, 1505773813', 'term': '3', 'total': '14,000.00', 'paid': '0.00', 'balance': '14,000.00'},
    {'adm': 'T2500011', 'name': 'Shaik Aahil', 'father': 'father Nagur Sharif', 'class': 'Grade 4 - B', 'mobile': '1148878712, 1866773522', 'term': '1', 'total': '15,000.00', 'paid': '0.00', 'balance': '15,000.00'},
    {'adm': 'T2500011', 'name': 'Shaik Aahil', 'father': 'father Nagur Sharif', 'class': 'Grade 4 - B', 'mobile': '1148878712, 1866773522', 'term': '2', 'total': '15,000.00', 'paid': '0.00', 'balance': '15,000.00'},
    {'adm': 'T2500011', 'name': 'Shaik Aahil', 'father': 'father Nagur Sharif', 'class': 'Grade 4 - B', 'mobile': '1148878712, 1866773522', 'term': '3', 'total': '14,000.00', 'paid': '0.00', 'balance': '14,000.00'},
    {'adm': 'T2500012', 'name': 'Utala Harija', 'father': 'father Utala Shiva Shankar', 'class': 'Grade 4 - B', 'mobile': '7674188067, 7013551541', 'term': '1', 'total': '15,000.00', 'paid': '0.00', 'balance': '15,000.00'},
    {'adm': 'T2500012', 'name': 'Utala Harija', 'father': 'father Utala Shiva Shankar', 'class': 'Grade 4 - B', 'mobile': '7674188067, 7013551541', 'term': '2', 'total': '15,000.00', 'paid': '0.00', 'balance': '15,000.00'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "Reports",
        subtitle: widget.reportTitle,
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.reportTitle,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFilters(),
                  const SizedBox(height: 16),
                  _buildSearchAndActions(),
                  const SizedBox(height: 16),
                  _buildDataTable(),
                ],
              ),
            ),
          ),
          _buildPaginationFooter(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildBodyDropdown("Branch", selectedBranch, branches, (v) => setState(() => selectedBranch = v!))),
            const SizedBox(width: 16),
            Expanded(child: _buildBodyDropdown("Academic Year", selectedYear, years, (v) => setState(() => selectedYear = v!))),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: _buildBodyDropdown("Class", selectedClass, classes, (v) => setState(() => selectedClass = v!))),
            const SizedBox(width: 16),
            Expanded(child: _buildBodyDropdown("Term", selectedTerm, terms, (v) => setState(() => selectedTerm = v!))),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBC5314),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                minimumSize: const Size(80, 36),
              ),
              child: const Text("Search", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
            const Spacer(),
          ],
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

  Widget _buildSearchAndActions() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: const TextStyle(fontSize: 12),
              isDense: true,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
              suffixIcon: const Icon(Icons.search, color: Colors.green),
            ),
          ),
        ),
        const Spacer(),
        _buildButton("Export to Excel", Colors.black87),
        const SizedBox(width: 8),
        _buildButton("Send SMS to all due Students", const Color(0xFFBC5314)),
      ],
    );
  }

  Widget _buildButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Processing: $text")));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 10)),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFF001A40)),
        columnSpacing: 20,
        horizontalMargin: 12,
        dividerThickness: 0.5,
        columns: const [
          DataColumn(label: Text("Admission No", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Full Name", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Father Name", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Class", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Mobile", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Term", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Term Amount", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Paid Amount", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Balance Amount", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Action", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
        ],
        rows: _studentsData.map((student) => DataRow(
          cells: [
            DataCell(Text(student['adm']!, style: const TextStyle(fontSize: 9, color: Colors.blue, decoration: TextDecoration.underline))),
            DataCell(Text(student['name']!, style: const TextStyle(fontSize: 9))),
            DataCell(Text(student['father']!, style: const TextStyle(fontSize: 9))),
            DataCell(Text(student['class']!, style: const TextStyle(fontSize: 9))),
            DataCell(Text(student['mobile']!, style: const TextStyle(fontSize: 9))),
            DataCell(Text(student['term']!, style: const TextStyle(fontSize: 9))),
            DataCell(Text(student['total']!, style: const TextStyle(fontSize: 9))),
            DataCell(Text(student['paid']!, style: const TextStyle(fontSize: 9, color: Colors.green))),
            DataCell(Text(student['balance']!, style: const TextStyle(fontSize: 9, color: Colors.red))),
            DataCell(
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sending SMS to ${student['name']}")));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF1B434),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(44, 26),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: const Text("SMS", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        )).toList(),
      ),
    );
  }

  Widget _buildPaginationFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.orange.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text("Items per page:", style: TextStyle(fontSize: 10)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: Row(
              children: const [
                Text("50", style: TextStyle(fontSize: 10)),
                Icon(Icons.arrow_drop_down, size: 14),
              ],
            ),
          ),
          const SizedBox(width: 24),
          const Text("1 - 50 of 111", style: TextStyle(fontSize: 10)),
          const SizedBox(width: 16),
          const Icon(Icons.first_page, size: 18, color: Colors.grey),
          const Icon(Icons.chevron_left, size: 18, color: Colors.grey),
          const Icon(Icons.chevron_right, size: 18),
          const Icon(Icons.last_page, size: 18),
        ],
      ),
    );
  }
}
