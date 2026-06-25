import 'package:flutter/material.dart';
import '../../../widgets/scrollable_table_wrapper.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_actions.dart';
import '../../../core/data/app_data_store.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class ExamItem {
  final String name;
  final String term;
  final String className;
  final String subject;
  final String date;
  final String time;
  final String duration;

  ExamItem({
    required this.name,
    required this.term,
    required this.className,
    required this.subject,
    required this.date,
    required this.time,
    required this.duration,
  });
}

class ExamResultItem {
  final String name;
  final String term;
  final String className;
  final String subject;
  final String publishedDate;

  ExamResultItem({
    required this.name,
    required this.term,
    required this.className,
    required this.subject,
    required this.publishedDate,
  });
}

class ExamsScreen extends StatefulWidget {
  final int activeTab;
  final Function(int)? onSubTabSelected;

  ExamsScreen({
    super.key,
    this.activeTab = 0,
    this.onSubTabSelected,
  });

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  String selectedClass = "Class 8";
  final _store = AppDataStore.instance;

  List<String> get _availableClasses {
    return _store.studyClasses.map((c) => c['name'] as String).toList();
  }

  @override
  void initState() {
    super.initState();
    _store.configVersion.addListener(_onStoreChanged);
    if (_availableClasses.isNotEmpty) {
      selectedClass = _availableClasses.first;
    }
  }

  void _onStoreChanged() {
    setState(() {
      if (_availableClasses.isNotEmpty && !_availableClasses.contains(selectedClass)) {
        selectedClass = _availableClasses.first;
      }
    });
  }

  @override
  void dispose() {
    _store.configVersion.removeListener(_onStoreChanged);
    super.dispose();
  }

  final List<ExamItem> _upcomingExams = [
    ExamItem(name: "Unit Test - I", term: "Term 1", className: "Class 8", subject: "Mathematics", date: "24 May 2024", time: "10:00 AM", duration: "1h 30m"),
    ExamItem(name: "Unit Test - I", term: "Term 1", className: "Class 9", subject: "Science", date: "25 May 2024", time: "10:00 AM", duration: "1h 30m"),
    ExamItem(name: "Half Yearly Exam", term: "Term 1", className: "Class 10", subject: "English", date: "27 May 2024", time: "09:00 AM", duration: "2h 30m"),
    ExamItem(name: "Mid Term Exam", term: "Term 1", className: "Class 8", subject: "Social Studies", date: "29 May 2024", time: "11:00 AM", duration: "1h 30m"),
    ExamItem(name: "Half Yearly Exam", term: "Term 1", className: "Class 9", subject: "Mathematics", date: "31 May 2024", time: "09:00 AM", duration: "2h 30m"),
  ];

  final List<ExamResultItem> _recentResults = [
    ExamResultItem(name: "Unit Test - I", term: "Term 1", className: "Class 8", subject: "Mathematics", publishedDate: "18 May 2024"),
    ExamResultItem(name: "Unit Test - I", term: "Term 1", className: "Class 7", subject: "English", publishedDate: "17 May 2024"),
    ExamResultItem(name: "Mid Term Exam", term: "Term 1", className: "Class 9", subject: "Science", publishedDate: "15 May 2024"),
  ];

  int _conductedExamsCount = 4;

