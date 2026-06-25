import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/data/app_data_store.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminIDCardsScreen extends StatefulWidget {
  AdminIDCardsScreen({super.key});

  @override
  State<AdminIDCardsScreen> createState() => _AdminIDCardsScreenState();
}

class _AdminIDCardsScreenState extends State<AdminIDCardsScreen> {
  String? _previewStudentAvatarUrl;
  String? _previewTeacherAvatarUrl;

  List<Map<String, dynamic>> get _records {
    return AppDataStore.instance.students.map((s) {
      return {
        'name': s['name'] ?? 'Unknown',
        'type': 'Student',
        'id': s['admission'] ?? 'N/A',
        'dept': s['class'] ?? 'N/A',
        'date': '20 Jun 2026',
        'status': s['status'] == 'Active' ? 'Approved' : 'Pending',
        'avatar': s['avatar'] ?? s['avatarUrl'] ?? '',
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    AppDataStore.instance.configVersion.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    AppDataStore.instance.configVersion.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      appBar: AdminAppBar(title: "ID Cards Management", subtitle: "Manage your account details"),
      bottomNavigationBar: AdminBottomNavBar(currentIndex: 4),
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
                  _buildStatCard("Total ID Cards", "1,245", "+12% this month", Colors.blue),
                  _buildStatCard("Students", "1,042", "+10% this month", Colors.green),
                  _buildStatCard("Teachers", "158", "+8% this month", Colors.orange),
                  _buildStatCard("Staff", "45", "+5% this month", Colors.purple),
                  _buildStatCard("Pending Requests", "38", "+8% this month", Colors.red),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Previews of Student & Staff Cards
            Text("ID Card Previews".tr,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
            SizedBox(height: 12),
            _buildCardPreviews(),
            SizedBox(height: 16),

            // ID Card summary chart
            _buildSummaryChart(),
            SizedBox(height: 16),

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

  Widget _buildCardPreviews() {
    return Column(
      children: [
        // 1. Student ID Card (Blue)
        _buildIDCardLayout(
          headerColor: AppColors.primary,
          headerText: "ECSTASY SCHOOL 1",
          subHeader: "Shaping Futures, Building Tomorrow",
          name: "Rahul Kumar",
          roleText: "STUDENT",
          details: {
            "Class": "8 - A",
            "Roll No.": "101",
            "DOB": "14 May 2010",
            "Blood Group": "B+",
          },
          idNumber: "ES1S2410101",
          avatarUrl: _previewStudentAvatarUrl,
          onImageEdit: () => _showManageImageDialog({
            'name': 'Rahul Kumar',
            'id': '101',
            'avatar': _previewStudentAvatarUrl,
            'isMockPreview': true,
          }),
        ),
        SizedBox(height: 16),
        // 2. Staff ID Card (Green)
        _buildIDCardLayout(
          headerColor: Color(0xFF10B981),
          headerText: "ECSTASY SCHOOL 1",
          subHeader: "Shaping Futures, Building Tomorrow",
          name: "Ananya Sharma",
          roleText: "STAFF",
          details: {
            'Designation': 'Mathematics Teacher',
            'Employee ID': 'TCH125',
            'Department': 'Academics',
          },
          idNumber: "ES1TCH125",
          avatarUrl: _previewTeacherAvatarUrl,
          onImageEdit: () => _showManageImageDialog({
            'name': 'Ananya Sharma',
            'id': 'TCH125',
            'avatar': _previewTeacherAvatarUrl,
            'isMockPreview': true,
          }),
        ),
      ],
    );
  }

  Widget _buildIDCardLayout({
    required Color headerColor,
    required String headerText,
    required String subHeader,
    required String name,
    required String roleText,
    required Map<String, String> details,
    required String idNumber,
    String? avatarUrl,
    VoidCallback? onImageEdit,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade50, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Header banner
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Row(
              children: [
                Icon(Icons.school, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(headerText, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(subHeader, style: TextStyle(color: Colors.white70, fontSize: 8)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Info body
          Padding(
            padding: EdgeInsets.all(14.0),
            child: Row(
              children: [
                // Profile Picture placeholder
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 70,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                        image: (avatarUrl != null && avatarUrl.isNotEmpty)
                            ? (avatarUrl.startsWith('http')
                                ? DecorationImage(image: NetworkImage(avatarUrl), fit: BoxFit.cover)
                                : DecorationImage(image: FileImage(File(avatarUrl)), fit: BoxFit.cover))
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: (avatarUrl == null || avatarUrl.isEmpty)
                          ? Icon(Icons.person, size: 40, color: Colors.grey.shade400)
                          : null,
                    ),
                    if (onImageEdit != null)
                      Positioned(
                        bottom: -8,
                        right: -8,
                        child: Material(
                          color: Colors.white,
                          shape: CircleBorder(),
                          elevation: 2,
                          child: InkWell(
                            onTap: onImageEdit,
                            customBorder: CircleBorder(),
                            child: Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(Icons.camera_alt, size: 16, color: Color(0xFF1E2875)),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 18),
                // Card details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                      ),
                      SizedBox(height: 6),
                      ...details.entries.map((e) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 2.0),
                          child: Row(
                            children: [
                              Text("${e.key}: ", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                              Text(e.value, style: TextStyle(fontSize: 10, color: Color(0xFF1E2875), fontWeight: FontWeight.bold)),
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          Divider(height: 1),
          // Barcode representation & ID footer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
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
                          margin: EdgeInsets.only(right: 1),
                        );
                      }),
                    ),
                    SizedBox(height: 4),
                    Text(idNumber, style: TextStyle(fontSize: 9, fontFamily: 'monospace', color: Colors.grey)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/principal_signature.png',
                      height: 30,
                      width: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 50,
                        height: 1,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text("Principal Sign".tr, style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ID Cards Summary".tr,
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
                            PieChartSectionData(value: 83.7, color: Color(0xFF3B82F6), radius: 10, showTitle: false),
                            PieChartSectionData(value: 12.7, color: Color(0xFF10B981), radius: 10, showTitle: false),
                            PieChartSectionData(value: 3.6, color: Color(0xFFF59E0B), radius: 10, showTitle: false),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("1,245".tr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
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
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Recent ID Card Logs".tr,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _records.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final rec = _records[index];
              final isApproved = rec['status'] == 'Approved';
              return ListTile(
                onTap: () => _showManageImageDialog(rec),
                title: Text(rec['name'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                subtitle: Text("ID: ${rec['id']} | Dept/Class: ${rec['dept']}\nTap to manage ID Card image", style: TextStyle(fontSize: 11, color: Colors.grey)),
                isThreeLine: true,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(rec['type'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    Text(
                      rec['status'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isApproved ? Color(0xFF10B981) : Color(0xFFEF4444),
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

  void _showManageImageDialog(Map<String, dynamic> rec) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Manage ID Image - ${rec['name']}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (rec['avatar'] != null && rec['avatar'].toString().isNotEmpty)
                rec['avatar'].toString().startsWith('http')
                    ? CircleAvatar(radius: 40, backgroundImage: NetworkImage(rec['avatar']))
                    : CircleAvatar(radius: 40, backgroundImage: FileImage(File(rec['avatar'])))
              else
                CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
              SizedBox(height: 16),
              Text("Would you like to add a new image from gallery or remove the existing one?".tr),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateStudentAvatar(rec, ''); // Remove
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image removed successfully!".tr)));
              },
              child: Text("Remove Image".tr, style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                if (picked != null) {
                  _updateStudentAvatar(rec, picked.path);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image added successfully!".tr)));
                }
              },
              child: Text("Add/Update Image".tr),
            ),
          ],
        );
      },
    );
  }

  void _updateStudentAvatar(Map<String, dynamic> rec, String avatarUrl) {
    if (rec['isMockPreview'] == true) {
      setState(() {
        if (rec['id'] == '101') _previewStudentAvatarUrl = avatarUrl;
        if (rec['id'] == 'TCH125') _previewTeacherAvatarUrl = avatarUrl;
      });
      return;
    }

    final admissionId = rec['id'];
    final students = AppDataStore.instance.students;
    final index = students.indexWhere((s) => s['admission'] == admissionId);
    if (index != -1) {
      final updated = Map<String, dynamic>.from(students[index]);
      updated['avatarUrl'] = avatarUrl;
      updated['avatar'] = avatarUrl;
      AppDataStore.instance.updateStudent(index, updated);
      setState(() {});
    }
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(margin: EdgeInsets.only(top: 4), width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 8),
        Expanded(
          child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        SizedBox(width: 4),
        Text(val, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
      ],
    );
  }
}

