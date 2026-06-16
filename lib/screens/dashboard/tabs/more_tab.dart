import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../login/login_screen.dart';

class MoreTab extends StatelessWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More Options",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildMoreTile(
              Icons.notifications_outlined, "Notification Settings", () {}),
          _buildMoreTile(Icons.lock_reset_outlined, "Change Password", () {}),
          _buildMoreTile(Icons.info_outline, "About School ERP", () {}),
          _buildMoreTile(Icons.help_outline, "Help Desk", () {}),
          const Divider(height: 30),
          _buildMoreTile(Icons.logout, "Logout", () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildMoreTile(IconData icon, String title, VoidCallback onTap,
      {Color color = AppColors.primary}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }
}
