import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class AdminCertificatesScreen extends StatefulWidget {
  const AdminCertificatesScreen({super.key});

  @override
  State<AdminCertificatesScreen> createState() => _AdminCertificatesScreenState();
}

class _AdminCertificatesScreenState extends State<AdminCertificatesScreen> {
  final List<Map<String, dynamic>> _certs = [
    {'name': 'Merit Certificate', 'type': 'Academic', 'student': 'Rahul Kumar', 'class': '8 - A', 'date': '20 Jun 2026', 'id': 'ACAD-26-0001', 'status': 'Issued'},
    {'name': 'Sports Achievement', 'type': 'Sports', 'student': 'Ananya Sharma', 'class': '8 - A', 'date': '18 Jun 2026', 'id': 'SPRT-26-0021', 'status': 'Issued'},
    {'name': 'Science Exhibition', 'type': 'Co-Curricular', 'student': 'Aarav Singh', 'class': '8 - B', 'date': '17 Jun 2026', 'id': 'COCU-26-0156', 'status': 'Pending'},
    {'name': 'Best Student Award', 'type': 'Appreciation', 'student': 'Diya Patel', 'class': '8 - B', 'date': '15 Jun 2026', 'id': 'APP-26-0098', 'status': 'Issued'},
    {'name': 'Art Competition', 'type': 'Co-Curricular', 'student': 'Kabir Verma', 'class': '7 - A', 'date': '14 Jun 2026', 'id': 'COCU-26-0145', 'status': 'Issued'},
    {'name': 'Perfect Attendance', 'type': 'Academic', 'student': 'Neha Joshi', 'class': '7 - B', 'date': '10 Jun 2026', 'id': 'ACAD-26-0008', 'status': 'Expired'},
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
              "Certificates",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            Text(
              "Manage student and staff certificates",
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
                  _buildStatCard("Total Certificates", "2,568", "+15% this year", Colors.blue),
                  _buildStatCard("Issued", "2,102", "+12% this year", Colors.green),
                  _buildStatCard("Pending", "248", "+8% this year", Colors.orange),
                  _buildStatCard("Expired", "76", "+5% this year", Colors.red),
                  _buildStatCard("Downloaded", "1,894", "+18% this year", Colors.purple),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Certificate Previews Section
            const Text(
              "Certificate Previews",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
            const SizedBox(height: 12),
            _buildCertificatePreviews(),
            const SizedBox(height: 16),

            // Performance overview donut + breakdown list
            _buildChartSection(),
            const SizedBox(height: 16),

            // Logs of Issued Certificates
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

  Widget _buildCertificatePreviews() {
    return Column(
      children: [
        // 1. Student Merit Certificate
        _buildCertLayout(
          primaryColor: const Color(0xFFD4AF37), // Gold Color
          title: "CERTIFICATE OF MERIT",
          subtitle: "PROUDLY PRESENTED TO",
          name: "Rahul Kumar",
          classDetails: "Class 8 - A • Roll No. 101",
          reason: "for achieving Academic Excellence and outstanding performance with a GPA of 9.8 during the Academic Session 2026 - 27.",
          date: "20 Jun 2026",
          authority: "Dr. Sarah Jenkins\nPrincipal",
        ),
        const SizedBox(height: 16),
        // 2. Teacher Appreciation Certificate
        _buildCertLayout(
          primaryColor: const Color(0xFF0038FF), // Blue Color
          title: "CERTIFICATE OF APPRECIATION",
          subtitle: "GRATEFULLY PRESENTED TO",
          name: "Mrs. Ananya Sharma",
          classDetails: "Senior Mathematics Faculty",
          reason: "in recognition of her exceptional dedication, academic leadership, and outstanding teaching contributions toward student success.",
          date: "18 Jun 2026",
          authority: "Dr. Sarah Jenkins\nPrincipal",
        ),
      ],
    );
  }

  Widget _buildCertLayout({
    required Color primaryColor,
    required String title,
    required String subtitle,
    required String name,
    required String classDetails,
    required String reason,
    required String date,
    required String authority,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade100, blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor.withValues(alpha: 0.2), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // School Badge & Name Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.school, color: primaryColor, size: 20),
                const Text(
                  "ECSTASY INTERNATIONAL SCHOOL",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                    letterSpacing: 0.5,
                  ),
                ),
                Icon(Icons.verified_outlined, color: primaryColor, size: 18),
              ],
            ),
            const SizedBox(height: 16),
            // Certificate Title
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: primaryColor,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            // Candidate Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            Text(
              classDetails,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            // Certificate Citation Body
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                reason,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  height: 1.4,
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            // Signature footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("DATE OF ISSUE", style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(date, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      authority.split('\n')[0],
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryColor, fontFamily: 'monospace'),
                    ),
                    Text(
                      authority.split('\n')[1],
                      style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
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
            "Certificates Overview",
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
                            PieChartSectionData(value: 48.9, color: const Color(0xFF3B82F6), radius: 10, showTitle: false),
                            PieChartSectionData(value: 24.3, color: const Color(0xFF10B981), radius: 10, showTitle: false),
                            PieChartSectionData(value: 13.9, color: const Color(0xFF8B5CF6), radius: 10, showTitle: false),
                            PieChartSectionData(value: 8.3, color: const Color(0xFFF59E0B), radius: 10, showTitle: false),
                            PieChartSectionData(value: 4.6, color: const Color(0xFF9CA3AF), radius: 10, showTitle: false),
                          ],
                        ),
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("2,568", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
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
                    _RowItem(Color(0xFF3B82F6), "Academic", "1,256 (48.9%)"),
                    SizedBox(height: 6),
                    _RowItem(Color(0xFF10B981), "Co-Curricular", "624 (24.3%)"),
                    SizedBox(height: 6),
                    _RowItem(Color(0xFF8B5CF6), "Sports", "356 (13.9%)"),
                    SizedBox(height: 6),
                    _RowItem(Color(0xFFF59E0B), "Appreciation", "212 (8.3%)"),
                  ],
                ),
              )
            ],
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
              "Issued Certificates Log",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _certs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final cert = _certs[index];
              Color statusColor;
              switch (cert['status']) {
                case 'Issued':
                  statusColor = const Color(0xFF10B981);
                  break;
                case 'Expired':
                  statusColor = const Color(0xFFEF4444);
                  break;
                default:
                  statusColor = const Color(0xFFF59E0B);
              }

              return ListTile(
                title: Text(cert['name'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                subtitle: Text("ID: ${cert['id']} • Student: ${cert['student']}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(cert['type'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    Text(
                      cert['status'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
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
