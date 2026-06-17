import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────────────────────
class _Exam {
  final String subject;
  final String date;
  final String time;
  final String room;
  final Color color;
  final IconData icon;

  const _Exam({
    required this.subject,
    required this.date,
    required this.time,
    required this.room,
    required this.color,
    required this.icon,
  });
}

class _Result {
  final String subject;
  final int marks;
  final int total;
  final Color color;
  final IconData icon;

  const _Result({
    required this.subject,
    required this.marks,
    required this.total,
    required this.color,
    required this.icon,
  });

  double get percentage => (marks / total) * 100;

  String get grade {
    final p = percentage;
    if (p >= 90) return 'A+';
    if (p >= 80) return 'A';
    if (p >= 70) return 'B+';
    if (p >= 60) return 'B';
    if (p >= 50) return 'C';
    return 'F';
  }

  Color get gradeColor {
    final p = percentage;
    if (p >= 80) return Colors.green;
    if (p >= 60) return Colors.orange;
    return Colors.red;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Static data
// ─────────────────────────────────────────────────────────────────────────────
const List<_Exam> _exams = [
  _Exam(
    subject: 'Mathematics',
    date: '18 Jun 2026',
    time: '09:00 AM – 12:00 PM',
    room: 'Hall A',
    color: Colors.purple,
    icon: Icons.calculate_outlined,
  ),
  _Exam(
    subject: 'Physics',
    date: '20 Jun 2026',
    time: '09:00 AM – 12:00 PM',
    room: 'Hall B',
    color: Colors.green,
    icon: Icons.science_outlined,
  ),
  _Exam(
    subject: 'Chemistry',
    date: '23 Jun 2026',
    time: '09:00 AM – 12:00 PM',
    room: 'Lab 1',
    color: Colors.orange,
    icon: Icons.biotech_outlined,
  ),
  _Exam(
    subject: 'English',
    date: '25 Jun 2026',
    time: '09:00 AM – 12:00 PM',
    room: 'Hall C',
    color: Colors.blue,
    icon: Icons.menu_book_outlined,
  ),
  _Exam(
    subject: 'Social Studies',
    date: '27 Jun 2026',
    time: '09:00 AM – 12:00 PM',
    room: 'Hall A',
    color: Colors.teal,
    icon: Icons.public_outlined,
  ),
  _Exam(
    subject: 'Computer Science',
    date: '30 Jun 2026',
    time: '09:00 AM – 12:00 PM',
    room: 'Lab 2',
    color: Colors.indigo,
    icon: Icons.computer_outlined,
  ),
];

const List<_Result> _results = [
  _Result(
    subject: 'Mathematics',
    marks: 87,
    total: 100,
    color: Colors.purple,
    icon: Icons.calculate_outlined,
  ),
  _Result(
    subject: 'Physics',
    marks: 79,
    total: 100,
    color: Colors.green,
    icon: Icons.science_outlined,
  ),
  _Result(
    subject: 'Chemistry',
    marks: 92,
    total: 100,
    color: Colors.orange,
    icon: Icons.biotech_outlined,
  ),
  _Result(
    subject: 'English',
    marks: 85,
    total: 100,
    color: Colors.blue,
    icon: Icons.menu_book_outlined,
  ),
  _Result(
    subject: 'Social Studies',
    marks: 74,
    total: 100,
    color: Colors.teal,
    icon: Icons.public_outlined,
  ),
  _Result(
    subject: 'Computer Science',
    marks: 95,
    total: 100,
    color: Colors.indigo,
    icon: Icons.computer_outlined,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Main widget
// ─────────────────────────────────────────────────────────────────────────────
class ExamsTab extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const ExamsTab({super.key, this.onOpenDrawer});

  @override
  State<ExamsTab> createState() => _ExExamsTabState();
}

class _ExExamsTabState extends State<ExamsTab>
    with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // 1. Curved Gradient Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF101B54), Color(0xFF0022C4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.only(
                top: 60,
                bottom: 25,
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (widget.onOpenDrawer != null)
                        IconButton(
                          icon: const Icon(Icons.menu,
                              color: Colors.white, size: 28),
                          onPressed: widget.onOpenDrawer,
                        ),
                      const SizedBox(width: 4),
                      const Expanded(
                        child: Text(
                          "Examination",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Right-side icons row
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // School dropdown badge
                          Container(
                            constraints: const BoxConstraints(maxWidth: 120),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.school_outlined,
                                    color: Colors.white, size: 12),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    "Ecstasy School 1",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_down,
                                    color: Colors.white, size: 12),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Notification bell with badge
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.notifications_none_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 32, minHeight: 32),
                              ),
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: const Text(
                                    "5",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 7,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 4),
                          // Profile Pic
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 1.0),
                                ),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: Image.asset(
                                      "assets/images/student_profile.png",
                                      width: 28,
                                      height: 28,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.person,
                                          color: Color(0xFF101B54),
                                          size: 16,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.white, size: 12),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Tab Bar Section
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF0038FF),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                labelColor: const Color(0xFF0038FF),
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.assignment_turned_in_outlined, size: 18),
                    text: "Exam Details",
                  ),
                  Tab(
                    icon: Icon(Icons.calendar_month_outlined, size: 18),
                    text: "Term Exam Timetable",
                  ),
                  Tab(
                    icon: Icon(Icons.analytics_outlined, size: 18),
                    text: "Grade Report",
                  ),
                ],
              ),
            ),

            // 3. Tab Contents
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
      ),
    );
  }

  // --- TAB BUILDERS ---

  Widget _buildExamDetailsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Examination Overview
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Text(
              "Examination Overview",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
          ),
          _buildOverviewStatsRow(),

          // 2. Upcoming Exams Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Upcoming Exams",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _tabController.animateTo(1); // Jump to Timetable Tab
                  },
                  child: const Row(
                    children: [
                      Text(
                        "View Timetable",
                        style: TextStyle(
                          color: Color(0xFF0038FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right,
                          size: 16, color: Color(0xFF0038FF)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildUpcomingExamsList(),

          const SizedBox(height: 25),

          // 3. Recent Exam Results Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Exam Results",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _tabController.animateTo(2); // Jump to Grade Report Tab
                  },
                  child: const Row(
                    children: [
                      Text(
                        "View All Results",
                        style: TextStyle(
                          color: Color(0xFF0038FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right,
                          size: 16, color: Color(0xFF0038FF)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildRecentResultsList(),

          const SizedBox(height: 25),

          // 4. Quick Actions Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickActionItem(Icons.calendar_month_outlined,
                        "Term Exam\nTimetable", Colors.purple),
                    _buildQuickActionItem(
                        Icons.analytics_outlined, "Grade Report", Colors.green),
                    _buildQuickActionItem(Icons.download_for_offline_outlined,
                        "Download\nHall Ticket", Colors.orange),
                    _buildQuickActionItem(Icons.bar_chart_outlined,
                        "Performance\nAnalysis", Colors.blue),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildTimetableTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Term 1 Exam Schedule",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2875)),
        ),
        const SizedBox(height: 12),
        _buildTimetableCard("Mathematics (MATH)", "25 Jun 2026", "10:00 AM",
            "1.30 Hrs", "Hall A", Colors.purple),
        _buildTimetableCard("Science (SCI)", "27 Jun 2026", "10:00 AM",
            "1.30 Hrs", "Hall B", Colors.green),
        _buildTimetableCard("English (ENG)", "29 Jun 2026", "10:00 AM",
            "1.30 Hrs", "Hall A", Colors.orange),
        _buildTimetableCard("Social Science (SST)", "31 Jun 2026", "10:00 AM",
            "1.30 Hrs", "Hall C", Colors.pink),
        _buildTimetableCard("Hindi (HIN)", "03 Jun 2026", "10:00 AM",
            "1.30 Hrs", "Hall B", Colors.blue),
      ],
    );
  }

  Widget _buildGradeReportTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Mid Term Academic Report",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2875)),
        ),
        const SizedBox(height: 12),
        _buildGradeScoreCard(
            "Mathematics (MATH)", "42", "50", "84%", "A", Colors.green),
        _buildGradeScoreCard(
            "Science (SCI)", "44", "50", "88%", "A", Colors.green),
        _buildGradeScoreCard(
            "English (ENG)", "38", "50", "76%", "B+", Colors.teal),
        _buildGradeScoreCard(
            "Social Science (SST)", "41", "50", "82%", "A", Colors.green),
        _buildGradeScoreCard(
            "Hindi (HIN)", "35", "50", "70%", "B", Colors.orange),
      ],
    );
  }

  // --- SUB-WIDGET BUILDERS ---

  Widget _buildOverviewStatsRow() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatCard(
              "Total Exams", "12", Icons.assignment_outlined, Colors.blue),
          _buildStatCard(
              "Completed", "7", Icons.check_circle_outline, Colors.green),
          _buildStatCard(
              "Upcoming", "5", Icons.calendar_today_outlined, Colors.orange),
          _buildStatCard("Average Score", "85.6%",
              Icons.bookmark_added_outlined, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 10,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2875),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingExamsList() {
    final headerStyle = TextStyle(
        color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Expanded(flex: 6, child: Text("Exam Name", style: headerStyle)),
              Expanded(flex: 4, child: Text("Subject", style: headerStyle)),
              Expanded(flex: 5, child: Text("Date", style: headerStyle)),
              Expanded(flex: 4, child: Text("Time", style: headerStyle)),
              Expanded(flex: 4, child: Text("Duration", style: headerStyle)),
              SizedBox(
                  width: 32,
                  child: Text("Syllabus",
                      style: headerStyle, textAlign: TextAlign.center)),
            ],
          ),
          const Divider(height: 20),

          // Items
          _buildUpcomingExamRow(
              "Unit Test - 1",
              "Term 1",
              "Mathematics",
              "MATH",
              "25 Jun 2026",
              "Saturday",
              "10:00 AM",
              "1.30 Hrs",
              Colors.purple),
          const Divider(height: 20),
          _buildUpcomingExamRow("Unit Test - 1", "Term 1", "Science", "SCI",
              "27 Jun 2026", "Monday", "10:00 AM", "1.30 Hrs", Colors.green),
          const Divider(height: 20),
          _buildUpcomingExamRow(
              "Unit Test - 1",
              "Term 1",
              "English",
              "ENG",
              "29 Jun 2026",
              "Wednesday",
              "10:00 AM",
              "1.30 Hrs",
              Colors.orange),
          const Divider(height: 20),
          _buildUpcomingExamRow(
              "Unit Test - 1",
              "Term 1",
              "Social Science",
              "SST",
              "31 Jun 2026",
              "Friday",
              "10:00 AM",
              "1.30 Hrs",
              Colors.pink),
          const Divider(height: 20),
          _buildUpcomingExamRow("Unit Test - 1", "Term 1", "Hindi", "HIN",
              "03 Jun 2026", "Monday", "10:00 AM", "1.30 Hrs", Colors.blue),

          const Divider(height: 24),
          // View All Link
          GestureDetector(
            onTap: () => _tabController.animateTo(1),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "View All Upcoming Exams",
                  style: TextStyle(
                    color: Color(0xFF0038FF),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 16, color: Color(0xFF0038FF)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingExamRow(
    String examName,
    String term,
    String subject,
    String subCode,
    String date,
    String day,
    String time,
    String duration,
    Color iconColor,
  ) {
    return Row(
      children: [
        // Exam Name
        Expanded(
          flex: 6,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child:
                    Icon(Icons.assignment_outlined, color: iconColor, size: 14),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      examName,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E2875)),
                    ),
                    Text(
                      term,
                      style:
                          TextStyle(fontSize: 9, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Subject
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875)),
              ),
              Text(
                subCode,
                style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        // Date
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875)),
              ),
              Text(
                day,
                style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        // Time
        Expanded(
          flex: 4,
          child: Text(
            time,
            style: const TextStyle(fontSize: 11, color: Color(0xFF1E2875)),
          ),
        ),
        // Duration
        Expanded(
          flex: 4,
          child: Text(
            duration,
            style: const TextStyle(fontSize: 11, color: Color(0xFF1E2875)),
          ),
        ),
        // Syllabus Document Icon
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 32,
            alignment: Alignment.center,
            child: const Icon(Icons.description_outlined,
                color: Color(0xFF0038FF), size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentResultsList() {
    final headerStyle = TextStyle(
        color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Expanded(flex: 6, child: Text("Exam Name", style: headerStyle)),
              Expanded(flex: 4, child: Text("Subject", style: headerStyle)),
              Expanded(flex: 5, child: Text("Date", style: headerStyle)),
              Expanded(
                  flex: 4,
                  child: Text("Marks Obtained",
                      style: headerStyle, textAlign: TextAlign.center)),
              Expanded(
                  flex: 4,
                  child: Text("Total Marks",
                      style: headerStyle, textAlign: TextAlign.center)),
              Expanded(
                  flex: 4,
                  child: Text("Percentage",
                      style: headerStyle, textAlign: TextAlign.center)),
              SizedBox(
                  width: 36,
                  child: Text("Grade",
                      style: headerStyle, textAlign: TextAlign.center)),
            ],
          ),
          const Divider(height: 20),

          // Items
          _buildRecentResultRow("Mid Term Exam", "Term 1", "Mathematics",
              "MATH", "15 Apr 2026", "42", "50", "84%", "A", Colors.green),
          const Divider(height: 20),
          _buildRecentResultRow("Mid Term Exam", "Term 1", "Science", "SCI",
              "16 Apr 2026", "44", "50", "88%", "A", Colors.green),
          const Divider(height: 20),
          _buildRecentResultRow("Mid Term Exam", "Term 1", "English", "ENG",
              "17 Apr 2026", "38", "50", "76%", "B+", Colors.teal),

          const Divider(height: 24),
          // View All Link
          GestureDetector(
            onTap: () => _tabController.animateTo(2),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "View All Results",
                  style: TextStyle(
                    color: Color(0xFF0038FF),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 16, color: Color(0xFF0038FF)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentResultRow(
    String examName,
    String term,
    String subject,
    String subCode,
    String date,
    String marksObtained,
    String totalMarks,
    String percentage,
    String grade,
    Color dotColor,
  ) {
    return Row(
      children: [
        // Exam Name
        Expanded(
          flex: 6,
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: dotColor),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      examName,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E2875)),
                    ),
                    Text(
                      term,
                      style:
                          TextStyle(fontSize: 9, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Subject
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875)),
              ),
              Text(
                subCode,
                style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        // Date
        Expanded(
          flex: 5,
          child: Text(
            date,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          ),
        ),
        // Marks Obtained
        Expanded(
          flex: 4,
          child: Text(
            marksObtained,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875)),
            textAlign: TextAlign.center,
          ),
        ),
        // Total Marks
        Expanded(
          flex: 4,
          child: Text(
            totalMarks,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
        ),
        // Percentage
        Expanded(
          flex: 4,
          child: Text(
            percentage,
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
            textAlign: TextAlign.center,
          ),
        ),
        // Grade Pill
        Container(
          width: 36,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: dotColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            grade,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: dotColor),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2875),
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTimetableCard(
    String subject,
    String date,
    String time,
    String duration,
    String hall,
    Color color,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.assignment_outlined,
                          color: color, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      subject,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2875),
                      ),
                    ),
                  ],
                ),
                Text(
                  hall,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Date",
                        style: TextStyle(color: Colors.grey, fontSize: 9)),
                    const SizedBox(height: 2),
                    Text(date,
                        style: const TextStyle(
                            color: Color(0xFF1E2875),
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Time",
                        style: TextStyle(color: Colors.grey, fontSize: 9)),
                    const SizedBox(height: 2),
                    Text(time,
                        style: const TextStyle(
                            color: Color(0xFF1E2875),
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Duration",
                        style: TextStyle(color: Colors.grey, fontSize: 9)),
                    const SizedBox(height: 2),
                    Text(duration,
                        style: const TextStyle(
                            color: Color(0xFF1E2875),
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeScoreCard(
    String subject,
    String scored,
    String total,
    String percent,
    String grade,
    Color color,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.analytics_outlined, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2875),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "Scored: $scored/$total",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Percent: $percent",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                grade,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
