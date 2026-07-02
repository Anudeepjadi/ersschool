import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import '../admin_attendance_screen.dart';
import '../student_management/admin_student_attendance_report_screen.dart';

class ClassAttendanceReportScreen extends StatefulWidget {
  const ClassAttendanceReportScreen({super.key});

  @override
  State<ClassAttendanceReportScreen> createState() => _ClassAttendanceReportScreenState();
}

class _ClassAttendanceReportScreenState extends State<ClassAttendanceReportScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  String selectedBranch = 'Ecstasy School 1 (ECS001)';
  String selectedClass = 'LKG';
  String selectedSection = 'A';
  String selectedMonth = 'Jun-2025';

  // Pagination State
  int itemsPerPage = 25;
  int currentPage = 1;

  final List<String> branches = [
    'Ecstasy School 1 (ECS001)',
    'Ecstay School 2 (ECS002)',
    'Ecstasy (ECS003)',
    'Ecstasy (ECS004)',
  ];
  final List<String> classes = ['LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
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

  List<Map<String, dynamic>> get _allAttendanceData {
    return AdminAttendanceScreen.students.map((student) {
      final isPresent = student['isPresent'] as bool;
      final fatherName = student['father']?.toString() ?? '';

      return {
        'name': student['name'] as String,
        'father': fatherName,
        'class': selectedClass,
        'section': selectedSection,
        'month': selectedMonth,
        'attendance': isPresent ? '3 / 3' : '2 / 3',
        'student': student, // Store original object
      };
    }).toList();
  }

  List<Map<String, dynamic>> get _paginatedAttendanceData {
    final allData = _allAttendanceData;
    int start = (currentPage - 1) * itemsPerPage;
    int end = start + itemsPerPage;
    if (end > allData.length) end = allData.length;
    if (start >= allData.length) return [];
    return allData.sublist(start, end);
  }

  @override
  void initState() {
    super.initState();
    AdminAttendanceScreen.loadStudents().then((_) {
      if (mounted) setState(() {});
    });
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 180,
            child: _buildBodyDropdown("Branch", selectedBranch, branches, (v) => setState(() => selectedBranch = v!)),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: _buildBodyDropdown("Class", selectedClass, classes, (v) => setState(() => selectedClass = v!)),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: _buildBodyDropdown("Section", selectedSection, sections, (v) => setState(() => selectedSection = v!)),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: _buildBodyDropdown("Month", selectedMonth, months, (v) => setState(() => selectedMonth = v!)),
          ),
          const SizedBox(width: 12),
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

  Widget _buildDataTable() {
    final dataList = _paginatedAttendanceData;
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
        rows: dataList.map((data) => DataRow(
          cells: [
            DataCell(Text(data['name']?.toString() ?? '', style: const TextStyle(fontSize: 9))),
            DataCell(Text(data['father']?.toString() ?? '', style: const TextStyle(fontSize: 9))),
            DataCell(Text(data['class']?.toString() ?? '', style: const TextStyle(fontSize: 9))),
            DataCell(Text(data['section']?.toString() ?? '', style: const TextStyle(fontSize: 9))),
            DataCell(Text(data['month']?.toString() ?? '', style: const TextStyle(fontSize: 9))),
            DataCell(Text(data['attendance']?.toString() ?? '', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
            DataCell(
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminStudentAttendanceReportScreen(
                        student: data['student'] as Map<String, dynamic>,
                      ),
                    ),
                  );
                },
                child: Container(
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
            ),
          ],
        )).toList(),
      ),
    ));
  }

  Widget _buildPaginationFooter() {
    int totalItems = AdminAttendanceScreen.students.length;
    int startIdx = totalItems == 0 ? 0 : (currentPage - 1) * itemsPerPage + 1;
    int endIdx = currentPage * itemsPerPage;
    if (endIdx > totalItems) endIdx = totalItems;

    int totalPages = (totalItems / itemsPerPage).ceil();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.orange.shade50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Items per page:", style: TextStyle(fontSize: 10)),
            const SizedBox(width: 8),
            PopupMenuButton<int>(
              onSelected: (value) {
                setState(() {
                  itemsPerPage = value;
                  currentPage = 1;
                });
              },
              itemBuilder: (context) => [10, 25, 50, 100].map((int val) => PopupMenuItem<int>(
                value: val,
                child: Text("$val", style: const TextStyle(fontSize: 11)),
              )).toList(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Text("$itemsPerPage", style: const TextStyle(fontSize: 10)),
                    const Icon(Icons.arrow_drop_down, size: 14),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            Text("$startIdx - $endIdx of $totalItems", style: const TextStyle(fontSize: 10)),
            const SizedBox(width: 16),
            IconButton(
              onPressed: currentPage > 1 ? () => setState(() => currentPage = 1) : null,
              icon: Icon(Icons.first_page, size: 18, color: currentPage > 1 ? Colors.black87 : Colors.grey),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: currentPage > 1 ? () => setState(() => currentPage--) : null,
              icon: Icon(Icons.chevron_left, size: 18, color: currentPage > 1 ? Colors.black87 : Colors.grey),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: currentPage < totalPages ? () => setState(() => currentPage++) : null,
              icon: Icon(Icons.chevron_right, size: 18, color: currentPage < totalPages ? Colors.black87 : Colors.grey),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: currentPage < totalPages ? () => setState(() => currentPage = totalPages) : null,
              icon: Icon(Icons.last_page, size: 18, color: currentPage < totalPages ? Colors.black87 : Colors.grey),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
