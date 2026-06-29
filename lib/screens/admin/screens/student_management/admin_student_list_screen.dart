import 'package:flutter/material.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/data/app_data_store.dart';
import 'package:ersschool/core/utils/profile_manager.dart';
import '../../widgets/admin_app_bar.dart';
import 'admin_student_details_screen.dart';
import 'admin_student_fee_details_screen.dart';
import 'admin_student_attendance_report_screen.dart';
import 'admin_register_student_screen.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

class AdminStudentListScreen extends StatefulWidget {
  const AdminStudentListScreen({super.key});

  @override
  State<AdminStudentListScreen> createState() => _AdminStudentListScreenState();
}

class _AdminStudentListScreenState extends State<AdminStudentListScreen> {
  int _currentPage = 1;
  final int _rowsPerPage = 3;
  final ScrollController _scrollController = ScrollController();

  String _selectedBranch = 'Ecstasy School 1 (ECS001)';
  String _selectedYear = '2025-26';
  String _selectedStatus = 'Only Active';
  String _selectedClass = 'Grade 1';
  String _selectedSection = 'All';
  String _searchQuery = '';

  // Use the shared store
  List<Map<String, dynamic>> get _students => AppDataStore.instance.students
      .where((s) => s['school'] == ProfileManager().selectedSchool.value)
      .toList();

  List<Map<String, dynamic>> get _filteredStudents {
    final list = _students;
    if (_searchQuery.isEmpty) return list;
    final query = _searchQuery.toLowerCase();
    return list.where((student) {
      return (student['name'] ?? '').toString().toLowerCase().contains(query) ||
             (student['admission'] ?? '').toString().toLowerCase().contains(query);
    }).toList();
  }

  List<Map<String, dynamic>> _getPaginatedStudents() {
    final filtered = _filteredStudents;
    int startIndex = (_currentPage - 1) * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    if (startIndex >= filtered.length) return [];
    if (endIndex > filtered.length) endIndex = filtered.length;
    return filtered.sublist(startIndex, endIndex);
  }

