import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/data/app_data_store.dart';
import '../../../core/utils/profile_manager.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminFeesScreen extends StatefulWidget {
  const AdminFeesScreen({super.key});

  @override
  State<AdminFeesScreen> createState() => _AdminFeesScreenState();
}

class _AdminFeesScreenState extends State<AdminFeesScreen> {
  String _selectedSession = '2026 - 27';
  String _selectedClass = 'All Classes';
  String _selectedFeeType = 'All Fee Types';

  List<Map<String, dynamic>> _getFeeTypes(String school) {
    // Return different mock data based on school for visual feedback
    double factor = school.contains('2') ? 0.8 : (school.contains('3') ? 1.2 : 1.0);
    return [
      {'type': 'Tuition Fee', 'pct': (24 * factor).toInt().clamp(0, 100), 'color': Colors.blue},
      {'type': 'Transport Fee', 'pct': (40 * factor).toInt().clamp(0, 100), 'color': Colors.red},
      {'type': 'Library Fee', 'pct': (70 * factor).toInt().clamp(0, 100), 'color': Colors.green},
      {'type': 'Lab Fee', 'pct': (50 * factor).toInt().clamp(0, 100), 'color': Colors.purple},
      {'type': 'Exam Fee', 'pct': (25 * factor).toInt().clamp(0, 100), 'color': Colors.orange},
      {'type': 'Activity Fee', 'pct': (42 * factor).toInt().clamp(0, 100), 'color': Colors.teal},
    ];
  }

