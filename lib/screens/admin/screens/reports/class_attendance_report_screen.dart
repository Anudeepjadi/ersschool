import 'package:flutter/material.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/admin_bottom_nav_bar.dart';

class ClassAttendanceReportScreen extends StatefulWidget {
  const ClassAttendanceReportScreen({super.key});

  @override
  State<ClassAttendanceReportScreen> createState() => _ClassAttendanceReportScreenState();
}

class _ClassAttendanceReportScreenState extends State<ClassAttendanceReportScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedBranch = 'Ecstasy School 1 (ECS001)';
  String selectedClass = 'Grade 1';
  String selectedSection = 'A';
  String selectedMonth = 'Jun-2025';

  final List<String> branches = [
    'Ecstasy School 1 (ECS001)',
    'Ecstay School 2 (ECS002)',
    'Ecstasy (ECS003)',
    'Ecstasy (ECS004)',
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
  final List<String> sections = ['A', 'B', 'C', 'D'];
  final List<String> months = [
    'Jun-2025',
    'Jul-2025',
    'Aug-2025',
    'Sep-2025',
    'Oct-2025',
    'Nov-2025',
    'Dec-2025',
    'Jan-2026',
    'Feb-2026',
    'Mar-2026',
    'Apr-2026',
  ];

  final List<Map<String, String>> _attendanceData = [
    {'name': 'Deepthi', 'father': '', 'class': 'Grade 1', 'section': 'A', 'month': 'Jun - 2026', 'attendance': '3 / 3'},
    {'name': 'Priya', 'father': '', 'class': 'Grade 1', 'section': 'A', 'month': 'Jun - 2026', 'attendance': '3 / 3'},
    {'name': 'suresh', 'father': '', 'class': 'Grade 1', 'section': 'A', 'month': 'Jun - 2026', 'attendance': '3 / 3'},
    {'name': 'Rimsa', 'father': '', 'class': 'Grade 1', 'section': 'A', 'month': 'Jun - 2026', 'attendance': '3 / 3'},
    {'name': 'tony', 'father': '', 'class': 'Grade 1', 'section': 'A', 'month': 'Jun - 2026', 'attendance': '3 / 3'},
    {'name': 'lakshmi', 'father': '', 'class': 'Grade 1', 'section': 'A', 'month': 'Jun - 2026', 'attendance': '3 / 3'},
    {'name': 'Vijaya', 'father': '', 'class': 'Grade 1', 'section': 'A', 'month': 'Jun - 2026', 'attendance': '3 / 3'},
    {'name': 'phani', 'father': '', 'class': 'Grade 1', 'section': 'A', 'month': 'Jun - 2026', 'attendance': '3 / 3'},
    {'name': 'vinitha', 'father': '', 'class': 'Grade 1', 'section': 'A', 'month': 'Jun - 2026', 'attendance': '3 / 3'},
    {'name': 'raju', 'father': '', 'class': 'Grade 1', 'section': 'A', 'month': 'Jun - 2026', 'attendance': '3 / 3'},
    {'name': 'dhurandhar', 'father': '', 'class': 'Grade 1', 'section': 'A', 'month': 'Jun - 2026', 'attendance': '3 / 3'},
    {'name': 'MadiviliNaresh', 'father': '', 'class': 'Grade 1', 'section': 'A', 'month': 'Jun - 2026', 'attendance': '3 / 3'},
    {'name': 'ECSTASY SOLUTIONS PVT LTD', 'father': '', 'class': 'Grade 1', 'section': 'A', 'month': 'Jun - 2026', 'attendance': '3 / 3'},
    {'name': 'Deepthi', 'father': '', 'class': 'Grade 1', 'section': 'A', 'month': 'Jun - 2026', 'attendance': '2 / 3'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "Reports",
        subtitle: "Class Attendance Report",
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
                  const Center(
                    child: Text(
                      "Class Attendance Report",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFilters(),
                  const SizedBox(height: 20),
                  const Text("Class: Grade 1 - A", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                  const SizedBox(height: 12),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: _buildBodyDropdown("Branch", selectedBranch, branches, (v) => setState(() => selectedBranch = v!)),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: _buildBodyDropdown("Class", selectedClass, classes, (v) => setState(() => selectedClass = v!)),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: _buildBodyDropdown("Section", selectedSection, sections, (v) => setState(() => selectedSection = v!)),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: _buildBodyDropdown("Month", selectedMonth, months, (v) => setState(() => selectedMonth = v!)),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFBC5314),
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

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFF001A40)),
        columnSpacing: 60,
        horizontalMargin: 12,
        dividerThickness: 0.5,
        columns: const [
          DataColumn(label: Text("Full Name", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Father Name", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Class", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Section", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Month", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Attendance", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Action", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
        ],
        rows: _attendanceData.map((data) => DataRow(
          cells: [
            DataCell(Text(data['name']!, style: const TextStyle(fontSize: 9))),
            DataCell(Text(data['father']!, style: const TextStyle(fontSize: 9))),
            DataCell(Text(data['class']!, style: const TextStyle(fontSize: 9))),
            DataCell(Text(data['section']!, style: const TextStyle(fontSize: 9))),
            DataCell(Text(data['month']!, style: const TextStyle(fontSize: 9))),
            DataCell(Text(data['attendance']!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
            DataCell(
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.visibility, size: 14, color: Colors.white),
                ),
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
                Text("25", style: TextStyle(fontSize: 10)),
                Icon(Icons.arrow_drop_down, size: 14),
              ],
            ),
          ),
          const SizedBox(width: 24),
          const Text("1 - 14 of 14", style: TextStyle(fontSize: 10)),
          const SizedBox(width: 16),
          const Icon(Icons.first_page, size: 18, color: Colors.grey),
          const Icon(Icons.chevron_left, size: 18, color: Colors.grey),
          const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
          const Icon(Icons.last_page, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}
