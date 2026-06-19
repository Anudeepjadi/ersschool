import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_actions.dart';

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

  const ExamsScreen({
    super.key,
    this.activeTab = 0,
    this.onSubTabSelected,
  });

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  final List<ExamItem> _upcomingExams = [
    ExamItem(name: "Unit Test - I", term: "Term 1", className: "Class 8 - A", subject: "Mathematics", date: "24 May 2024", time: "10:00 AM", duration: "1h 30m"),
    ExamItem(name: "Unit Test - I", term: "Term 1", className: "Class 9 - A", subject: "Science", date: "25 May 2024", time: "10:00 AM", duration: "1h 30m"),
    ExamItem(name: "Half Yearly Exam", term: "Term 1", className: "Class 10 - A", subject: "English", date: "27 May 2024", time: "09:00 AM", duration: "2h 30m"),
    ExamItem(name: "Mid Term Exam", term: "Term 1", className: "Class 8 - A", subject: "Social Studies", date: "29 May 2024", time: "11:00 AM", duration: "1h 30m"),
    ExamItem(name: "Half Yearly Exam", term: "Term 1", className: "Class 9 - A", subject: "Mathematics", date: "31 May 2024", time: "09:00 AM", duration: "2h 30m"),
  ];

  final List<ExamResultItem> _recentResults = [
    ExamResultItem(name: "Unit Test - I", term: "Term 1", className: "Class 8 - A", subject: "Mathematics", publishedDate: "18 May 2024"),
    ExamResultItem(name: "Unit Test - I", term: "Term 1", className: "Class 7 - A", subject: "English", publishedDate: "17 May 2024"),
    ExamResultItem(name: "Mid Term Exam", term: "Term 1", className: "Class 9 - A", subject: "Science", publishedDate: "15 May 2024"),
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
          title: const Text("Create New Exam"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Exam Name (e.g. Unit Test - II)"),
                ),
                TextField(
                  controller: termController,
                  decoration: const InputDecoration(labelText: "Term (e.g. Term 1, Term 2)"),
                ),
                TextField(
                  controller: classController,
                  decoration: const InputDecoration(labelText: "Class Name (e.g. Class 8 - A)"),
                ),
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(labelText: "Subject"),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: "Date (e.g. 15 June 2024)"),
                ),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: "Time (e.g. 10:00 AM)"),
                ),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(labelText: "Duration (e.g. 1h 30m)"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
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
                        className: classController.text.isNotEmpty ? classController.text : "Class 8 - A",
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
              child: const Text("Create"),
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
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Performance Report:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Average Score:"), Text("78.5%", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Highest Score:"), Text("98.0%", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Lowest Score:"), Text("45.0%", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red))],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Passing Percentage:"), Text("92.3%", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple))],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Downloading detailed analysis...")),
                );
              },
              child: const Text("Download PDF"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.activeTab == 0) return _buildOverviewTab();
    if (widget.activeTab == 1) return _buildExamScheduleTab();
    return _buildResultsTab();
  }

  Widget _buildOverviewTab() {
    final totalExams = _upcomingExams.length + _conductedExamsCount;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Overview Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Overview",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B263B),
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                StatCard(
                  title: "Total Exams",
                  value: "$totalExams",
                  icon: Icons.assignment,
                  iconColor: Colors.blue,
                  iconBackgroundColor: Colors.blue.withValues(alpha: 0.1),
                ),
                StatCard(
                  title: "Total Students",
                  value: "538",
                  icon: Icons.people,
                  iconColor: Colors.green,
                  iconBackgroundColor: Colors.green.withValues(alpha: 0.1),
                ),
                StatCard(
                  title: "Exams Conducted",
                  value: "$_conductedExamsCount",
                  icon: Icons.task_alt,
                  iconColor: Colors.orange,
                  iconBackgroundColor: Colors.orange.withValues(alpha: 0.1),
                ),
                StatCard(
                  title: "Upcoming Exams",
                  value: "${_upcomingExams.length}",
                  icon: Icons.hourglass_empty,
                  iconColor: Colors.purple,
                  iconBackgroundColor: Colors.purple.withValues(alpha: 0.1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Upcoming Exams Section (Preview)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Upcoming Exams (${_upcomingExams.length})",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B263B),
                  ),
                ),
                TextButton(
                  onPressed: () => widget.onSubTabSelected?.call(1),
                  child: const Text("View All", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Upcoming Exams List
          _buildExamsList(_upcomingExams.take(3).toList()),

          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => widget.onSubTabSelected?.call(1),
              child: const Text("View All Exams ->", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),

          // 3. Recent Exam Results Section (Preview)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Exam Results",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B263B),
                  ),
                ),
                TextButton(
                  onPressed: () => widget.onSubTabSelected?.call(2),
                  child: const Text("View All", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          _buildResultsList(_recentResults.take(2).toList()),

          const SizedBox(height: 20),

          // 4. Quick Actions
          QuickActionsBar(
            actions: [
              QuickActionItem(title: "Create Exam", icon: Icons.add_circle_outline, onTap: _showCreateExamDialog),
              QuickActionItem(title: "Schedule Exam", icon: Icons.calendar_month, onTap: () {}),
              QuickActionItem(title: "Generate Hall Tickets", icon: Icons.badge_outlined, onTap: () {}),
              QuickActionItem(title: "Enter Marks", icon: Icons.edit_note, onTap: () {}),
              QuickActionItem(title: "Publish Results", icon: Icons.campaign_outlined, onTap: () {
                setState(() {
                  _conductedExamsCount++;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Mock Results published successfully!")),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExamScheduleTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Exam Schedule (${_upcomingExams.length})",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B263B)),
                ),
                ElevatedButton.icon(
                  onPressed: _showCreateExamDialog,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text("New Exam", style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B263B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          _buildExamsList(_upcomingExams),
          const SizedBox(height: 20),
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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Recent Exam Results",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B263B)),
            ),
          ),
          _buildResultsList(_recentResults),
          const SizedBox(height: 20),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: exams.length,
          separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
          itemBuilder: (context, index) {
            final exam = exams[index];
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.assignment_outlined, color: Colors.blue[800], size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exam.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B263B)),
                        ),
                        Text(
                          exam.term,
                          style: TextStyle(color: Colors.grey[500], fontSize: 10),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildSmallChip("Class", exam.className, Colors.blue),
                            const SizedBox(width: 8),
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
                          const Icon(Icons.calendar_today, size: 10, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(exam.date, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 10, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(exam.time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        exam.duration,
                        style: TextStyle(color: Colors.grey[600], fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.more_vert, color: Colors.grey, size: 20),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: results.length,
          separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
          itemBuilder: (context, index) {
            final result = results[index];
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.task_alt, color: Colors.green[800], size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${result.name} - ${result.subject}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B263B)),
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
                    child: const Text("View Report", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const Icon(Icons.more_vert, color: Colors.grey, size: 20),
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$prefix: ", style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.black87, fontSize: 9, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}