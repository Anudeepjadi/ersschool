import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/data/app_data_store.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../widgets/scrollable_table_wrapper.dart';
import 'admin_hall_ticket_print_screen.dart';
import '../widgets/admin_drawer.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:image_picker/image_picker.dart';

// Sibling sub-screens imports

enum ExaminationFeature {
  menu,
  examDetails,
  examTimetable,
  examHallTickets,
  gradeReport,
  gradeReportCustom,
}

class AdminExaminationsScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  final ExaminationFeature initialFeature;
  final bool openDrawer;

  const AdminExaminationsScreen({
    super.key,
    this.onOpenDrawer,
    this.initialFeature = ExaminationFeature.menu,
    this.openDrawer = false,
  });

  @override
  State<AdminExaminationsScreen> createState() =>
      AdminExaminationsScreenState();
}

class AdminExaminationsScreenState extends State<AdminExaminationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ExaminationFeature _selectedFeature;

  // Filter selection states
  String _selectedBranch = 'Ecstasy School 1';
  String _selectedClass = 'Class 1';
  String _selectedExam = 'SA1';
  String _selectedYear = '2025-26';
  String _selectedSection = 'A';
  String _gradeSearchQuery = "";
  final TextEditingController _gradeSearchController = TextEditingController();

  Map<String, dynamic>? _selectedStudentForReport;
  bool _isEditingGrade = false;

  // Searched states for the Grade Report Table
  String _searchedBranch = 'Ecstasy School 1';
  String _searchedClass = 'Class 1';
  String _searchedSection = 'A';

  static final Map<String, Map<String, Map<int, String>>> _mockStudentMarksDB = {};
  
  final Map<String, TextEditingController> _markControllers = {};

  TextEditingController _getMarkController(String admission, String sub, int termIndex, String initialVal) {
    String key = "${admission}_${sub}_$termIndex";
    if (!_markControllers.containsKey(key)) {
      _markControllers[key] = TextEditingController(text: initialVal);
    }
    return _markControllers[key]!;
  }



  void _ensureStudentHasMarks(String admission) {
    if (!_mockStudentMarksDB.containsKey(admission)) {
      final Random rnd = Random(admission.hashCode);
      final Map<String, Map<int, String>> subMap = {};
      for (var sub in _subjects) {
        subMap[sub] = {};
        for (int term = 0; term < 4; term++) {
          int mark = 15 + rnd.nextInt(86);
          subMap[sub]![term] = mark.toString();
        }
      }
      _mockStudentMarksDB[admission] = subMap;
    }
  }

  String _getOverallGrade(String admission) {
    _ensureStudentHasMarks(admission);
    final marks = _mockStudentMarksDB[admission];
    if (marks == null || marks.isEmpty) return "-";

    int totalMarks = 0;
    int count = 0;

    for (var sub in _subjects) {
      var subMarks = marks[sub];
      if (subMarks != null) {
        for (int term = 0; term < 4; term++) {
          String? mStr = subMarks[term];
          if (mStr != null && mStr.isNotEmpty) {
            int? m = int.tryParse(mStr);
            if (m != null) {
              totalMarks += m;
              count++;
            }
          }
        }
      }
    }

    if (count == 0) return "-";

    double percentage = totalMarks / count;
    String finalGrade = _getGrade(percentage.round());
    if (finalGrade == "F") return "Fail";
    return finalGrade;
  }

  String _getGrade(int marks) {
    if (marks >= 90) return "A+";
    if (marks >= 80) return "A";
    if (marks >= 70) return "B+";
    if (marks >= 60) return "B";
    if (marks >= 50) return "C";
    if (marks >= 40) return "D";
    return "F";
  }

  // Toggle display of data
  bool _showDetailsData = true;
  bool _showTimetableData = true;
  bool _showHallTicketData = true;
  bool _showGradeData = true;

  // Timetable State variables
  final TextEditingController _examTitleController =
      TextEditingController(text: "SA1");
  List<Map<String, dynamic>> _timetableRows = [];

  // Hall Tickets State variables
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // Dropdown options
  final List<String> _branches = [
    'Ecstasy School 1',
    'Ecstasy School 2',
    'Ecstasy School 3'
  ];
  final List<String> _classes = ['LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
  final List<String> _exams = ['SA1', 'SA2', 'Unit Test 1', 'Unit Test 2'];
  final List<String> _subjects = [
    'Telugu',
    'English',
    'Hindi',
    'Maths',
    'Science',
    'Social',
    'Art work'
  ];

  @override
  void initState() {
    super.initState();
    _selectedFeature = widget.initialFeature;
    _initializeTimetable();

    if (widget.openDrawer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scaffoldKey.currentState?.openDrawer();
      });
    }
  }

  void selectFeature(ExaminationFeature feature) {
    setState(() {
      _selectedFeature = feature;
    });
  }

  @override
  void didUpdateWidget(AdminExaminationsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFeature != oldWidget.initialFeature) {
      setState(() {
        _selectedFeature = widget.initialFeature;
      });
    }
  }

  @override
  void dispose() {
    _examTitleController.dispose();
    _searchController.dispose();
    _gradeSearchController.dispose();
    super.dispose();
  }

  void _initializeTimetable() {
    _timetableRows = [
      {
        'subject': 'Telugu',
        'date': '2/1/2026',
        'startHour': '09',
        'startMinute': '00',
        'startPeriod': 'AM',
        'endHour': '10',
        'endMinute': '00',
        'endPeriod': 'AM',
      },
      {
        'subject': 'English',
        'date': '3/1/2026',
        'startHour': '09',
        'startMinute': '00',
        'startPeriod': 'AM',
        'endHour': '10',
        'endMinute': '00',
        'endPeriod': 'AM',
      },
      {
        'subject': 'Hindi',
        'date': '5/1/2026',
        'startHour': '09',
        'startMinute': '00',
        'startPeriod': 'AM',
        'endHour': '10',
        'endMinute': '00',
        'endPeriod': 'AM',
      },
      {
        'subject': 'Maths',
        'date': '6/1/2026',
        'startHour': '09',
        'startMinute': '00',
        'startPeriod': 'AM',
        'endHour': '10',
        'endMinute': '00',
        'endPeriod': 'AM',
      },
      {
        'subject': 'Science',
        'date': '7/1/2026',
        'startHour': '09',
        'startMinute': '00',
        'startPeriod': 'AM',
        'endHour': '10',
        'endMinute': '00',
        'endPeriod': 'AM',
      },
      {
        'subject': 'Social',
        'date': '8/1/2026',
        'startHour': '09',
        'startMinute': '00',
        'startPeriod': 'AM',
        'endHour': '10',
        'endMinute': '00',
        'endPeriod': 'AM',
      },
      {
        'subject': 'Art work',
        'date': '9/1/2026',
        'startHour': '09',
        'startMinute': '00',
        'startPeriod': 'AM',
        'endHour': '10',
        'endMinute': '00',
        'endPeriod': 'AM',
      },
    ];
  }

  String _getFeatureTitle() {
    switch (_selectedFeature) {
      case ExaminationFeature.menu:
        return "Examination";
      case ExaminationFeature.examDetails:
        return "Exam Details";
      case ExaminationFeature.examTimetable:
        return "Exam Timetable";
      case ExaminationFeature.examHallTickets:
        return "Student List for Hall Tickets";
      case ExaminationFeature.gradeReport:
        return "Student Grade Reports";
      case ExaminationFeature.gradeReportCustom:
        return "Grade Report Custom";
    }
  }

  String _getFeatureSubtitle() {
    switch (_selectedFeature) {
      case ExaminationFeature.menu:
        return "Select a feature to continue";
      case ExaminationFeature.examDetails:
        return "View and search general examination records";
      case ExaminationFeature.examTimetable:
        return "Manage exam timetables, dates and timings";
      case ExaminationFeature.examHallTickets:
        return "View and print candidate hall tickets";
      case ExaminationFeature.gradeReport:
        return "Assess academic grades and classes";
      case ExaminationFeature.gradeReportCustom:
        return "Configure custom grading system rules";
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FF),
      bottomNavigationBar: widget.onOpenDrawer == null
          ? AdminBottomNavBar(currentIndex: 4)
          : null,
      drawer: const AdminDrawer(),
      appBar: AdminAppBar(
        title: _getFeatureTitle(),
        subtitle: _getFeatureSubtitle(),
        leading: _selectedFeature != ExaminationFeature.menu
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _selectedFeature = ExaminationFeature.menu;
                  });
                },
              )
            : null,
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: Column(
        children: [
          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: _buildSelectedFeatureBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedFeatureBody() {
    if (_selectedFeature == ExaminationFeature.gradeReport && _selectedStudentForReport != null) {
      return _buildGradeReportDetailView(_selectedStudentForReport!);
    }

    switch (_selectedFeature) {
      case ExaminationFeature.menu:
        return _buildMainMenuView();
      case ExaminationFeature.examDetails:
        return _buildExamDetailsView();
      case ExaminationFeature.examTimetable:
        return _buildExamTimetableView();
      case ExaminationFeature.examHallTickets:
        return _buildExamHallTicketsView();
      case ExaminationFeature.gradeReport:
        return _buildGradeReportView(false);
      case ExaminationFeature.gradeReportCustom:
        return _buildGradeReportView(true);
    }
  }

  Widget _buildMainMenuView() {
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Exam Details', 'feature': ExaminationFeature.examDetails, 'icon': Icons.description_outlined},
      {'title': 'Exam Timetable', 'feature': ExaminationFeature.examTimetable, 'icon': Icons.calendar_month_outlined},
      {
        'title': 'Exam Hall Tickets',
        'feature': ExaminationFeature.examHallTickets,
        'icon': Icons.confirmation_number_outlined
      },
      {'title': 'Grade Report', 'feature': ExaminationFeature.gradeReport, 'icon': Icons.assessment_outlined},
      {
        'title': 'Grade Report Custom',
        'feature': ExaminationFeature.gradeReportCustom,
        'icon': Icons.settings_suggest_outlined
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: menuItems.map((item) {
          final index = menuItems.indexOf(item);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item['icon'] as IconData, color: AppColors.primary, size: 20),
                ),
                title: Text(
                  (item['title'] as String).tr,
                  style: const TextStyle(
                    color: Color(0xFF1E2875),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 14, color: Colors.grey),
                onTap: () {
                  setState(() {
                    _selectedFeature = item['feature'] as ExaminationFeature;
                  });
                },
              ),
              if (index < menuItems.length - 1)
                Divider(height: 1, color: Colors.grey.shade200),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ─── 1. EXAM DETAILS VIEW ──────────────────────────────────────────────────
  Widget _buildExamDetailsView() {
    // Mock exams
    final List<Map<String, dynamic>> mockExams = [
      {
        'name': 'Summative Assessment 1',
        'code': 'SA1',
        'type': 'Terminal',
        'duration': '3 Hours',
        'marks': '100',
        'status': 'Upcoming'
      },
      {
        'name': 'Formative Assessment 1',
        'code': 'FA1',
        'type': 'Class Test',
        'duration': '1.5 Hours',
        'marks': '50',
        'status': 'Completed'
      },
      {
        'name': 'Summative Assessment 2',
        'code': 'SA2',
        'type': 'Terminal',
        'duration': '3 Hours',
        'marks': '100',
        'status': 'Upcoming'
      },
      {
        'name': 'Formative Assessment 2',
        'code': 'FA2',
        'type': 'Class Test',
        'duration': '1.5 Hours',
        'marks': '50',
        'status': 'Completed'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildFilterDropdown(
                      label: "Branch",
                      value: _selectedBranch,
                      items: _branches,
                      onChanged: (val) =>
                          setState(() => _selectedBranch = val!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFilterDropdown(
                      label: "Class",
                      value: _selectedClass,
                      items: _classes,
                      onChanged: (val) => setState(() => _selectedClass = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFF8B4513), // Brown matching screenshot "Get Data"
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  setState(() {
                    _showDetailsData = true;
                  });
                },
                child: Text("Get Data".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (_showDetailsData)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Examination Records - $_selectedClass".tr,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2875)),
                ),
                const SizedBox(height: 12),
                ScrollableTableWrapper(
                  child: DataTable(
                    headingRowColor:
                        WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                    columns: [
                      DataColumn(
                          label: Text("Exam Name".tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color(0xFF1E2875)))),
                      DataColumn(
                          label: Text("Code".tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color(0xFF1E2875)))),
                      DataColumn(
                          label: Text("Type".tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color(0xFF1E2875)))),
                      DataColumn(
                          label: Text("Duration".tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color(0xFF1E2875)))),
                      DataColumn(
                          label: Text("Max Marks".tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color(0xFF1E2875)))),
                      DataColumn(
                          label: Text("Status".tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color(0xFF1E2875)))),
                    ],
                    rows: mockExams.map((exam) {
                      final isUpcoming = exam['status'] == 'Upcoming';
                      return DataRow(
                        cells: [
                          DataCell(Text(exam['name']!.toString().tr)),
                          DataCell(Text(exam['code']!.toString())),
                          DataCell(Text(exam['type']!.toString().tr)),
                          DataCell(Text(exam['duration']!.toString())),
                          DataCell(Text(exam['marks']!.toString())),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isUpcoming
                                    ? Colors.orange.withValues(alpha: 0.1)
                                    : Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                exam['status']!.toString().tr,
                                style: TextStyle(
                                  color:
                                      isUpcoming ? Colors.orange : Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ─── 2. EXAM TIMETABLE VIEW ────────────────────────────────────────────────
  Widget _buildExamTimetableView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Filter Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildFilterDropdown(
                      label: "Branch",
                      value: _selectedBranch,
                      items: _branches,
                      onChanged: (val) =>
                          setState(() => _selectedBranch = val!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFilterDropdown(
                      label: "Examination",
                      value: _selectedExam,
                      items: _exams,
                      onChanged: (val) {
                        setState(() {
                          _selectedExam = val!;
                          _examTitleController.text = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFilterDropdown(
                      label: "Class",
                      value: _selectedClass,
                      items: _classes,
                      onChanged: (val) => setState(() => _selectedClass = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  setState(() {
                    _showTimetableData = true;
                  });
                },
                child: Text("Get Timetable".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (_showTimetableData) ...[
          // Exam Title input and Actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Exam Title".tr,
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey)),
                          const SizedBox(height: 4),
                          SizedBox(
                            height: 40,
                            child: TextField(
                              controller: _examTitleController,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E2875)),
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4513),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Timetable for ${_examTitleController.text} saved successfully!"
                                    .tr),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      child: Text("Save".tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          _timetableRows.add({
                            'subject': _subjects.first,
                            'date': '10/1/2026',
                            'startHour': '09',
                            'startMinute': '00',
                            'startPeriod': 'AM',
                            'endHour': '10',
                            'endMinute': '00',
                            'endPeriod': 'AM',
                          });
                        });
                      },
                      child: Text("Add New".tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Timetable Editor Table
                ScrollableTableWrapper(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerTheme:
                          const DividerThemeData(thickness: 1, space: 1),
                    ),
                    child: Table(
                      border: TableBorder.all(
                          color: Colors.grey.shade200, width: 1),
                      columnWidths: const {
                        0: FixedColumnWidth(160),
                        1: FixedColumnWidth(180),
                        2: FixedColumnWidth(210),
                        3: FixedColumnWidth(210),
                        4: FixedColumnWidth(60),
                      },
                      children: [
                        // Headers Row
                        TableRow(
                          decoration: const BoxDecoration(
                              color: AppColors.primary), // Very dark blue/black header
                          children: [
                            _buildTableHeaderCell("Subject"),
                            _buildTableHeaderCell("Date"),
                            _buildTableHeaderCell("Start Time"),
                            _buildTableHeaderCell("End Time"),
                            _buildTableHeaderCell("Action", isCenter: true),
                          ],
                        ),
                        // Data Rows
                        ...List.generate(_timetableRows.length, (index) {
                          final row = _timetableRows[index];
                          return TableRow(
                            children: [
                              // Subject cell
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: row['subject'],
                                      isDense: true,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black),
                                      onChanged: (v) {
                                        setState(() {
                                          row['subject'] = v!;
                                        });
                                      },
                                      items: _subjects.map((sub) {
                                        return DropdownMenuItem<String>(
                                          value: sub,
                                          child: Text(sub.tr),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),

                              // Date Cell
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime(2026, 1, 1),
                                      firstDate: DateTime(2025, 1, 1),
                                      lastDate: DateTime(2027, 12, 31),
                                    );
                                    if (date != null) {
                                      setState(() {
                                        row['date'] =
                                            "${date.day}/${date.month}/${date.year}";
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(row['date'],
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        Icon(Icons.calendar_month,
                                            color: Colors.grey.shade600,
                                            size: 16),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Start Time Cell
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildTimePickerRow(row, 'start'),
                              ),

                              // End Time Cell
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildTimePickerRow(row, 'end'),
                              ),

                              // Delete Cell
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        _timetableRows.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]
      ],
    );
  }

  Widget _buildTableHeaderCell(String text, {bool isCenter = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Text(
        text.tr,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        textAlign: isCenter ? TextAlign.center : TextAlign.start,
      ),
    );
  }

  Widget _buildTimePickerRow(Map<String, dynamic> row, String prefix) {
    final List<String> hours =
        List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
    final List<String> minutes =
        List.generate(60, (index) => index.toString().padLeft(2, '0'));
    final List<String> periods = ['AM', 'PM'];

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("HH", style: TextStyle(fontSize: 8, color: Colors.grey)),
            Container(
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: row['${prefix}Hour'],
                  style: const TextStyle(fontSize: 11, color: Colors.black),
                  onChanged: (v) => setState(() => row['${prefix}Hour'] = v!),
                  items: hours
                      .map((h) => DropdownMenuItem(value: h, child: Text(h)))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        const Padding(padding: EdgeInsets.only(top: 12.0), child: Text(":")),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("MM", style: TextStyle(fontSize: 8, color: Colors.grey)),
            Container(
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: row['${prefix}Minute'],
                  style: const TextStyle(fontSize: 11, color: Colors.black),
                  onChanged: (v) => setState(() => row['${prefix}Minute'] = v!),
                  items: minutes
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("AM/PM",
                style: TextStyle(fontSize: 8, color: Colors.grey)),
            Container(
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: row['${prefix}Period'],
                  style: const TextStyle(fontSize: 11, color: Colors.black),
                  onChanged: (v) => setState(() => row['${prefix}Period'] = v!),
                  items: periods
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── 3. EXAM HALL TICKETS VIEW ─────────────────────────────────────────────
  Widget _buildExamHallTicketsView() {
    // Get students from database matching search query and filters
    // Fallback students to match the user's specific screenshot
    final List<Map<String, dynamic>> fallbackStudents = [
      {
        'name': 'Deepthi',
        'gender': 'Female',
        'roll': 'ECS00021',
        'admission': 'ECS00021',
        'class': 'LKG',
        'section': 'A',
        'school': 'Ecstasy School 1'
      },
      {
        'name': 'Deepthi',
        'gender': 'Female',
        'roll': 'ECS00022',
        'admission': 'ECS00022',
        'class': 'LKG',
        'section': 'A',
        'school': 'Ecstasy School 1'
      },
      {
        'name': 'dhurandarrr',
        'gender': 'Male',
        'roll': 'ECS00023',
        'admission': 'ECS00023',
        'class': 'LKG',
        'section': 'A',
        'school': 'Ecstasy School 1'
      },
      {
        'name': 'ECSTASY SOLUTIONS PVT LTD',
        'gender': 'Male',
        'roll': 'ECS00024',
        'admission': 'ECS00024',
        'class': 'LKG',
        'section': 'A',
        'school': 'Ecstasy School 1'
      },
      {
        'name': 'lakshmi',
        'gender': 'Male',
        'roll': 'ECS00025',
        'admission': 'ECS00025',
        'class': 'LKG',
        'section': 'A',
        'school': 'Ecstasy School 1'
      },
      {
        'name': 'MadiviliNaresh',
        'gender': 'Male',
        'roll': 'ECS00026',
        'admission': 'ECS00026',
        'class': 'LKG',
        'section': 'A',
        'school': 'Ecstasy School 1'
      },
      {
        'name': 'phani',
        'gender': 'Male',
        'roll': 'ECS00027',
        'admission': 'ECS00027',
        'class': 'LKG',
        'section': 'A',
        'school': 'Ecstasy School 1'
      },
      {
        'name': 'Priya',
        'gender': 'Female',
        'roll': 'ECS00028',
        'admission': 'ECS00028',
        'class': 'LKG',
        'section': 'A',
        'school': 'Ecstasy School 1'
      },
      {
        'name': 'Rimsa',
        'gender': 'Female',
        'roll': 'ECS00029',
        'admission': 'ECS00029',
        'class': 'LKG',
        'section': 'A',
        'school': 'Ecstasy School 1'
      },
      {
        'name': 'suresh',
        'gender': 'Male',
        'roll': 'ECS00030',
        'admission': 'ECS00030',
        'class': 'LKG',
        'section': 'A',
        'school': 'Ecstasy School 1'
      },
      {
        'name': 'tony',
        'gender': 'Male',
        'roll': 'ECS00031',
        'admission': 'ECS00031',
        'class': 'LKG',
        'section': 'A',
        'school': 'Ecstasy School 1'
      },
      {
        'name': 'Vijaya',
        'gender': 'Male',
        'roll': 'ECS00032',
        'admission': 'ECS00032',
        'class': 'LKG',
        'section': 'A',
        'school': 'Ecstasy School 1'
      },
      {
        'name': 'vinitha',
        'gender': 'Female',
        'roll': 'ECS00033',
        'admission': 'ECS00033',
        'class': 'LKG',
        'section': 'A',
        'school': 'Ecstasy School 1'
      },
    ];

    // Read real students from data store first
    List<Map<String, dynamic>> studentsList = AppDataStore.instance.students
        .where((s) =>
            s['school'] == _selectedBranch && s['class'] == _selectedClass)
        .toList();

    // If empty (e.g. no DB students for Grade 1), fallback to our mock list
    if (studentsList.isEmpty) {
      studentsList = fallbackStudents
          .where((s) =>
              s['school'] == _selectedBranch && s['class'] == _selectedClass)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      studentsList = studentsList
          .where((s) {
            final name = s['name']?.toString() ?? '';
            return name.toLowerCase().contains(_searchQuery.toLowerCase());
          })
          .toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildFilterDropdown(
                      label: "Branch",
                      value: _selectedBranch,
                      items: _branches,
                      onChanged: (val) =>
                          setState(() => _selectedBranch = val!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFilterDropdown(
                      label: "Examination",
                      value: _selectedExam,
                      items: _exams,
                      onChanged: (val) => setState(() => _selectedExam = val!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFilterDropdown(
                      label: "Class",
                      value: _selectedClass,
                      items: _classes,
                      onChanged: (val) => setState(() => _selectedClass = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  setState(() {
                    _showHallTicketData = true;
                  });
                },
                child: Text("Get Data".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (_showHallTicketData) ...[
          // Search input
          TextField(
            controller: _searchController,
            style: const TextStyle(fontSize: 13),
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            decoration: InputDecoration(
              hintText: "Search students by name...".tr,
              prefixIcon:
                  const Icon(Icons.search, color: Color(0xFF757897), size: 18),
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Student list table
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ScrollableTableWrapper(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerTheme:
                          const DividerThemeData(thickness: 1, space: 1),
                    ),
                    child: Table(
                      border: TableBorder.all(
                          color: Colors.grey.shade100, width: 1),
                      columnWidths: const {
                        0: FixedColumnWidth(220),
                        1: FixedColumnWidth(100),
                        2: FixedColumnWidth(140),
                        3: FixedColumnWidth(100),
                        4: FixedColumnWidth(100),
                        5: FixedColumnWidth(130),
                      },
                      children: [
                        // Headers Row
                        TableRow(
                          decoration:
                              const BoxDecoration(color: AppColors.primary),
                          children: [
                            _buildTableHeaderCell("Student Name"),
                            _buildTableHeaderCell("Gender"),
                            _buildTableHeaderCell("Academic Year"),
                            _buildTableHeaderCell("Class"),
                            _buildTableHeaderCell("Section"),
                            _buildTableHeaderCell("Action", isCenter: true),
                          ],
                        ),
                        // Data rows
                        if (studentsList.isEmpty)
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text("No students found.".tr,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ),
                              ),
                              TableCell(child: Container()),
                              TableCell(child: Container()),
                              TableCell(child: Container()),
                              TableCell(child: Container()),
                              TableCell(child: Container()),
                            ],
                          )
                        else
                          ...studentsList.map((stud) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text(stud['name'] ?? '',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text(
                                      stud['gender']?.toString().tr ?? '',
                                      style: const TextStyle(fontSize: 12)),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text("2025-26",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text(stud['class'] ?? '',
                                      style: const TextStyle(fontSize: 12)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text(stud['section'] ?? 'A',
                                      style: const TextStyle(fontSize: 12)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  child: Center(
                                    child: SizedBox(
                                      height: 30,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  AdminHallTicketPrintScreen(
                                                student: stud,
                                                examination: _selectedExam,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Hall Ticket".tr,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]
      ],
    );
  }

  void _showUploadDialog(BuildContext context, Map<String, dynamic> student) {
    String? uploadedFileName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      color: const Color(0xFFE67E22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Grade Report".tr, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close, color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Grade Report".tr, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                          const SizedBox(height: 16),
                          if (uploadedFileName == null)
                            ElevatedButton.icon(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                if (image != null) {
                                  setDialogState(() {
                                    uploadedFileName = image.name;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D6EFD),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                              icon: const Icon(Icons.attach_file, size: 18),
                              label: Text("Upload File".tr),
                            )
                          else
                            Row(
                              children: [
                                const Icon(Icons.insert_drive_file, color: Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(child: Text(uploadedFileName!, style: const TextStyle(fontSize: 14))),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setDialogState(() {
                                      uploadedFileName = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E283C),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            child: Text("Cancel".tr),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (uploadedFileName != null) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("File uploaded successfully!".tr)));
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please upload a file first.".tr)));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD35400),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            child: Text("Save".tr),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  // ─── 4. GRADE REPORT VIEW ──────────────────────────────────────────────────
  Widget _buildGradeReportView(bool isCustom) {
    if (isCustom) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(
                        label: "Branch",
                        value: _selectedBranch,
                        items: _branches,
                        onChanged: (val) =>
                            setState(() => _selectedBranch = val!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFilterDropdown(
                        label: "Class",
                        value: _selectedClass,
                        items: _classes,
                        onChanged: (val) =>
                            setState(() => _selectedClass = val!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B4513),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    setState(() {
                      _showGradeData = true;
                    });
                  },
                  child: Text("Get Data".tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13)),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (_showGradeData) ...[
            Text("Class: $_selectedClass", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Container(
                    color: const Color(0xFF1E2875),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const Expanded(flex: 3, child: Padding(padding: EdgeInsets.only(left: 16), child: Text("Admission No", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))),
                        const Expanded(flex: 4, child: Text("Full Name", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                        const Expanded(flex: 2, child: Text("Section", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                        const Expanded(flex: 3, child: Text("Grade Report", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      final students = AppDataStore.instance.students.where((s) => s['school'] == _selectedBranch && s['class'] == _selectedClass).toList();
                      if (students.isEmpty) {
                        return const Padding(padding: EdgeInsets.all(24.0), child: Text("No records found", style: TextStyle(color: Colors.grey)));
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: students.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final stud = students[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Padding(padding: const EdgeInsets.only(left: 16), child: Text((stud['admission'] ?? '').toString(), style: const TextStyle(fontSize: 12)))),
                                Expanded(flex: 4, child: Text((stud['name'] ?? '').toString(), style: const TextStyle(fontSize: 12))),
                                Expanded(flex: 2, child: Text((stud['section'] ?? 'A').toString(), style: const TextStyle(fontSize: 12))),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () => _showUploadDialog(context, stud),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                                          child: const Icon(Icons.add, color: Colors.white, size: 16),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                        child: const Icon(Icons.delete, color: Colors.white, size: 16),
                                      ),
                                      const SizedBox(width: 16),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ]
        ],
      );
    }


    // Standard Grade Report View matching the screenshot
    List<Map<String, String>> currentGradeList = AppDataStore.instance.students
        .where((s) =>
            s['school'] == _searchedBranch && s['class'] == _searchedClass)
        .map((s) => {
              'admission': (s['admission'] ?? '').toString(),
              'name': (s['name'] ?? '').toString(),
              'gender': (s['gender'] ?? 'Male').toString(),
              'class': (s['class'] ?? '').toString(),
            })
        .toList();

    if (_gradeSearchQuery.isNotEmpty) {
      currentGradeList = currentGradeList
          .where((s) =>
              s['name']!
                  .toLowerCase()
                  .contains(_gradeSearchQuery.toLowerCase()) ||
              s['admission']!
                  .toLowerCase()
                  .contains(_gradeSearchQuery.toLowerCase()))
          .toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildFilterDropdown(
                      label: "Branch",
                      value: _selectedBranch,
                      items: _branches,
                      onChanged: (val) =>
                          setState(() => _selectedBranch = val!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFilterDropdown(
                      label: "Academic Year",
                      value: _selectedYear,
                      items: const ['2025-26', '2024-25', '2023-24'],
                      onChanged: (val) => setState(() => _selectedYear = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildFilterDropdown(
                      label: "Class",
                      value: _selectedClass,
                      items: _classes,
                      onChanged: (val) => setState(() => _selectedClass = val!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFilterDropdown(
                      label: "Section",
                      value: _selectedSection,
                      items: const ['A', 'B', 'C'],
                      onChanged: (val) =>
                          setState(() => _selectedSection = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC0392B), // Red/coral
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Recreating reports for $_selectedClass - Section $_selectedSection..."
                                    .tr),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      child: Text("Recreate Report for Class".tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4513), // Brown
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        setState(() {
                          _showGradeData = true;
                          _searchedBranch = _selectedBranch;
                          _searchedClass = _selectedClass;
                          _searchedSection = _selectedSection;
                        });
                      },
                      child: Text("Search".tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (_showGradeData) ...[
          // Search box
          TextField(
            controller: _gradeSearchController,
            style: const TextStyle(fontSize: 13),
            onChanged: (val) {
              setState(() {
                _gradeSearchQuery = val;
              });
            },
            decoration: InputDecoration(
              hintText: "Search".tr,
              suffixIcon: const Icon(Icons.search,
                  color: Color(0xFF27AE60), size: 20), // Green search icon!
              fillColor: Colors.white,
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Student Grade table
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ScrollableTableWrapper(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerTheme:
                          const DividerThemeData(thickness: 1, space: 1),
                    ),
                    child: Table(
                      border: TableBorder.all(
                          color: Colors.grey.shade100, width: 1),
                      columnWidths: const {
                        0: FixedColumnWidth(50),
                        1: FixedColumnWidth(120),
                        2: FixedColumnWidth(200),
                        3: FixedColumnWidth(90),
                        4: FixedColumnWidth(140),
                        5: FixedColumnWidth(130),
                      },
                      children: [
                        // Headers Row matching screenshot 4
                        TableRow(
                          decoration:
                              const BoxDecoration(color: AppColors.primary),
                          children: [
                            _buildTableHeaderCell("S.No"),
                            _buildTableHeaderCell("Admission No"),
                            _buildTableHeaderCell("Full Name"),
                            _buildTableHeaderCell("Section"),
                            _buildTableHeaderCell("Grade Report"),
                            _buildTableHeaderCell("Action", isCenter: true),
                          ],
                        ),
                        // Data rows
                        if (currentGradeList.isEmpty)
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text("No records found.".tr,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ),
                              ),
                              TableCell(child: Container()),
                              TableCell(child: Container()),
                              TableCell(child: Container()),
                              TableCell(child: Container()),
                              TableCell(child: Container()),
                            ],
                          )
                        else
                          ...currentGradeList.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final stud = entry.value;
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                  child: Text("${idx + 1}",
                                      style: const TextStyle(fontSize: 12)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                  child: Text(stud['admission'] ?? '',
                                      style: const TextStyle(fontSize: 12)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                  child: Text(stud['name'] ?? '',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                  child: Text(
                                      _searchedSection,
                                      style: const TextStyle(fontSize: 12)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                  child: Text(_getOverallGrade(stud['admission'] ?? ''),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: _getOverallGrade(stud['admission'] ?? '') == 'Fail' ? Colors.red : Colors.green)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.visibility, color: Color(0xFF2980B9), size: 28),
                                        onPressed: () {
                                          setState(() {
                                            _selectedStudentForReport = stud;
                                            _isEditingGrade = false;
                                          });
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        tooltip: "View Grade Report".tr,
                                      ),
                                      const SizedBox(width: 16),
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Color(0xFF3498DB), size: 28),
                                        onPressed: () {
                                          setState(() {
                                            _selectedStudentForReport = stud;
                                            _isEditingGrade = true;
                                          });
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        tooltip: "Edit Grade Report".tr,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ],
    );
  }

  Widget _buildGradeReportDetailView(Map<String, dynamic> student) {
    const double colSubject = 150;
    const double colMarks = 80;
    const double colSNo = 40;
    const double colGrandTotal = 100;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with logo placeholder and buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("ecstasy",
                      style: TextStyle(
                          color: Color(0xFF00D9FF),
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  Container(height: 1, width: 30, color: const Color(0xFF00D9FF)),
                ],
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  if (_isEditingGrade) ...[
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          final adm = _selectedStudentForReport?['admission'];
                          if (adm != null) {
                            for (var sub in _subjects) {
                              for (int i = 0; i < 3; i++) {
                                String key = "${adm}_${sub}_$i";
                                if (_markControllers.containsKey(key)) {
                                  _mockStudentMarksDB.putIfAbsent(adm, () => {}).putIfAbsent(sub, () => {})[i] = _markControllers[key]!.text;
                                }
                              }
                            }
                          }
                          _isEditingGrade = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Report Saved successfully!".tr), backgroundColor: AppColors.success),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB45309),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(0, 32),
                      ),
                      icon: const Icon(Icons.save, size: 14),
                      label: Text("Save".tr, style: const TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (!_isEditingGrade) ...[
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await Printing.layoutPdf(
                            onLayout: (PdfPageFormat format) async {
                              final doc = pw.Document();
                              doc.addPage(
                                pw.Page(
                                  pageFormat: format,
                                  margin: const pw.EdgeInsets.all(32),
                                  build: (pw.Context context) {
                                    return pw.Column(
                                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text("STUDENT GRADE REPORT", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                                        pw.SizedBox(height: 24),
                                        pw.Text("Student Name: ${student['name'] ?? ''}"),
                                        pw.Text("Admission No: ${student['admission'] ?? ''}"),
                                        pw.Text("Class: $_selectedClass - $_selectedSection"),
                                        pw.Text("Academic Year: $_selectedYear"),
                                        pw.SizedBox(height: 40),
                                        pw.TableHelper.fromTextArray(
                                          border: pw.TableBorder.all(),
                                          headers: ['Subject', 'Grade'],
                                          data: _subjects.map((s) => [s, 'A+']).toList(), // Simulated for now
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                              return doc.save();
                            },
                            name: 'Grade_Report_${student['name'] ?? 'student'}',
                          );
                        } catch (e) {
                          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(0, 32),
                      ),
                      icon: const Icon(Icons.print, size: 14),
                      label: Text("Print".tr, style: const TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                  ],
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedStudentForReport = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      minimumSize: const Size(0, 32),
                    ),
                    icon: const Icon(Icons.close, size: 14),
                    label: Text("Close".tr, style: const TextStyle(fontSize: 12)),
                  ),
                  if (_isEditingGrade) ...[
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC0392B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(0, 32),
                      ),
                      icon: const Icon(Icons.refresh, size: 14),
                      label: Text("Recreate Blank Report".tr, style: const TextStyle(fontSize: 11)),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Student Info Grid matching screenshots
          Wrap(
            spacing: 24,
            runSpacing: 8,
            children: [
              SizedBox(
                width: 250,
                child: Column(
                  children: [
                    _buildInfoRowCompact("Name:", student['name'] ?? ''),
                    _buildInfoRowCompact("Father Name:", student['father'] ?? ''),
                    if (!_isEditingGrade) _buildInfoRowCompact("Mobile :", student['mobile'] ?? ''),
                  ],
                ),
              ),
              SizedBox(
                width: 250,
                child: Column(
                  children: [
                    _buildInfoRowCompact("Class:", "$_selectedClass - $_selectedSection"),
                    _buildInfoRowCompact("Academic Year:", _selectedYear),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Marks Table - Completely redesigned for horizontal alignment
          ScrollableTableWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top header row for SA1, SA2, etc.
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 0.5),
                      left: BorderSide(color: Colors.grey, width: 0.5),
                      right: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: colSNo + colSubject),
                      _buildMainHeader("SA1", colMarks * 4),
                      _buildMainHeader("SA2", colMarks * 4),
                      _buildMainHeader("unit test 1", colMarks * 4),
                      _buildMainHeader("sa3", colMarks * 4),
                      _buildMainHeader("Grand Total", colGrandTotal),
                    ],
                  ),
                ),
                Table(
                  border: TableBorder.all(color: Colors.grey, width: 0.5),
                  columnWidths: const {
                    0: FixedColumnWidth(colSNo),
                    1: FixedColumnWidth(colSubject),
                    2: FixedColumnWidth(colMarks),
                    3: FixedColumnWidth(colMarks),
                    4: FixedColumnWidth(colMarks),
                    5: FixedColumnWidth(colMarks),
                    6: FixedColumnWidth(colMarks),
                    7: FixedColumnWidth(colMarks),
                    8: FixedColumnWidth(colMarks),
                    9: FixedColumnWidth(colMarks),
                    10: FixedColumnWidth(colMarks),
                    11: FixedColumnWidth(colMarks),
                    12: FixedColumnWidth(colMarks),
                    13: FixedColumnWidth(colMarks),
                    14: FixedColumnWidth(colMarks),
                    15: FixedColumnWidth(colMarks),
                    16: FixedColumnWidth(colMarks),
                    17: FixedColumnWidth(colMarks),
                    18: FixedColumnWidth(colGrandTotal),
                  },
                  children: [
                    // Sub-headers row
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
                      children: [
                        _buildCell("S.No", isSubHeader: true),
                        _buildCell("Subject", isSubHeader: true),
                        ...List.generate(4, (_) => [
                          _buildCell("Total Marks", isSubHeader: true),
                          _buildCell("Marks Secured", isSubHeader: true),
                          _buildCell("Percentage", isSubHeader: true),
                          _buildCell("Grade", isSubHeader: true),
                        ]).expand((e) => e),
                        _buildCell("", isSubHeader: true),
                      ],
                    ),
                    // Data Rows
                    ..._subjects.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final sub = entry.value;
                      int grandTotal = 0;
                      return TableRow(
                        children: [
                          _buildCell("${idx + 1}"),
                          _buildCell(sub, textAlign: TextAlign.start),
                          ...List.generate(16, (i) {
                            int termIndex = i ~/ 4;
                            int colType = i % 4; // 0: Total, 1: Student Mark, 2: Percentage, 3: Grade
                            
                            String markStr = _mockStudentMarksDB[_selectedStudentForReport?['admission']]?[sub]?[termIndex] ?? "";
                            int? mark = int.tryParse(markStr);
                            
                            if (colType == 1 && mark != null) {
                              grandTotal += mark; // Add to grand total
                            }

                            if (colType == 0) return _buildCell("100");

                            if (colType == 1) {
                              if (_isEditingGrade) {
                                return TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: TextField(
                                      controller: _getMarkController(_selectedStudentForReport?['admission'] ?? "", sub, termIndex, markStr),
                                      onChanged: (val) {
                                        final adm = _selectedStudentForReport?['admission'];
                                        if (adm != null) {
                                          _mockStudentMarksDB.putIfAbsent(adm, () => {}).putIfAbsent(sub, () => {})[termIndex] = val;
                                          setState(() {}); // Updates immediately
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                        border: OutlineInputBorder(),
                                      ),
                                      style: const TextStyle(fontSize: 10),
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                              return _buildCell(markStr.isNotEmpty ? markStr : "-");
                            }

                            if (colType == 2) { // Percentage
                              return _buildCell(mark != null ? "$mark" : "-");
                            }

                            if (colType == 3) { // Grade
                              return _buildCell(mark != null ? _getGrade(mark) : "-");
                            }

                            return _buildCell("-");
                          }),
                          _buildCell(grandTotal > 0 ? grandTotal.toString() : "-"),
                        ],
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Note: A+ (90-100), A (80-89), B+ (70-79), B (60-69), C (50-59), D (40-49), F (Below 40)".tr,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMainHeader(String text, double width) {
    return Container(
      width: width,
      height: 32,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Text(
        text.tr.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E2875),
        ),
      ),
    );
  }

  Widget _buildCell(String text, {bool isSubHeader = false, TextAlign textAlign = TextAlign.center}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Text(
          text.tr,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSubHeader ? FontWeight.bold : FontWeight.normal,
            color: isSubHeader ? const Color(0xFF1E2875) : Colors.black87,
          ),
          textAlign: textAlign,
          softWrap: false,
        ),
      ),
    );
  }

  Widget _buildInfoRowCompact(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }


  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.tr,
              style: const TextStyle(fontSize: 9, color: Colors.grey)),
          const SizedBox(height: 2),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isDense: true,
              isExpanded: true,
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF1E2875),
                  fontWeight: FontWeight.bold),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item.tr),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

}