
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/data/app_data_store.dart';
import '../../../core/utils/profile_manager.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../widgets/scrollable_table_wrapper.dart';
import 'admin_hall_ticket_print_screen.dart';
import 'package:ersschool/core/localization/language_manager.dart';

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
  State<AdminExaminationsScreen> createState() => AdminExaminationsScreenState();
}

class AdminExaminationsScreenState extends State<AdminExaminationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ExaminationFeature _selectedFeature;
  
  // Filter selection states
  String _selectedBranch = 'Ecstasy School 1';
  String _selectedClass = 'Grade 1';
  String _selectedExam = 'SA1';
  String _selectedYear = '2025-26';
  String _selectedSection = 'A';
  String _gradeSearchQuery = "";
  final TextEditingController _gradeSearchController = TextEditingController();

  // Toggle display of data
  bool _showDetailsData = true;
  bool _showTimetableData = true;
  bool _showHallTicketData = true;
  bool _showGradeData = true;

  // Timetable State variables
  final TextEditingController _examTitleController = TextEditingController(text: "SA1");
  List<Map<String, dynamic>> _timetableRows = [];

  // Hall Tickets State variables
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // Dropdown options
  final List<String> _branches = ['Ecstasy School 1', 'Ecstasy School 2', 'Ecstasy School 3'];
  final List<String> _classes = ['Grade 1', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
  final List<String> _exams = ['SA1', 'SA2', 'Unit Test 1', 'Unit Test 2'];
  final List<String> _subjects = ['Telugu', 'English', 'Hindi', 'Maths', 'Science', 'Social', 'Art work'];

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
      {'subject': 'Telugu', 'date': '2/1/2026', 'startHour': '09', 'startMinute': '00', 'startPeriod': 'AM', 'endHour': '10', 'endMinute': '00', 'endPeriod': 'AM'},
      {'subject': 'English', 'date': '3/1/2026', 'startHour': '09', 'startMinute': '00', 'startPeriod': 'AM', 'endHour': '10', 'endMinute': '00', 'endPeriod': 'AM'},
      {'subject': 'Hindi', 'date': '5/1/2026', 'startHour': '09', 'startMinute': '00', 'startPeriod': 'AM', 'endHour': '10', 'endMinute': '00', 'endPeriod': 'AM'},
      {'subject': 'Maths', 'date': '6/1/2026', 'startHour': '09', 'startMinute': '00', 'startPeriod': 'AM', 'endHour': '10', 'endMinute': '00', 'endPeriod': 'AM'},
      {'subject': 'Science', 'date': '7/1/2026', 'startHour': '09', 'startMinute': '00', 'startPeriod': 'AM', 'endHour': '10', 'endMinute': '00', 'endPeriod': 'AM'},
      {'subject': 'Social', 'date': '8/1/2026', 'startHour': '09', 'startMinute': '00', 'startPeriod': 'AM', 'endHour': '10', 'endMinute': '00', 'endPeriod': 'AM'},
      {'subject': 'Art work', 'date': '9/1/2026', 'startHour': '09', 'startMinute': '00', 'startPeriod': 'AM', 'endHour': '10', 'endMinute': '00', 'endPeriod': 'AM'},
    ];
  }

  String _getFeatureTitle() {
    switch (_selectedFeature) {
      case ExaminationFeature.menu: return "Examination";
      case ExaminationFeature.examDetails: return "Exam Details";
      case ExaminationFeature.examTimetable: return "Exam Timetable";
      case ExaminationFeature.examHallTickets: return "Student List for Hall Tickets";
      case ExaminationFeature.gradeReport: return "Student Grade Reports";
      case ExaminationFeature.gradeReportCustom: return "Grade Report Custom";
    }
  }

  String _getFeatureSubtitle() {
    switch (_selectedFeature) {
      case ExaminationFeature.menu: return "Select a feature to continue";
      case ExaminationFeature.examDetails: return "View and search general examination records";
      case ExaminationFeature.examTimetable: return "Manage exam timetables, dates and timings";
      case ExaminationFeature.examHallTickets: return "View and print candidate hall tickets";
      case ExaminationFeature.gradeReport: return "Assess academic grades and classes";
      case ExaminationFeature.gradeReportCustom: return "Configure custom grading system rules";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FF),
      bottomNavigationBar: widget.onOpenDrawer == null ? AdminBottomNavBar(currentIndex: 4) : null,
      appBar: AdminAppBar(
        title: _getFeatureTitle(),
        subtitle: _getFeatureSubtitle(),
        leading: _selectedFeature != ExaminationFeature.menu ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              _selectedFeature = ExaminationFeature.menu;
            });
          },
        ) : null,
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: _buildSelectedFeatureBody(),
      ),
    );
  }

  Widget _buildSelectedFeatureBody() {
    switch (_selectedFeature) {
      case ExaminationFeature.menu: return _buildMainMenuView();
      case ExaminationFeature.examDetails: return _buildExamDetailsView();
      case ExaminationFeature.examTimetable: return _buildExamTimetableView();
      case ExaminationFeature.examHallTickets: return _buildExamHallTicketsView();
      case ExaminationFeature.gradeReport: return _buildGradeReportView(false);
      case ExaminationFeature.gradeReportCustom: return _buildGradeReportView(true);
    }
  }

  Widget _buildMainMenuView() {
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Exam Details', 'feature': ExaminationFeature.examDetails, 'icon': Icons.description_outlined},
      {'title': 'Exam Timetable', 'feature': ExaminationFeature.examTimetable, 'icon': Icons.calendar_month_outlined},
      {'title': 'Exam Hall Tickets', 'feature': ExaminationFeature.examHallTickets, 'icon': Icons.confirmation_number_outlined},
      {'title': 'Grade Report', 'feature': ExaminationFeature.gradeReport, 'icon': Icons.assessment_outlined},
      {'title': 'Grade Report Custom', 'feature': ExaminationFeature.gradeReportCustom, 'icon': Icons.settings_suggest_outlined},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFF5F7FF), borderRadius: BorderRadius.circular(8)),
                  child: Icon(item['icon'] as IconData, color: AppColors.primary, size: 20),
                ),
                title: Text((item['title'] as String).tr, style: const TextStyle(color: Color(0xFF1E2875), fontWeight: FontWeight.bold, fontSize: 14)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () => setState(() => _selectedFeature = item['feature'] as ExaminationFeature),
              ),
              if (index < menuItems.length - 1) Divider(height: 1, color: Colors.grey.shade200),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExamDetailsView() {
    final List<Map<String, dynamic>> mockExams = [
      {'name': 'Summative Assessment 1', 'code': 'SA1', 'type': 'Terminal', 'duration': '3 Hours', 'marks': '100', 'status': 'Upcoming'},
      {'name': 'Formative Assessment 1', 'code': 'FA1', 'type': 'Class Test', 'duration': '1.5 Hours', 'marks': '50', 'status': 'Completed'},
      {'name': 'Summative Assessment 2', 'code': 'SA2', 'type': 'Terminal', 'duration': '3 Hours', 'marks': '100', 'status': 'Upcoming'},
      {'name': 'Formative Assessment 2', 'code': 'FA2', 'type': 'Class Test', 'duration': '1.5 Hours', 'marks': '50', 'status': 'Completed'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: _buildFilterDropdown(label: "Branch", value: _selectedBranch, items: _branches, onChanged: (val) => setState(() => _selectedBranch = val!))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildFilterDropdown(label: "Class", value: _selectedClass, items: _classes, onChanged: (val) => setState(() => _selectedClass = val!))),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () => setState(() => _showDetailsData = true),
                child: Text("Get Data".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_showDetailsData)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Examination Records - $_selectedClass".tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                const SizedBox(height: 12),
                ScrollableTableWrapper(
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                    columns: [
                      DataColumn(label: Text("Exam Name".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF1E2875)))),
                      DataColumn(label: Text("Code".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF1E2875)))),
                      DataColumn(label: Text("Type".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF1E2875)))),
                      DataColumn(label: Text("Duration".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF1E2875)))),
                      DataColumn(label: Text("Max Marks".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF1E2875)))),
                      DataColumn(label: Text("Status".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF1E2875)))),
                    ],
                    rows: mockExams.map((exam) {
                      final isUpcoming = exam['status'] == 'Upcoming';
                      return DataRow(cells: [
                        DataCell(Text(exam['name']!.toString().tr)),
                        DataCell(Text(exam['code']!.toString())),
                        DataCell(Text(exam['type']!.toString().tr)),
                        DataCell(Text(exam['duration']!.toString())),
                        DataCell(Text(exam['marks']!.toString())),
                        DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: isUpcoming ? Colors.orange.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Text(exam['status']!.toString().tr, style: TextStyle(color: isUpcoming ? Colors.orange : Colors.green, fontSize: 10, fontWeight: FontWeight.bold)))),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildExamTimetableView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: _buildFilterDropdown(label: "Branch", value: _selectedBranch, items: _branches, onChanged: (val) => setState(() => _selectedBranch = val!))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildFilterDropdown(label: "Examination", value: _selectedExam, items: _exams, onChanged: (val) { setState(() { _selectedExam = val!; _examTitleController.text = val; }); })),
                  const SizedBox(width: 8),
                  Expanded(child: _buildFilterDropdown(label: "Class", value: _selectedClass, items: _classes, onChanged: (val) => setState(() => _selectedClass = val!))),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () => setState(() => _showTimetableData = true),
                child: Text("Get Timetable".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_showTimetableData) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("Exam Title".tr, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      const SizedBox(height: 4),
                      SizedBox(height: 40, child: TextField(controller: _examTitleController, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)), decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300))))),
                    ])),
                    const SizedBox(width: 12),
                    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)), onPressed: () { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Timetable for ${_examTitleController.text} saved successfully!".tr), backgroundColor: AppColors.success)); }, child: Text("Save".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    const SizedBox(width: 8),
                    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)), onPressed: () { setState(() { _timetableRows.add({'subject': _subjects.first, 'date': '10/1/2026', 'startHour': '09', 'startMinute': '00', 'startPeriod': 'AM', 'endHour': '10', 'endMinute': '00', 'endPeriod': 'AM'}); }); }, child: Text("Add New".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  ],
                ),
                const SizedBox(height: 16),
                ScrollableTableWrapper(
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerTheme: const DividerThemeData(thickness: 1, space: 1)),
                    child: Table(
                      border: TableBorder.all(color: Colors.grey.shade200, width: 1),
                      columnWidths: const { 0: FixedColumnWidth(160), 1: FixedColumnWidth(180), 2: FixedColumnWidth(210), 3: FixedColumnWidth(210), 4: FixedColumnWidth(60) },
                      children: [
                        TableRow(decoration: const BoxDecoration(color: Color(0xFF0F172A)), children: [ _buildTableHeaderCell("Subject"), _buildTableHeaderCell("Date"), _buildTableHeaderCell("Start Time"), _buildTableHeaderCell("End Time"), _buildTableHeaderCell("Action", isCenter: true) ]),
                        ...List.generate(_timetableRows.length, (index) {
                          final row = _timetableRows[index];
                          return TableRow(children: [
                            Padding(padding: const EdgeInsets.all(8.0), child: Container(padding: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(6)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: row['subject'], isDense: true, style: const TextStyle(fontSize: 12, color: Colors.black), onChanged: (v) => setState(() => row['subject'] = v!), items: _subjects.map((sub) => DropdownMenuItem(value: sub, child: Text(sub.tr))).toList())))),
                            Padding(padding: const EdgeInsets.all(8.0), child: InkWell(onTap: () async { final date = await showDatePicker(context: context, initialDate: DateTime(2026, 1, 1), firstDate: DateTime(2025, 1, 1), lastDate: DateTime(2027, 12, 31)); if (date != null) setState(() => row['date'] = "${date.day}/${date.month}/${date.year}"); }, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(6)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(row['date'], style: const TextStyle(fontSize: 12)), Icon(Icons.calendar_month, color: Colors.grey.shade600, size: 16)])))),
                            Padding(padding: const EdgeInsets.all(8.0), child: _buildTimePickerRow(row, 'start')),
                            Padding(padding: const EdgeInsets.all(8.0), child: _buildTimePickerRow(row, 'end')),
                            Padding(padding: const EdgeInsets.all(8.0), child: Center(child: IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 18), onPressed: () => setState(() => _timetableRows.removeAt(index))))),
                          ]);
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
      child: Text(text.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11), textAlign: isCenter ? TextAlign.center : TextAlign.start),
    );
  }

  Widget _buildTimePickerRow(Map<String, dynamic> row, String prefix) {
    final hours = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
    final minutes = List.generate(60, (index) => index.toString().padLeft(2, '0'));
    final periods = ['AM', 'PM'];
    return Row(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ const Text("HH", style: TextStyle(fontSize: 8, color: Colors.grey)), Container(height: 24, padding: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: row['${prefix}Hour'], style: const TextStyle(fontSize: 11, color: Colors.black), onChanged: (v) => setState(() => row['${prefix}Hour'] = v!), items: hours.map((h) => DropdownMenuItem(value: h, child: Text(h))).toList())))]),
      const SizedBox(width: 4), const Padding(padding: EdgeInsets.only(top: 12.0), child: Text(":")), const SizedBox(width: 4),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ const Text("MM", style: TextStyle(fontSize: 8, color: Colors.grey)), Container(height: 24, padding: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: row['${prefix}Minute'], style: const TextStyle(fontSize: 11, color: Colors.black), onChanged: (v) => setState(() => row['${prefix}Minute'] = v!), items: minutes.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList())))]),
      const SizedBox(width: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ const Text("AM/PM", style: TextStyle(fontSize: 8, color: Colors.grey)), Container(height: 24, padding: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: row['${prefix}Period'], style: const TextStyle(fontSize: 11, color: Colors.black), onChanged: (v) => setState(() => row['${prefix}Period'] = v!), items: periods.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList())))]),
    ]);
  }

  Widget _buildExamHallTicketsView() {
    final List<Map<String, dynamic>> fallbackStudents = [
      {'name': 'Deepthi', 'gender': 'Female', 'roll': 'ECS00021', 'admission': 'ECS00021', 'class': 'Grade 1', 'section': 'A', 'school': 'Ecstasy School 1'},
      {'name': 'tony', 'gender': 'Male', 'roll': 'ECS00031', 'admission': 'ECS00031', 'class': 'Grade 1', 'section': 'A', 'school': 'Ecstasy School 1'},
    ];

    List<Map<String, dynamic>> studentsList = AppDataStore.instance.students.where((s) => s['school'] == _selectedBranch && s['class'] == _selectedClass).toList();
    if (studentsList.isEmpty) { studentsList = fallbackStudents.where((s) => s['school'] == _selectedBranch && s['class'] == _selectedClass).toList(); }
    if (_searchQuery.isNotEmpty) { studentsList = studentsList.where((s) => s['name']!.toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList(); }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(child: _buildFilterDropdown(label: "Branch", value: _selectedBranch, items: _branches, onChanged: (val) => setState(() => _selectedBranch = val!))),
          const SizedBox(width: 8),
          Expanded(child: _buildFilterDropdown(label: "Examination", value: _selectedExam, items: _exams, onChanged: (val) => setState(() => _selectedExam = val!))),
          const SizedBox(width: 8),
          Expanded(child: _buildFilterDropdown(label: "Class", value: _selectedClass, items: _classes, onChanged: (val) => setState(() => _selectedClass = val!))),
        ]),
        const SizedBox(height: 12),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 14)), onPressed: () => setState(() => _showHallTicketData = true), child: Text("Get Data".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
      ])),
      const SizedBox(height: 16),
      if (_showHallTicketData) ...[
        TextField(controller: _searchController, style: const TextStyle(fontSize: 13), onChanged: (val) => setState(() => _searchQuery = val), decoration: InputDecoration(hintText: "Search students by name...".tr, prefixIcon: const Icon(Icons.search, color: Color(0xFF757897), size: 18), fillColor: Colors.white, filled: true, contentPadding: const EdgeInsets.symmetric(vertical: 0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ScrollableTableWrapper(child: Theme(data: Theme.of(context).copyWith(dividerTheme: const DividerThemeData(thickness: 1, space: 1)), child: Table(border: TableBorder.all(color: Colors.grey.shade100, width: 1), columnWidths: const { 0: FixedColumnWidth(220), 1: FixedColumnWidth(100), 2: FixedColumnWidth(140), 3: FixedColumnWidth(100), 4: FixedColumnWidth(100), 5: FixedColumnWidth(130) }, children: [
            TableRow(decoration: const BoxDecoration(color: Color(0xFF0F172A)), children: [ _buildTableHeaderCell("Student Name"), _buildTableHeaderCell("Gender"), _buildTableHeaderCell("Academic Year"), _buildTableHeaderCell("Class"), _buildTableHeaderCell("Section"), _buildTableHeaderCell("Action", isCenter: true) ]),
            if (studentsList.isEmpty) TableRow(children: [ TableCell(child: Padding(padding: const EdgeInsets.all(16.0), child: Text("No students found.".tr, style: const TextStyle(fontSize: 12, color: Colors.grey)))), TableCell(child: Container()), TableCell(child: Container()), TableCell(child: Container()), TableCell(child: Container()), TableCell(child: Container()) ])
            else ...studentsList.map((stud) => TableRow(children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text(stud['name'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text(stud['gender']?.toString().tr ?? '', style: const TextStyle(fontSize: 12))),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text("2025-26", style: TextStyle(fontSize: 12))),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text(stud['class'] ?? '', style: const TextStyle(fontSize: 12))),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text(stud['section'] ?? 'A', style: const TextStyle(fontSize: 12))),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: Center(child: SizedBox(height: 30, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), padding: const EdgeInsets.symmetric(horizontal: 12)), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminHallTicketPrintScreen(student: stud, examination: _selectedExam))), child: Text("Hall Ticket".tr, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))))),
            ])),
          ]))),
        ])),
      ]
    ]);
  }

  Widget _buildGradeReportView(bool isCustom) {
    if (isCustom) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(child: _buildFilterDropdown(label: "Branch", value: _selectedBranch, items: _branches, onChanged: (val) => setState(() => _selectedBranch = val!))),
            const SizedBox(width: 12),
            Expanded(child: _buildFilterDropdown(label: "Class", value: _selectedClass, items: _classes, onChanged: (val) => setState(() => _selectedClass = val!))),
          ]),
          const SizedBox(height: 12),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 14)), onPressed: () => setState(() => _showGradeData = true), child: Text("Get Data".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
        ])),
        const SizedBox(height: 16),
        if (_showGradeData) Container(width: double.infinity, padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)), child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [ Icon(Icons.tune_outlined, size: 48, color: AppColors.primary), const SizedBox(height: 16), Text("Grade Report Custom Rules".tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))), const SizedBox(height: 8), Text("Custom report parameters and thresholds details will be configured in the next phase.".tr, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center), const SizedBox(height: 20), Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)), child: Text("Configuration Pre-loaded for $_selectedBranch - $_selectedClass".tr, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)))]))
      ]);
    }

    final mockGradeStudents = [ {'admission': '02600046', 'name': 'Deepthi', 'gender': 'Female', 'class': 'Grade 1'}, {'admission': '02600047', 'name': 'Priya', 'gender': 'Female', 'class': 'Grade 1'} ];
    List<Map<String, String>> currentGradeList = _selectedClass == 'Grade 1' ? mockGradeStudents : AppDataStore.instance.students.where((s) => s['school'] == _selectedBranch && s['class'] == _selectedClass).map((s) => { 'admission': (s['admission'] ?? '').toString(), 'name': (s['name'] ?? '').toString(), 'gender': (s['gender'] ?? 'Male').toString(), 'class': (s['class'] ?? '').toString() }).toList();
    if (_gradeSearchQuery.isNotEmpty) { currentGradeList = currentGradeList.where((s) => s['name']!.toLowerCase().contains(_gradeSearchQuery.toLowerCase()) || s['admission']!.toLowerCase().contains(_gradeSearchQuery.toLowerCase())).toList(); }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(child: _buildFilterDropdown(label: "Branch", value: _selectedBranch, items: _branches, onChanged: (val) => setState(() => _selectedBranch = val!))),
          const SizedBox(width: 8),
          Expanded(child: _buildFilterDropdown(label: "Academic Year", value: _selectedYear, items: const ['2025-26', '2024-25', '2023-24'], onChanged: (val) => setState(() => _selectedYear = val!))),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _buildFilterDropdown(label: "Class", value: _selectedClass, items: _classes, onChanged: (val) => setState(() => _selectedClass = val!))),
          const SizedBox(width: 8),
          Expanded(child: _buildFilterDropdown(label: "Section", value: _selectedSection, items: const ['A', 'B', 'C'], onChanged: (val) => setState(() => _selectedSection = val!))),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(flex: 2, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC0392B), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 14)), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Recreating reports for $_selectedClass - Section $_selectedSection...".tr), backgroundColor: AppColors.primary)), child: Text("Recreate Report for Class".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)))),
          const SizedBox(width: 10),
          Expanded(flex: 1, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 14)), onPressed: () => setState(() => _showGradeData = true), child: Text("Search".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)))),
        ]),
      ])),
      const SizedBox(height: 16),
      if (_showGradeData) ...[
        TextField(
          controller: _gradeSearchController,
          style: const TextStyle(fontSize: 13),
          onChanged: (val) => setState(() => _gradeSearchQuery = val),
          decoration: InputDecoration(
            hintText: "Search".tr,
            suffixIcon: const Icon(Icons.search, color: Color(0xFF27AE60), size: 20),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    dividerTheme: const DividerThemeData(thickness: 1, space: 1),
                  ),
                  child: Table(
                    border: TableBorder.all(color: Colors.grey.shade100, width: 1),
                    columnWidths: const {
                      0: FixedColumnWidth(50),
                      1: FixedColumnWidth(140),
                      2: FixedColumnWidth(240),
                      3: FixedColumnWidth(110),
                      4: FixedColumnWidth(120),
                    },
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(color: Color(0xFF0F172A)),
                        children: [
                          _buildTableHeaderCell(""),
                          _buildTableHeaderCell("Admission No"),
                          _buildTableHeaderCell("Student Name"),
                          _buildTableHeaderCell("Gender"),
                          _buildTableHeaderCell("Class"),
                        ],
                      ),
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
                          ],
                        )
                      else
                        ...currentGradeList.map((stud) => TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                  child: Text(""),
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
                                      stud['gender']?.toString().tr ?? '',
                                      style: const TextStyle(fontSize: 12)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                  child: Text(stud['class'] ?? '',
                                      style: const TextStyle(fontSize: 12)),
                                ),
                              ],
                            )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ]);
  }

  Widget _buildFilterDropdown({required String label, required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [ Text(label.tr, style: const TextStyle(fontSize: 9, color: Colors.grey)), const SizedBox(height: 2), DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, isDense: true, isExpanded: true, style: const TextStyle(fontSize: 11, color: Color(0xFF1E2875), fontWeight: FontWeight.bold), items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item.tr))).toList(), onChanged: onChanged))]));
  }

  Widget _buildDrawer() {
    return Drawer(backgroundColor: Colors.white, child: ListView(padding: EdgeInsets.zero, children: [
      DrawerHeader(decoration: const BoxDecoration(color: Color(0xFF001C7F)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [ Row(children: [ CircleAvatar(radius: 25, backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xFF001C7F), size: 30)), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text("Admin User".tr, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), Text("Super Administrator".tr, style: const TextStyle(color: Colors.white70, fontSize: 12)) ])]), const SizedBox(height: 16), PopupMenuButton<String>(onSelected: (String value) => ProfileManager().selectedSchool.value = value, color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[ PopupMenuItem<String>(value: 'Ecstasy School 1', child: Text('Ecstasy School 1'.tr, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875)))), PopupMenuItem<String>(value: 'Ecstasy School 2', child: Text('Ecstasy School 2'.tr, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875)))), PopupMenuItem<String>(value: 'Ecstasy School 3', child: Text('Ecstasy School 3'.tr, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875)))) ], child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withValues(alpha: 0.15))), child: ValueListenableBuilder<String>(valueListenable: ProfileManager().selectedSchool, builder: (context, selectedSchool, _) => Row(children: [ const Icon(Icons.school_outlined, color: Colors.white, size: 18), const SizedBox(width: 8), Expanded(child: Text(selectedSchool, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500))), Icon(Icons.keyboard_arrow_down, color: Colors.white.withValues(alpha: 0.7), size: 18) ]))))])),
      _buildDrawerSectionTitle("MAIN"),
      _buildDrawerItem(Icons.grid_view_outlined, "Dashboard", false, () { Navigator.pop(context); Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => AdminDashboardScreen(initialIndex: 0)), (route) => false); }),
      Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent), child: ExpansionTile(initiallyExpanded: true, leading: const Icon(Icons.assignment_outlined, color: AppColors.primary), title: Text("Examination".tr, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)), trailing: Icon(_isExamExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right, size: 16, color: AppColors.primary), childrenPadding: const EdgeInsets.only(left: 12), onExpansionChanged: (isExpanded) => setState(() => _isExamExpanded = isExpanded), children: [
        _buildDrawerSubItem("Exam Details", () { Navigator.pop(context); setState(() => _selectedFeature = ExaminationFeature.examDetails); }),
        _buildDrawerSubItem("Exam Timetable", () { Navigator.pop(context); setState(() => _selectedFeature = ExaminationFeature.examTimetable); }),
        _buildDrawerSubItem("Exam Hall Tickets", () { Navigator.pop(context); setState(() => _selectedFeature = ExaminationFeature.examHallTickets); }),
        _buildDrawerSubItem("Grade Report", () { Navigator.pop(context); setState(() => _selectedFeature = ExaminationFeature.gradeReport); }),
        _buildDrawerSubItem("Grade Report Custom", () { Navigator.pop(context); setState(() => _selectedFeature = ExaminationFeature.gradeReportCustom); }),
      ])),
      const Divider(height: 20),
      _buildDrawerItem(Icons.logout, "Logout", false, () { Navigator.pop(context); Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false); }, showChevron: false),
    ]));
  }

  Widget _buildDrawerSectionTitle(String title) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0)));
  }

  Widget _buildDrawerItem(IconData icon, String title, bool selected, VoidCallback onTap, {bool showChevron = true}) {
    return ListTile(leading: Icon(icon, color: selected ? AppColors.primary : const Color(0xFF757897)), title: Text(title, style: TextStyle(color: selected ? AppColors.primary : const Color(0xFF1E2875), fontWeight: selected ? FontWeight.bold : FontWeight.w500, fontSize: 13)), trailing: showChevron ? const Icon(Icons.chevron_right, size: 16, color: Colors.grey) : null, selected: selected, onTap: onTap, dense: true);
  }

  Widget _buildDrawerSubItem(String title, VoidCallback onTap) {
    return ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 0), title: Text(title.tr, style: const TextStyle(color: Color(0xFF1E2875), fontSize: 12, fontWeight: FontWeight.w500)), onTap: onTap, dense: true);
  }
}