  List<Map<String, dynamic>> _getRecentTransactions(String school) {
    if (school == 'Ecstasy School 2') {
      return [
        {'receipt': 'RCP000201', 'student': 'Kabir Malhotra', 'class': '10 - A', 'type': 'Tuition Fee', 'amount': '₹ 12,000', 'date': '21 Jun 2026', 'status': 'Paid'},
        {'receipt': 'RCP000202', 'student': 'Dia Sen', 'class': '10 - B', 'type': 'Transport Fee', 'amount': '₹ 5,000', 'date': '21 Jun 2026', 'status': 'Paid'},
      ];
    } else if (school == 'Ecstasy School 3') {
      return [
        {'receipt': 'RCP000301', 'student': 'Vivaan Kapoor', 'class': '10 - A', 'type': 'Tuition Fee', 'amount': '₹ 18,000', 'date': '22 Jun 2026', 'status': 'Paid'},
      ];
    }
    return [
      {'receipt': 'RCP000125', 'student': 'Rahul Kumar', 'class': '8 - A', 'type': 'Tuition Fee', 'amount': '₹ 15,000', 'date': '20 Jun 2026', 'status': 'Paid'},
      {'receipt': 'RCP000124', 'student': 'Ananya Sharma', 'class': '7 - B', 'type': 'Transport Fee', 'amount': '₹ 7,500', 'date': '20 Jun 2026', 'status': 'Paid'},
      {'receipt': 'RCP000123', 'student': 'Aarav Singh', 'class': '6 - A', 'type': 'Tuition Fee', 'amount': '₹ 15,000', 'date': '20 Jun 2026', 'status': 'Paid'},
      {'receipt': 'RCP000121', 'student': 'Kabir Verma', 'class': '8 - B', 'type': 'Exam Fee', 'amount': '₹ 3,000', 'date': '18 Jun 2026', 'status': 'Pending'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      appBar: AdminAppBar(title: "Fees Collection", subtitle: "Manage your account details"),
      bottomNavigationBar: AdminBottomNavBar(currentIndex: 4),
      body: ValueListenableBuilder<String>(
        valueListenable: ProfileManager().selectedSchool,
        builder: (context, school, _) {
          final metrics = AppDataStore.instance.getSchoolMetrics(school);
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter dropdowns
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 140,
                        child: _buildDropdown(
                          label: "Session",
                          value: _selectedSession,
                          items: ['2026 - 27', '2025 - 26'],
                          onChanged: (v) => setState(() => _selectedSession = v!),
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 140,
                        child: _buildDropdown(
                          label: "Class",
                          value: _selectedClass,
                          items: ['All Classes', '8 - A', '7 - B'],
                          onChanged: (v) => setState(() => _selectedClass = v!),
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 140,
                        child: _buildDropdown(
                          label: "Fee Type",
                          value: _selectedFeeType,
                          items: ['All Fee Types', 'Tuition Fee', 'Transport Fee'],
                          onChanged: (v) => setState(() => _selectedFeeType = v!),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Stat Cards Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildStatCard("Total Collected", metrics['totalCollected'],
                          "+12.5% vs Apr", Color(0xFF10B981)),
                      _buildStatCard("Total Pending", metrics['totalPending'], "-8.3% vs Apr",
                          Color(0xFFEF4444)),
                      _buildStatCard("Overdue Amount", metrics['overdueAmount'] ?? '₹ 0', "-5.6% vs Apr",
                          Color(0xFFEF4444)),
                      _buildStatCard("Collection %", "${metrics['collectedPercent'].toInt()}%", "+4.2% vs Apr",
                          Color(0xFF10B981)),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Charts Section
                _buildFeeCollectionCardForSchool(school, metrics),
                SizedBox(height: 16),

                // Fee Type breakdown list
                _buildFeeTypeBreakdown(_getFeeTypes(school)),
                SizedBox(height: 16),

                // Recent Transactions Table
                _buildRecentTransactions(_getRecentTransactions(school)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 9, color: Colors.grey)),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isDense: true,
              isExpanded: true,
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF1E2875),
                  fontWeight: FontWeight.bold),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String subtext, Color subColor) {
    return Container(
      width: 135,
      height: 100,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2875))),
              SizedBox(height: 2),
              Text(subtext,
                  style: TextStyle(
                      fontSize: 10, color: subColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeeTypeBreakdown(List<Map<String, dynamic>> feeTypes) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Fee Type Collection Breakdown".tr,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875)),
          ),
          SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: feeTypes.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final ft = feeTypes[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: ft['color'],
                                    shape: BoxShape.circle)),
                            SizedBox(width: 8),
                            Text(ft['type'],
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E2875))),
                          ],
                        ),
                        Text("${ft['pct']}% Collected",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: ft['pct'] / 100,
                      color: ft['color'],
                      backgroundColor: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 6,
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

  Widget _buildRecentTransactions(List<Map<String, dynamic>> transactions) {
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
            child: Text("Recent Transactions".tr,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875)),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final isPaid = tx['status'] == 'Paid';
              return ListTile(
                title: Text(tx['student'],
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2875))),
                subtitle: Text("${tx['receipt']} | ${tx['type']}",
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(tx['amount'],
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2875))),
                    Text(
                      tx['status'],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isPaid
                            ? Color(0xFF10B981)
                            : Color(0xFFEF4444),
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

  Widget _buildFeeCollectionCardForSchool(String school, Map<String, dynamic> metrics) {
    final double tuitionPaid = metrics['tuitionPaidPercent'] as double;
    final double tuitionPending = metrics['tuitionPendingPercent'] as double;
    final double transportPaid = metrics['transportPaidPercent'] as double;
    final double transportPending = metrics['transportPendingPercent'] as double;
    
    String branchCode = "ECS001";
    if (school == "Ecstasy School 2") branchCode = "ECS002";
    if (school == "Ecstasy School 3") branchCode = "ECS003";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Branch Selector Dropdown Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade50,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Branch".tr,
                style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: school,
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF1E2875)),
                  style: TextStyle(fontSize: 14, color: Color(0xFF1E2875), fontWeight: FontWeight.bold),
                  items: [
                    DropdownMenuItem(value: 'All Branches', child: Text("All Branches".tr)),
                    DropdownMenuItem(value: 'Ecstasy School 1', child: Text("Ecstasy School 1 (ECS001)".tr)),
                    DropdownMenuItem(value: 'Ecstasy School 2', child: Text("Ecstasy School 2 (ECS002)".tr)),
                    DropdownMenuItem(value: 'Ecstasy School 3', child: Text("Ecstasy School 3 (ECS003)".tr)),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ProfileManager().selectedSchool.value = v;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // 2. Side-by-Side Pie Charts
        Row(
          children: [
            // Tuition Fee Collection
            Expanded(
              child: Container(
                height: 250,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade50, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$school ($branchCode)", style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text("Tuition Fee Collection".tr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDotLegend(Color(0xFF0F5A35), "Paid ${tuitionPaid.toInt()}%"),
                        _buildDotLegend(Color(0xFFB3241F), "Pending ${tuitionPending.toInt()}%"),
                      ],
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 36,
                              sections: [
                                PieChartSectionData(value: tuitionPaid, color: Color(0xFF0F5A35), radius: 14, showTitle: false),
                                PieChartSectionData(value: tuitionPending, color: Color(0xFFB3241F), radius: 14, showTitle: false),
                              ],
                            ),
                          ),
                          Text("${tuitionPaid.toInt()}%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12),
            // Transport Fee Collection
            Expanded(
              child: Container(
                height: 250,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade50, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$school ($branchCode)", style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text("Transport Fee Collection".tr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDotLegend(Color(0xFF0F5A35), "Paid ${transportPaid.toInt()}%"),
                        _buildDotLegend(Color(0xFFB3241F), "Pending ${transportPending.toInt()}%"),
                      ],
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 36,
                              sections: [
                                PieChartSectionData(value: transportPaid, color: Color(0xFF0F5A35), radius: 14, showTitle: false),
                                PieChartSectionData(value: transportPending, color: Color(0xFFB3241F), radius: 14, showTitle: false),
                              ],
                            ),
                          ),
                          Text("${transportPaid.toInt()}%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // 3. Fee Due Students Section
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade50,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$school ($branchCode)", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              SizedBox(height: 2),
              Text("Fee Due Students".tr,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildLegendBlock(Color(0xFF1E3A8A), "Total Students"),
                  _buildLegendBlock(Color(0xFF0F5A35), "Term 1 Paid"),
                  _buildLegendBlock(Color(0xFFB3241F), "Term 1 Due"),
                  _buildLegendBlock(Color(0xFF10B981), "Term 2 Paid"),
                  _buildLegendBlock(Color(0xFFF59E0B), "Term 2 Due"),
                  _buildLegendBlock(Color(0xFFA7F3D0), "Term 3 Paid"),
                  _buildLegendBlock(Color(0xFFFCA5A5), "Term 3 Due"),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 160,
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
                            switch (value.toInt()) {
                              case 0: return Text("Total".tr, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey));
                              case 1: return Text("Term 1".tr, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey));
                              case 2: return Text("Term 2".tr, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey));
                              case 3: return Text("Term 3".tr, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey));
                            }
                            return SizedBox();
                          },
                        ),
                      ),
                    ),
                    barGroups: _buildFeeDueBarGroups(school),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // 4. School Fee Structures Card
        _buildSchoolFeeStructuresCard(),
      ],
    );
  }

  Widget _buildDotLegend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _buildLegendBlock(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF757897))),
      ],
    );
  }

  List<BarChartGroupData> _buildFeeDueBarGroups(String school) {
    int count = AppDataStore.instance.students.where((s) {
      final sSchool = s['school']?.toString() ?? '';
      return sSchool == school || sSchool.startsWith('$school (');
    }).length;

    double total = count.toDouble();
    if (total == 0) total = 0.1; // Prevent completely invisible bars if 0

    double term1Paid = total * 0.85;
    double term1Due = total * 0.15;
    double term2Paid = total * 0.70;
    double term2Due = total * 0.30;
    double term3Paid = total * 0.55;
    double term3Due = total * 0.45;

    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(toY: total, color: const Color(0xFF1E3A8A), width: 14, borderRadius: BorderRadius.circular(4)),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(toY: term1Paid, color: const Color(0xFF0F5A35), width: 10, borderRadius: BorderRadius.circular(4)),
          BarChartRodData(toY: term1Due, color: const Color(0xFFB3241F), width: 10, borderRadius: BorderRadius.circular(4)),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(toY: term2Paid, color: const Color(0xFF10B981), width: 10, borderRadius: BorderRadius.circular(4)),
          BarChartRodData(toY: term2Due, color: const Color(0xFFF59E0B), width: 10, borderRadius: BorderRadius.circular(4)),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(toY: term3Paid, color: const Color(0xFFA7F3D0), width: 10, borderRadius: BorderRadius.circular(4)),
          BarChartRodData(toY: term3Due, color: const Color(0xFFFCA5A5), width: 10, borderRadius: BorderRadius.circular(4)),
        ],
      ),
    ];
  }

  Widget _buildSchoolFeeStructuresCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
              Icon(Icons.table_chart_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text("School Fee Structures (Annual)".tr,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
              ),
            ],
          ),
          SizedBox(height: 12),
          Table(
            border: TableBorder.all(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
            columnWidths: const {
              0: FlexColumnWidth(2.6),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(2.0),
              3: FlexColumnWidth(1.4),
              4: FlexColumnWidth(1.6),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey.shade50),
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("School".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF1E2875)))),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("Tuition".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF1E2875)))),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("Transport".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF1E2875)))),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("Exam".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF1E2875)))),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("Total".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF1E2875)))),
                ],
              ),
              ...AppDataStore.instance.feeStructures.map((fee) {
                return TableRow(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("${fee['school']}\n(${fee['branchCode']})", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF757897)))),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("₹ ${fee['tuition']}", style: TextStyle(fontSize: 9, color: Color(0xFF1E2875)))),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("₹ ${fee['transport']}", style: TextStyle(fontSize: 9, color: Color(0xFF1E2875)))),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("₹ ${fee['exam']}", style: TextStyle(fontSize: 9, color: Color(0xFF1E2875)))),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("₹ ${fee['total']}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)))),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
