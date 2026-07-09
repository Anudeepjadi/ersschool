import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../core/theme/app_colors.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminVideoTutorialsScreen extends StatefulWidget {
  const AdminVideoTutorialsScreen({super.key});

  @override
  State<AdminVideoTutorialsScreen> createState() => _AdminVideoTutorialsScreenState();
}

class _AdminVideoTutorialsScreenState extends State<AdminVideoTutorialsScreen> {
  final List<Map<String, dynamic>> _videos = [
    {
      'title': '1. System Overview & Dashboard',
      'desc': 'Get an overview of the dashboard and key features.',
      'duration': '06:25',
      'level': 'Beginner',
      'icon': Icons.dashboard,
      'color': Colors.blue,
    },
    {
      'title': '2. Managing Students Profile',
      'desc': 'Add, edit and manage student information easily.',
      'duration': '05:12',
      'level': 'Beginner',
      'icon': Icons.people,
      'color': Colors.green,
    },
    {
      'title': '3. Taking Student Attendance',
      'desc': 'Learn how to take attendance and generate reports.',
      'duration': '04:38',
      'level': 'Beginner',
      'icon': Icons.checklist,
      'color': Colors.orange,
    },
    {
      'title': '4. Fees Collection setup',
      'desc': 'Configure and process fee structure details.',
      'duration': '07:15',
      'level': 'Intermediate',
      'icon': Icons.currency_rupee,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      appBar: AdminAppBar(title: "Video Tutorials", subtitle: "Manage your account details"),
      bottomNavigationBar: AdminBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search field
            TextField(
              decoration: InputDecoration(
                hintText: "Search tutorials by feature, topic...",
                prefixIcon: Icon(Icons.search, color: Color(0xFF757897)),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Stats row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard("Total Videos", "126", "Watch anytime", Colors.blue),
                  _buildStatCard("Total Watch Time", "18h 45m", "Accumulated content", Colors.green),
                  _buildStatCard("Completion Rate", "89%", "Consistent learning", Colors.orange),
                  _buildStatCard("Saved Videos", "24", "Quick access list", Colors.purple),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Video list grid representation
            Text("Featured Tutorials".tr,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
            SizedBox(height: 12),
            _buildVideoGrid(),
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
          Text(subtext, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildVideoGrid() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final v = _videos[index];
        return Card(
          elevation: 0,
          color: Colors.white,
          margin: EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fake Video Thumbnail representation
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: v['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(v['icon'], size: 50, color: v['color']),
                    CircleAvatar(
                      backgroundColor: Colors.white70,
                      radius: 20,
                      child: Icon(Icons.play_arrow, color: AppColors.primary),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
                        child: Text(v['duration'], style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              // Video details text
              Padding(
                padding: EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(v['level'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: v['color'])),
                        Icon(Icons.bookmark_border, size: 16, color: Colors.grey),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(v['title'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    SizedBox(height: 4),
                    Text(v['desc'], style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
