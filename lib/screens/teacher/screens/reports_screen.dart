import 'package:flutter/material.dart';
import '../../../widgets/scrollable_table_wrapper.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_actions.dart';
import '../../../core/data/app_data_store.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class ReportItem {
  final String name;
  final String type;
  final String date;
  final String time;
  final String author;
  final String avatarUrl;

  ReportItem({
    required this.name,
    required this.type,
    required this.date,
    required this.time,
    required this.author,
    required this.avatarUrl,
  });
}

class ReportsScreen extends StatefulWidget {
  final int activeTab;
  final Function(int)? onSubTabSelected;

  ReportsScreen({
    super.key,
    this.activeTab = 0,
    this.onSubTabSelected,
  });

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedPeriod = "This Term";
  final List<ReportItem> _recentReports = [
    ReportItem(name: "Class 8 Performance Report", type: "Student Report", date: "20 May 2024", time: "10:30 AM", author: "Ms. Priya Sharma", avatarUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100"),
    ReportItem(name: "Monthly Attendance Report April 2024", type: "Attendance Report", date: "18 May 2024", time: "04:15 PM", author: "Mr. Ramesh Kumar", avatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100"),
    ReportItem(name: "Unit Test - I Result Analysis Class 9", type: "Exam Report", date: "17 May 2024", time: "02:40 PM", author: "Mr. Amit Gupta", avatarUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100"),
    ReportItem(name: "Class 10 Subject Summary", type: "Class Report", date: "15 May 2024", time: "11:20 AM", author: "Ms. Neha Verma", avatarUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100"),
    ReportItem(name: "Term 1 Overall Report (Classes 6 - 10)", type: "Custom Report", date: "10 May 2024", time: "09:00 AM", author: "Ms. Sneha Reddy", avatarUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100"),
  ];

  String selectedOverviewClass = "Class 8";
  final _store = AppDataStore.instance;

  List<String> get _availableClasses {
    return _store.studyClasses.map((c) => c['name'] as String).toList();
  }

  @override
  void initState() {
    super.initState();
    _store.configVersion.addListener(_onStoreChanged);
    if (_availableClasses.isNotEmpty) {
      selectedOverviewClass = _availableClasses.first;
    }
  }

  void _onStoreChanged() {
    setState(() {
      if (_availableClasses.isNotEmpty && !_availableClasses.contains(selectedOverviewClass)) {
        selectedOverviewClass = _availableClasses.first;
      }
    });
  }

  @override
  void dispose() {
    _store.configVersion.removeListener(_onStoreChanged);
    super.dispose();
  }

  // Custom Report State
  String _selectedClass = "All Classes";
  String _selectedStudent = "All Students";
  String _selectedSubject = "All Subjects";
  String _selectedReportType = "Attendance";
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _classes = ["All Classes", "Class 8", "Class 9", "Class 10"];
  final List<String> _students = ["All Students", "Aarav Sharma", "Ananya Verma", "Vivaan Mehta"];
  final List<String> _subjects = ["All Subjects", "Mathematics", "Science", "English"];
  final List<String> _reportTypes = ["Attendance", "Examinations", "Assignments", "Class Participation"];

  void _clearFilters() {
    setState(() {
      _selectedClass = "All Classes";
      _selectedStudent = "All Students";
      _selectedSubject = "All Subjects";
      _selectedReportType = "Attendance";
      _startDate = null;
      _endDate = null;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _showGenerateReportDialog() {
    final nameController = TextEditingController();
    final typeController = TextEditingController();
    final authorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Generate New Report".tr),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Report Name"),
                ),
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(labelText: "Report Type (e.g. Student Report, Class Report)"),
                ),
                TextField(
                  controller: authorController,
                  decoration: InputDecoration(labelText: "Author / Generated By"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel".tr),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _recentReports.insert(
                      0,
                      ReportItem(
                        name: nameController.text,
                        type: typeController.text.isNotEmpty ? typeController.text : "General Report",
                        date: "17 Jun 2026",
                        time: "12:26 PM",
                        author: authorController.text.isNotEmpty ? authorController.text : "Ms. Priya Sharma",
                        avatarUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
                      ),
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${nameController.text} generated successfully')),
                  );
                }
              },
              child: Text("Generate".tr),
            ),
          ],
        );
      },
    );
  }

  void _showExportDataDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Export Report Data".tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Choose export format:".tr, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.table_view, color: Colors.green),
                title: Text("Microsoft Excel (.xlsx)".tr),
              ),
              ListTile(
                leading: Icon(Icons.description, color: Colors.blue),
                title: Text("Portable Document Format (.pdf)".tr),
              ),
              ListTile(
                leading: Icon(Icons.code, color: Colors.orange),
                title: Text("Comma Separated Values (.csv)".tr),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel".tr),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Export started... data will download shortly.".tr)),
                );
              },
              child: Text("Export".tr),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: widget.activeTab > 4 ? 0 : widget.activeTab,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.white,
            elevation: 1,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: EdgeInsets.symmetric(horizontal: 12),
              dividerColor: Colors.transparent,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: [
                Tab(text: "Overall School Report"),
                Tab(text: "Academic Report"),
                Tab(text: "Financial Report"),
                Tab(text: "HR Report"),
                Tab(text: "Asset Report"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildOverview(),
                _buildReportDetailList(),
                _buildReportDetailList(), // financial placeholder
                _buildReportDetailList(), // hr placeholder
                _buildReportDetailList(), // asset placeholder
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview() {
    if (selectedPeriod == "This Month") {
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── All Classes Overview Grid ────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Row(
              children: [
                Text('Overview'.tr,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B263B)),
                ),
                Spacer(),
                Text(
                  '${_availableClasses.length} Classes',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 148,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _availableClasses.length,
              separatorBuilder: (_, __) => SizedBox(width: 10),
              itemBuilder: (context, index) {
                final clsName = _availableClasses[index];
                final isSelected = clsName == selectedOverviewClass;
                final colors = [
                  Colors.blue, Colors.green, Colors.purple, Colors.orange,
                  Colors.teal, Colors.red, Colors.indigo,
                ];
                final color = colors[index % colors.length];
                
                final totalSts = 35; // Mock data for reports view
                final boysSts = 18;
                final girlsSts = 17;
                
                final mapping = _store.classSubjectsMapping.where((m) {
                  final baseClass = clsName.split(' - ').first;
                  return m['class'] == baseClass;
                }).toList();
                final teacherName = mapping.isNotEmpty ? mapping.first['teacher']?.split(' ').last ?? 'N/A' : 'TBD';
                final subjectCount = mapping.length;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOverviewClass = clsName;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: 130,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.blue[700]! : Colors.grey[200]!,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: Colors.blue.withValues(alpha: 0.15), blurRadius: 8, offset: Offset(0, 3))]
                          : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 32,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  clsName.split(' ').last,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: color),
                                ),
                              ),
                            ),
                            Spacer(),
                            if (isSelected)
                              Icon(Icons.check_circle, color: Colors.blue[700], size: 14),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          clsName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Color(0xFF1B263B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          '$totalSts students',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600]),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '${boysSts}B · ${girlsSts}G',
                          style: TextStyle(
                              fontSize: 10,
                              color: color,
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                teacherName,
                                style: TextStyle(
                                    fontSize: 9, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '$subjectCount sub',
                                style: TextStyle(
                                    fontSize: 8,
                                    color: color,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Summary Row Text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 8,
              runSpacing: 8,
              children: [
                Text("Total Students: 538".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue)),
                Text("Pass Percentage: 94%".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green)),
                Text("Average Attendance: 92%".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.orange)),
              ],
            ),
          ),
          SizedBox(height: 16),

          // 2. Overview Stats (Horizontal scroll)
          SizedBox(
            height: 140, // Increased height to prevent bottom overflow
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                StatCard(
                  title: "Total Staff",
                  value: "124",
                  icon: Icons.people,
                  iconColor: Colors.blue,
                  iconBackgroundColor: Colors.blue.withValues(alpha: 0.1),
                ),
                StatCard(
                  title: "Teaching Staff",
                  value: "85",
                  icon: Icons.school,
                  iconColor: Colors.green,
                  iconBackgroundColor: Colors.green.withValues(alpha: 0.1),
                ),
                StatCard(
                  title: "Non-Teaching Staff",
                  value: "39",
                  icon: Icons.support_agent,
                  iconColor: Colors.orange,
                  iconBackgroundColor: Colors.orange.withValues(alpha: 0.1),
                ),
                StatCard(
                  title: "Total Assets",
                  value: "1,450",
                  icon: Icons.inventory_2,
                  iconColor: Colors.purple,
                  iconBackgroundColor: Colors.purple.withValues(alpha: 0.1),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // 3. Academic Performance Overview
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Academic Performance Overview".tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B263B),
                  ),
                ),
                TextButton(
                  onPressed: () => widget.onSubTabSelected?.call(1),
                  child: Text("View All".tr, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),

          // Recent Reports Table/List
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _recentReports.length,
                separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey),
                itemBuilder: (context, index) {
                  final report = _recentReports[index];
                  return InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening ${report.name}...')),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Icon
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.article_outlined, color: Colors.blue[800], size: 20),
                          ),
                          SizedBox(width: 12),
                          // Center Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  report.name,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B263B)),
                                ),
                                SizedBox(height: 4),
                                // Subtitle with overflow protection
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      report.type,
                                      style: TextStyle(color: Colors.grey[600], fontSize: 11, fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(width: 6),
                                    Container(width: 3, height: 3, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey)),
                                    SizedBox(width: 6),
                                    Text(
                                      "${report.date} | ${report.time}",
                                      style: TextStyle(color: Colors.grey[500], fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16), // Increased space between report title and author profile
                          // Right Author Avatar
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    report.author.split(' ').last,
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.more_vert, color: Colors.grey, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => widget.onSubTabSelected?.call(1),
              child: Text("View All Reports ->".tr, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: 20),

          SizedBox(height: 20),

          // 4. Quick Actions
          QuickActionsBar(
            actions: [
              QuickActionItem(title: "Generate Reports", icon: Icons.add_circle_outline, onTap: _showGenerateReportDialog),
              QuickActionItem(title: "Export Data", icon: Icons.file_download_outlined, onTap: _showExportDataDialog),
              QuickActionItem(
                title: "Schedule Reports",
                icon: Icons.calendar_month,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Scheduling feature coming soon...".tr)),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildReportDetailList() {
    final List<String> categories = ["Overview", "Student Reports", "Attendance Reports", "Exam Reports", "Class Reports", "Custom Reports"];
    final String currentCategory = categories[widget.activeTab];

    if (widget.activeTab == 2) {
      return _buildAttendanceReportView();
    }
    if (widget.activeTab == 3) {
      return _buildExamReportView();
    }
    if (widget.activeTab == 4) {
      return _buildClassReportView();
    }
    if (widget.activeTab == 5) {
      return _buildCustomReportView();
    }

    // Filter reports based on category if needed, for now just show a list
    final filteredReports = _recentReports.where((r) => r.type == currentCategory || widget.activeTab == 1).toList();

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => widget.onSubTabSelected?.call(0),
              ),
              Text(
                currentCategory,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B263B)),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredReports.length,
              itemBuilder: (context, index) {
                final report = filteredReports[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Icon(Icons.article, color: Colors.blue),
                    title: Text(report.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${report.date} | ${report.author}"),
                    trailing: Icon(Icons.download, color: Colors.grey),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening ${report.name}...')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceReportView() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: EdgeInsets.symmetric(horizontal: 12),
            dividerColor: Colors.transparent,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: "Student Attendance"),
              Tab(text: "Employee Attendance"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildStudentAttendanceTable(),
                _buildEmployeeAttendanceTable(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentAttendanceTable() {
    final List<Map<String, dynamic>> studentAttendance = [
      {"name": "Aarav Sharma", "presents": 22, "absents": 2},
      {"name": "Ananya Verma", "presents": 24, "absents": 0},
      {"name": "Vivaan Mehta", "presents": 20, "absents": 4},
      {"name": "Myra Singh", "presents": 23, "absents": 1},
      {"name": "Arjun Gupta", "presents": 21, "absents": 3},
      {"name": "Diya Patel", "presents": 19, "absents": 5},
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: ScrollableTableWrapper(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(Colors.grey[50]),
            columns: [
              DataColumn(label: Text("Student Name".tr, style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("Presents".tr, style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("Absents".tr, style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: studentAttendance.map((data) {
              return DataRow(cells: [
                DataCell(Text(data["name"])),
                DataCell(Text("${data["presents"]}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                DataCell(Text("${data["absents"]}", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeAttendanceTable() {
    final List<Map<String, dynamic>> employeeAttendance = [
      {"name": "Ms. Priya Sharma", "presents": 20, "absents": 1, "sickUsed": 1, "sickTotal": 2, "normalUsed": 2},
      {"name": "Mr. Ramesh Kumar", "presents": 22, "absents": 0, "sickUsed": 0, "sickTotal": 2, "normalUsed": 2},
      {"name": "Ms. Neha Verma", "presents": 18, "absents": 2, "sickUsed": 2, "sickTotal": 2, "normalUsed": 2},
      {"name": "Mr. Amit Gupta", "presents": 21, "absents": 0, "sickUsed": 1, "sickTotal": 2, "normalUsed": 2},
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: ScrollableTableWrapper(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(Colors.grey[50]),
            columns: [
              DataColumn(label: Text("Employee Name".tr, style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("Presents".tr, style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("Absents".tr, style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("Sick Leaves (Used/Total)".tr, style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("Normal Leaves".tr, style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: employeeAttendance.map((data) {
              return DataRow(cells: [
                DataCell(Text(data["name"])),
                DataCell(Text("${data["presents"]}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                DataCell(Text("${data["absents"]}", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                DataCell(
                  Row(
                    children: [
                      Text("${data["sickUsed"]}/${data["sickTotal"]}"),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 40,
                        child: LinearProgressIndicator(
                          value: data["sickUsed"] / data["sickTotal"],
                          backgroundColor: Colors.grey[200],
                          color: data["sickUsed"] >= data["sickTotal"] ? Colors.red : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(Text("${data["normalUsed"]} Used")),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildExamReportView() {
    final List<Map<String, dynamic>> examReports = [
      {
        "subject": "Mathematics",
        "date": "20 May 2024",
        "status": "Completed",
        "attended": 42,
        "passed": 38,
        "failed": 4
      },
      {
        "subject": "Science",
        "date": "18 May 2024",
        "status": "Completed",
        "attended": 40,
        "passed": 35,
        "failed": 5
      },
      {
        "subject": "English",
        "date": "15 May 2024",
        "status": "Completed",
        "attended": 41,
        "passed": 39,
        "failed": 2
      },
      {
        "subject": "Social Studies",
        "date": "25 May 2024",
        "status": "Upcoming",
        "attended": 0,
        "passed": 0,
        "failed": 0
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => widget.onSubTabSelected?.call(0),
              ),
              Text("Exam Reports".tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B263B)),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: ScrollableTableWrapper(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey[50]),
                columns: [
                  DataColumn(label: Text("Subject".tr, style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Date".tr, style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Status".tr, style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Attended".tr, style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Passed".tr, style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Failed".tr, style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: examReports.map((data) {
                  final isCompleted = data["status"] == "Completed";
                  return DataRow(cells: [
                    DataCell(Text(data["subject"], style: TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(Text(data["date"])),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCompleted ? Colors.green[50] : Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          data["status"],
                          style: TextStyle(
                            color: isCompleted ? Colors.green[800] : Colors.orange[800],
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text("${data["attended"]}")),
                    DataCell(Text("${data["passed"]}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                    DataCell(Text("${data["failed"]}", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomReportView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => widget.onSubTabSelected?.call(0),
              ),
              Text("Generate Custom Report".tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B263B)),
              ),
            ],
          ),
          SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Select Criteria".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      TextButton.icon(
                        onPressed: _clearFilters,
                        icon: Icon(Icons.refresh, size: 16),
                        label: Text("Clear All".tr, style: TextStyle(fontSize: 13)),
                        style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          "Select Class",
                          _classes,
                          _selectedClass,
                              (val) => setState(() => _selectedClass = val!),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdownField(
                          "Select Student",
                          _students,
                          _selectedStudent,
                              (val) => setState(() => _selectedStudent = val!),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          "Select Subject",
                          _subjects,
                          _selectedSubject,
                              (val) => setState(() => _selectedSubject = val!),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdownField(
                          "Report Type",
                          _reportTypes,
                          _selectedReportType,
                              (val) => setState(() => _selectedReportType = val!),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text("Date Range".tr, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, true),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  _startDate == null ? "Start Date" : _startDate!.toString().split(' ')[0],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _startDate == null ? Colors.grey[600] : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, false),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  _endDate == null ? "End Date" : _endDate!.toString().split(' ')[0],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _endDate == null ? Colors.grey[600] : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Generating report for $_selectedClass, $_selectedReportType...",
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1B263B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text("Generate Report".tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Text("Export Options".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildExportButton(Icons.picture_as_pdf, "PDF", Colors.red),
              _buildExportButton(Icons.table_view, "Excel", Colors.green),
              _buildExportButton(Icons.description, "CSV", Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedValue,
            underline: SizedBox(),
            style: TextStyle(color: Colors.black87, fontSize: 13),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildExportButton(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Exporting as $label...")),
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildClassReportView() {
    final List<Map<String, dynamic>> classReports = [
      {
        "class": "Class 8 - A",
        "total": 42,
        "present": 38,
        "attendance": "90.4%",
        "avgMarks": "78.5",
        "assignments": "12/15",
        "remarks": "Excellent overall performance."
      },
      {
        "class": "Class 9 - A",
        "total": 40,
        "present": 36,
        "attendance": "90.0%",
        "avgMarks": "72.2",
        "assignments": "10/15",
        "remarks": "Need to focus on Science labs."
      },
      {
        "class": "Class 10 - A",
        "total": 39,
        "present": 39,
        "attendance": "100%",
        "avgMarks": "84.0",
        "assignments": "15/15",
        "remarks": "Perfect attendance this month."
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => widget.onSubTabSelected?.call(0),
              ),
              Text("Class Reports".tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B263B)),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: ScrollableTableWrapper(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey[50]),
                columnSpacing: 24,
                columns: [
                  DataColumn(label: Text("Class".tr, style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Total".tr, style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Present".tr, style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Atten. %".tr, style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Avg. Marks".tr, style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Assignments".tr, style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Remarks".tr, style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: classReports.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data["class"], style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text("${data["total"]}")),
                    DataCell(Text("${data["present"]}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500))),
                    DataCell(Text(data["attendance"])),
                    DataCell(Text(data["avgMarks"])),
                    DataCell(Text(data["assignments"])),
                    DataCell(
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 180),
                        child: Text(data["remarks"], style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
