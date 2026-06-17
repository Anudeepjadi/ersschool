import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/admin_app_bar.dart';

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
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AdminAppBar(
        title: "Examinations",
        subtitle: "Manage exams, schedules and results",
        onOpenDrawer: widget.onOpenDrawer,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 16),

            // Exam Schedule list
            _buildExamSchedule(),
            const SizedBox(height: 16),

            // Performance overview row (Donut + top performing classes bar chart)
            _buildPerformanceSection(),
            const SizedBox(height: 16),

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
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          const SizedBox(height: 4),
          Text(subtext, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildExamSchedule() {
    return Container(
      padding: const EdgeInsets.all(16),
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
              const Text(
                "Exam Schedule",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
              ),
              Text(
                "View Calendar",
                style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _schedules.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final sched = _schedules[index];
              Color statusColor;
              switch (sched['status']) {
                case 'Ongoing':
                  statusColor = const Color(0xFFF59E0B);
                  break;
                case 'Completed':
                  statusColor = const Color(0xFF10B981);
                  break;
                default:
                  statusColor = Colors.blue;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sched['name'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                          Text("Class ${sched['class']} • ${sched['type']}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        "${sched['start']} - ${sched['end']}",
                        style: const TextStyle(fontSize: 11, color: Color(0xFF757897), fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        sched['status'],
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Performance Overview",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          const SizedBox(height: 16),
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
                            PieChartSectionData(value: 75, color: const Color(0xFF10B981), radius: 12, showTitle: false),
                            PieChartSectionData(value: 15, color: const Color(0xFFF59E0B), radius: 12, showTitle: false),
                            PieChartSectionData(value: 10, color: const Color(0xFFEF4444), radius: 12, showTitle: false),
                          ],
                        ),
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("75%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                          Text("Avg Pass", style: TextStyle(fontSize: 8, color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 6,
                child: SizedBox(
                  height: 120,
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const classes = ['C10', 'C9', 'C8', 'C7', 'C6'];
                              if (value.toInt() >= 0 && value.toInt() < classes.length) {
                                return Text(classes[value.toInt()], style: const TextStyle(fontSize: 8, color: Colors.grey));
                              }
                              return const SizedBox();
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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Student Exam Performance Logs",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _results.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final res = _results[index];
              Color resColor;
              switch (res['result']) {
                case 'Pass':
                  resColor = const Color(0xFF10B981);
                  break;
                case 'Fail':
                  resColor = const Color(0xFFEF4444);
                  break;
                default:
                  resColor = const Color(0xFFF59E0B);
              }

              return ListTile(
                title: Text(res['student'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                subtitle: Text("Class ${res['class']} • ${res['exam']}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${res['obtained']}/${res['total']}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    Text(
                      "${res['pct']} (${res['result']})",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: resColor,
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
