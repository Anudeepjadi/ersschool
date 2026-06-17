import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class AdminFeesScreen extends StatefulWidget {
  const AdminFeesScreen({super.key});

  @override
  State<AdminFeesScreen> createState() => _AdminFeesScreenState();
}

class _AdminFeesScreenState extends State<AdminFeesScreen> {
  String _selectedSession = '2026 - 27';
  String _selectedClass = 'All Classes';
  String _selectedFeeType = 'All Fee Types';

  final List<Map<String, dynamic>> _feeTypes = [
    {
      'type': 'Tuition Fee',
      'total': '₹ 15,000',
      'collected': '₹ 3,60',
      'pending': '₹ 11,40',
      'pct': 24,
      'color': Colors.blue
    },
    {
      'type': 'Transport Fee',
      'total': '₹ 3,00',
      'collected': '₹ 1,20',
      'pending': '₹ 1,80',
      'pct': 40,
      'color': Colors.red
    },
    {
      'type': 'Library Fee',
      'total': '₹ 1,00',
      'collected': '₹ 70',
      'pending': '₹ 30',
      'pct': 70,
      'color': Colors.green
    },
    {
      'type': 'Lab Fee',
      'total': '₹ 80',
      'collected': '₹ 40',
      'pending': '₹ 40',
      'pct': 50,
      'color': Colors.purple
    },
    {
      'type': 'Exam Fee',
      'total': '₹ 1,20',
      'collected': '₹ 30',
      'pending': '₹ 90',
      'pct': 25,
      'color': Colors.orange
    },
    {
      'type': 'Activity Fee',
      'total': '₹ 60',
      'collected': '₹ 25',
      'pending': '₹ 35',
      'pct': 42,
      'color': Colors.teal
    },
  ];

  final List<Map<String, dynamic>> _transactions = [
    {
      'receipt': 'RCP000125',
      'student': 'Rahul Kumar',
      'class': '8 - A',
      'type': 'Tuition Fee',
      'amount': '₹ 15,000',
      'date': '20 Jun 2026',
      'status': 'Paid'
    },
    {
      'receipt': 'RCP000124',
      'student': 'Ananya Sharma',
      'class': '7 - B',
      'type': 'Transport Fee',
      'amount': '₹ 7,500',
      'date': '20 Jun 2026',
      'status': 'Paid'
    },
    {
      'receipt': 'RCP000123',
      'student': 'Aarav Singh',
      'class': '6 - A',
      'type': 'Tuition Fee',
      'amount': '₹ 15,000',
      'date': '20 Jun 2026',
      'status': 'Paid'
    },
    {
      'receipt': 'RCP000122',
      'student': 'Diya Patel',
      'class': '5 - B',
      'type': 'Library Fee',
      'amount': '₹ 2,000',
      'date': '20 Jun 2026',
      'status': 'Paid'
    },
    {
      'receipt': 'RCP000121',
      'student': 'Kabir Verma',
      'class': '8 - B',
      'type': 'Exam Fee',
      'amount': '₹ 3,000',
      'date': '18 Jun 2026',
      'status': 'Pending'
    },
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
              "Fees Collection",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
            Text(
              "Manage and track all fee collections",
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
            // Filter dropdowns
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: "Session",
                    value: _selectedSession,
                    items: ['2026 - 27', '2025 - 26'],
                    onChanged: (v) => setState(() => _selectedSession = v!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(
                    label: "Class",
                    value: _selectedClass,
                    items: ['All Classes', '8 - A', '7 - B'],
                    onChanged: (v) => setState(() => _selectedClass = v!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(
                    label: "Fee Type",
                    value: _selectedFeeType,
                    items: ['All Fee Types', 'Tuition Fee', 'Transport Fee'],
                    onChanged: (v) => setState(() => _selectedFeeType = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stat Cards Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard("Total Collected", "₹ 2,45,000",
                      "+12.5% vs Apr", const Color(0xFF10B981)),
                  _buildStatCard("Total Pending", "₹ 18,75,000", "-8.3% vs Apr",
                      const Color(0xFFEF4444)),
                  _buildStatCard("Overdue Amount", "₹ 5,60,000", "-5.6% vs Apr",
                      const Color(0xFFEF4444)),
                  _buildStatCard("Collection %", "24%", "+4.2% vs Apr",
                      const Color(0xFF10B981)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Charts Section (Donut + Collection Trend)
            _buildChartsSection(),
            const SizedBox(height: 16),

            // Fee Type breakdown list
            _buildFeeTypeBreakdown(),
            const SizedBox(height: 16),

            // Recent Transactions Table
            _buildRecentTransactions(),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isDense: true,
              isExpanded: true,
              style: const TextStyle(
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

  Widget _buildStatCard(
      String label, String value, String subtext, Color subColor) {
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
          Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875))),
          const SizedBox(height: 4),
          Text(subtext,
              style: TextStyle(
                  fontSize: 10, color: subColor, fontWeight: FontWeight.bold)),
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
            "Collection Overview",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875)),
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
                          centerSpaceRadius: 32,
                          sections: [
                            PieChartSectionData(
                                value: 24,
                                color: AppColors.primary,
                                radius: 12,
                                showTitle: false),
                            PieChartSectionData(
                                value: 62,
                                color: const Color(0xFFEF4444),
                                radius: 12,
                                showTitle: false),
                            PieChartSectionData(
                                value: 14,
                                color: const Color(0xFFF59E0B),
                                radius: 12,
                                showTitle: false),
                          ],
                        ),
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("24%",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E2875))),
                          Text("Collected",
                              style:
                                  TextStyle(fontSize: 8, color: Colors.grey)),
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
                  child: LineChart(
                    LineChartData(
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const months = [
                                'Dec',
                                'Jan',
                                'Feb',
                                'Mar',
                                'Apr',
                                'May'
                              ];
                              if (value.toInt() >= 0 &&
                                  value.toInt() < months.length) {
                                return Text(months[value.toInt()],
                                    style: const TextStyle(
                                        fontSize: 8, color: Colors.grey));
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 1.2),
                            FlSpot(1, 1.8),
                            FlSpot(2, 2.1),
                            FlSpot(3, 2.6),
                            FlSpot(4, 2.3),
                            FlSpot(5, 2.45),
                          ],
                          isCurved: true,
                          color: AppColors.primary,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                        )
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

  Widget _buildFeeTypeBreakdown() {
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
            "Fee Type Collection Breakdown",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875)),
          ),
          const SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _feeTypes.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final ft = _feeTypes[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
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
                            const SizedBox(width: 8),
                            Text(ft['type'],
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E2875))),
                          ],
                        ),
                        Text("${ft['pct']}% Collected",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 8),
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

  Widget _buildRecentTransactions() {
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
              "Recent Transactions",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875)),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _transactions.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final tx = _transactions[index];
              final isPaid = tx['status'] == 'Paid';
              return ListTile(
                title: Text(tx['student'],
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2875))),
                subtitle: Text("${tx['receipt']} • ${tx['type']}",
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(tx['amount'],
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2875))),
                    Text(
                      tx['status'],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isPaid
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
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
