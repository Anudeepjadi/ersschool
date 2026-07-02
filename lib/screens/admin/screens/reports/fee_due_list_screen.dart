import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import '../student_management/admin_student_fee_details_screen.dart';

class FeeDueListScreen extends StatefulWidget {
  final String reportTitle;
  const FeeDueListScreen({super.key, required this.reportTitle});

  @override
  State<FeeDueListScreen> createState() => _FeeDueListScreenState();
}

class _FeeDueListScreenState extends State<FeeDueListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  String selectedBranch = 'Ecstasy School 1 (ECS001)';
  String selectedYear = '2025-26';
  String selectedClass = 'All';
  String selectedTerm = 'All';

  // Pagination State
  int itemsPerPage = 50;
  int currentPage = 1;

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

  final List<String> classes = ['All', 'LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];

  final List<String> terms = [
    'All',
    '1',
    '2',
    '3',
  ];

  // Large mock dataset
  late final List<Map<String, String>> _allStudentsData;

  @override
  void initState() {
    super.initState();
    _generateMockData();
  }

  void _generateMockData() {
    _allStudentsData = List.generate(111, (index) {
      final id = index + 1;
      return {
        'adm': 'T25000$id',
        'name': 'Student Name $id',
        'father': 'Father Name $id',
        'class': 'Grade 4 - ${index % 2 == 0 ? 'A' : 'B'}',
        'mobile': '987654321$index',
        'term': '${(index % 3) + 1}',
        'total': '15,000.00',
        'paid': '0.00',
        'balance': '15,000.00'
      };
    });
  }

  List<Map<String, String>> get _paginatedData {
    int start = (currentPage - 1) * itemsPerPage;
    int end = start + itemsPerPage;
    if (end > _allStudentsData.length) end = _allStudentsData.length;
    if (start >= _allStudentsData.length) return [];
    return _allStudentsData.sublist(start, end);
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: 160, child: _buildBodyDropdown("Branch", selectedBranch, branches, (v) => setState(() => selectedBranch = v!))),
          const SizedBox(width: 8),
          SizedBox(width: 120, child: _buildBodyDropdown("Academic Year", selectedYear, years, (v) => setState(() => selectedYear = v!))),
          const SizedBox(width: 8),
          SizedBox(width: 100, child: _buildBodyDropdown("Class", selectedClass, classes, (v) => setState(() => selectedClass = v!))),
          const SizedBox(width: 8),
          SizedBox(width: 100, child: _buildBodyDropdown("Term", selectedTerm, terms, (v) => setState(() => selectedTerm = v!))),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              minimumSize: const Size(60, 38),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text("Search", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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

  Widget _buildSearchAndActions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 200,
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildButton("Export to Excel", Colors.black87),
            _buildButton("Send SMS to all due Students", AppColors.primary),
          ],
        ),
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
          rows: _paginatedData.map((student) => DataRow(
            cells: [
              DataCell(
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminStudentFeeDetailsScreen(
                          student: {
                            'admission': student['adm'],
                            'name': student['name'],
                            'father': student['father'],
                            'class': student['class']?.split(' - ').first ?? 'Grade 4',
                            'section': student['class']?.split(' - ').last ?? 'A',
                            'mobile': student['mobile']?.split(', ').first ?? '',
                          },
                        ),
                      ),
                    );
                  },
                  child: Text(
                    student['adm']!,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
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
      ),
    );
  }

  Widget _buildPaginationFooter() {
    int totalItems = _allStudentsData.length;
    int startIdx = (currentPage - 1) * itemsPerPage + 1;
    int endIdx = currentPage * itemsPerPage;
    if (endIdx > totalItems) endIdx = totalItems;
    if (totalItems == 0) startIdx = 0;

    int totalPages = (totalItems / itemsPerPage).ceil();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.orange.shade50,
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
    );
  }
}
