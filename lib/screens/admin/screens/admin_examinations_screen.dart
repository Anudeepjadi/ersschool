import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminExaminationsScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const AdminExaminationsScreen({super.key, this.onOpenDrawer});

  @override
  State<AdminExaminationsScreen> createState() => _AdminExaminationsScreenState();
}

class _AdminExaminationsScreenState extends State<AdminExaminationsScreen> {
  final List<Map<String, dynamic>> _schedules = [
    {'name': 'Unit Test - 1', 'type': 'Unit Test', 'class': '8 - A', 'start': '20 Jun 2026', 'end': '22 Jun 2026', 'status': 'Upcoming'},
    {'name': 'Mid Term Exam', 'type': 'Mid Term', 'class': '7 - B', 'start': '03 Jul 2026', 'end': '07 Jul 2026', 'status': 'Upcoming'},
    {'name': 'Unit Test - 2', 'type': 'Unit Test', 'class': '6 - A', 'start': '17 Jul 2026', 'end': '19 Jul 2026', 'status': 'Upcoming'},
    {'name': 'Annual Exam', 'type': 'Annual', 'class': '8 - A', 'start': '10 Mar 2027', 'end': '25 Mar 2027', 'status': 'Ongoing'},
    {'name': 'Pre Final Exam', 'type': 'Pre Final', 'class': '10 - A', 'start': '05 Feb 2027', 'end': '14 Feb 2027', 'status': 'Completed'},
  ];

  final List<Map<String, dynamic>> _results = [
    {'student': 'Rahul Kumar', 'class': '8 - A', 'exam': 'Unit Test - 1', 'total': 100, 'obtained': 85, 'pct': '85%', 'result': 'Pass'},
    {'student': 'Ananya Sharma', 'class': '8 - A', 'exam': 'Unit Test - 1', 'total': 100, 'obtained': 72, 'pct': '72%', 'result': 'Pass'},
    {'student': 'Aarav Singh', 'class': '8 - A', 'exam': 'Unit Test - 1', 'total': 100, 'obtained': 48, 'pct': '48%', 'result': 'Average'},
    {'student': 'Diya Patel', 'class': '8 - A', 'exam': 'Unit Test - 1', 'total': 100, 'obtained': 35, 'pct': '35%', 'result': 'Fail'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      bottomNavigationBar: AdminBottomNavBar(currentIndex: 4),
      appBar: AdminAppBar(
        title: "Examinations",
        subtitle: "Manage exams, schedules and results",
        onOpenDrawer: widget.onOpenDrawer,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard("Total Exams", "12", "Ongoing: 1", Colors.blue),
                  _buildStatCard("Upcoming", "5", "+2 this year", Colors.orange),
                  _buildStatCard("Completed", "6", "Archived: 4", Colors.green),
                  _buildStatCard("Published Results", "5", "+1 this month", Colors.purple),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Exam Schedule list
            _buildExamSchedule(),
            SizedBox(height: 16),

            // Performance overview row (Donut + top performing classes bar chart)
            _buildPerformanceSection(),
            SizedBox(height: 16),

            // Student results log
            _buildResultsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String subtext, Color color) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          SizedBox(height: 4),
          Text(subtext, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildExamSchedule() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Exam Schedule".tr,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
              ),
              Text("View Calendar".tr,
                style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 14),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _schedules.length,
            itemBuilder: (context, index) {
              final sched = _schedules[index];
              Color statusColor;
              switch (sched['status']) {
                case 'Ongoing':
                  statusColor = Color(0xFFF59E0B);
                  break;
                case 'Completed':
                  statusColor = Color(0xFF10B981);
                  break;
                default:
                  statusColor = Colors.blue;
              }

              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.event_available_outlined, color: statusColor, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  sched['name'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E2875),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  sched['status'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Class ${sched['class']} | ${sched['type']}",
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.calendar_month_outlined, size: 14, color: Colors.grey.shade500),
                              SizedBox(width: 4),
                              Text(
                                "${sched['start']} - ${sched['end']}",
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Performance Overview".tr,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 35,
                          sections: [
                            PieChartSectionData(value: 75, color: Color(0xFF10B981), radius: 12, showTitle: false),
                            PieChartSectionData(value: 15, color: Color(0xFFF59E0B), radius: 12, showTitle: false),
                            PieChartSectionData(value: 10, color: Color(0xFFEF4444), radius: 12, showTitle: false),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("75%".tr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                          Text("Avg Pass".tr, style: TextStyle(fontSize: 8, color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 6,
                child: SizedBox(
                  height: 120,
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const classes = ['C10', 'C9', 'C8', 'C7', 'C6'];
                              if (value.toInt() >= 0 && value.toInt() < classes.length) {
                                return Text(classes[value.toInt()], style: TextStyle(fontSize: 8, color: Colors.grey));
                              }
                              return SizedBox();
                            },
                          ),
                        ),
                      ),
                      barGroups: [
                        _buildBarGroup(0, 88),
                        _buildBarGroup(1, 82),
                        _buildBarGroup(2, 78),
                        _buildBarGroup(3, 72),
                        _buildBarGroup(4, 65),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primary,
          width: 8,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: Colors.grey.shade100,
          ),
        ),
      ],
    );
  }

  Widget _buildResultsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Student Exam Performance Logs".tr,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _results.length,
            itemBuilder: (context, index) {
              final res = _results[index];
              Color resColor;
              switch (res['result']) {
                case 'Pass':
                  resColor = Color(0xFF10B981);
                  break;
                case 'Fail':
                  resColor = Color(0xFFEF4444);
                  break;
                default:
                  resColor = Color(0xFFF59E0B);
              }

              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: resColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.person_outline, color: resColor, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  res['student'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E2875),
                                  ),
                                ),
                              ),
                              Text(
                                "${res['obtained']}/${res['total']}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E2875),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "Class ${res['class']} | ${res['exam']}",
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: resColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "${res['pct']} (${res['result']})",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: resColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