  @override
  void initState() {
    super.initState();
    AppDataStore.instance.configVersion.addListener(_onStoreChanged);
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    AppDataStore.instance.configVersion.removeListener(_onStoreChanged);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
      appBar: AdminAppBar(
        title: "Student List".tr,
        subtitle: "Manage your students details",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // Filter Grid
              _buildFilters(),

              const SizedBox(height: 16),

              // Action Row (Search & Export)
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search".tr,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        suffixIcon: const Icon(Icons.search, color: Colors.green, size: 20),
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
                    onPressed: () async {
                      try {
                        await Printing.layoutPdf(
                          onLayout: (PdfPageFormat format) => _generateStudentListPdf(format),
                          name: 'Student_List_${DateTime.now().millisecondsSinceEpoch}',
                        );
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e")),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    child: Text("Print List".tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Exporting to Excel...".tr)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    child: Text("Export to Excel".tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Data Table
              Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DataTable(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    headingRowColor: WidgetStateProperty.all(AppColors.primaryDark), // Dark slate blue
                    headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    dataRowMaxHeight: 60,
                    dataRowMinHeight: 48,
                    columnSpacing: 24,
                    horizontalMargin: 16,
                    columns: [
                      DataColumn(label: Text("Admission\nNo".tr)),
                      DataColumn(label: Text("Student Name".tr)),
                      DataColumn(label: Text("Father Name".tr)),
                      DataColumn(label: Text("Gender".tr)),
                      DataColumn(label: Text("Class".tr)),
                      DataColumn(label: Text("Section".tr)),
                      DataColumn(label: Text("Mobile".tr)),
                      DataColumn(label: Text("Active".tr)),
                      const DataColumn(label: Text("")), // Actions
                    ],
                    rows: _getPaginatedStudents().asMap().entries.map((entry) {
                      final index = entry.key;
                      final s = entry.value;
                      final isEven = index % 2 == 0;
                      return DataRow(
                        color: WidgetStateProperty.all(isEven ? Colors.white : Colors.grey.shade50),
                        cells: [
                          DataCell(Text(s['admission'] ?? "", style: const TextStyle(fontSize: 13))),
                          DataCell(Text(s['name'] ?? "", style: const TextStyle(fontSize: 13))),
                          DataCell(Text(s['father'] ?? "N/A", style: const TextStyle(fontSize: 13))),
                          DataCell(Text(s['gender'] ?? "", style: const TextStyle(fontSize: 13))),
                          DataCell(Text(s['class'] ?? "", style: const TextStyle(fontSize: 13))),
                          DataCell(Text("A", style: const TextStyle(fontSize: 13))),
                          DataCell(Text(s['phone'] ?? "", style: const TextStyle(fontSize: 12))),
                          DataCell(Text(s['status'] ?? "", style: const TextStyle(fontSize: 13))),
                          DataCell(_buildActionButtons(s)),
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
              const SizedBox(height: 16),
              _buildPagination(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    final filtered = _filteredStudents;
    int totalPages = (filtered.length / _rowsPerPage).ceil();
    if (totalPages == 0) totalPages = 1;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        OutlinedButton(
          onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: BorderSide(color: Colors.grey.shade400),
            padding: const EdgeInsets.symmetric(horizontal: 11),
          ),
          child: Text("Previous".tr),
        ),
        for (int i = 1; i <= totalPages; i++)
          InkWell(
            onTap: () => setState(() => _currentPage = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _currentPage == i ? AppColors.primary : Colors.white,
                border: Border.all(color: _currentPage == i ? AppColors.primary : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "$i",
                style: TextStyle(color: _currentPage == i ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        OutlinedButton(
          onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: BorderSide(color: Colors.grey.shade400),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: Text("Next".tr),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    double screenWidth = MediaQuery.of(context).size.width;
    double fieldWidth = screenWidth > 600 ? 250 : screenWidth - 32;

    return Column(
      children: [
        // Row 1
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(width: fieldWidth, child: _buildLabeledDropdown("Branch", _selectedBranch, ["All Branches", "Ecstasy School 1 (ECS001)", "Ecstasy School 2 (ECS002)", "Ecstasy (ECS003)", "Ecstasy (ECS004)"], (val) => setState(() => _selectedBranch = val!))),
            SizedBox(width: fieldWidth, child: _buildLabeledDropdown("Academic Year", _selectedYear, ["All", "2025-26"], (val) => setState(() => _selectedYear = val!))),
            SizedBox(width: fieldWidth, child: _buildLabeledDropdown("Active / Inactive", _selectedStatus, ["All students", "Only Active", "Only Inactive"], (val) => setState(() => _selectedStatus = val!))),
          ],
        ),
        const SizedBox(height: 16),
        // Row 2
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            SizedBox(width: fieldWidth, child: _buildLabeledDropdown("Class", _selectedClass, ["All", "L.K.G", "U.K.G", "Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5", "Grade 6", "Grade 7", "Grade 8", "Grade 9", "Class 10"], (val) => setState(() => _selectedClass = val!))),
            SizedBox(width: fieldWidth, child: _buildLabeledDropdown("Section", _selectedSection, ["All", "A", "B", "C"], (val) => setState(() => _selectedSection = val!))),
            SizedBox(
              width: fieldWidth,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Action clicked!".tr)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: Text("Search".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabeledDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        const SizedBox(height: 4),
        Container(
          height: 38,
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
              icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.black54),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item.tr, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> student) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _iconButton(Icons.visibility, AppColors.primaryDark, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminStudentDetailsScreen(student: student)));
        }),
        const SizedBox(width: 8),
        _iconButton(Icons.currency_rupee, AppColors.success, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminStudentFeeDetailsScreen(student: student)));
        }),
        const SizedBox(width: 8),
        _iconButton(Icons.pan_tool, AppColors.primary, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminStudentAttendanceReportScreen(student: student)));
        }),
        const SizedBox(width: 8),
        _iconButton(Icons.edit, AppColors.primaryDark, onTap: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminRegisterStudentScreen(isEditMode: true, student: student)));
          if (result != null && result is Map<String, dynamic>) {
            // Find in global list and update using admission number as unique key
            final globalIndex = AppDataStore.instance.students.indexWhere((s) => 
              (s['admission'] ?? s['admNo']) == (student['admission'] ?? student['admNo'])
            );
            if (globalIndex != -1) {
              AppDataStore.instance.updateStudent(globalIndex, result);
            }
            setState(() {});
          }
        }),
      ],
    );
  }

  Widget _iconButton(IconData icon, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color, width: 1.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }

  Future<Uint8List> _generateStudentListPdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    final filtered = _filteredStudents;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format.copyWith(
          marginBottom: 1.5 * PdfPageFormat.cm,
          marginLeft: 1.0 * PdfPageFormat.cm,
          marginRight: 1.0 * PdfPageFormat.cm,
          marginTop: 1.5 * PdfPageFormat.cm,
        ),
        orientation: pw.PageOrientation.landscape,
        header: (context) => pw.Column(
          children: [
            pw.Center(
              child: pw.Text(
                ProfileManager().selectedSchool.value.toUpperCase(),
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Center(
              child: pw.Text(
                "STUDENT LIST REPORT - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Class: $_selectedClass", style: const pw.TextStyle(fontSize: 10)),
                pw.Text("Section: $_selectedSection", style: const pw.TextStyle(fontSize: 10)),
                pw.Text("Total Students: ${filtered.length}", style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Divider(),
          ],
        ),
        footer: (context) => pw.Column(
          children: [
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Generated by ERS School Management System", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
                pw.Text("Page ${context.pageNumber} of ${context.pagesCount}", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
              ],
            ),
          ],
        ),
        build: (pw.Context context) {
          return [
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(),
              headerAlignment: pw.Alignment.center,
              cellAlignment: pw.Alignment.centerLeft,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1E2875)),
              cellStyle: const pw.TextStyle(fontSize: 8),
              columnWidths: const {
                0: pw.FlexColumnWidth(1.2),
                1: pw.FlexColumnWidth(2.5),
                2: pw.FlexColumnWidth(2),
                3: pw.FlexColumnWidth(1),
                4: pw.FlexColumnWidth(1.2),
                5: pw.FlexColumnWidth(1),
                6: pw.FlexColumnWidth(1.5),
                7: pw.FlexColumnWidth(1),
              },
              headers: ['Adm No', 'Student Name', 'Father Name', 'Gender', 'Class', 'Sec', 'Mobile', 'Status'],
              data: filtered.map((s) => [
                s['admission'] ?? "",
                s['name'] ?? "",
                s['father'] ?? "",
                s['gender'] ?? "",
                s['class'] ?? "",
                "A",
                s['phone'] ?? "",
                s['status'] ?? "",
              ]).toList(),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
