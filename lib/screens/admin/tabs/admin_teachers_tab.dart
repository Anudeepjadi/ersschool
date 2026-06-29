import 'package:flutter/material.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/ai_bot_fab.dart';
import '../screens/admin_employee_list_screen.dart';
import '../screens/admin_register_employee_screen.dart';
import '../screens/admin_employee_id_cards_screen.dart';

class AdminTeachersTab extends StatelessWidget {
  final VoidCallback? onOpenDrawer;
  const AdminTeachersTab({super.key, this.onOpenDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AdminAppBar(
        title: "Employees",
        subtitle: "Manage all staff members",
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
                  title: "Employees List",
                  icon: Icons.list_alt,
                  color: const Color(0xFF0D6EFD),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminEmployeeListScreen(staffType: 'Employee'))),
                ),
                const SizedBox(height: 12),
                _buildCard(
                  context,
                  title: "Teachers List",
                  icon: Icons.co_present_outlined,
                  color: const Color(0xFF10B981),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminEmployeeListScreen(staffType: 'Teacher'))),
                ),
                const SizedBox(height: 12),
                _buildCard(
                  context,
                  title: "Add New Teacher",
                  icon: Icons.person_add_alt_1,
                  color: const Color(0xFFF59E0B),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminRegisterEmployeeScreen(staffType: 'Teacher'))),
                ),
                const SizedBox(height: 12),
                _buildCard(
                  context,
                  title: "Attender/Aaya List",
                  icon: Icons.cleaning_services_outlined,
                  color: const Color(0xFF8B5CF6),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminEmployeeListScreen(staffType: 'Attender'))),
                ),
                const SizedBox(height: 12),
                _buildCard(
                  context,
                  title: "Employee ID Cards",
                  icon: Icons.badge,
                  color: const Color(0xFFEC4899),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminEmployeeIDCardsScreen())),
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