  void _showCreateExamDialog() {
    final nameController = TextEditingController();
    final termController = TextEditingController();
    final classController = TextEditingController();
    final subjectController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Create New Exam".tr),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Exam Name (e.g. Unit Test - II)"),
                ),
                TextField(
                  controller: termController,
                  decoration: InputDecoration(labelText: "Term (e.g. Term 1, Term 2)"),
                ),
                TextField(
                  controller: classController,
                  decoration: InputDecoration(labelText: "Class Name (e.g. Class 8)"),
                ),
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(labelText: "Subject"),
                ),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: "Date (e.g. 15 June 2024)"),
                ),
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(labelText: "Time (e.g. 10:00 AM)"),
                ),
                TextField(
                  controller: durationController,
                  decoration: InputDecoration(labelText: "Duration (e.g. 1h 30m)"),
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
                if (nameController.text.isNotEmpty && subjectController.text.isNotEmpty) {
                  setState(() {
                    _upcomingExams.insert(
                      0,
                      ExamItem(
                        name: nameController.text,
                        term: termController.text.isNotEmpty ? termController.text : "Term 1",
                        className: classController.text.isNotEmpty ? classController.text : "Class 8",
                        subject: subjectController.text,
                        date: dateController.text.isNotEmpty ? dateController.text : "TBD",
                        time: timeController.text.isNotEmpty ? timeController.text : "10:00 AM",
                        duration: durationController.text.isNotEmpty ? durationController.text : "1h 30m",
                      ),
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${nameController.text} scheduled successfully')),
                  );
                }
              },
              child: Text("Create".tr),
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog(String examName, String subject, String className) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("$examName - $subject ($className)"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Performance Report:".tr, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Average Score:".tr), Text("78.5%".tr, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Highest Score:".tr), Text("98.0%".tr, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Lowest Score:".tr), Text("45.0%".tr, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red))],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Passing Percentage:".tr), Text("92.3%".tr, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple))],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close".tr),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Downloading detailed analysis...".tr)),
                );
              },
              child: Text("Download PDF".tr),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: widget.activeTab > 2 ? 0 : widget.activeTab,
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
                Tab(text: "View Examination"),
                Tab(text: "Subject-wise Marks"),
                Tab(text: "Students Performance"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildOverviewTab(),
                _buildExamScheduleTab(),
                _buildResultsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
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
                final isSelected = clsName == selectedClass;
                final colors = [
                  Colors.blue, Colors.green, Colors.purple, Colors.orange,
                  Colors.teal, Colors.red, Colors.indigo,
                ];
                final color = colors[index % colors.length];
                
                final totalSts = 35; // Mock data
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
                      selectedClass = clsName;
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
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  '$selectedClass — Overview',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B263B)),
                ),
              ],
            ),
          ),
          
          // 2. Stat Cards
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                StatCard(
                  title: "Upcoming Exams",
                  value: "${_upcomingExams.length}",
                  icon: Icons.hourglass_empty,
                  iconColor: Colors.purple,
                  iconBackgroundColor: Colors.purple.withValues(alpha: 0.1),
                ),
                StatCard(
                  title: "Exams Conducted",
                  value: "$_conductedExamsCount",
                  icon: Icons.task_alt,
                  iconColor: Colors.orange,
                  iconBackgroundColor: Colors.orange.withValues(alpha: 0.1),
                ),
                StatCard(
                  title: "Passed Students",
                  value: "38",
                  icon: Icons.check_circle_outline,
                  iconColor: Colors.green,
                  iconBackgroundColor: Colors.green.withValues(alpha: 0.1),
                ),
                StatCard(
                  title: "Failed Students",
                  value: "4",
                  icon: Icons.cancel_outlined,
                  iconColor: Colors.red,
                  iconBackgroundColor: Colors.red.withValues(alpha: 0.1),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // 3. Upcoming Exams Table
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Upcoming Exams (${_upcomingExams.length})",
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

          _buildExamsTable(_upcomingExams),

          SizedBox(height: 20),

          // 4. Quick Actions
          QuickActionsBar(
            actions: [
              QuickActionItem(title: "Create Exam", icon: Icons.add_circle_outline, onTap: _showCreateExamDialog),
              QuickActionItem(title: "Record Marks", icon: Icons.edit_note, onTap: () {}),
              QuickActionItem(title: "Download Report Card", icon: Icons.file_download_outlined, onTap: () {}),
              QuickActionItem(title: "Generate Syllabus", icon: Icons.menu_book, onTap: () {}),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildExamsTable(List<ExamItem> exams) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
        child: ScrollableTableWrapper(
          child: SizedBox(
            width: 600,
            child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              color: Colors.grey[50],
              child: Row(children: [
                  Expanded(flex: 2, child: Text("Name".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  Expanded(flex: 1, child: Text("Term".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  Expanded(flex: 2, child: Text("Subject".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  Expanded(flex: 2, child: Text("Date".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  Expanded(flex: 1, child: Text("Time".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  Expanded(flex: 1, child: Text("Duration".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.right)),
                ],
              ),
            ),
            Divider(height: 1),
            ...exams.map((e) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text(e.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  Expanded(flex: 1, child: Text(e.term, style: TextStyle(fontSize: 11))),
                  Expanded(flex: 2, child: Text(e.subject, style: TextStyle(fontSize: 11))),
                  Expanded(flex: 2, child: Text(e.date, style: TextStyle(fontSize: 11))),
                  Expanded(flex: 1, child: Text(e.time, style: TextStyle(fontSize: 11))),
                  Expanded(flex: 1, child: Text(e.duration, style: TextStyle(fontSize: 11), textAlign: TextAlign.right)),
                ],
              ),
            )),
          ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExamScheduleTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Exam Schedule (${_upcomingExams.length})",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B263B)),
                ),
                ElevatedButton.icon(
                  onPressed: _showCreateExamDialog,
                  icon: Icon(Icons.add, size: 16),
                  label: Text("New Exam".tr, style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1B263B),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          _buildExamsList(_upcomingExams),
          SizedBox(height: 20),
          QuickActionsBar(
            actions: [
              QuickActionItem(title: "Calendar View", icon: Icons.calendar_today, onTap: () {}),
              QuickActionItem(title: "Room Allocation", icon: Icons.room_preferences, onTap: () {}),
              QuickActionItem(title: "Invigilation List", icon: Icons.person_search, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Recent Exam Results".tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B263B)),
            ),
          ),
          _buildResultsList(_recentResults),
          SizedBox(height: 20),
          QuickActionsBar(
            actions: [
              QuickActionItem(title: "Enter Marks", icon: Icons.edit_note, onTap: () {}),
              QuickActionItem(title: "Publish Result", icon: Icons.campaign_outlined, onTap: () {}),
              QuickActionItem(title: "Result Analytics", icon: Icons.analytics, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExamsList(List<ExamItem> exams) {
    return Padding(
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
          itemCount: exams.length,
          separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey),
          itemBuilder: (context, index) {
            final exam = exams[index];
            return Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.assignment_outlined, color: Colors.blue[800], size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exam.name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B263B)),
                        ),
                        Text(
                          exam.term,
                          style: TextStyle(color: Colors.grey[500], fontSize: 10),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _buildSmallChip("Class", exam.className, Colors.blue),
                            _buildSmallChip("Subject", exam.subject, Colors.green),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 10, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(exam.date, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 10, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(exam.time, style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        exam.duration,
                        style: TextStyle(color: Colors.grey[600], fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.more_vert, color: Colors.grey, size: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultsList(List<ExamResultItem> results) {
    return Padding(
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
          itemCount: results.length,
          separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey),
          itemBuilder: (context, index) {
            final result = results[index];
            return Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.task_alt, color: Colors.green[800], size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${result.name} - ${result.subject}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B263B)),
                        ),
                        Text(
                          "${result.className} | Published: ${result.publishedDate}",
                          style: TextStyle(color: Colors.grey[500], fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showReportDialog(result.name, result.subject, result.className),
                    child: Text("View Report".tr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  Icon(Icons.more_vert, color: Colors.grey, size: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSmallChip(String prefix, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$prefix: ", style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: Colors.black87, fontSize: 9, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}