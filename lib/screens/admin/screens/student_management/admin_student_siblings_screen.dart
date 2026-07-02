import 'package:flutter/material.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import '../../widgets/admin_app_bar.dart';

class AdminStudentSiblingsScreen extends StatefulWidget {
  const AdminStudentSiblingsScreen({super.key});

  @override
  State<AdminStudentSiblingsScreen> createState() => _AdminStudentSiblingsScreenState();
}

class _AdminStudentSiblingsScreenState extends State<AdminStudentSiblingsScreen> {
  int _currentPage = 1;
  int _itemsPerPage = 25;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  String _selectedBranch = 'Ecstasy School 1 (ECS001)';
  String _selectedYear = '2025-26';
  String _selectedStatus = 'Only Active';
  String _selectedClass = 'LKG';
  String _selectedSection = 'All';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _dummyData = [
    {
      'admission': 'T2500041',
      'name': 'Nallam Sainath',
      'father': 'Father N.Trinadh',
      'gender': 'Male',
      'class': 'Grade 2 - A',
      'mobile': '8712221571',
      'active': 'True',
      'siblings': [
        {'name': 'Nallam Bala Bhuvan Aasrith', 'gender': 'Male', 'class': 'Grade 2 - A', 'active': 'True', 'branch': 'Ecstasy School 1'}
      ]
    },
    {
      'admission': 'O2600062',
      'name': 'Mallempudi Bhuhari Siva Manikanta',
      'father': 'Mallempudi Suribabu',
      'gender': 'Male',
      'class': 'Grade 2 - A',
      'mobile': '8765432199',
      'active': 'True',
      'siblings': [
        {'name': 'Mallempudi Leela Saranya', 'gender': 'Female', 'class': 'Grade 2 - A', 'active': 'True', 'branch': 'Ecstasy School 1'}
      ]
    },
    {
      'admission': 'O2600066',
      'name': 'Mallempudi Bhuhari Siva Manikanta',
      'father': 'Mallempudi Suribabu',
      'gender': 'Male',
      'class': 'Grade 2 - A',
      'mobile': '8765432199',
      'active': 'True',
      'siblings': [
        {'name': 'Mallempudi Leela Saranya', 'gender': 'Female', 'class': 'Grade 2 - A', 'active': 'True', 'branch': 'Ecstasy School 1'}
      ]
    },
    {
      'admission': 'O2600078',
      'name': 'ECSTASY SOLUTIONS PVT LTD',
      'father': '',
      'gender': 'Male',
      'class': 'Grade 1 - A',
      'mobile': '7075768117',
      'active': 'True',
      'siblings': [
        {'name': 'Srishti Paiyala', 'gender': 'Female', 'class': 'Grade 3 - A', 'active': 'True', 'branch': 'Ecstasy School 1'}
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fieldWidth = screenWidth > 600 ? 250 : screenWidth - 32;

    return Scaffold(
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "Student Siblings".tr,
        subtitle: "Manage student siblings",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [


            // Filters Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(width: fieldWidth, child: _buildFilterDropdown("Branch", _selectedBranch, ["All Branches", "Ecstasy School 1 (ECS001)", "Ecstasy School 2 (ECS002)", "Ecstasy (ECS003)", "Ecstasy (ECS004)"], (val) => setState(() => _selectedBranch = val!))),
                      SizedBox(width: fieldWidth, child: _buildFilterDropdown("Academic Year", _selectedYear, ["All", "2025-26"], (val) => setState(() => _selectedYear = val!))),
                      SizedBox(width: fieldWidth, child: _buildFilterDropdown("Active / Inactive", _selectedStatus, ["All students", "Only Active", "Only Inactive"], (val) => setState(() => _selectedStatus = val!))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      SizedBox(width: fieldWidth, child: _buildFilterDropdown("Class", _selectedClass, ['All', 'LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'], (val) => setState(() => _selectedClass = val!))),
                      SizedBox(width: fieldWidth, child: _buildFilterDropdown("Section", _selectedSection, ["All", "A", "B", "C"], (val) => setState(() => _selectedSection = val!))),
                      SizedBox(
                        width: fieldWidth,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Searching...".tr)));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            child: Text("Search".tr, style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Search Bar and Print Button
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: constraints.maxWidth > 500 ? 300 : constraints.maxWidth),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search".tr,
                          suffixIcon: const Icon(Icons.search, color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                            _currentPage = 1;
                          });
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Print dialog mock".tr)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Text("Print".tr, style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                );
              }
            ),
            const SizedBox(height: 16),

            // Custom DataTable layout
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SizedBox(
                  width: 1300, // force wide layout
                  child: Column(
                    children: [
                      // Header
                      Container(
                        color: AppColors.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Row(
                          children: [
                            _buildHeaderCell("Admission\nNo", 90),
                            _buildHeaderCell("Student Name", 200),
                            _buildHeaderCell("Father Name", 150),
                            _buildHeaderCell("Gender", 80),
                            _buildHeaderCell("Class", 100),
                            _buildHeaderCell("Mobile", 100),
                            _buildHeaderCell("Active", 60),
                            Expanded(child: _buildHeaderCell("", 0)), // placeholder for right block
                          ],
                        ),
                      ),
                      // Data Rows
                      ..._getPaginatedData().map((data) => _buildDataRow(data)),
                    ],
                  ),
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
                  onPressed: () { if (_scrollController.hasClients) _scrollController.animateTo(_scrollController.offset - 250, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut); },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_circle_right_outlined, color: AppColors.primary),
                  onPressed: () { if (_scrollController.hasClients) _scrollController.animateTo(_scrollController.offset + 250, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut); },
                ),
              ],
            ),

