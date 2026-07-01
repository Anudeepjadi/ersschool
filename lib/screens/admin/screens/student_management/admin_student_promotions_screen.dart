import 'package:flutter/material.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import '../../widgets/admin_app_bar.dart';

class AdminStudentPromotionsScreen extends StatefulWidget {
  const AdminStudentPromotionsScreen({super.key});

  @override
  State<AdminStudentPromotionsScreen> createState() => _AdminStudentPromotionsScreenState();
}

class _AdminStudentPromotionsScreenState extends State<AdminStudentPromotionsScreen> {
  int _currentPage = 1;
  int _itemsPerPage = 25;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  String _selectedBranch = 'Ecstasy School 1 (ECS001)';
  String _selectedAcademicYear = '2025-26';
  String _selectedClass = 'All';
  String _selectedSection = 'All';
  String _searchQuery = '';
  bool _selectAll = false;

  final List<Map<String, dynamic>> _dummyData = [
    {'admission': 'T2500032', 'name': 'Yanda Chandraditya', 'gender': 'Male', 'year': '2025-26', 'class': 'LKG', 'section': 'B', 'selected': false, 'promoteYear': '2026-27', 'promoteClass': 'Grade 2 - B'},
    {'admission': 'O2600045', 'name': 'Sri Vardhan', 'gender': 'Male', 'year': '2025-26', 'class': 'LKG', 'section': 'A', 'selected': false, 'promoteYear': '2026-27', 'promoteClass': 'Grade 2 - A'},
    {'admission': 'O2600046', 'name': 'Deepthi', 'gender': 'Female', 'year': '2025-26', 'class': 'LKG', 'section': 'A', 'selected': false, 'promoteYear': '2026-27', 'promoteClass': 'Grade 2 - A'},
    {'admission': 'O2600047', 'name': 'Priya', 'gender': 'Female', 'year': '2025-26', 'class': 'LKG', 'section': 'A', 'selected': false, 'promoteYear': '2026-27', 'promoteClass': 'Grade 2 - A'},
    {'admission': 'O2600048', 'name': 'Deepthi', 'gender': 'Female', 'year': '2025-26', 'class': 'LKG', 'section': 'A', 'selected': false, 'promoteYear': '2026-27', 'promoteClass': 'Grade 2 - A'},
    {'admission': 'O2600049', 'name': 'Suresh', 'gender': 'Male', 'year': '2025-26', 'class': 'LKG', 'section': 'A', 'selected': false, 'promoteYear': '2026-27', 'promoteClass': 'Grade 2 - A'},
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fieldWidth = screenWidth > 600 ? 250 : screenWidth - 32;
    double searchWidth = screenWidth > 600 ? 300 : screenWidth - 32;

    return Scaffold(
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "Student Promotions".tr,
        subtitle: "Promote students to next class",
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
                      SizedBox(
                        width: fieldWidth,
                        child: _buildFilterDropdown("Branch", _selectedBranch, ["All Branches", "Ecstasy School 1 (ECS001)", "Ecstasy School 2 (ECS002)", "Ecstasy (ECS003)", "Ecstasy (ECS004)"], (val) {
                          setState(() => _selectedBranch = val!);
                        }),
                      ),
                      SizedBox(
                        width: fieldWidth,
                        child: _buildFilterDropdown("Academic Year", _selectedAcademicYear, ["All", "2025-26"], (val) {
                          setState(() => _selectedAcademicYear = val!);
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      SizedBox(
                        width: fieldWidth,
                        child: _buildFilterDropdown("Class", _selectedClass, ['All', 'LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'], (val) {
                          setState(() => _selectedClass = val!);
                        }),
                      ),
                      SizedBox(
                        width: fieldWidth,
                        child: _buildFilterDropdown("Section", _selectedSection, ["All", "A", "B", "C"], (val) {
                          setState(() => _selectedSection = val!);
                        }),
                      ),
                      SizedBox(
                        width: fieldWidth,
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
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Search Bar and Promote Button
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: searchWidth,
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
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Selected students promoted!".tr)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Text("Promote Selected".tr, style: const TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("All grades promoted successfully!".tr)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Text("Promote All Grades".tr, style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // DataTable
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
                    child: DataTable(
                      border: TableBorder.all(color: Colors.grey.shade300),
                      headingRowColor: WidgetStateProperty.all(AppColors.primaryDark),
                      dataRowColor: WidgetStateProperty.resolveWith<Color>((states) {
                        return Colors.white;
                      }),
                      headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      dataTextStyle: const TextStyle(color: AppColors.primaryDark, fontSize: 13),
                      columns: [
                        DataColumn(
                          label: Checkbox(
                        value: _selectAll,
                        onChanged: (val) {
                          setState(() {
                            _selectAll = val ?? false;
                            for (var item in _dummyData) {
                              item['selected'] = _selectAll;
                            }
                          });
                        },
                        checkColor: Colors.white,
                        activeColor: AppColors.primary,
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                    DataColumn(label: Text("Admission No".tr)),
                    DataColumn(label: Text("Student Name".tr)),
                    DataColumn(label: Text("Gender".tr)),
                    DataColumn(label: Text("Current Year".tr)),
                    DataColumn(label: Text("Current Class".tr)),
                    DataColumn(label: Text("Current Section".tr)),
                    DataColumn(label: Text("Promote Year".tr)),
                    DataColumn(label: Text("Promote Class".tr)),
                  ],
                  rows: _getPaginatedData().map((data) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Checkbox(
                            value: data['selected'],
                            onChanged: (val) {
                              setState(() {
                                data['selected'] = val ?? false;
                                _selectAll = _dummyData.every((item) => item['selected']);
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                        ),
                        DataCell(Text(data['admission'], style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline))),
                        DataCell(Text(data['name'])),
                        DataCell(Text(data['gender'])),
                        DataCell(Text(data['year'])),
                        DataCell(Text(data['class'])),
                        DataCell(Text(data['section'])),
                        DataCell(
                          SizedBox(
                            width: 120,
                            child: _buildSmallDropdown(data['promoteYear'], ["2026-27"], (val) {
                              setState(() => data['promoteYear'] = val!);
                            }),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 140,
                            child: _buildSmallDropdown(data['promoteClass'], [
                              "Passed out",
                              "Grade 1 - A",
                              "Grade 1 - B",
                              "Grade 1 - c",
                              "Grade 1 - D",
                              "Grade 2 - A",
                              "Grade 2 - B",
                              "Grade 2 - C",
                              "Grade 3 - A",
                              "Grade 3 - B",
                              "Grade 3 - C",
                              "Grade 3 - D",
                              "Grade 3 - tagore",
                              "Grade 4 - A",
                              "Grade 4 - B",
                              "Grade 4 - C",
                              "batch1 - grade1",
                            ], (val) {
                              setState(() => data['promoteClass'] = val!);
                            }),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
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

  Widget _buildSmallDropdown(String value, List<String> items, Function(String?) onChanged) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 16),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 12)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
