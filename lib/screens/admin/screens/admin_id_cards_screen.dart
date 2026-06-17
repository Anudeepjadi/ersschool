import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class AdminIDCardsScreen extends StatefulWidget {
  const AdminIDCardsScreen({super.key});

  @override
  State<AdminIDCardsScreen> createState() => _AdminIDCardsScreenState();
}

class _AdminIDCardsScreenState extends State<AdminIDCardsScreen> {
  final List<Map<String, dynamic>> _records = [
    {'name': 'Rahul Kumar', 'type': 'Student', 'id': '101', 'dept': '8 - A', 'date': '20 Jun 2026', 'status': 'Approved'},
    {'name': 'Ananya Sharma', 'type': 'Student', 'id': '102', 'dept': '8 - A', 'date': '20 Jun 2026', 'status': 'Approved'},
    {'name': 'Aarav Singh', 'type': 'Student', 'id': '103', 'dept': '8 - A', 'date': '19 Jun 2026', 'status': 'Pending'},
    {'name': 'Diya Patel', 'type': 'Student', 'id': '104', 'dept': '8 - A', 'date': '19 Jun 2026', 'status': 'Pending'},
    {'name': 'Kabir Verma', 'type': 'Student', 'id': '105', 'dept': '8 - B', 'date': '18 Jun 2026', 'status': 'Approved'},
    {'name': 'Ananya Sharma', 'type': 'Teacher', 'id': 'TCH125', 'dept': 'Mathematics', 'date': '18 Jun 2026', 'status': 'Approved'},
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
              "ID Cards Management",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            Text(
              "Manage student and staff ID cards",
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
                  _buildStatCard("Total ID Cards", "1,245", "+12% this month", Colors.blue),
                  _buildStatCard("Students", "1,042", "+10% this month", Colors.green),
                  _buildStatCard("Teachers", "158", "+8% this month", Colors.orange),
                  _buildStatCard("Staff", "45", "+5% this month", Colors.purple),
                  _buildStatCard("Pending Requests", "38", "+8% this month", Colors.red),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Previews of Student & Staff Cards
            const Text(
              "ID Card Previews",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
            const SizedBox(height: 12),
            _buildCardPreviews(),
            const SizedBox(height: 16),

            // ID Card summary chart
            _buildSummaryChart(),
            const SizedBox(height: 16),

            // List table
            _buildRecordsTable(),
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

  Widget _buildCardPreviews() {
    return Column(
      children: [
        // 1. Student ID Card (Blue)
        _buildIDCardLayout(
          headerColor: AppColors.primary,
          headerText: "ECSTASY SCHOOL 1",
          subHeader: "Shaping Futures, Building Tomorrow",
          roleText: "STUDENT",
          name: "Rahul Kumar",
          details: {
            'Class': '8 - A',
            'Roll No.': '101',
            'DOB': '14 May 2010',
            'Blood Group': 'B+',
          },
          idNumber: "ES1S2410101",
        ),
        const SizedBox(height: 16),
        // 2. Staff ID Card (Green)
        _buildIDCardLayout(
          headerColor: const Color(0xFF10B981),
          headerText: "ECSTASY SCHOOL 1",
          subHeader: "Shaping Futures, Building Tomorrow",
          roleText: "STAFF",
          name: "Ananya Sharma",
          details: {
            'Designation': 'Mathematics Teacher',
            'Employee ID': 'TCH125',
            'Department': 'Academics',
          },
          idNumber: "ES1TCH125",
        ),
      ],
    );
  }

  Widget _buildIDCardLayout({
    required Color headerColor,
    required String headerText,
    required String subHeader,
    required String roleText,
    required String name,
    required Map<String, String> details,
    required String idNumber,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade50, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Header banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.school, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(headerText, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(subHeader, style: const TextStyle(color: Colors.white70, fontSize: 8)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Info body
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                // Profile Picture placeholder
                Container(
                  width: 70,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.person, size: 40, color: Colors.grey.shade400),
                ),
                const SizedBox(width: 14),
                // Card details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                      ),
                      const SizedBox(height: 6),
                      ...details.entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Row(
                            children: [
                              Text("${e.key}: ", style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                              Text(e.value, style: const TextStyle(fontSize: 10, color: Color(0xFF1E2875), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                // Vertical role strip
                RotatedBox(
                  quarterTurns: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: headerColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      roleText,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: headerColor, letterSpacing: 0.5),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 1),
          // Barcode representation & ID footer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fake barcode lines
                    Row(
                      children: List.generate(20, (index) {
                        return Container(
                          width: (index % 3 == 0) ? 3.0 : 1.5,
                          height: 20,
                          color: Colors.black,
                          margin: const EdgeInsets.only(right: 1),
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(idNumber, style: const TextStyle(fontSize: 9, fontFamily: 'monospace', color: Colors.grey)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 1,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 4),
                    const Text("Principal Sign", style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummaryChart() {
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
            "ID Cards Summary",
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
                            PieChartSectionData(value: 83.7, color: const Color(0xFF3B82F6), radius: 10, showTitle: false),
                            PieChartSectionData(value: 12.7, color: const Color(0xFF10B981), radius: 10, showTitle: false),
                            PieChartSectionData(value: 3.6, color: const Color(0xFFF59E0B), radius: 10, showTitle: false),
                          ],
                        ),
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("1,245", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                          Text("Total", style: TextStyle(fontSize: 8, color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                flex: 6,
                child: Column(
                  children: [
                    _SummaryRow(Color(0xFF3B82F6), "Students", "1,042 (83.7%)"),
                    SizedBox(height: 8),
                    _SummaryRow(Color(0xFF10B981), "Teachers", "158 (12.7%)"),
                    SizedBox(height: 8),
                    _SummaryRow(Color(0xFFF59E0B), "Staff", "45 (3.6%)"),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRecordsTable() {
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
              "Recent ID Card Logs",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _records.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final rec = _records[index];
              final isApproved = rec['status'] == 'Approved';
              return ListTile(
                title: Text(rec['name'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                subtitle: Text("ID: ${rec['id']} • Dept/Class: ${rec['dept']}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(rec['type'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    Text(
                      rec['status'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isApproved ? const Color(0xFF10B981) : const Color(0xFFEF4444),
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

class _SummaryRow extends StatelessWidget {
  final Color color;
  final String label;
  final String val;
  const _SummaryRow(this.color, this.label, this.val);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
      ],
    );
  }
}
