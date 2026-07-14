import 'package:ersschool/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/student_app_bar.dart';
import '../../../../widgets/scrollable_table_wrapper.dart';
import 'package:ersschool/core/localization/language_manager.dart';


// ─────────────────────────────────────────────────────────────────────────────
// Static data
// ─────────────────────────────────────────────────────────────────────────────
// Main widget
// ─────────────────────────────────────────────────────────────────────────────
class ExamsTab extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  final Function(int)? onTabSelected;

  const ExamsTab({super.key, this.onOpenDrawer, this.onTabSelected});

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
      appBar: StudentAppBar(
        title: "Examinations",
        subtitle: "View your schedules and results",
        onOpenDrawer: widget.onOpenDrawer ?? () => Scaffold.of(context).openDrawer(),
        onProfileTap: widget.onTabSelected != null ? () => widget.onTabSelected!(1) : null,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // 2. Tab Bar Section
            // 2. Tab Bar Section
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                unselectedLabelStyle:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
                tabs: [
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
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Examination Overview
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Text("Examination Overview".tr,
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Upcoming Exams".tr,
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
                  child: Row(children: [
                      Text("View Timetable".tr,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right,
                          size: 16, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildUpcomingExamsList(),

          SizedBox(height: 25),

          // 3. Recent Exam Results Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recent Exam Results".tr,
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
                  child: Row(children: [
                      Text("View All Results".tr,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right,
                          size: 16, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildRecentResultsList(),

          SizedBox(height: 25),

          // 4. Quick Actions Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Quick Actions".tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickActionItem(Icons.calendar_month_outlined,
                        "Term Exam\nTimetable", Colors.purple, onTap: () {
                      _tabController.animateTo(1);
                    }),
                    _buildQuickActionItem(
                        Icons.analytics_outlined, "Grade Report", Colors.green, onTap: () {
                      _tabController.animateTo(2);
                    }),
                    _buildQuickActionItem(Icons.download_for_offline_outlined,
                        "Download\nHall Ticket", Colors.orange, onTap: () {
                      _downloadHallTicket(context);
                    }),
                    _buildQuickActionItem(Icons.bar_chart_outlined,
                        "Performance\nAnalysis", Colors.blue, onTap: () {
                      _showPerformanceAnalysisDialog(context);
                    }),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 30),
        ],
      ),
    );
  }

  void _showPerformanceAnalysisDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Performance Analysis'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1E2875))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Here is your academic overview based on recent exams:'.tr),
            SizedBox(height: 16),
            _buildPerformanceRow('Top Subject:', 'Science (88%)', Colors.green),
            SizedBox(height: 8),
            _buildPerformanceRow('Weakest Subject:', 'Hindi (64%)', Colors.orange),
            SizedBox(height: 8),
            _buildPerformanceRow('Overall Average:', '78.5%', Colors.blue),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                  Icon(Icons.trending_up, color: Colors.blue, size: 24),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Great job! Your performance has improved by 4% compared to the last term.'.tr,
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 15)),
      ],
    );
  }

  Widget _buildTimetableTab() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Text("Term 1 Exam Schedule".tr,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2875)),
        ),
        SizedBox(height: 12),
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
      padding: EdgeInsets.all(20),
      children: [
        Text("Mid Term Academic Report".tr,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2875)),
        ),
        SizedBox(height: 12),
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
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(16),
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
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 10,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
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
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          ScrollableTableWrapper(
            child: SizedBox(
              width: 650,
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(flex: 6, child: Text("Exam Name".tr, style: headerStyle)),
                      Expanded(flex: 4, child: Text("Subject".tr, style: headerStyle)),
                      Expanded(flex: 5, child: Text("Date".tr, style: headerStyle)),
                      Expanded(flex: 4, child: Text("Time".tr, style: headerStyle)),
                      Expanded(flex: 4, child: Text("Duration".tr, style: headerStyle)),
                      SizedBox(
                          width: 32,
                          child: Text("Syllabus".tr,
                              style: headerStyle, textAlign: TextAlign.center)),
                    ],
                  ),
                  Divider(height: 20),
        
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
                  Divider(height: 20),
                  _buildUpcomingExamRow("Unit Test - 1", "Term 1", "Science", "SCI",
                      "27 Jun 2026", "Monday", "10:00 AM", "1.30 Hrs", Colors.green),
                  Divider(height: 20),
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
                  Divider(height: 20),
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
                  Divider(height: 20),
                  _buildUpcomingExamRow("Unit Test - 1", "Term 1", "Hindi", "HIN",
                      "03 Jun 2026", "Monday", "10:00 AM", "1.30 Hrs", Colors.blue),
                ],
              ),
            ),
          ),

          Divider(height: 24),
          // View All Link
          GestureDetector(
            onTap: () => _tabController.animateTo(1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("View All Upcoming Exams".tr,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
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
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child:
                    Icon(Icons.assignment_outlined, color: iconColor, size: 14),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      examName,
                      style: TextStyle(
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
                style: TextStyle(
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
                style: TextStyle(
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
            style: TextStyle(fontSize: 11, color: Color(0xFF1E2875)),
          ),
        ),
        // Duration
        Expanded(
          flex: 4,
          child: Text(
            duration,
            style: TextStyle(fontSize: 11, color: Color(0xFF1E2875)),
          ),
        ),
        // Syllabus Document Icon
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 32,
            alignment: Alignment.center,
            child: Icon(Icons.description_outlined,
                color: AppColors.primary, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentResultsList() {
    final headerStyle = TextStyle(
        color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          ScrollableTableWrapper(
            child: SizedBox(
              width: 750,
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(flex: 6, child: Text("Exam Name".tr, style: headerStyle)),
                      Expanded(flex: 4, child: Text("Subject".tr, style: headerStyle)),
                      Expanded(flex: 5, child: Text("Date".tr, style: headerStyle)),
                      Expanded(
                          flex: 4,
                          child: Text("Marks Obtained".tr,
                              style: headerStyle, textAlign: TextAlign.center)),
                      Expanded(
                          flex: 4,
                          child: Text("Total Marks".tr,
                              style: headerStyle, textAlign: TextAlign.center)),
                      Expanded(
                          flex: 4,
                          child: Text("Percentage".tr,
                              style: headerStyle, textAlign: TextAlign.center)),
                      SizedBox(
                          width: 36,
                          child: Text("Grade".tr,
                              style: headerStyle, textAlign: TextAlign.center)),
                    ],
                  ),
                  Divider(height: 20),
        
                  // Items
                  _buildRecentResultRow("Mid Term Exam", "Term 1", "Mathematics",
                      "MATH", "15 Apr 2026", "42", "50", "84%", "A", Colors.green),
                  Divider(height: 20),
                  _buildRecentResultRow("Mid Term Exam", "Term 1", "Science", "SCI",
                      "16 Apr 2026", "44", "50", "88%", "A", Colors.green),
                  Divider(height: 20),
                  _buildRecentResultRow("Mid Term Exam", "Term 1", "English", "ENG",
                      "17 Apr 2026", "38", "50", "76%", "B+", Colors.teal),
                ],
              ),
            ),
          ),

          Divider(height: 24),
          // View All Link
          GestureDetector(
            onTap: () => _tabController.animateTo(2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("View All Results".tr,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
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
              SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      examName,
                      style: TextStyle(
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
                style: TextStyle(
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
            style: TextStyle(
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
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
            textAlign: TextAlign.center,
          ),
        ),
        // Grade Pill
        Container(
          width: 36,
          padding: EdgeInsets.symmetric(vertical: 4),
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

  Widget _buildQuickActionItem(IconData icon, String label, Color color, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _downloadHallTicket(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preparing Hall Ticket...'.tr)),
    );
    await Future.delayed(Duration(seconds: 2));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hall Ticket downloaded successfully!'.tr),
        backgroundColor: Colors.green,
      ),
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
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.assignment_outlined,
                          color: color, size: 16),
                    ),
                    SizedBox(width: 8),
                    Text(
                      subject,
                      style: TextStyle(
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
            Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date".tr,
                        style: TextStyle(color: Colors.grey, fontSize: 9)),
                    SizedBox(height: 2),
                    Text(date,
                        style: TextStyle(
                            color: Color(0xFF1E2875),
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Time".tr,
                        style: TextStyle(color: Colors.grey, fontSize: 9)),
                    SizedBox(height: 2),
                    Text(time,
                        style: TextStyle(
                            color: Color(0xFF1E2875),
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Duration".tr,
                        style: TextStyle(color: Colors.grey, fontSize: 9)),
                    SizedBox(height: 2),
                    Text(duration,
                        style: TextStyle(
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
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.analytics_outlined, color: color, size: 20),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2875),
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "Scored: $scored/$total",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Percent: $percent",
                        style: TextStyle(
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
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
