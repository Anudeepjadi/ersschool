import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ExamsTab extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  const ExamsTab({super.key, required this.onOpenDrawer});

  @override
  State<ExamsTab> createState() => _ExamsTabState();
}

class _ExamsTabState extends State<ExamsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _switchToTab(int index) {
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 15, right: 15),
            decoration: const BoxDecoration(
              color: Color(0xFF1E2875),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: widget.onOpenDrawer,
                    ),
                    const SizedBox(width: 5),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Examination",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "View your exam details and results",
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // School Selector
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.school_outlined, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          const Text("Ecstasy School 1", style: TextStyle(color: Colors.white, fontSize: 10)),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Notification
                    Stack(
                      children: [
                        const Icon(Icons.notifications_none, color: Colors.white, size: 24),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                            child: const Text("5", style: TextStyle(color: Colors.white, fontSize: 7), textAlign: TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    // Profile
                    const CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage("assets/images/student_profile.png"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Custom TabBar
          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF1E2875),
            labelColor: const Color(0xFF1E2875),
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: "Exam Details", icon: Icon(Icons.assignment_outlined, size: 20)),
              Tab(text: "Term Exam Timetable", icon: Icon(Icons.calendar_month_outlined, size: 20)),
              Tab(text: "Grade Report", icon: Icon(Icons.description_outlined, size: 20)),
            ],
          ),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildExamDetailsTab(),
                _buildTimetableTab(),
                _buildGradeReportTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Examination Overview"),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildOverviewItem(Icons.assignment, "Total Exams", "12", Colors.blue),
              _buildOverviewItem(Icons.check_circle_outline, "Completed", "7", Colors.green),
              _buildOverviewItem(Icons.calendar_today, "Upcoming", "5", Colors.orange),
              _buildOverviewItem(Icons.auto_graph, "Average Score", "85.6%", Colors.purple),
            ],
          ),
          const SizedBox(height: 30),
          _buildSectionHeader("Upcoming Exams", trailing: "View Timetable >", onTrailingTap: () => _switchToTab(1)),
          const SizedBox(height: 15),
          _buildUpcomingExamsList(),
          _buildViewAllButton("View All Upcoming Exams >", onTap: () => _switchToTab(1)),
          const SizedBox(height: 30),
          _buildSectionHeader("Recent Exam Results", trailing: "View All Results >", onTrailingTap: () => _switchToTab(2)),
          const SizedBox(height: 15),
          _buildResultsList(),
          _buildViewAllButton("View All Results >", onTap: () => _switchToTab(2)),
          const SizedBox(height: 30),
          _buildSectionHeader("Quick Actions"),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickAction(Icons.calendar_month, "Term Exam\nTimetable", Colors.purple, onTap: () => _switchToTab(1)),
              _buildQuickAction(Icons.description_outlined, "Grade\nReport", Colors.green, onTap: () => _switchToTab(2)),
              _buildQuickAction(Icons.file_download_outlined, "Download\nHall Ticket", Colors.orange, onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Downloading Hall Ticket...")),
                );
              }),
              _buildQuickAction(Icons.bar_chart, "Performance\nAnalysis", Colors.blue, onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Opening Performance Analysis...")),
                );
              }),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildTimetableTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Term Exam Timetable"),
          const SizedBox(height: 15),
          _buildUpcomingExamsList(),
          const SizedBox(height: 20),
          const Center(
            child: Text("Full timetable for Term 1 available here", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeReportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Grade Report"),
          const SizedBox(height: 15),
          _buildResultsList(),
          const SizedBox(height: 20),
          _buildResultRow("Mid Term Exam", "Term 1", "Social Science", "SST", "18 Apr 2024", "40", "50", "80%", "A", Colors.green),
          _buildResultRow("Mid Term Exam", "Term 1", "Hindi", "HIN", "19 Apr 2024", "45", "50", "90%", "A+", Colors.green),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Overall Grade: A", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                Text("Percentage: 85.6%", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? trailing, VoidCallback? onTrailingTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
        ),
        if (trailing != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(
              trailing,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
      ],
    );
  }

  Widget _buildOverviewItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
      ],
    );
  }

  Widget _buildUpcomingExamsList() {
    return Column(
      children: [
        _buildTableHeader(["Exam Name", "Subject", "Date", "Time", "Duration", "Syllabus"]),
        const Divider(height: 1),
        _buildUpcomingRow("Unit Test - 1", "Term 1", "Mathematics", "MATH", "25 May 2024", "Saturday", "10:00 AM", "1.30 Hrs", Colors.purple),
        _buildUpcomingRow("Unit Test - 1", "Term 1", "Science", "SCI", "27 May 2024", "Monday", "10:00 AM", "1.30 Hrs", Colors.green),
        _buildUpcomingRow("Unit Test - 1", "Term 1", "English", "ENG", "29 May 2024", "Wednesday", "10:00 AM", "1.30 Hrs", Colors.orange),
        _buildUpcomingRow("Unit Test - 1", "Term 1", "Social Science", "SST", "31 May 2024", "Friday", "10:00 AM", "1.30 Hrs", Colors.redAccent),
        _buildUpcomingRow("Unit Test - 1", "Term 1", "Hindi", "HIN", "03 Jun 2024", "Monday", "10:00 AM", "1.30 Hrs", Colors.blue),
      ],
    );
  }

  Widget _buildResultsList() {
    return Column(
      children: [
        _buildTableHeader(["Exam Name", "Subject", "Date", "Marks", "Total", "%", "Grade"]),
        const Divider(height: 1),
        _buildResultRow("Mid Term Exam", "Term 1", "Mathematics", "MATH", "15 Apr 2024", "42", "50", "84%", "A", Colors.green),
        _buildResultRow("Mid Term Exam", "Term 1", "Science", "SCI", "16 Apr 2024", "44", "50", "88%", "A", Colors.green),
        _buildResultRow("Mid Term Exam", "Term 1", "English", "ENG", "17 Apr 2024", "38", "50", "76%", "B+", Colors.blue),
      ],
    );
  }

  Widget _buildTableHeader(List<String> headers) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: headers.map((h) => Expanded(
          flex: h == "Exam Name" || h == "Subject" || h == "Date" ? 2 : 1,
          child: Text(h, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
        )).toList(),
      ),
    );
  }

  Widget _buildUpcomingRow(String name, String term, String sub, String subCode, String date, String day, String time, String duration, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(Icons.assignment_outlined, size: 16, color: color),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      Text(term, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sub, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                Text(subCode, style: const TextStyle(fontSize: 9, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                Text(day, style: const TextStyle(fontSize: 9, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(child: Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey))),
          Expanded(child: Text(duration, style: const TextStyle(fontSize: 10, color: Colors.grey))),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.description_outlined, size: 16, color: Colors.blue),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Opening Syllabus...")),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String name, String term, String sub, String subCode, String date, String marks, String total, String percent, String grade, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(Icons.assignment_turned_in_outlined, size: 16, color: color),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      Text(term, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sub, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                Text(subCode, style: const TextStyle(fontSize: 9, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(date, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(marks, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
          Expanded(child: Text(total, style: const TextStyle(fontSize: 11, color: Colors.grey))),
          Expanded(
            child: Text(percent, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(grade, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewAllButton(String text, {VoidCallback? onTap}) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Color(0xFF1E2875), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
