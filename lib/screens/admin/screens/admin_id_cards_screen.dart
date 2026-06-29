import 'package:flutter/material.dart';
import 'dart:io';
import 'package:ersschool/core/theme/app_colors.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/data/app_data_store.dart';
import 'package:ersschool/core/utils/profile_manager.dart';
import '../widgets/admin_app_bar.dart';
import 'student_management/admin_student_id_card_print_screen.dart';

class AdminIDCardsScreen extends StatefulWidget {
  const AdminIDCardsScreen({super.key});

  @override
  State<AdminIDCardsScreen> createState() => _AdminIDCardsScreenState();
}

class _AdminIDCardsScreenState extends State<AdminIDCardsScreen> {
  String _selectedBranch = 'Ecstasy School 1 (ECS001)';
  String _selectedYear = '2025-26';
  String _selectedStatus = 'Only Active';
  String _selectedClass = 'Grade 1';
  String _selectedSection = 'All';
  String _searchQuery = '';
  bool _selectAll = false;
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  int _itemsPerPage = 25;

  List<Map<String, dynamic>> get _students => AppDataStore.instance.students
      .where((s) => s['school'] == ProfileManager().selectedSchool.value)
      .toList();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fieldWidth = screenWidth > 600 ? 250 : screenWidth - 32;
    double searchWidth = screenWidth > 600 ? 300 : screenWidth - 32;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "Student ID Cards".tr,
        subtitle: "Generate student ID cards",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Filters Row
            Column(
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(width: fieldWidth, child: _buildFilterDropdown("Branch", _selectedBranch, ["All Branches", "Ecstasy School 1 (ECS001)", "Ecstasy School 2 (ECS002)", "Ecstasy (ECS003)", "Ecstasy (ECS004)"], (val) => setState(() => _selectedBranch = val!))),
                    SizedBox(width: fieldWidth, child: _buildFilterDropdown("Academic Year", _selectedYear, ["2025-26"], (val) => setState(() => _selectedYear = val!))),
                    SizedBox(width: fieldWidth, child: _buildFilterDropdown("Active / Inactive", _selectedStatus, ["All students", "Only Active", "Only Inactive"], (val) => setState(() => _selectedStatus = val!))),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    SizedBox(width: fieldWidth, child: _buildFilterDropdown("Class", _selectedClass, ["All", "L.K.G", "U.K.G", "Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5", "Grade 6", "Grade 7", "Grade 8", "Grade 9", "Class 10"], (val) => setState(() => _selectedClass = val!))),
                    SizedBox(width: fieldWidth, child: _buildFilterDropdown("Section", _selectedSection, ["All", "A", "B", "C"], (val) => setState(() => _selectedSection = val!))),
                    SizedBox(
                      width: fieldWidth,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {},
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
            const SizedBox(height: 16),

            // Second Row (Search + Action Buttons)
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: searchWidth,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search students".tr,
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
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ElevatedButton(
                      onPressed: () => _showDownloadDialog(targetName: "selected students"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Text("Download Selected ID Cards".tr, style: const TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () => _showDownloadDialog(targetName: "all students"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success, // green
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Text("Download All ID Cards".tr, style: const TextStyle(color: Colors.white)),
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
                            for (var item in _filteredData) {
                              item['selected'] = _selectAll;
                            }
                          });
                        },
                        checkColor: Colors.white,
                        activeColor: AppColors.primary,
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                    DataColumn(label: const Text("")), // Avatar placeholder
                    DataColumn(label: Text("Student Name".tr)),
                    DataColumn(label: Text("Father Name".tr)),
                    DataColumn(label: Text("Mother Name".tr)),
                    DataColumn(label: Text("Gender".tr)),
                    DataColumn(label: Text("Class".tr)),
                    DataColumn(label: Text("Section".tr)),
                    DataColumn(label: Text("Mobile".tr)),
                    DataColumn(label: Text("Mobile 2".tr)),
                    DataColumn(label: Text("Address".tr)),
                    DataColumn(label: const Text("")), // Action
                  ],
                  rows: _getPaginatedData().map((data) {
                    final photoPath = data['photoPath'];
                    return DataRow(
                      cells: [
                        DataCell(
                          Checkbox(
                            value: data['selected'] ?? false,
                            onChanged: (val) {
                              setState(() {
                                data['selected'] = val ?? false;
                              _selectAll = _filteredData.every((item) => item['selected'] == true);
                            });
                            },
                            activeColor: AppColors.primary,
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: photoPath != null && File(photoPath).existsSync()
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.file(File(photoPath), fit: BoxFit.cover),
                                  )
                                : const Icon(Icons.person, color: Colors.white, size: 20),
                          ),
                        ),
                        DataCell(Text(data['name'] ?? "")),
                        DataCell(Text(data['father'] ?? "")),
                        DataCell(Text(data['mother'] ?? "")),
                        DataCell(Text(data['gender'] ?? "")),
                        DataCell(Text(data['class'] ?? "")),
                        DataCell(Text(data['section'] ?? "A")),
                        DataCell(Text(data['mobile'] ?? data['phone'] ?? "")),
                        DataCell(Text(data['secondary_mobile'] ?? "")),
                        DataCell(Text(data['address'] ?? "")),
                        DataCell(
                          InkWell(
                            onTap: () => _showDownloadDialog(studentData: data),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.success, // green
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.download, color: Colors.white, size: 16),
                            ),
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
                color: const Color(0xFFFDE6D2), // light orange
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "Total Records: ${_filteredData.length}".tr,
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Items per page:".tr, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _itemsPerPage,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 25, child: Text("25", style: TextStyle(fontSize: 12))),
                            DropdownMenuItem(value: 50, child: Text("50", style: TextStyle(fontSize: 12))),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() { _itemsPerPage = val; _currentPage = 1; });
                          },
                        ),
                        const SizedBox(width: 24),
                        Text("$_currentPage - ${(_filteredData.length / _itemsPerPage).ceil() == 0 ? 1 : (_filteredData.length / _itemsPerPage).ceil()} of ${_filteredData.length}".tr, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: _currentPage > 1 ? () => setState(() => _currentPage = 1) : null,
                          child: Icon(Icons.first_page, size: 20, color: _currentPage > 1 ? Colors.black87 : Colors.black26),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                          child: Icon(Icons.chevron_left, size: 20, color: _currentPage > 1 ? Colors.black87 : Colors.black26),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: _currentPage < (_filteredData.length / _itemsPerPage).ceil() ? () => setState(() => _currentPage++) : null,
                          child: Icon(Icons.chevron_right, size: 20, color: _currentPage < (_filteredData.length / _itemsPerPage).ceil() ? Colors.black87 : Colors.black26),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: _currentPage < (_filteredData.length / _itemsPerPage).ceil() ? () => setState(() => _currentPage = (_filteredData.length / _itemsPerPage).ceil()) : null,
                          child: Icon(Icons.last_page, size: 20, color: _currentPage < (_filteredData.length / _itemsPerPage).ceil() ? Colors.black87 : Colors.black26),
                        ),
                      ],
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
    final students = _students;
    if (_searchQuery.isEmpty) return students;
    final query = _searchQuery.toLowerCase();
    return students.where((student) {
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
          height: 40,
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(item, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  void _showDownloadDialog({String? targetName, Map<String, dynamic>? studentData}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Confirm download".tr,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (studentData != null) _buildIdCardPreview(studentData),
              if (studentData != null) const SizedBox(height: 16),
              Text(
                "Are you sure you want to download ID card for ${targetName ?? studentData?['name'] ?? ''} ?".tr,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade500,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: Text("No".tr, style: const TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                if (studentData != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminStudentIdCardPrintScreen(studentData: studentData),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Batch download feature coming soon...".tr)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: Text("Yes, Download".tr, style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIdCardPreview(Map<String, dynamic> studentData) {
    final photo = studentData['avatar'] ?? studentData['photoPath'];
    final bool hasValidPhoto = photo != null && File(photo.toString()).existsSync();
    final headerColor = Colors.blue.shade800;
    
    return Container(
      width: 350, // Increased from 320 to 350 for better visibility
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.school, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ProfileManager().selectedSchool.value.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      const Text("Shaping Futures, Building Tomorrow", style: TextStyle(color: Colors.white70, fontSize: 8)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Info body
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: hasValidPhoto
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(File(photo.toString()), fit: BoxFit.cover),
                        )
                      : const Icon(Icons.person, color: Colors.grey, size: 40),
                ),
                const SizedBox(width: 14),
                // Card details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        studentData['name'] ?? "",
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                      ),
                      const SizedBox(height: 6),
                      _buildIdInfoRow("Class", "${studentData['class'] ?? ''} - ${studentData['section'] ?? 'A'}"),
                      _buildIdInfoRow("Roll No.", studentData['roll']?.toString().replaceAll('Roll No: ', '') ?? "N/A"),
                      _buildIdInfoRow("Gender", studentData['gender'] ?? ""),
                      _buildIdInfoRow("Parent", studentData['mobile'] ?? studentData['phone'] ?? ""),
                      _buildIdInfoRow("Email", studentData['email'] ?? ""),
                      _buildIdInfoRow("Mother", studentData['mother'] ?? ""),
                    ],
                  ),
                ),
                // Vertical role strip
                RotatedBox(
                  quarterTurns: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: headerColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "STUDENT",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: headerColor, letterSpacing: 0.5),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 1),
          // Barcode representation & ID footer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fake barcode lines
                    Row(
                      children: List.generate(20, (index) {
                        return Container(
                          width: (index % 3 == 0) ? 3.0 : 1.5,
                          height: 20,
                          color: Colors.black,
                          margin: const EdgeInsets.only(right: 1),
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(studentData['admission'] ?? studentData['admNo'] ?? "", style: const TextStyle(fontSize: 9, fontFamily: 'monospace', color: Colors.grey)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/principal_signature.png',
                      height: 30,
                      width: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 50,
                        height: 1,
                        margin: const EdgeInsets.only(top: 15),
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("Principal Sign".tr, style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIdInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50, // Fixed width for labels to keep alignment
            child: Text("${label.tr}: ", style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(
              value, 
              style: const TextStyle(fontSize: 10, color: Color(0xFF1E2875), fontWeight: FontWeight.bold),
              softWrap: true, // Allow wrapping to prevent horizontal overflow
            ),
          ),
        ],
      ),
    );
  }
}
