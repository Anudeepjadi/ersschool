import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../widgets/admin_app_bar.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminCertificatesScreen extends StatefulWidget {
  AdminCertificatesScreen({super.key});

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
      backgroundColor: Color(0xFFF5F7FF),
      bottomNavigationBar: AdminBottomNavBar(currentIndex: 4),
      appBar: AdminAppBar(
        title: "Certificates",
        subtitle: "Manage student and staff certificates",
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
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
            SizedBox(height: 16),

            // Certificate Previews Section
            Text("Certificate Previews".tr,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
            SizedBox(height: 12),
            _buildCertificatePreviews(),
            SizedBox(height: 16),

            // Performance overview donut + breakdown list
            _buildChartSection(),
            SizedBox(height: 16),

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
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          SizedBox(height: 4),
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
          primaryColor: Color(0xFFD4AF37), // Gold Color
          title: "CERTIFICATE OF MERIT",
          subtitle: "PROUDLY PRESENTED TO",
          name: "Rahul Kumar",
          classDetails: "Class 8 - A | Roll No. 101",
          reason: "for achieving Academic Excellence and outstanding performance with a GPA of 9.8 during the Academic Session 2026 - 27.",
          date: "20 Jun 2026",
          authority: "Dr. Sarah Jenkins\nPrincipal",
        ),
        SizedBox(height: 16),
        // 2. Teacher Appreciation Certificate
        _buildCertLayout(
          primaryColor: Color(0xFF0038FF), // Blue Color
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
          BoxShadow(color: Colors.grey.shade100, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(14),
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
                Text("ECSTASY INTERNATIONAL SCHOOL".tr,
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
            SizedBox(height: 16),
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
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 10),
            // Candidate Name
            Text(
              name,
              style: TextStyle(
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
            SizedBox(height: 8),
            // Certificate Citation Body
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
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
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),
            // Signature footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("DATE OF ISSUE".tr, style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text(date, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
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
                      style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Certificates Overview".tr,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          SizedBox(height: 16),
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
                            PieChartSectionData(value: 48.9, color: Color(0xFF3B82F6), radius: 10, showTitle: false),
                            PieChartSectionData(value: 24.3, color: Color(0xFF10B981), radius: 10, showTitle: false),
                            PieChartSectionData(value: 13.9, color: Color(0xFF8B5CF6), radius: 10, showTitle: false),
                            PieChartSectionData(value: 8.3, color: Color(0xFFF59E0B), radius: 10, showTitle: false),
                            PieChartSectionData(value: 4.6, color: Color(0xFF9CA3AF), radius: 10, showTitle: false),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("2,568".tr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                          Text("Total".tr, style: TextStyle(fontSize: 8, color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
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
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Issued Certificates Log".tr,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _certs.length,
            itemBuilder: (context, index) {
              final cert = _certs[index];
              Color statusColor;
              switch (cert['status']) {
                case 'Issued':
                  statusColor = Color(0xFF10B981);
                  break;
                case 'Expired':
                  statusColor = Color(0xFFEF4444);
                  break;
                default:
                  statusColor = Color(0xFFF59E0B);
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
                      child: Icon(Icons.workspace_premium_outlined, color: statusColor, size: 20),
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
                                  cert['name'],
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
                                  cert['status'],
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
                            "${cert['type']} | ${cert['student']}",
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.badge_outlined, size: 14, color: Colors.grey.shade500),
                              SizedBox(width: 4),
                              Text(
                                "ID: ${cert['id']}",
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
}

class _RowItem extends StatelessWidget {
  final Color color;
  final String label;
  final String val;
  const _RowItem(this.color, this.label, this.val);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(margin: EdgeInsets.only(top: 4), width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 8),
        Expanded(
          child: Text(label, style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: 4),
        Text(val, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
      ],
    );
  }
}

