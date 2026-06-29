import 'package:flutter/material.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/ai_bot_fab.dart';
import '../screens/student_management/admin_student_list_screen.dart';
import '../screens/student_management/admin_register_student_screen.dart';
import '../screens/student_management/admin_student_promotions_screen.dart';
import '../screens/student_management/admin_student_siblings_screen.dart';
import '../screens/admin_id_cards_screen.dart';

class AdminStudentsTab extends StatelessWidget {
  final VoidCallback? onOpenDrawer;
  const AdminStudentsTab({super.key, this.onOpenDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AdminAppBar(
        title: "Students",
        subtitle: "Manage students and records",
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
                  title: "Students List",
                  icon: Icons.list_alt,
                  color: const Color(0xFF0D6EFD),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentListScreen())),
                ),
                const SizedBox(height: 12),
                _buildCard(
                  context,
                  title: "Register New Student",
                  icon: Icons.person_add,
                  color: const Color(0xFF10B981),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminRegisterStudentScreen())),
                ),
                const SizedBox(height: 12),
                _buildCard(
                  context,
                  title: "Student Promotions",
                  icon: Icons.trending_up,
                  color: const Color(0xFFF59E0B),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentPromotionsScreen())),
                ),
                const SizedBox(height: 12),
                _buildCard(
                  context,
                  title: "All Student Siblings",
                  icon: Icons.family_restroom,
                  color: const Color(0xFF8B5CF6),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentSiblingsScreen())),
                ),
                const SizedBox(height: 12),
                _buildCard(
                  context,
                  title: "Student Id Cards",
                  icon: Icons.badge,
                  color: const Color(0xFFEC4899),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminIDCardsScreen())),
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
              color: color.withOpacity(0.1),
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
                color: color.withOpacity(0.15),
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
