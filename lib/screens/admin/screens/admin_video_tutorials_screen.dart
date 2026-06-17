import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

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
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Video Tutorials",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            Text(
              "Learn at your own pace",
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
            // Search field
            TextField(
              decoration: InputDecoration(
                hintText: "Search tutorials by feature, topic...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF757897)),
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

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
            const SizedBox(height: 16),

            // Video list grid representation
            const Text(
              "Featured Tutorials",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
            const SizedBox(height: 12),
            _buildVideoGrid(),
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
          Text(subtext, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildVideoGrid() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final v = _videos[index];
        return Card(
          elevation: 0,
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fake Video Thumbnail representation
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: v['color'].withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(v['icon'], size: 50, color: v['color']),
                    const CircleAvatar(
                      backgroundColor: Colors.white70,
                      radius: 20,
                      child: Icon(Icons.play_arrow, color: AppColors.primary),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
                        child: Text(v['duration'], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              // Video details text
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(v['level'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: v['color'])),
                        const Icon(Icons.bookmark_border, size: 16, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(v['title'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    const SizedBox(height: 4),
                    Text(v['desc'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
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
