import 'package:flutter/material.dart';
import '../../../widgets/scrollable_table_wrapper.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_actions.dart';
import '../../../core/data/app_data_store.dart';
import '../../../core/utils/profile_manager.dart';
import 'students_screen.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class ClassItem {
  String section;
  int students;
  int boys;
  int girls;
  String teacher;
  String room;
  List<String> subjects;

  ClassItem({
    required this.section,
    required this.students,
    required this.boys,
    required this.girls,
    required this.teacher,
    required this.room,
    this.subjects = const ["Mathematics", "Science", "English"],
  });
}

class ClassesScreen extends StatefulWidget {
  final int activeTab;
  final Function(int)? onSubTabSelected;
  final Function(int, {int? subTab, String? moreSubScreen})? onNavigateTab;

  ClassesScreen({
    super.key,
    this.activeTab = 0,
    this.onSubTabSelected,
    this.onNavigateTab,
  });

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  String selectedOverviewClass = "";
  String searchQuery = "";
  int _currentPage = 1;
  final int _itemsPerPage = 7;

  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  final _store = AppDataStore.instance;
  List<Map<String, dynamic>>? _attendanceList;

  List<ClassItem> get _allClasses {
    final classes = _store.studyClasses.map((c) => c['name'] as String).toSet().toList();
    final subjects = _store.subjects.map((s) => s['name'] as String).toSet().toList();

    // Get the unified list of students dynamically
    final allStudents = StudentsScreen.getUnifiedStudents(_store, ProfileManager().selectedSchool.value);

    List<ClassItem> list = [];
    int roomCounter = 101;
    for (int i = 0; i < classes.length; i++) {
      final className = classes[i];
      // Filter students by className (ignoring section suffix e.g. Class 10 - A)
      final classSts = allStudents.where((s) => s.className.split(' - ').first == className).toList();
      final totalSts = classSts.length;
      final boysSts = classSts.where((s) => s.gender == "Male").length;
      final girlsSts = classSts.where((s) => s.gender == "Female").length;

      list.add(ClassItem(
        section: className,
        students: totalSts,
        boys: boysSts,
        girls: girlsSts,
        teacher: "Teacher ${i + 1}",
        room: "${roomCounter++}",
        subjects: subjects.take(3).toList(),
      ));
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    _store.configVersion.addListener(_onStoreChanged);
    if (_allClasses.isNotEmpty) {
      selectedOverviewClass = _allClasses.first.section;
    }
  }

  void _onStoreChanged() {
    setState(() {
      if (_allClasses.isNotEmpty && !_allClasses.any((c) => c.section == selectedOverviewClass)) {
        selectedOverviewClass = _allClasses.first.section;
      }
    });
  }

  @override
  void dispose() {
    _store.configVersion.removeListener(_onStoreChanged);
    _classNameController.dispose();
    _teacherController.dispose();
    _roomController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  void _showAddClassDialog() {
    // Currently Study Classes are added via Admin > Settings.
    // For the demo, show a message directing them there.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Notice".tr),
        content: Text("Please add new classes and sections from the Admin Settings > Study Classes / Sections menu.".tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK".tr),
          ),
        ],
      ),
    );
  }

  void _showAssignTeacherDialog() {
    // Currently assigned through mapping in store
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Assign teacher through Admin > Settings > Subjects Mapping'.tr))
    );
  }

  void _showManageSubjectsDialog() {
    String? selectedClass = _allClasses.isNotEmpty ? _allClasses[0].section : null;
    _subjectController.clear();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final currentClass = _allClasses.firstWhere((c) => c.section == selectedClass);
          return AlertDialog(
            title: Text("Manage Subjects".tr, style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedClass,
                    items: _allClasses.take(15).map((c) => DropdownMenuItem(value: c.section, child: Text(c.section))).toList(),
                    onChanged: (val) => setDialogState(() => selectedClass = val),
                    decoration: InputDecoration(labelText: "Select Class"),
                  ),
                  SizedBox(height: 16),
                  Text("Current Subjects:".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B263B))),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: currentClass.subjects.map((s) => Chip(
                      label: Text(s, style: TextStyle(fontSize: 11)),
                      backgroundColor: Colors.blue[50],
                      deleteIconColor: Colors.red,
                      onDeleted: () {
                        setState(() {
                          currentClass.subjects.remove(s);
                        });
                        setDialogState(() {});
                      },
                    )).toList(),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _subjectController,
                    decoration: InputDecoration(labelText: "Add New Subject", hintText: "e.g. Art"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Close".tr)),
              ElevatedButton(
                onPressed: () {
                  if (_subjectController.text.isNotEmpty) {
                    setState(() {
                      if (!currentClass.subjects.contains(_subjectController.text)) {
                        currentClass.subjects.add(_subjectController.text);
                      }
                    });
                    _subjectController.clear();
                    setDialogState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[700]),
                child: Text("Add".tr, style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showClassReportDialog() {
    String? selectedClass = _allClasses.isNotEmpty ? _allClasses[0].section : null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final cls = _allClasses.firstWhere((c) => c.section == selectedClass);
          return AlertDialog(
            title: Text("Class Performance Report".tr, style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedClass,
                    items: _allClasses.take(15).map((c) => DropdownMenuItem(value: c.section, child: Text(c.section))).toList(),
                    onChanged: (val) => setDialogState(() => selectedClass = val),
                    decoration: InputDecoration(labelText: "Select Class"),
                  ),
                  SizedBox(height: 20),
                  _buildReportItem("Total Students", "${cls.students}"),
                  _buildReportItem("Boys / Girls", "${cls.boys} / ${cls.girls}"),
                  _buildReportItem("Average Attendance", "94%"),
                  _buildReportItem("Pass Percentage", "88%"),
                  _buildReportItem("Class Teacher", cls.teacher),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Subjects Summary:".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(cls.subjects.join(", "), style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                  ),
                  SizedBox(height: 16),
                  Text("Progress Summary:".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  SizedBox(height: 8),
                  LinearProgressIndicator(value: 0.82, backgroundColor: Colors.grey, color: Colors.blue),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Close".tr)),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Downloading report...".tr)));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[700]),
                child: Text("Download PDF".tr, style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showTeacherMessageDialog(String teacherName) {
    final TextEditingController _messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Message to $teacherName", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Type your requirement or message for the teacher:".tr,
                style: TextStyle(fontSize: 13, color: Colors.grey)),
            SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter teacher requirement text here...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel".tr)),
          ElevatedButton(
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Requirement sent to $teacherName successfully!"))
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
            child: Text("Send".tr, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B263B))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      initialIndex: widget.activeTab,
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
                Tab(text: "Class Details"),
                Tab(text: "Class Timetable"),
                Tab(text: "Class Attendance"),
                Tab(text: "Class Dairy"),
                Tab(text: "Assignments"),
                Tab(text: "Class Teachers"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildClassDetails(),
                _buildTimetable(),
                _buildAttendance(),
                _buildDiary(),
                _buildAssignments(),
                _buildTeachers(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 1. Class Timetable UI
  Widget _buildTimetable() {
    final List<Map<String, String>> schedule = [
      {"time": "08:30 - 09:20", "subject": "Mathematics", "teacher": "Ms. Priya Sharma", "room": "103"},
      {"time": "09:20 - 10:10", "subject": "English", "teacher": "Ms. Neha Verma", "room": "103"},
      {"time": "10:10 - 10:30", "subject": "Short Break", "teacher": "-", "room": "-"},
      {"time": "10:30 - 11:20", "subject": "Science", "teacher": "Mr. Ramesh Kumar", "room": "Lab 1"},
      {"time": "11:20 - 12:10", "subject": "Social Studies", "teacher": "Mr. Amit Gupta", "room": "103"},
      {"time": "12:10 - 12:50", "subject": "Lunch Break", "teacher": "-", "room": "Canteen"},
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        final item = schedule[index];
        bool isBreak = item['subject']!.contains("Break");
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[200]!)),
          color: isBreak ? Colors.blue[50] : Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(item['time']!, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900], fontSize: 13)),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['subject']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      if (!isBreak) Text(item['teacher']!, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
                if (!isBreak) Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
                  child: Text("Room ${item['room']}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // 2. Class Attendance UI
  Widget _buildAttendance() {
    _attendanceList ??= [
      {"name": "Aarav Sharma", "roll": "01", "status": "Present", "color": Colors.green},
      {"name": "Ananya Verma", "roll": "02", "status": "Present", "color": Colors.green},
      {"name": "Vivaan Mehta", "roll": "03", "status": "Absent", "color": Colors.red},
      {"name": "Myra Singh", "roll": "04", "status": "Present", "color": Colors.green},
      {"name": "Arjun Gupta", "roll": "05", "status": "Late", "color": Colors.orange},
      {"name": "Diya Patel", "roll": "06", "status": "Present", "color": Colors.green},
    ];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today, Oct 25".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ElevatedButton(onPressed: () {}, child: Text("Take Attendance".tr, style: TextStyle(fontSize: 12))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _attendanceList!.length,
            itemBuilder: (context, index) {
              final student = _attendanceList![index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(child: Text(student['roll'])),
                title: Text(student['name'], style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (student['status'] == 'Present' || student['status'] == 'Late') {
                        student['status'] = 'Absent';
                        student['color'] = Colors.red;
                      } else {
                        student['status'] = 'Present';
                        student['color'] = Colors.green;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: student['color'].withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                    child: Text(student['status'], style: TextStyle(color: student['color'], fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 3. Class Diary UI
  Widget _buildDiary() {
    final List<Map<String, String>> diaryNotes = [
      {"date": "Oct 24", "subject": "Mathematics", "note": "Exercises 4.2 completed in class. Homework: Page 45, Q1-Q5."},
      {"date": "Oct 24", "subject": "Science", "note": "Introduced 'Plant Cell' structure. Students asked to bring colored pencils tomorrow."},
      {"date": "Oct 23", "subject": "English", "note": "Finished reading 'The Road Not Taken'. Grammar test scheduled for Friday."},
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: diaryNotes.length,
      itemBuilder: (context, index) {
        final entry = diaryNotes[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry['subject']!, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    Text(entry['date']!, style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                Divider(),
                Text(entry['note']!, style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        );
      },
    );
  }

  // 4. Assignments UI
  Widget _buildAssignments() {
    final List<Map<String, dynamic>> assignments = [
      {"title": "Quadratic Equations Worksheet", "due": "Oct 27", "status": "Ongoing", "submissions": "32/42"},
      {"title": "History: The Mughal Empire Project", "due": "Oct 30", "status": "New", "submissions": "5/42"},
      {"title": "English Essay: Environment", "due": "Oct 20", "status": "Completed", "submissions": "40/42"},
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        final item = assignments[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(item['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Due Date: ${item['due']}  |  Submissions: ${item['submissions']}"),
            trailing: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: item['status'] == "Completed" ? Colors.green[50] : Colors.blue[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(item['status'], style: TextStyle(color: item['status'] == "Completed" ? Colors.green : Colors.blue, fontWeight: FontWeight.bold, fontSize: 10)),
            ),
          ),
        );
      },
    );
  }

  // 5. Class Teachers UI
  Widget _buildTeachers() {
    final List<Map<String, String>> teachers = [
      {"name": "Ms. Priya Sharma", "subject": "Mathematics (Class Teacher)", "exp": "8 Years"},
      {"name": "Mr. Ramesh Kumar", "subject": "General Science", "exp": "5 Years"},
      {"name": "Ms. Neha Verma", "subject": "English Literature", "exp": "10 Years"},
      {"name": "Mr. Amit Gupta", "subject": "History & Civics", "exp": "12 Years"},
    ];

    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: teachers.length,
      separatorBuilder: (context, index) => Divider(height: 32),
      itemBuilder: (context, index) {
        final t = teachers[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.deepPurple[50],
                child: Icon(Icons.person, color: Colors.deepPurple[300], size: 28),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t['name']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1B263B))),
                    SizedBox(height: 4),
                    Text(t['subject']!, style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.speaker_notes_outlined, size: 24, color: Colors.grey),
                onPressed: () => _showTeacherMessageDialog(t['name']!),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClassDetails() {
    final matchingClass = _allClasses.firstWhere(
          (cls) => cls.section == selectedOverviewClass,
      orElse: () => _allClasses[0],
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── All Classes Overview Grid ────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
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
                  '${_allClasses.length} Classes',
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
              itemCount: _allClasses.length,
              separatorBuilder: (_, __) => SizedBox(width: 10),
              itemBuilder: (context, index) {
                final cls = _allClasses[index];
                final isSelected = cls.section == selectedOverviewClass;
                final colors = [
                  Colors.blue, Colors.green, Colors.purple, Colors.orange,
                  Colors.teal, Colors.red, Colors.indigo,
                ];
                final color = colors[index % colors.length];
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedOverviewClass = cls.section);
                    StudentsScreen.selectedClassOverride = cls.section;
                    widget.onNavigateTab?.call(2);
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
                                  cls.section.startsWith("Class ") ? cls.section.substring(6) : cls.section,
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
                          cls.section,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Color(0xFF1B263B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          '${cls.students} students',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600]),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '${cls.boys}B · ${cls.girls}G',
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
                                cls.teacher.split(' ').last,
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
                                '${cls.subjects.length} sub',
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
          // ── Selected Class Detail ────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: [
                Text(
                  '$selectedOverviewClass — Details',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B263B)),
                ),
                Spacer(),
                _buildClassSelector(),
              ],
            ),
          ),
          _buildStatCards(matchingClass),
          SizedBox(height: 20),
          _buildClassListHeader(),
          SizedBox(height: 12),
          _buildSearchAndFilter(),
          SizedBox(height: 12),
          _buildClassesTable(),
          _buildPaginationInfo(),
          SizedBox(height: 24),
          _buildQuickActions(),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildClassSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
      child: DropdownButton<String>(
        value: selectedOverviewClass,
        underline: SizedBox(),
        icon: Icon(Icons.keyboard_arrow_down, size: 18),
        style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.bold),
        onChanged: (val) {
          setState(() => selectedOverviewClass = val!);
          StudentsScreen.selectedClassOverride = val;
          widget.onNavigateTab?.call(2);
        },
        items: _allClasses.map((cls) => DropdownMenuItem(value: cls.section, child: Text(cls.section))).toList(),
      ),
    );
  }

  Widget _buildStatCards(ClassItem cls) {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          StatCard(
            title: "Total Students",
            value: "${cls.students}",
            icon: Icons.groups_rounded,
            iconColor: Colors.blue,
            iconBackgroundColor: Colors.blue.withValues(alpha: 0.1),
            onTap: () => widget.onNavigateTab?.call(2),
          ),
          StatCard(
            title: "Boys",
            value: "${cls.boys}",
            icon: Icons.boy_rounded,
            iconColor: Colors.green,
            iconBackgroundColor: Colors.green.withValues(alpha: 0.1),
            onTap: () => widget.onNavigateTab?.call(2),
          ),
          StatCard(
            title: "Girls",
            value: "${cls.girls}",
            icon: Icons.girl_rounded,
            iconColor: Colors.pink,
            iconBackgroundColor: Colors.pink.withValues(alpha: 0.1),
            onTap: () => widget.onNavigateTab?.call(2),
          ),
          StatCard(
            title: "Class Teacher",
            value: cls.teacher,
            icon: Icons.record_voice_over_rounded,
            iconColor: Colors.purple,
            iconBackgroundColor: Colors.purple.withValues(alpha: 0.1),
            onTap: () => widget.onNavigateTab?.call(5, moreSubScreen: "Employees"),
          ),
          StatCard(
            title: "Subject Teachers",
            value: "${cls.subjects.length}",
            icon: Icons.menu_book_rounded,
            iconColor: Colors.orange,
            iconBackgroundColor: Colors.orange.withValues(alpha: 0.1),
            onTap: () => widget.onNavigateTab?.call(5, moreSubScreen: "Employees", subTab: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildClassListHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Class Details".tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B263B))),
          ElevatedButton.icon(
            onPressed: _showAddClassDialog,
            icon: Icon(Icons.add, size: 14, color: Colors.white),
            label: Text("Add Class".tr, style: TextStyle(fontSize: 12, color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
        child: TextField(
          onChanged: (val) => setState(() {
            searchQuery = val;
            _currentPage = 1;
          }),
          decoration: InputDecoration(
              hintText: "Search by class or teacher...",
              prefixIcon: Icon(Icons.search, size: 18),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10)
          ),
        ),
      ),
    );
  }

  Widget _buildClassesTable() {
    final filtered = _allClasses.where((c) {
      final query = searchQuery.toLowerCase();
      return c.section.toLowerCase().contains(query) || c.teacher.toLowerCase().contains(query);
    }).toList();

    final int startIndex = (_currentPage - 1) * _itemsPerPage;
    final int endIndex = startIndex + _itemsPerPage;
    final paginated = filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );

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
                  Expanded(flex: 3, child: Text("Class / Section".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  Expanded(flex: 2, child: Text("Students".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.center)),
                  Expanded(flex: 4, child: Text("Class Teacher".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  Expanded(flex: 2, child: Text("Room No.".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  Expanded(flex: 1, child: Text("Actions".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.right)),
                ],
              ),
            ),
            ...paginated.map((c) => InkWell(
              onTap: () {
                StudentsScreen.selectedClassOverride = c.section;
                widget.onNavigateTab?.call(2);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.section, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Text("All Sections".tr, style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ),
                    ),
                    Expanded(flex: 2, child: Text("${c.students}", style: TextStyle(fontSize: 12), textAlign: TextAlign.center)),
                    Expanded(flex: 4, child: Text(c.teacher, style: TextStyle(fontSize: 12))),
                    Expanded(flex: 2, child: Text(c.room, style: TextStyle(fontSize: 12))),
                    Expanded(
                      flex: 1,
                      child: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, size: 18, color: Colors.grey),
                        padding: EdgeInsets.zero,
                        onSelected: (value) {
                          if (value == 'view') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Viewing details for ${c.section}")));
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'view', child: Text('View Details'.tr)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationInfo() {
    final filtered = _allClasses.where((c) {
      final query = searchQuery.toLowerCase();
      return c.section.toLowerCase().contains(query) || c.teacher.toLowerCase().contains(query);
    }).toList();

    int totalPages = (filtered.length / _itemsPerPage).ceil();
    if (totalPages == 0) totalPages = 1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Showing ${((_currentPage - 1) * _itemsPerPage) + 1} to ${(_currentPage * _itemsPerPage) > filtered.length ? filtered.length : (_currentPage * _itemsPerPage)} of ${filtered.length} classes",
                style: TextStyle(color: Colors.grey[600], fontSize: 11),
              ),
              Text("Page $_currentPage of $totalPages", style: TextStyle(color: Colors.grey[600], fontSize: 11)),
            ],
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, size: 20),
                  onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                  constraints: BoxConstraints(), padding: EdgeInsets.zero,
                ),
                SizedBox(width: 8),
                for (int i = 1; i <= totalPages; i++)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: InkWell(
                      onTap: () => setState(() => _currentPage = i),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: i == _currentPage ? Colors.blue[800] : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: i == _currentPage ? Colors.blue[800]! : Colors.grey[300]!),
                          boxShadow: i == _currentPage ? [BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 4, offset: Offset(0, 2))] : null,
                        ),
                        child: Text("$i", style: TextStyle(color: i == _currentPage ? Colors.white : Colors.grey[700], fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.chevron_right, size: 20),
                  onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
                  constraints: BoxConstraints(), padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return QuickActionsBar(
      actions: [
        QuickActionItem(title: "Add Class", icon: Icons.person_add_alt_1, onTap: _showAddClassDialog, color: Colors.blue),
        QuickActionItem(title: "Assign Teacher", icon: Icons.assignment_ind, onTap: _showAssignTeacherDialog, color: Colors.green),
        QuickActionItem(title: "Manage Subjects", icon: Icons.menu_book, onTap: _showManageSubjectsDialog, color: Colors.orange),
        QuickActionItem(title: "Class Report", icon: Icons.assessment, onTap: _showClassReportDialog, color: Colors.purple),
      ],
    );
  }
}