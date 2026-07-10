import 'package:flutter/material.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/ai_bot_fab.dart';
import 'admin_assignments_screen.dart';
import 'admin_attendance_screen.dart';
import 'admin_class_details_screen.dart';
import 'admin_class_teachers_screen.dart';
import 'admin_diary_screen.dart';
import 'admin_time_table_screen.dart';

class AdminClassesScreen extends StatelessWidget {
  final VoidCallback? onOpenDrawer;
  const AdminClassesScreen({super.key, this.onOpenDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AdminAppBar(
        title: "Classes",
        subtitle: "Manage all class related activities",
        onOpenDrawer: onOpenDrawer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildCard(
              context,
              title: "Assignments",
              icon: Icons.assignment_outlined,
              color: const Color(0xFF0D6EFD),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAssignmentsScreen())),
            ),
            const SizedBox(height: 12),
            _buildCard(
              context,
              title: "Attendance",
              icon: Icons.calendar_today_outlined,
              color: const Color(0xFF10B981),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAttendanceScreen())),
            ),
            const SizedBox(height: 12),
            _buildCard(
              context,
              title: "Class Details",
              icon: Icons.info_outline,
              color: const Color(0xFFF59E0B),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminClassDetailsScreen())),
            ),
            const SizedBox(height: 12),
            _buildCard(
              context,
              title: "Class Teachers",
              icon: Icons.person_outline,
              color: const Color(0xFF8B5CF6),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminClassTeachersScreen())),
            ),
            const SizedBox(height: 12),
            _buildCard(
              context,
              title: "Diary",
              icon: Icons.book_outlined,
              color: const Color(0xFFEC4899),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDiaryScreen())),
            ),
            const SizedBox(height: 12),
            _buildCard(
              context,
              title: "Time Table",
              icon: Icons.schedule_outlined,
              color: const Color(0xFF14B8A6),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminTimeTableScreen())),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      floatingActionButton: AiBotFab(),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title.tr,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
