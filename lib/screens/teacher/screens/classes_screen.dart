import 'package:flutter/material.dart';
import '../../../widgets/scrollable_table_wrapper.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_actions.dart';
import '../../../core/data/app_data_store.dart';

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

  const ClassesScreen({
    Key? key,
    this.activeTab = 0,
    this.onSubTabSelected,
    this.onNavigateTab,
  }) : super(key: key);

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

  List<ClassItem> get _allClasses {
    final classes = _store.studyClasses.map((c) => c['name'] as String).toSet().toList();
    final sections = _store.classSections.map((s) => s['name'] as String).toSet().toList();
    final subjects = _store.subjects.map((s) => s['name'] as String).toSet().toList();

    List<ClassItem> list = [];
    int roomCounter = 101;
    for (int i = 0; i < classes.length; i++) {
      for (int j = 0; j < sections.length; j++) {
        final secName = sections[j].split(' ').last; // e.g. "Section A" -> "A"
        list.add(ClassItem(
          section: "${classes[i]} - $secName",
          students: 30 + ((i + j) % 15),
          boys: 15 + ((i + j) % 8),
          girls: 15 + ((i + j) % 7),
          teacher: "Teacher ${i * sections.length + j + 1}",
          room: "${roomCounter++}",
          subjects: subjects.take(3).toList(),
        ));
      }
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
        title: const Text("Notice"),
        content: const Text("Please add new classes and sections from the Admin Settings > Study Classes / Sections menu."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showEditClassDialog(ClassItem item) {
    _classNameController.text = item.section;
    _teacherController.text = item.teacher;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Class"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _classNameController, decoration: const InputDecoration(labelText: "Class Name")),
            TextField(controller: _teacherController, decoration: const InputDecoration(labelText: "Teacher")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                item.section = _classNameController.text;
                item.teacher = _teacherController.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void _showAssignTeacherDialog() {
    // Currently assigned through mapping in store
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Assign teacher through Admin > Settings > Subjects Mapping'))
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
            title: const Text("Manage Subjects", style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedClass,
                    items: _allClasses.take(15).map((c) => DropdownMenuItem(value: c.section, child: Text(c.section))).toList(),
                    onChanged: (val) => setDialogState(() => selectedClass = val),
                    decoration: const InputDecoration(labelText: "Select Class"),
                  ),
                  const SizedBox(height: 16),
                  const Text("Current Subjects:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B263B))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: currentClass.subjects.map((s) => Chip(
                      label: Text(s, style: const TextStyle(fontSize: 11)),
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
                  const SizedBox(height: 12),
                  TextField(
                    controller: _subjectController,
                    decoration: const InputDecoration(labelText: "Add New Subject", hintText: "e.g. Art"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
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
                child: const Text("Add", style: TextStyle(color: Colors.white)),
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
            title: const Text("Class Performance Report", style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedClass,
                    items: _allClasses.take(15).map((c) => DropdownMenuItem(value: c.section, child: Text(c.section))).toList(),
                    onChanged: (val) => setDialogState(() => selectedClass = val),
                    decoration: const InputDecoration(labelText: "Select Class"),
                  ),
                  const SizedBox(height: 20),
                  _buildReportItem("Total Students", "${cls.students}"),
                  _buildReportItem("Boys / Girls", "${cls.boys} / ${cls.girls}"),
                  _buildReportItem("Average Attendance", "94%"),
                  _buildReportItem("Pass Percentage", "88%"),
                  _buildReportItem("Class Teacher", cls.teacher),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Subjects Summary:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(cls.subjects.join(", "), style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                  ),
                  const SizedBox(height: 16),
                  const Text("Progress Summary:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  const LinearProgressIndicator(value: 0.82, backgroundColor: Colors.grey, color: Colors.blue),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Downloading report...")));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[700]),
                child: const Text("Download PDF", style: TextStyle(color: Colors.white)),
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
        title: Text("Message to $teacherName", style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Type your requirement or message for the teacher:",
                style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 12),
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
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
            child: const Text("Send", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B263B))),
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
          const Material(
            color: Colors.white,
            elevation: 1,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
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
      padding: const EdgeInsets.all(16),
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        final item = schedule[index];
        bool isBreak = item['subject']!.contains("Break");
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[200]!)),
          color: isBreak ? Colors.blue[50] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(item['time']!, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900], fontSize: 13)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['subject']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      if (!isBreak) Text(item['teacher']!, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
                if (!isBreak) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
                  child: Text("Room ${item['room']}", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
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
    final List<Map<String, dynamic>> attendance = [
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
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Today, Oct 25", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ElevatedButton(onPressed: () {}, child: const Text("Take Attendance", style: TextStyle(fontSize: 12))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: attendance.length,
            itemBuilder: (context, index) {
              final student = attendance[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(child: Text(student['roll'])),
                title: Text(student['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: student['color'].withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text(student['status'], style: TextStyle(color: student['color'], fontWeight: FontWeight.bold, fontSize: 11)),
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
      padding: const EdgeInsets.all(16),
      itemCount: diaryNotes.length,
      itemBuilder: (context, index) {
        final entry = diaryNotes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry['subject']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    Text(entry['date']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const Divider(),
                Text(entry['note']!, style: const TextStyle(fontSize: 14)),
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
      padding: const EdgeInsets.all(16),
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        final item = assignments[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Due Date: ${item['due']}  |  Submissions: ${item['submissions']}"),
            trailing: Container(
              padding: const EdgeInsets.all(6),
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
      padding: const EdgeInsets.all(16),
      itemCount: teachers.length,
      separatorBuilder: (context, index) => const Divider(height: 32),
      itemBuilder: (context, index) {
        final t = teachers[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.deepPurple[50],
                child: Icon(Icons.person, color: Colors.deepPurple[300], size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1B263B))),
                    const SizedBox(height: 4),
                    Text(t['subject']!, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.speaker_notes_outlined, size: 24, color: Colors.grey),
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
          // 1. Class Overview Dropdown Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Class Overview",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B263B),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: DropdownButton<String>(
                    value: _allClasses.any((c) => c.section == selectedOverviewClass) ? selectedOverviewClass : (_allClasses.isNotEmpty ? _allClasses.first.section : null),
                    underline: const SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                    style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.bold),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() { selectedOverviewClass = newValue; });
                      }
                    },
                    items: _allClasses.map((cls) {
                      return DropdownMenuItem(value: cls.section, child: Text(cls.section));
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // ── Selected Class Detail ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: [
                Text(
                  '$selectedOverviewClass — Details',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B263B)),
                ),
                const Spacer(),
                _buildClassSelector(),
              ],
            ),
          ),
          _buildStatCards(matchingClass),
          const SizedBox(height: 20),
          _buildClassListHeader(),
          const SizedBox(height: 12),
          _buildSearchAndFilter(),
          const SizedBox(height: 12),
          _buildClassesTable(),
          _buildPaginationInfo(),
          const SizedBox(height: 24),
          _buildQuickActions(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildClassSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
      child: DropdownButton<String>(
        value: selectedOverviewClass,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, size: 18),
        style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.bold),
        onChanged: (val) => setState(() => selectedOverviewClass = val!),
        items: _allClasses.take(7).map((cls) => DropdownMenuItem(value: cls.section, child: Text(cls.section))).toList(),
      ),
    );
  }

  Widget _buildStatCards(ClassItem cls) {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Class Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B263B))),
          ElevatedButton.icon(
            onPressed: _showAddClassDialog,
            icon: const Icon(Icons.add, size: 14, color: Colors.white),
            label: const Text("Add Class", style: TextStyle(fontSize: 12, color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
        child: TextField(
          onChanged: (val) => setState(() {
            searchQuery = val;
            _currentPage = 1;
          }),
          decoration: const InputDecoration(
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
        child: ScrollableTableWrapper(
          child: SizedBox(
            width: 600,
            child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[50],
              child: const Row(
                children: [
                  Expanded(flex: 3, child: Text("Class / Section", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  Expanded(flex: 2, child: Text("Students", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.center)),
                  Expanded(flex: 4, child: Text("Class Teacher", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  Expanded(flex: 2, child: Text("Room No.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  Expanded(flex: 1, child: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.right)),
                ],
              ),
            ),
            const Divider(height: 1),
            ...paginated.map((c) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.section, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        const Text("Section A", style: TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    ),
                  ),
                  Expanded(flex: 2, child: Text("${c.students}", style: const TextStyle(fontSize: 12), textAlign: TextAlign.center)),
                  Expanded(flex: 4, child: Text(c.teacher, style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text(c.room, style: const TextStyle(fontSize: 12))),
                  Expanded(
                    flex: 1,
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                      padding: EdgeInsets.zero,
                      onSelected: (value) {
                        if (value == 'view') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Viewing details for ${c.section}")));
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'view', child: Text('View Details')),
                      ],
                    ),
                  ),
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

  Widget _buildPaginationInfo() {
    final filtered = _allClasses.where((c) {
      final query = searchQuery.toLowerCase();
      return c.section.toLowerCase().contains(query) || c.teacher.toLowerCase().contains(query);
    }).toList();

    int totalPages = (filtered.length / _itemsPerPage).ceil();
    if (totalPages == 0) totalPages = 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                  constraints: const BoxConstraints(), padding: EdgeInsets.zero,
                ),
                const SizedBox(width: 8),
                for (int i = 1; i <= totalPages; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: InkWell(
                      onTap: () => setState(() => _currentPage = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: i == _currentPage ? Colors.blue[800] : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: i == _currentPage ? Colors.blue[800]! : Colors.grey[300]!),
                          boxShadow: i == _currentPage ? [BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))] : null,
                        ),
                        child: Text("$i", style: TextStyle(color: i == _currentPage ? Colors.white : Colors.grey[700], fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
                  constraints: const BoxConstraints(), padding: EdgeInsets.zero,
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