            // Pagination Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                border: Border(
                  left: BorderSide(color: Colors.grey.shade300),
                  right: BorderSide(color: Colors.grey.shade300),
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  Text("Items per page:".tr, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: _itemsPerPage,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 2, child: Text("2", style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 25, child: Text("25", style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 50, child: Text("50", style: TextStyle(fontSize: 12))),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() { _itemsPerPage = val; _currentPage = 1; });
                    },
                  ),
                  const SizedBox(width: 24),
                  Text("$_currentPage of ${(_filteredData.length / _itemsPerPage).ceil() == 0 ? 1 : (_filteredData.length / _itemsPerPage).ceil()}".tr, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: _currentPage > 1 ? () => setState(() => _currentPage = 1) : null,
                    child: Icon(Icons.first_page, size: 20, color: _currentPage > 1 ? Colors.black87 : Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                    child: Icon(Icons.chevron_left, size: 20, color: _currentPage > 1 ? Colors.black87 : Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _currentPage < (_filteredData.length / _itemsPerPage).ceil() ? () => setState(() => _currentPage++) : null,
                    child: Icon(Icons.chevron_right, size: 20, color: _currentPage < (_filteredData.length / _itemsPerPage).ceil() ? Colors.black87 : Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _currentPage < (_filteredData.length / _itemsPerPage).ceil() ? () => setState(() => _currentPage = (_filteredData.length / _itemsPerPage).ceil()) : null,
                    child: Icon(Icons.last_page, size: 20, color: _currentPage < (_filteredData.length / _itemsPerPage).ceil() ? Colors.black87 : Colors.grey),
                  ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                "V6.0 Developed by Ecstasy Consulting And Solutions Pvt Ltd.\nCopyright © 2026 All rights reserved",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredData {
    if (_searchQuery.isEmpty) return _dummyData;
    final query = _searchQuery.toLowerCase();
    return _dummyData.where((student) {
      return student.values.any((val) => val.toString().toLowerCase().contains(query));
    }).toList();
  }

  List<Map<String, dynamic>> _getPaginatedData() {
    final filtered = _filteredData;
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    if (startIndex >= filtered.length) return [];
    if (endIndex > filtered.length) endIndex = filtered.length;
    return filtered.sublist(startIndex, endIndex);
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text.tr,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget _buildDataRow(Map<String, dynamic> data) {
    final siblings = data['siblings'] as List<Map<String, dynamic>>;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left main student info
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                children: [
                  SizedBox(width: 90, child: Text(data['admission'], style: const TextStyle(fontSize: 12, color: AppColors.primaryDark))),
                  SizedBox(width: 200, child: Text(data['name'], style: const TextStyle(fontSize: 12, color: AppColors.primaryDark))),
                  SizedBox(width: 150, child: Text(data['father'], style: const TextStyle(fontSize: 12, color: AppColors.primaryDark))),
                  SizedBox(width: 80, child: Text(data['gender'], style: const TextStyle(fontSize: 12, color: AppColors.primaryDark))),
                  SizedBox(width: 100, child: Text(data['class'], style: const TextStyle(fontSize: 12, color: AppColors.primaryDark))),
                  SizedBox(width: 100, child: Text(data['mobile'], style: const TextStyle(fontSize: 12, color: AppColors.primaryDark))),
                  SizedBox(width: 60, child: Text(data['active'], style: const TextStyle(fontSize: 12, color: AppColors.primaryDark))),
                ],
              ),
            ),
            // Right sibling info block
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Column(
                  children: siblings.map((sib) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSiblingRow("Name:", sib['name']),
                          const SizedBox(height: 4),
                          _buildSiblingRow("Gender:", sib['gender']),
                          const SizedBox(height: 4),
                          _buildSiblingRow("Class:", sib['class']),
                          const SizedBox(height: 4),
                          _buildSiblingRow("Active:", sib['active']),
                          const SizedBox(height: 4),
                          _buildSiblingRow("Branch:", sib['branch']),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSiblingRow(String label, String value) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12, color: Colors.black87))),
      ],
    );
  }
}
