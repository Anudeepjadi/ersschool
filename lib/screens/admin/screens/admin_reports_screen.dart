import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  final List<Map<String, dynamic>> _reportsList = [
    {'name': 'Monthly Attendance Report - Jun 2026', 'type': 'Attendance', 'dept': 'Administration', 'format': 'PDF', 'status': 'Generated', 'date': '20 Jun 2026'},
    {'name': 'Class 10 - Term 1 Result Analysis', 'type': 'Examination', 'dept': 'Academics', 'format': 'Excel', 'status': 'Generated', 'date': '19 Jun 2026'},
    {'name': 'Fee Collection Report - May 2026', 'type': 'Finance', 'dept': 'Accounts', 'format': 'PDF', 'status': 'Generated', 'date': '18 Jun 2026'},
    {'name': 'Student Performance Summary', 'type': 'Academic', 'dept': 'Academics', 'format': 'PDF', 'status': 'Generated', 'date': '17 Jun 2026'},
    {'name': 'Transport Usage Report - Jun 2026', 'type': 'Transport', 'dept': 'Transport', 'format': 'Excel', 'status': 'Generated', 'date': '16 Jun 2026'},
    {'name': 'Library Usage Statistics', 'type': 'Library', 'dept': 'Library', 'format': 'Excel', 'status': 'Generated', 'date': '15 Jun 2026'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reports Dashboard",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            Text(
              "View and generate school reports",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard("Total Reports", "1,256", "+18% this year", Colors.blue),
                  _buildStatCard("Generated", "1,102", "+15% this year", Colors.green),
                  _buildStatCard("Scheduled", "68", "+8% this year", Colors.orange),
                  _buildStatCard("Downloaded", "2,856", "+22% this year", Colors.purple),
                  _buildStatCard("Shared", "654", "+10% this year", Colors.teal),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Line chart & Donut charts
            _buildChartsSection(),
            const SizedBox(height: 16),

            // Popular Reports section
            _buildPopularReports(),
            const SizedBox(height: 16),

            // Recent Reports List
            _buildLogsTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String subtext, Color color) {
    return Container(
      width: 125,
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
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          const SizedBox(height: 4),
          Text(subtext, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
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
            "Reports Analytics",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 110,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 30,
                          sections: [
                            PieChartSectionData(value: 40.8, color: const Color(0xFF3B82F6), radius: 10, showTitle: false),
                            PieChartSectionData(value: 18.8, color: const Color(0xFF10B981), radius: 10, showTitle: false),
                            PieChartSectionData(value: 14.6, color: const Color(0xFFF59E0B), radius: 10, showTitle: false),
                            PieChartSectionData(value: 14, color: const Color(0xFF8B5CF6), radius: 10, showTitle: false),
                            PieChartSectionData(value: 11.8, color: const Color(0xFF9CA3AF), radius: 10, showTitle: false),
                          ],
                        ),
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("1,256", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                          Text("Total", style: TextStyle(fontSize: 8, color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                flex: 6,
                child: Column(
                  children: [
                    _RowItem(Color(0xFF3B82F6), "Academic Reports", "512 (40.8%)"),
                    SizedBox(height: 6),
                    _RowItem(Color(0xFF10B981), "Attendance Reports", "236 (18.8%)"),
                    SizedBox(height: 6),
                    _RowItem(Color(0xFFF59E0B), "Finance Reports", "184 (14.6%)"),
                    SizedBox(height: 6),
                    _RowItem(Color(0xFF8B5CF6), "Examination Reports", "176 (14%)"),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPopularReports() {
    final List<Map<String, dynamic>> items = [
      {'name': 'Student Performance Summary', 'icon': Icons.menu_book, 'color': Colors.blue},
      {'name': 'Fee Collection Overview', 'icon': Icons.currency_rupee, 'color': Colors.green},
      {'name': 'Attendance Summary Logs', 'icon': Icons.checklist, 'color': Colors.orange},
    ];

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
            "Popular Reports Templates",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          const SizedBox(height: 12),
          Column(
            children: items.map((it) {
              return Card(
                elevation: 0,
                color: const Color(0xFFF5F7FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: it['color'].withValues(alpha: 0.1), child: Icon(it['icon'], color: it['color'])),
                  title: Text(it['name'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  onTap: () {},
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildLogsTable() {
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
              "Recent Generated Reports",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _reportsList.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final rep = _reportsList[index];
              return ListTile(
                title: Text(rep['name'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                subtitle: Text("Format: ${rep['format']} • Dept: ${rep['dept']}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(rep['type'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    Text(
                      rep['date'],
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
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

class _RowItem extends StatelessWidget {
  final Color color;
  final String label;
  final String val;
  const _RowItem(this.color, this.label, this.val);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
        Text(val, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
      ],
    );
  }
}
